//
//  JXRangeTree.m
//  JXFoundation
//
//

#import "JXRangeTree-Private.h"

#import "JXInlineVector.hpp"
#import "JXRangeTreeNode-Private.h"
#import <float.h>
#import <algorithm>
#import <vector>

struct JXRangeTreeRecursionNode
{
    __unsafe_unretained JXRangeTreeNode* startNode;
    NSUInteger          parentIndex;
    BOOL                tryRightBranch;
};

typedef JXFoundation::inline_vector<JXRangeTreeRecursionNode, 32> JXRangeTreeRecursionNodes;

#pragma mark -

@implementation JXRangeTree
{
    JXRangeTreeNode* _rootNode;
    JXRangeTreeNode* _nilNode;
    NSUInteger          _enumerationCount;
}

#pragma mark Managing life cycle

- (id)init
{
    if(self = [super init])
    {
        _nilNode = [[JXRangeTreeNode alloc] initNilNode];
        
        _rootNode = [[JXRangeTreeNode alloc] initRootNodeWithNilNode:_nilNode];
    }
    return self;
}

#pragma mark Adding and removing objects

- (JXRangeTreeNode*)addObject:(id)object forRangeWithLowValue:(CFIndex)lowValue highValue:(CFIndex)highValue
{
    JXRangeTreeNode* newNode = nil;
    
    if(_enumerationCount == 0)
    {
        newNode = [[JXRangeTreeNode alloc] initWithObject:object lowValue:lowValue highValue:highValue];
        [self insertNode:newNode];
        
        [self updateMaxHighForNodeAndAncestors:newNode.parentNode];
        
        newNode.isRed = YES;
        while(newNode.parentNode.isRed)  // use sentinel instead of checking for rootNode
        {
            JXRangeTreeNode* grandParentNode = newNode.parentNode.parentNode;
            if(newNode.parentNode == grandParentNode.leftNode)
            {
                JXRangeTreeNode* rightOfGrandParentNode = grandParentNode.rightNode;
                if(rightOfGrandParentNode.isRed)
                {
                    newNode.parentNode.isRed = NO;
                    rightOfGrandParentNode.isRed = NO;
                    grandParentNode.isRed = YES;
                    newNode = grandParentNode;
                }
                else
                {
                    if(newNode == newNode.parentNode.rightNode)
                    {
                        newNode = newNode.parentNode;
                        [self rotateNodeToLeft:newNode];
                    }
                    newNode.parentNode.isRed = NO;
                    grandParentNode.isRed = YES;
                    [self rotateNodeToRight:newNode.parentNode.parentNode];
                } 
            }
            else
            { 
                NSAssert(newNode.parentNode == grandParentNode.rightNode, nil);
                JXRangeTreeNode* leftOfGrandParentNode = grandParentNode.leftNode;
                if(leftOfGrandParentNode.isRed)
                {
                    newNode.parentNode.isRed = NO;
                    leftOfGrandParentNode.isRed = NO;
                    grandParentNode.isRed = YES;
                    newNode = grandParentNode;
                }
                else
                {
                    if(newNode == newNode.parentNode.leftNode)
                    {
                        newNode = newNode.parentNode;
                        [self rotateNodeToRight:newNode];
                    }
                    newNode.parentNode.isRed = NO;
                    grandParentNode.isRed = YES;
                    [self rotateNodeToLeft:newNode.parentNode.parentNode];
                } 
            }
        }
        _rootNode.leftNode.isRed = NO;
        
#ifndef NDEBUG
        [self checkAssertions];
#endif  
        NSAssert(!_nilNode.isRed, @"nilNode not red in addObject:forRangeWithLowValue:highValue:");
        NSAssert(!_rootNode.isRed, @"rootNode not red in addObject:forRangeWithLowValue:highValue:");
        NSAssert((_nilNode.maxHigh == kCFNotFound), @"nilNode.maxHigh != kCFNotFound in addObject:forRangeWithLowValue:highValue:");
    }
    else        
        [NSException raise:NSInternalInconsistencyException
                    format:@"Trying to mutate interval tree by adding object during enumeration."];
    
    return(newNode);
}

- (id)removeObjectForRangeWithLowValue:(CFIndex)aLowValue highValue:(CFIndex)aHighValue
{
    id removedObject = nil;
    
    if(_enumerationCount == 0)
    {
        JXRangeTreeNode* node = [self nodeForRangeWithLowValue:aLowValue highValue:aHighValue];
        if(node)
            removedObject = [self deleteNode:node];
    }
    else
        [NSException raise:NSInternalInconsistencyException
                    format:@"Trying to mutate interval tree by removing object during enumeration."];

    return removedObject;
}

- (void)insertNode:(JXRangeTreeNode*)node
{
    node.rightNode = _nilNode;
    node.leftNode = node.rightNode;
    
    JXRangeTreeNode* newParentNode = _rootNode;
    JXRangeTreeNode* iterationNode = _rootNode.leftNode;
    while(iterationNode != _nilNode)
    {
        newParentNode = iterationNode;
        if(iterationNode.key > node.key)
            iterationNode = iterationNode.leftNode;
        else
        {
            NSAssert(iterationNode.key <= node.key, nil);
            iterationNode = iterationNode.rightNode;
        }
    }
    
    node.parentNode = newParentNode;
    if((newParentNode == _rootNode) || (newParentNode.key > node.key))
        newParentNode.leftNode = node;
    else
        newParentNode.rightNode = node;
    
    NSAssert(!_nilNode.isRed, @"nilNode not red in insertNode:");
    NSAssert((_nilNode.maxHigh == kCFNotFound), @"nilNode.maxHigh != kCFNotFound in insertNode:");
}

- (void)balanceNode:(JXRangeTreeNode*)node
{
    JXRangeTreeNode* rootLeftNode = _rootNode.leftNode;
    while((!node.isRed) && (rootLeftNode != node))
    {
        JXRangeTreeNode* parentNode = node.parentNode;
        if(node == parentNode.leftNode)
        {
            JXRangeTreeNode* parentRightNode = parentNode.rightNode;
            if(parentRightNode.isRed)
            {
                parentRightNode.isRed = NO;
                parentNode.isRed = YES;
                [self rotateNodeToLeft:parentNode];
                parentRightNode = parentNode.rightNode;
            }
            if((!parentRightNode.rightNode.isRed) && (!parentRightNode.leftNode.isRed))
            { 
                parentRightNode.isRed = YES;
                node = parentNode;
            } 
            else
            {
                if(!parentRightNode.rightNode.isRed)
                {
                    parentRightNode.leftNode.isRed = NO;
                    parentRightNode.isRed = YES;
                    [self rotateNodeToRight:parentRightNode];
                    parentRightNode = parentNode.rightNode;
                }
                parentRightNode.isRed = parentNode.isRed;
                parentNode.isRed = NO;
                parentRightNode.rightNode.isRed = NO;
                [self rotateNodeToLeft:parentNode];
                node = rootLeftNode;
            }
        }
        else
        {
            JXRangeTreeNode* parentLeftNode = parentNode.leftNode;
            if (parentLeftNode.isRed)
            {
                parentLeftNode.isRed = NO;
                parentNode.isRed = YES;
                [self rotateNodeToRight:parentNode];
                parentLeftNode = parentNode.leftNode;
            }
            if((!parentLeftNode.rightNode.isRed) && (!parentLeftNode.leftNode.isRed))
            { 
                parentLeftNode.isRed = YES;
                node = parentNode;
            }
            else
            {
                if(!parentLeftNode.leftNode.isRed)
                {
                    parentLeftNode.rightNode.isRed = NO;
                    parentLeftNode.isRed = YES;
                    [self rotateNodeToLeft:parentLeftNode];
                    parentLeftNode = parentNode.leftNode;
                }
                parentLeftNode.isRed = parentNode.isRed;
                parentNode.isRed = NO;
                parentLeftNode.leftNode.isRed = NO;
                [self rotateNodeToRight:parentNode];
                node = rootLeftNode;
            }
        }
    }
    node.isRed = NO;
    
#ifndef NDEBUG
    [self checkAssertions];
#endif
    NSAssert(!_nilNode.isRed, @"nilNode not black in balanceNode:");
    NSAssert((_nilNode.maxHigh == kCFNotFound),  @"nilNode.maxHigh != kCFNotFound in balanceNode:");
}

- (id)deleteNode:(JXRangeTreeNode*)node
{
    NSAssert(_enumerationCount == 0, nil);
    
    id object = node.object;
    
    JXRangeTreeNode* spliceOutNode = ((node.leftNode == _nilNode) || (node.rightNode == _nilNode)) ? node : [self nodeSucceedingNode:node];
    JXRangeTreeNode* spliceOutChildNode = (spliceOutNode.leftNode == _nilNode) ? spliceOutNode.rightNode : spliceOutNode.leftNode;
    spliceOutChildNode.parentNode = spliceOutNode.parentNode;
    if(_rootNode == spliceOutNode.parentNode)
        _rootNode.leftNode = spliceOutChildNode;
    else
    {
        JXRangeTreeNode* spliceOutParentNode = spliceOutNode.parentNode;
        if(spliceOutNode == spliceOutParentNode.leftNode)
            spliceOutParentNode.leftNode = spliceOutChildNode;
        else
            spliceOutParentNode.rightNode = spliceOutChildNode;
    }
    if(spliceOutNode != node)
    {
        NSAssert(spliceOutNode != _nilNode, nil);

        spliceOutNode.maxHigh = kCFNotFound;
        spliceOutNode.leftNode = node.leftNode;
        spliceOutNode.rightNode = node.rightNode;
        spliceOutNode.parentNode = node.parentNode;

        node.rightNode.parentNode = spliceOutNode;
        node.leftNode.parentNode = node.rightNode.parentNode;
        JXRangeTreeNode* parentNode = node.parentNode;
        if(node == parentNode.leftNode)
            parentNode.leftNode = spliceOutNode; 
        else
            parentNode.rightNode = spliceOutNode;
    
        [self updateMaxHighForNodeAndAncestors:spliceOutChildNode.parentNode]; 
        if(!(spliceOutNode.isRed)) 
        {
            spliceOutNode.isRed = node.isRed;
            [self balanceNode:spliceOutChildNode];
        } 
        else
            spliceOutNode.isRed = node.isRed; 

#ifndef NDEBUG
        [self checkAssertions];
#endif
        NSAssert(!_nilNode.isRed,@"nilNode not black in deleteNode:");
        NSAssert(_nilNode.maxHigh == kCFNotFound, @"nilNode.maxHigh != kCFNotFound in deleteNode:");
    }
    else
    {
        [self updateMaxHighForNodeAndAncestors:spliceOutChildNode.parentNode];
        if(!(spliceOutNode.isRed))
            [self balanceNode:spliceOutChildNode];

#ifndef NDEBUG
        [self checkAssertions];
#endif
        NSAssert(!_nilNode.isRed, @"nilNode not black in deleteNode:");
        NSAssert(_nilNode.maxHigh == kCFNotFound, @"nilNode.maxHigh != kCFNotFound in deleteNode:");
    }
    
    return object;
}

#pragma mark Accessing objects and nodes

- (void)enumerateNodesInRangeWithLowValue:(CFIndex)aLowValue 
                                   highValue:(CFIndex)aHighValue
                                  usingBlock:(void (^)(JXRangeTreeNode* node, BOOL* stop))block
{
    NSParameterAssert(block);
    
    ++_enumerationCount;
    
    // To improve performance it would be nice if the recursion node stack could live on the stack with a maximum size.
    // If the size becomes too small it could be copied to the heap.
    
    JXRangeTreeRecursionNodes recursionNodeStack;
    
    NSUInteger recursionNodeStackTop = 1;
    NSUInteger currentParentIndex    = 0;

    recursionNodeStack[0].startNode = NULL; 

    JXRangeTreeNode* node = _rootNode.leftNode;
    
    __block BOOL stop = NO;
    
    while(node != _nilNode)
    {
        if([node overlapsWithRangeWithLowValue:aLowValue highValue:aHighValue]) 
        {
            block(node, &stop);
            if(stop)
                break;
            
            recursionNodeStack[currentParentIndex].tryRightBranch = YES;
        }
        
        JXRangeTreeNode* leftNode = node.leftNode;
        if(leftNode != nil && leftNode.maxHigh > aLowValue)
        {             
            recursionNodeStack[recursionNodeStackTop].startNode = node;
            recursionNodeStack[recursionNodeStackTop].tryRightBranch = NO;
            recursionNodeStack[recursionNodeStackTop].parentIndex = currentParentIndex;
            currentParentIndex = recursionNodeStackTop++;
            node = node.leftNode;
        } else
            node = node.rightNode;
        
        while((node == _nilNode) && (recursionNodeStackTop > 1))
            if(recursionNodeStack[--recursionNodeStackTop].tryRightBranch)
            {
                node = recursionNodeStack[recursionNodeStackTop].startNode.rightNode;
                currentParentIndex = recursionNodeStack[recursionNodeStackTop].parentIndex;
                recursionNodeStack[currentParentIndex].tryRightBranch = YES;
            }
    }
    
    --_enumerationCount;
}

- (NSSet*)nodesInRangeWithLowValue:(CFIndex)aLowValue highValue:(CFIndex)aHighValue
{
    NSMutableSet* nodesInRange = [[NSMutableSet alloc] init];
    
    [self enumerateNodesInRangeWithLowValue:aLowValue 
                                     highValue:aHighValue
                                    usingBlock:^(JXRangeTreeNode* node, BOOL* stop) {
                                        [nodesInRange addObject:node];
                                    }];
    
    return nodesInRange;
}

- (NSSet*)objectsInRangeWithLowValue:(CFIndex)aLowValue highValue:(CFIndex)aHighValue
{
    NSMutableSet* objectsInRange = [[NSMutableSet alloc] init];
    
    [self enumerateNodesInRangeWithLowValue:aLowValue 
                                     highValue:aHighValue
                                    usingBlock:^(JXRangeTreeNode* node, BOOL* stop) {
                                        [objectsInRange addObject:node.object];
                                    }];
    
    return objectsInRange;
}

- (JXRangeTreeNode*)nodeForRangeWithLowValue:(CFIndex)aLowValue highValue:(CFIndex)aHighValue
{
    JXRangeTreeNode* node = nil;
    
    JXRangeTreeNode* currentNode = _rootNode.leftNode;
    while(currentNode != _nilNode) 
    {
        if ((currentNode.lowValue == aLowValue) && (currentNode.highValue == aHighValue)) 
        {
            node = currentNode;
            break;
        } 
        else
        {
            if (aLowValue < currentNode.lowValue)
                currentNode = currentNode.leftNode;
            else
                currentNode = currentNode.rightNode;
        }
    }
    
    return node;    
}

#pragma mark Accessing preceding and succeeding node 

- (JXRangeTreeNode*)nodePrecedingNode:(JXRangeTreeNode*)node
{
    JXRangeTreeNode* predecessorNode;

    if((predecessorNode = node.leftNode) != _nilNode)    // assignment to predecessorNode is intentional
        while(predecessorNode.rightNode != _nilNode)     // returns the maximum of the left subtree of node
            predecessorNode = predecessorNode.rightNode;
    else
    {
        predecessorNode = node.parentNode;
        while(node == predecessorNode.leftNode)
        { 
            if(predecessorNode == _rootNode)
            {
                predecessorNode = _nilNode; 
                break;
            }
            node = predecessorNode;
            predecessorNode = predecessorNode.parentNode;
        }
    }
    
    return predecessorNode;
}

- (JXRangeTreeNode*)nodeSucceedingNode:(JXRangeTreeNode*)node
{
    JXRangeTreeNode* successorNode;
    
    if((successorNode = node.rightNode) != _nilNode) // assignment to successorNode is intentional
        while(successorNode.leftNode != _nilNode)        // returns the minium of the right subtree of node
            successorNode = successorNode.leftNode;
    else 
    {
        successorNode = node.parentNode;
        while(node == successorNode.rightNode)          // sentinel used instead of checking for nil
        { 
            node = successorNode;
            successorNode = successorNode.parentNode;
        }
        if(successorNode == _rootNode)
            successorNode = _nilNode;
    }
    
    return successorNode;
}

#pragma mark Rotating nodes

- (void)rotateNodeToLeft:(JXRangeTreeNode*)node
{
    JXRangeTreeNode* parentNode = node.parentNode;
    JXRangeTreeNode* rightNode = node.rightNode;
    node.rightNode = rightNode.leftNode;
    
    if(rightNode.leftNode != _nilNode)
        rightNode.leftNode.parentNode = node; // used to use sentinel here
    rightNode.parentNode = parentNode;   
    
    if(node == parentNode.leftNode)
        parentNode.leftNode = rightNode;
    else
        parentNode.rightNode = rightNode;

    rightNode.leftNode = node;
    node.parentNode = rightNode;
    
    node.maxHigh = MAX(node.leftNode.maxHigh, MAX(node.rightNode.maxHigh, node.high));
    rightNode.maxHigh = MAX(node.maxHigh, MAX(rightNode.rightNode.maxHigh, rightNode.high));
    
#ifndef NDEBUG
    [self checkAssertions];
#endif
    NSAssert(!_nilNode.isRed, @"nilNode not red in rotateNodeToLeft:");
    NSAssert(_nilNode.maxHigh == kCFNotFound, @"nilNode.maxHigh != kCFNotFound in rotateNodeToLeft:");
}

- (void)rotateNodeToRight:(JXRangeTreeNode*)node
{
    JXRangeTreeNode* parentNode = node.parentNode;
    JXRangeTreeNode* leftNode = node.leftNode;
    node.leftNode = leftNode.rightNode;
    
    if(_nilNode != leftNode.rightNode)
        leftNode.rightNode.parentNode = node;   // used to use sentinel here
    leftNode.parentNode = parentNode;
    
    if(node == parentNode.leftNode)
        parentNode.leftNode = leftNode;
    else
        parentNode.rightNode = leftNode;
    
    leftNode.rightNode = node;
    node.parentNode = leftNode;
    
    node.maxHigh = MAX(node.leftNode.maxHigh, MAX(node.rightNode.maxHigh, node.high));
    leftNode.maxHigh = MAX(leftNode.leftNode.maxHigh, MAX(node.maxHigh, leftNode.high));
    
#ifndef NDEBUG
    [self checkAssertions];
#endif
    NSAssert(!_nilNode.isRed, @"nilNode not red in rotateNodeToRight:");
    NSAssert(_nilNode.maxHigh == kCFNotFound, @"nilNode.maxHigh != kCFNotFound in rotateNodeToRight:");
}

#pragma mark Updating and checking max highs

- (void)updateMaxHighForNodeAndAncestors:(JXRangeTreeNode*)node
{
    while(node != _rootNode)
    {
        node.maxHigh = MAX(node.high, MAX(node.leftNode.maxHigh, node.rightNode.maxHigh));
        node = node.parentNode;
    }
    
#ifndef NDEBUG
    [self checkAssertions];
#endif
}

- (BOOL)checkMaxHighOfNode:(JXRangeTreeNode*)node currentHigh:(CFIndex)currentHigh match:(BOOL)match
{
    if(node != _nilNode) {
        match = [self checkMaxHighOfNode:node.leftNode currentHigh:currentHigh match:match] ? YES : match;
        NSAssert(node.high <= currentHigh, nil);
        if (node.high == currentHigh)
            match = YES;
        match = [self checkMaxHighOfNode:node.rightNode currentHigh:currentHigh match:match] ? YES : match;
    }
    
    return match;
}

- (void)checkMaxHighOfNode:(JXRangeTreeNode*)node
{
    if(node != _nilNode)
    {
        [self checkMaxHighOfNode:node.leftNode];
        NSAssert([self checkMaxHighOfNode:node currentHigh:node.maxHigh match:NO] > 0, nil);
        [self checkMaxHighOfNode:node.rightNode];
    }
}

- (void)checkAssertions
{
    NSAssert(_nilNode.key == kCFNotFound, @"nilNode.key != kCFNotFound");
    NSAssert(_nilNode.high == kCFNotFound, @"nilNode.high != kCFNotFound");
    NSAssert(_nilNode.maxHigh == kCFNotFound, @"nilNode.maxHigh != kCFNotFound");
    
    NSAssert(_rootNode.key == LONG_MAX, @"rootNode.key != LONG_MAX");
    NSAssert(_rootNode.high == LONG_MAX, @"rootNode.high != LONG_MAX");
    NSAssert(_rootNode.maxHigh == LONG_MAX, @"rootNode.maxHigh != LONG_MAX");
    
    NSAssert(_nilNode.object == nil, @"nilNode.object != nil");
    NSAssert(_rootNode.object == nil, @"rootNode.object != nil");
    
    NSAssert(_nilNode.isRed == NO, @"nilNode.isRed != NO");
    NSAssert(_rootNode.isRed == NO, @"rootNode.isRed != NO");
    
    //[self checkMaxHighOfNode:rootNode.leftNode];
}

#pragma mark Accessing dot representation

- (NSString*)dotRepresentation
{
    return _rootNode.leftNode.dotRepresentation;
}

- (void)showInGraphvizWithName:(NSString*)name
{
    NSString* dotRepresentation = self.dotRepresentation;
    dotRepresentation = [NSString stringWithFormat:@"digraph RBTree {\n%@\n}\n", dotRepresentation];
    
    NSMutableString* path = [NSMutableString stringWithCapacity:50];
    [path setString:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dot", name]]];
    [path replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, path.length)];
    
    if([dotRepresentation writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil])
        system([[NSString stringWithFormat:@"open -b com.att.graphviz '%@'", path] UTF8String]);
}

@end
