//
//  JXRangeTree-Private.h
//  JXRangeTree
//
//

#import "JXRangeTree.h"

@interface JXRangeTree (Private)

#pragma mark Inserting and deleting nodes

- (void)insertNode:(JXRangeTreeNode*)node;
- (id)deleteNode:(JXRangeTreeNode*)node;
- (void)balanceNode:(JXRangeTreeNode*)node;

#pragma mark Accessing preceding and succeeding node 

- (JXRangeTreeNode*)nodePrecedingNode:(JXRangeTreeNode*)node;
- (JXRangeTreeNode*)nodeSucceedingNode:(JXRangeTreeNode*)node;

#pragma mark Rotating nodes

- (void)rotateNodeToLeft:(JXRangeTreeNode*)node;
- (void)rotateNodeToRight:(JXRangeTreeNode*)node;

#pragma mark Updating and checking max highs

- (void)updateMaxHighForNodeAndAncestors:(JXRangeTreeNode*)node;
- (void)checkMaxHighOfNode:(JXRangeTreeNode*)node;

#pragma mark Accessing dot representation

- (NSString*)dotRepresentation;
- (void)showInGraphvizWithName:(NSString*)name;

@end
