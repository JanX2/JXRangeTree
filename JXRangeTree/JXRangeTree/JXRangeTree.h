//
//  JXRangeTree.h
//  JXRangeTree
//
// Simple Obj-C Implementation of an interval tree.
// Inspired by Emin Martinian's C-implementation ( http://web.mit.edu/~emin/www.old/source_code/cpp_trees )

@class JXRangeTreeNode;

@interface JXRangeTree : NSObject

#pragma mark Adding and removing objects

- (JXRangeTreeNode *)addObject:(id)object
                      forRange:(NSRange)range;

- (id)removeObjectForRange:(NSRange)range;

- (id)deleteNode:(JXRangeTreeNode *)node;

#pragma mark Accessing objects and nodes

- (void)enumerateNodesInRange:(NSRange)range
                   usingBlock:(void (^)(JXRangeTreeNode *node, BOOL *stop))block;

- (NSSet *)objectsInRange:(NSRange)range;

- (NSSet *)nodesInRange:(NSRange)range;

- (JXRangeTreeNode *)nodeForRange:(NSRange)range;

@end
