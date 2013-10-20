//
//  JXRangeTreeTest.m
//  JXRangeTree
//
//

#import <XCTest/XCTest.h>

#import "JXRangeTree.h"
#import "JXRangeTreeNode.h"


NS_INLINE NSRange JXMakeRangeFromTo(NSUInteger start, NSUInteger end)
{
	NSRange r;
	r.location = start;
	r.length = end - start;
	return r;
}

@interface JXRangeTreeTest : XCTestCase
@end

@implementation JXRangeTreeTest

- (void)testRangeTree
{
	JXRangeTree *rangeTree = [[JXRangeTree alloc] init];
    
	NSString *testObjectA = @"TestObject A";
	NSSet *setWithObjectA = [NSSet setWithObject:testObjectA];
    
	[rangeTree addObject:testObjectA forRange:JXMakeRangeFromTo(2, 4)];
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(0, 1)], [NSSet set]);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(1, 2)], [NSSet set]);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 3)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 4)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(4, 5)], [NSSet set]);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(5, 9)], [NSSet set]);
}

- (void)testRangeTreeAdditionBeforeRemoval
{
	JXRangeTree *rangeTree = [[JXRangeTree alloc] init];
    
	NSString *testObjectA = @"TestObject A";
	[rangeTree addObject:testObjectA forRange:JXMakeRangeFromTo(2, 5)];
	NSString *testObjectB = @"TestObject B";
	[rangeTree addObject:testObjectB forRange:JXMakeRangeFromTo(3, 7)];
	NSString *testObjectC = @"TestObject C";
    
	NSSet *setWithObjectA = [NSSet setWithObject:testObjectA];
	NSSet *setWithObjectB = [NSSet setWithObject:testObjectB];
	NSSet *setWithObjectC = [NSSet setWithObject:testObjectC];
	NSSet *setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
	NSSet *setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
	NSSet *setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 3)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(3, 5)], setWithObjectsAB);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(5, 7)], setWithObjectB);
    
	[rangeTree addObject:testObjectC forRange:JXMakeRangeFromTo(4, 6)];
    
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 3)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(3, 4)], setWithObjectsAB);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(4, 5)], setWithObjectsABC);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(5, 6)], setWithObjectsBC);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(6, 7)], setWithObjectB);
    
	[rangeTree removeObjectForRange:JXMakeRangeFromTo(4, 6)];
    
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 3)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(3, 5)], setWithObjectsAB);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(5, 7)], setWithObjectB);
}

- (void)testRangeTreeAdditionAfterRemoval
{
	JXRangeTree *rangeTree = [[JXRangeTree alloc] init];
    
	NSString *testObjectA = @"TestObject A";
	[rangeTree addObject:testObjectA forRange:JXMakeRangeFromTo(2, 5)];
	NSString *testObjectB = @"TestObject B";
	[rangeTree addObject:testObjectB forRange:JXMakeRangeFromTo(3, 7)];
	NSString *testObjectC = @"TestObject C";
	[rangeTree addObject:testObjectC forRange:JXMakeRangeFromTo(4, 6)];
    
	NSSet *setWithObjectA = [NSSet setWithObject:testObjectA];
	NSSet *setWithObjectB = [NSSet setWithObject:testObjectB];
	NSSet *setWithObjectC = [NSSet setWithObject:testObjectC];
	NSSet *setWithObjectsAB = [setWithObjectA setByAddingObjectsFromSet:setWithObjectB];
	NSSet *setWithObjectsBC = [setWithObjectB setByAddingObjectsFromSet:setWithObjectC];
	NSSet *setWithObjectsABC = [setWithObjectsAB setByAddingObjectsFromSet:setWithObjectC];
    
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 3)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(3, 4)], setWithObjectsAB);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(4, 5)], setWithObjectsABC);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(5, 6)], setWithObjectsBC);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(6, 7)], setWithObjectB);
    
	[rangeTree removeObjectForRange:JXMakeRangeFromTo(4, 6)];
    
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 3)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(3, 5)], setWithObjectsAB);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(5, 7)], setWithObjectB);
    
	[rangeTree addObject:testObjectC forRange:JXMakeRangeFromTo(4, 6)];
    
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 3)], setWithObjectA);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(3, 4)], setWithObjectsAB);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(4, 5)], setWithObjectsABC);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(5, 6)], setWithObjectsBC);
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(6, 7)], setWithObjectB);
}

- (void)testRangeTreeSameRange
{
	JXRangeTree *rangeTree = [[JXRangeTree alloc] init];
    
	NSString *testObjectA = @"TestObject A";
	NSString *testObjectB = @"TestObject B";
	NSSet *setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];
    
	[rangeTree addObject:testObjectA forRange:JXMakeRangeFromTo(2, 5)];
	[rangeTree addObject:testObjectB forRange:JXMakeRangeFromTo(2, 5)];
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(2, 5)], setWithObjectsAB);
}

- (void)testRangeTreeWithRangeStartingAtZero
{
	JXRangeTree *rangeTree = [[JXRangeTree alloc] init];
    
	NSString *testObjectA = @"TestObject A";
	NSString *testObjectB = @"TestObject B";
	NSSet *setWithObjectsAB = [NSSet setWithObjects:testObjectA, testObjectB, nil];
    
	[rangeTree addObject:testObjectA forRange:JXMakeRangeFromTo(4, 18)];
	[rangeTree addObject:testObjectB forRange:JXMakeRangeFromTo(26, 40)];
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(0, 476)], setWithObjectsAB);
    
	NSSet *nodes = [rangeTree nodesInRange:JXMakeRangeFromTo(0, 476)];
	for (JXRangeTreeNode *node in nodes) {
		[rangeTree deleteNode:node];
	}
	XCTAssertEqualObjects([rangeTree objectsInRange:JXMakeRangeFromTo(0, 476)], [NSSet set]);
}

- (void)testRecursiveEnumeration
{
	JXRangeTree *rangeTree = [[JXRangeTree alloc] init];
    
	NSString *testObjectA = @"A";
	NSString *testObjectB = @"B";
	NSString *testObjectC = @"C";
	NSString *testObjectD = @"D";
	NSString *testObjectE = @"E";
    
	[rangeTree addObject:testObjectA forRange:JXMakeRangeFromTo(3, 4)];
	[rangeTree addObject:testObjectB forRange:JXMakeRangeFromTo(4, 6)];
	[rangeTree addObject:testObjectC forRange:JXMakeRangeFromTo(5, 7)];
	[rangeTree addObject:testObjectD forRange:JXMakeRangeFromTo(8, 10)];
	[rangeTree addObject:testObjectE forRange:JXMakeRangeFromTo(10, 11)];
    
	NSSet *setWithObjectsABC = [NSSet setWithObjects:testObjectA, testObjectB, testObjectC, nil];
	NSSet *setWithObjectsBC = [NSSet setWithObjects:testObjectB, testObjectC, nil];
	NSSet *setWithObjectsDE = [NSSet setWithObjects:testObjectD, testObjectE, nil];
    
	NSMutableSet *enumeratedObjectsForB = [NSMutableSet set];
	NSMutableSet *enumeratedObjectsForC = [NSMutableSet set];
	NSMutableSet *enumeratedObjectsForD = [NSMutableSet set];
    
	// Outer enumeration should include B, C, and D.
	[rangeTree enumerateNodesInRange:JXMakeRangeFromTo(5, 9) usingBlock:^ (JXRangeTreeNode *outerNode, BOOL *stop) {
        CFIndex lowValue  = outerNode.lowValue - 1;
        CFIndex highValue = outerNode.highValue + 1;
        id outerObject = outerNode.object;
        
        NSMutableSet *enumeratedObjects;
        
        if ([outerObject isEqual:testObjectB]) {
            enumeratedObjects = enumeratedObjectsForB;
        }
        else if ([outerObject isEqual:testObjectC]) {
            enumeratedObjects = enumeratedObjectsForC;
        }
        else {
            NSAssert([outerObject isEqual:testObjectD], nil);
            enumeratedObjects = enumeratedObjectsForD;
        }
        
        // Inner enumeration includes A, B, C for B; B, C for C; and D, E for D.
        [rangeTree enumerateNodesInRange:JXMakeRangeFromTo(lowValue, highValue)
                              usingBlock:^ (JXRangeTreeNode *innerNode, BOOL *stop2) {
                                  id innerObject = innerNode.object;
                                  [enumeratedObjects addObject:innerObject];
                              }
         
         ];
    }
     
     ];
    
	XCTAssertEqualObjects(enumeratedObjectsForB, setWithObjectsABC);
	XCTAssertEqualObjects(enumeratedObjectsForC, setWithObjectsBC);
	XCTAssertEqualObjects(enumeratedObjectsForD, setWithObjectsDE);
}

- (void)testMutationDuringEnumeration
{
	JXRangeTree *rangeTree = [[JXRangeTree alloc] init];
    
	NSString *testObjectA = @"A";
	NSString *testObjectB = @"B";
	NSString *testObjectC = @"C";
    
	[rangeTree addObject:testObjectA forRange:JXMakeRangeFromTo(3, 4)];
	[rangeTree addObject:testObjectB forRange:JXMakeRangeFromTo(4, 6)];
    
	XCTAssertThrows([rangeTree enumerateNodesInRange:JXMakeRangeFromTo(5, 5) usingBlock:^ (JXRangeTreeNode *outerNode, BOOL *stop) {
        [rangeTree addObject:testObjectC forRange:JXMakeRangeFromTo(5, 7)];
    }
                     
                     ]);
}

@end
