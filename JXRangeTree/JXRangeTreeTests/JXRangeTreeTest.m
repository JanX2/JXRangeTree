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
    
    [rangeTree addObject:testObjectA forRangeWithLowValue:2 highValue:4];
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:0 highValue:1], [NSSet set]);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:1 highValue:2], [NSSet set]);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:3], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:4], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:4 highValue:5], [NSSet set]);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:5 highValue:9], [NSSet set]);
}

- (void)testRangeTreeAdditionBeforeRemoval
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    [rangeTree addObject:testObjectA forRangeWithLowValue:2 highValue:5];
    NSString* testObjectB = @"TestObject B";
    [rangeTree addObject:testObjectB forRangeWithLowValue:3 highValue:7];
    NSString* testObjectC = @"TestObject C";
    
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    NSSet* setWithObjectB = [NSSet setWithObject:testObjectB];
    NSSet* setWithObjectC = [NSSet setWithObject:testObjectC];
    NSSet* setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
    NSSet* setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
    NSSet* setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:3], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:3 highValue:5], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:5 highValue:7], setWithObjectB);
    
    [rangeTree addObject:testObjectC forRangeWithLowValue:4 highValue:6];

    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:3], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:3 highValue:4], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:4 highValue:5], setWithObjectsABC);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:5 highValue:6], setWithObjectsBC);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:6 highValue:7], setWithObjectB);
    
    [rangeTree removeObjectForRangeWithLowValue:4 highValue:6];
    
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:3], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:3 highValue:5], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:5 highValue:7], setWithObjectB);
}

- (void)testRangeTreeAdditionAfterRemoval
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    [rangeTree addObject:testObjectA forRangeWithLowValue:2 highValue:5];
    NSString* testObjectB = @"TestObject B";
    [rangeTree addObject:testObjectB forRangeWithLowValue:3 highValue:7];
    NSString* testObjectC = @"TestObject C";
    [rangeTree addObject:testObjectC forRangeWithLowValue:4 highValue:6];
    
    NSSet* setWithObjectA = [NSSet setWithObject:testObjectA];
    NSSet* setWithObjectB = [NSSet setWithObject:testObjectB];
    NSSet* setWithObjectC = [NSSet setWithObject:testObjectC];
    NSSet* setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
    NSSet* setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
    NSSet* setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:3], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:3 highValue:4], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:4 highValue:5], setWithObjectsABC);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:5 highValue:6], setWithObjectsBC);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:6 highValue:7], setWithObjectB);

    [rangeTree removeObjectForRangeWithLowValue:4 highValue:6];

    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:3], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:3 highValue:5], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:5 highValue:7], setWithObjectB);
    
    [rangeTree addObject:testObjectC forRangeWithLowValue:4 highValue:6];

    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:3], setWithObjectA);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:3 highValue:4], setWithObjectsAB);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:4 highValue:5], setWithObjectsABC);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:5 highValue:6], setWithObjectsBC);
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:6 highValue:7], setWithObjectB);
}

- (void)testRangeTreeSameRange
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSString* testObjectB = @"TestObject B";
    NSSet* setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];

    [rangeTree addObject:testObjectA forRangeWithLowValue:2 highValue:5];
    [rangeTree addObject:testObjectB forRangeWithLowValue:2 highValue:5];
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:2 highValue:5], setWithObjectsAB);
}

- (void)testRangeTreeWithRangeStartingAtZero
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"TestObject A";
    NSString* testObjectB = @"TestObject B";
    NSSet* setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];

    [rangeTree addObject:testObjectA forRangeWithLowValue:4 highValue:18];
    [rangeTree addObject:testObjectB forRangeWithLowValue:26 highValue:40];
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:0 highValue:476], setWithObjectsAB);
    
    NSSet* nodes = [rangeTree nodesInRangeWithLowValue:0 highValue:476];
    for(JXRangeTreeNode* node in nodes)
        [rangeTree deleteNode:node];
    XCTAssertEqualObjects([rangeTree objectsInRangeWithLowValue:0 highValue:476], [NSSet set]);
}

- (void)testRecursiveEnumeration
{
    JXRangeTree* rangeTree = [[JXRangeTree alloc] init];
    
    NSString* testObjectA = @"A";
    NSString* testObjectB = @"B";
    NSString* testObjectC = @"C";
    NSString* testObjectD = @"D";
    NSString* testObjectE = @"E";
    
    [rangeTree addObject:testObjectA forRangeWithLowValue: 3 highValue: 4];
    [rangeTree addObject:testObjectB forRangeWithLowValue: 4 highValue: 6];
    [rangeTree addObject:testObjectC forRangeWithLowValue: 5 highValue: 7];
    [rangeTree addObject:testObjectD forRangeWithLowValue: 8 highValue:10];
    [rangeTree addObject:testObjectE forRangeWithLowValue:10 highValue:11];
    
    NSSet* setWithObjectsABC = [NSSet setWithObjects:testObjectA, testObjectB, testObjectC, nil];
    NSSet* setWithObjectsBC = [NSSet setWithObjects:testObjectB, testObjectC, nil];
    NSSet* setWithObjectsDE = [NSSet setWithObjects:testObjectD, testObjectE, nil];

    NSMutableSet* enumeratedObjectsForB = [NSMutableSet set];
    NSMutableSet* enumeratedObjectsForC = [NSMutableSet set];
    NSMutableSet* enumeratedObjectsForD = [NSMutableSet set];
    
    // Outer enumeration should include B, C, and D.
    [rangeTree enumerateNodesInRangeWithLowValue:5 highValue:9 usingBlock:^(JXRangeTreeNode* outerNode, BOOL* stop) {
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
    
    [rangeTree addObject:testObjectA forRangeWithLowValue:3 highValue:4];
    [rangeTree addObject:testObjectB forRangeWithLowValue:4 highValue:6];

    XCTAssertThrows([rangeTree enumerateNodesInRangeWithLowValue:5 highValue:5 usingBlock:^(JXRangeTreeNode* outerNode, BOOL* stop) {
        [rangeTree addObject:testObjectC forRangeWithLowValue:5 highValue:7];
    }]);
}

@end
