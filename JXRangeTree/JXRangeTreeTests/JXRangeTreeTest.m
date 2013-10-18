//
//  JXRangeTreeTest.m
//  JXFoundation
//
//

#import <XCTest/XCTest.h>

#import "JXRangeTree.h"
#import "JXRangeTreeNode.h"

@interface JXRangeTreeTest : XCTestCase
@end

@implementation JXRangeTreeTest

- (void)testRangeTree
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    
    [rangeTree addObject:testObjectA forRange:CFRangeMake(2, 4 - 2)];
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(0, 1 - 0)], [NSSet set]);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(1, 2 - 1)], [NSSet set]);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 3 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 4 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(4, 5 - 4)], [NSSet set]);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(5, 9 - 5)], [NSSet set]);
}

- (void)testRangeTreeAdditionBeforeRemoval
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    [rangeTree addObject:testObjectA forRange:CFRangeMake(2, 5 - 2)];
    NSString* testObjectB = @"TestObject B";
    [rangeTree addObject:testObjectB forRange:CFRangeMake(3, 7 - 3)];
    NSString* testObjectC = @"TestObject C";
    
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    NSSet* setWithObjectB = [NSSet setWithObject:testObjectB];
    NSSet* setWithObjectC = [NSSet setWithObject:testObjectC];
    NSSet* setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
    NSSet* setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
    NSSet* setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 3 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(3, 5 - 3)], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(5, 7 - 5)], setWithObjectB);
    
    [rangeTree addObject:testObjectC forRange:CFRangeMake(4, 6 - 4)];

    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 3 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(3, 4 - 3)], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(4, 5 - 4)], setWithObjectsABC);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(5, 6 - 5)], setWithObjectsBC);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(6, 7 - 6)], setWithObjectB);
    
    [rangeTree removeObjectForRange:CFRangeMake(4, 6 - 4)];
    
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 3 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(3, 5 - 3)], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(5, 7 - 5)], setWithObjectB);
}

- (void)testRangeTreeAdditionAfterRemoval
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    [rangeTree addObject:testObjectA forRange:CFRangeMake(2, 5 - 2)];
    NSString* testObjectB = @"TestObject B";
    [rangeTree addObject:testObjectB forRange:CFRangeMake(3, 7 - 3)];
    NSString* testObjectC = @"TestObject C";
    [rangeTree addObject:testObjectC forRange:CFRangeMake(4, 6 - 4)];
    
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    NSSet* setWithObjectB = [NSSet setWithObject:testObjectB];
    NSSet* setWithObjectC = [NSSet setWithObject:testObjectC];
    NSSet* setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
    NSSet* setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
    NSSet* setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 3 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(3, 4 - 3)], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(4, 5 - 4)], setWithObjectsABC);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(5, 6 - 5)], setWithObjectsBC);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(6, 7 - 6)], setWithObjectB);

    [rangeTree removeObjectForRange:CFRangeMake(4, 6 - 4)];

    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 3 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(3, 5 - 3)], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(5, 7 - 5)], setWithObjectB);
    
    [rangeTree addObject:testObjectC forRange:CFRangeMake(4, 6 - 4)];

    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 3 - 2)], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(3, 4 - 3)], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(4, 5 - 4)], setWithObjectsABC);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(5, 6 - 5)], setWithObjectsBC);
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(6, 7 - 6)], setWithObjectB);
}

- (void)testRangeTreeSameRange
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSString* testObjectB = @"TestObject B";
    NSSet* setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];

    [rangeTree addObject:testObjectA forRange:CFRangeMake(2, 5 - 2)];
    [rangeTree addObject:testObjectB forRange:CFRangeMake(2, 5 - 2)];
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(2, 5 - 2)], setWithObjectsAB);
}

- (void)testRangeTreeWithRangeStartingAtZero
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSString* testObjectB = @"TestObject B";
    NSSet* setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];

    [rangeTree addObject:testObjectA forRange:CFRangeMake(4, 18 - 4)];
    [rangeTree addObject:testObjectB forRange:CFRangeMake(26, 40 - 26)];
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(0, 476 - 0)], setWithObjectsAB);
    
    NSSet* nodes = [rangeTree nodesInRange:CFRangeMake(0, 476 - 0)];
    for(JXRangeTreeNode* node in nodes)
        [rangeTree deleteNode:node];
    XCTAssertEqualObjects([rangeTree objectsInRange:CFRangeMake(0, 476 - 0)], [NSSet set]);
}

- (void)testRecursiveEnumeration
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"A";
    NSString* testObjectB = @"B";
    NSString* testObjectC = @"C";
    NSString* testObjectD = @"D";
    NSString* testObjectE = @"E";
    
    [rangeTree addObject:testObjectA forRange:CFRangeMake(3, 4 - 3)];
    [rangeTree addObject:testObjectB forRange:CFRangeMake(4, 6 - 4)];
    [rangeTree addObject:testObjectC forRange:CFRangeMake(5, 7 - 5)];
    [rangeTree addObject:testObjectD forRange:CFRangeMake(8, 10 - 8)];
    [rangeTree addObject:testObjectE forRange:CFRangeMake(10, 11 - 10)];
    
    NSSet* setWithObjectsABC = [NSSet setWithObjects:testObjectA, testObjectB, testObjectC, nil];
    NSSet* setWithObjectsBC = [NSSet setWithObjects:testObjectB, testObjectC, nil];
    NSSet* setWithObjectsDE = [NSSet setWithObjects:testObjectD, testObjectE, nil];

    NSMutableSet* enumeratedObjectsForB = [NSMutableSet set];
    NSMutableSet* enumeratedObjectsForC = [NSMutableSet set];
    NSMutableSet* enumeratedObjectsForD = [NSMutableSet set];
    
    // Outer enumeration should include B, C, and D.
    [rangeTree enumerateNodesInRange:CFRangeMake(5, 9 - 5) usingBlock:^(JXRangeTreeNode* outerNode, BOOL* stop) {
        CFIndex lowValue  = outerNode.lowValue - 1;
        CFIndex highValue = outerNode.highValue + 1;
        id outerObject = outerNode.object;
        
        NSMutableSet* enumeratedObjects;

        if([outerObject isEqual:testObjectB])
            enumeratedObjects = enumeratedObjectsForB;
        else if([outerObject isEqual:testObjectC])
            enumeratedObjects = enumeratedObjectsForC;
        else
        {
            NSAssert([outerObject isEqual:testObjectD], nil);
            enumeratedObjects = enumeratedObjectsForD;
        }
        
        // Inner enumeration includes A, B, C for B; B, C for C; and D, E for D.
        [rangeTree enumerateNodesInRangeWithLowValue:lowValue highValue:highValue usingBlock:^(JXRangeTreeNode* innerNode, BOOL* stop2) {
            id innerObject = innerNode.object;
            [enumeratedObjects addObject:innerObject];
        }];
    }];
        
    XCTAssertEqualObjects(enumeratedObjectsForB, setWithObjectsABC);
    XCTAssertEqualObjects(enumeratedObjectsForC, setWithObjectsBC);
    XCTAssertEqualObjects(enumeratedObjectsForD, setWithObjectsDE);
}

- (void)testMutationDuringEnumeration
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"A";
    NSString* testObjectB = @"B";
    NSString* testObjectC = @"C";
    
    [rangeTree addObject:testObjectA forRange:CFRangeMake(3, 4 - 3)];
    [rangeTree addObject:testObjectB forRange:CFRangeMake(4, 6 - 4)];

    XCTAssertThrows([rangeTree enumerateNodesInRange:CFRangeMake(5, 5 - 5) usingBlock:^(JXRangeTreeNode* outerNode, BOOL* stop) {
        [rangeTree addObject:testObjectC forRange:CFRangeMake(5, 7 - 5)];
    }]);
}

@end
