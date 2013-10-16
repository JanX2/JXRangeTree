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
    JXRangeTree* intervalTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    
    [intervalTree addObject:testObjectA forRangeWithLowValue:2 highValue:4];
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:0 highValue:1], [NSSet set]);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:1 highValue:2], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2.5 highValue:3.5], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:4 highValue:5], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:5 highValue:9], [NSSet set]);
}

- (void)testRangeTreeAdditionBeforeRemoval
{
    JXRangeTree* intervalTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    [intervalTree addObject:testObjectA forRangeWithLowValue:2 highValue:5];
    NSString* testObjectB = @"TestObject B";
    [intervalTree addObject:testObjectB forRangeWithLowValue:3 highValue:7];
    NSString* testObjectC = @"TestObject C";
    
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    NSSet* setWithObjectB = [NSSet setWithObject:testObjectB];
    NSSet* setWithObjectC = [NSSet setWithObject:testObjectC];
    NSSet* setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
    NSSet* setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
    NSSet* setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2.2 highValue:2.8], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:3.2 highValue:4.8], setWithObjectsAB);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:5.2 highValue:6.8], setWithObjectB);
    
    [intervalTree addObject:testObjectC forRangeWithLowValue:4 highValue:6];

    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2.2 highValue:2.8], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:3.2 highValue:3.8], setWithObjectsAB);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:4.2 highValue:4.8], setWithObjectsABC);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:5.2 highValue:5.8], setWithObjectsBC);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:6.2 highValue:6.8], setWithObjectB);
    
    [intervalTree removeObjectForRangeWithLowValue:4 highValue:6];
    
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2.2 highValue:2.8], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:3.2 highValue:4.8], setWithObjectsAB);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:5.2 highValue:6.8], setWithObjectB);
}

- (void)testRangeTreeAdditionAfterRemoval
{
    JXRangeTree* intervalTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    [intervalTree addObject:testObjectA forRangeWithLowValue:2 highValue:5];
    NSString* testObjectB = @"TestObject B";
    [intervalTree addObject:testObjectB forRangeWithLowValue:3 highValue:7];
    NSString* testObjectC = @"TestObject C";
    [intervalTree addObject:testObjectC forRangeWithLowValue:4 highValue:6];
    
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    NSSet* setWithObjectB = [NSSet setWithObject:testObjectB];
    NSSet* setWithObjectC = [NSSet setWithObject:testObjectC];
    NSSet* setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
    NSSet* setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
    NSSet* setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2.2 highValue:2.8], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:3.2 highValue:3.8], setWithObjectsAB);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:4.2 highValue:4.8], setWithObjectsABC);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:5.2 highValue:5.8], setWithObjectsBC);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:6.2 highValue:6.8], setWithObjectB);

    [intervalTree removeObjectForRangeWithLowValue:4 highValue:6];

    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2.2 highValue:2.8], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:3.2 highValue:4.8], setWithObjectsAB);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:5.2 highValue:6.8], setWithObjectB);
    
    [intervalTree addObject:testObjectC forRangeWithLowValue:4 highValue:6];

    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2.2 highValue:2.8], setWithObjectA);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:3.2 highValue:3.8], setWithObjectsAB);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:4.2 highValue:4.8], setWithObjectsABC);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:5.2 highValue:5.8], setWithObjectsBC);
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:6.2 highValue:6.8], setWithObjectB);
}

- (void)testRangeTreeSameRange
{
    JXRangeTree* intervalTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSString* testObjectB = @"TestObject B";
    NSSet* setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];

    [intervalTree addObject:testObjectA forRangeWithLowValue:2 highValue:5];
    [intervalTree addObject:testObjectB forRangeWithLowValue:2 highValue:5];
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:2 highValue:5], setWithObjectsAB);
}

- (void)testRangeTreeWithRangeStartingAtZero
{
    JXRangeTree* intervalTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSString* testObjectB = @"TestObject B";
    NSSet* setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];

    [intervalTree addObject:testObjectA forRangeWithLowValue:4 highValue:18];
    [intervalTree addObject:testObjectB forRangeWithLowValue:26 highValue:40];
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:0 highValue:476], setWithObjectsAB);
    
    NSSet* nodes = [intervalTree nodesInRangeWithLowValue:0 highValue:476];
    for(JXRangeTreeNode* node in nodes)
        [intervalTree deleteNode:node];
    XCTAssertEqualObjects([intervalTree objectsInRangeWithLowValue:0 highValue:476], [NSSet set]);
}

- (void)testRecursiveEnumeration
{
    JXRangeTree* intervalTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"A";
    NSString* testObjectB = @"B";
    NSString* testObjectC = @"C";
    NSString* testObjectD = @"D";
    NSString* testObjectE = @"E";
    
    [intervalTree addObject:testObjectA forRangeWithLowValue: 3 highValue: 4];
    [intervalTree addObject:testObjectB forRangeWithLowValue: 4 highValue: 6];
    [intervalTree addObject:testObjectC forRangeWithLowValue: 5 highValue: 7];
    [intervalTree addObject:testObjectD forRangeWithLowValue: 8 highValue:10];
    [intervalTree addObject:testObjectE forRangeWithLowValue:10 highValue:11];
    
    NSSet* setWithObjectsABC = [NSSet setWithObjects:testObjectA, testObjectB, testObjectC, nil];
    NSSet* setWithObjectsABCD = [NSSet setWithObjects:testObjectA, testObjectB, testObjectC, testObjectD, nil];
    NSSet* setWithObjectsCDE = [NSSet setWithObjects:testObjectC, testObjectD, testObjectE, nil];

    NSMutableSet* enumeratedObjectsForB = [NSMutableSet set];
    NSMutableSet* enumeratedObjectsForC = [NSMutableSet set];
    NSMutableSet* enumeratedObjectsForD = [NSMutableSet set];
    
    // Outer enumeration should include B, C, and D.
    [intervalTree enumerateNodesInRangeWithLowValue:5 highValue:9 usingBlock:^(JXRangeTreeNode* outerNode, BOOL* stop) {
        double lowValue  = outerNode.lowValue - 1;
        double highValue = outerNode.highValue + 1;
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
        
        // Inner enumeration includes A, B, C for B; A, B, C, D for C; and C, D, E for D.
        [intervalTree enumerateNodesInRangeWithLowValue:lowValue highValue:highValue usingBlock:^(JXRangeTreeNode* innerNode, BOOL* stop2) {
            id innerObject = innerNode.object;
            [enumeratedObjects addObject:innerObject];
        }];
    }];
        
    XCTAssertEqualObjects(enumeratedObjectsForB, setWithObjectsABC);
    XCTAssertEqualObjects(enumeratedObjectsForC, setWithObjectsABCD);
    XCTAssertEqualObjects(enumeratedObjectsForD, setWithObjectsCDE);
}

- (void)testMutationDuringEnumeration
{
    JXRangeTree* intervalTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"A";
    NSString* testObjectB = @"B";
    NSString* testObjectC = @"C";
    
    [intervalTree addObject:testObjectA forRangeWithLowValue:3 highValue:4];
    [intervalTree addObject:testObjectB forRangeWithLowValue:4 highValue:6];

    XCTAssertThrows([intervalTree enumerateNodesInRangeWithLowValue:5 highValue:5 usingBlock:^(JXRangeTreeNode* outerNode, BOOL* stop) {
        [intervalTree addObject:testObjectC forRangeWithLowValue:5 highValue:7];
    }]);
}

@end
