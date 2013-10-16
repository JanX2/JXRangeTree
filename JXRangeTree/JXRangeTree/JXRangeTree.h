//
//  JXRangeTree.h
//  JXFoundation
//
// Simple Obj-C Implementation of an interval tree.
// Inspired by Emin Martinian's C-implementation ( http://web.mit.edu/~emin/www.old/source_code/cpp_trees )

@class JXRangeTreeNode;

@interface JXRangeTree : NSObject 

#pragma mark Adding and removing objects

- (JXRangeTreeNode*)addObject:(id)object
         forRangeWithLowValue:(double)lowValue
                       highValue:(double)highValue;

- (id)removeObjectForRangeWithLowValue:(double)lowValue
                                highValue:(double)highValue;

- (id)deleteNode:(JXRangeTreeNode*)node;

#pragma mark Accessing objects and nodes

- (void)enumerateNodesInRangeWithLowValue:(double)lowValue
                                   highValue:(double)highValue
                                  usingBlock:(void (^)(JXRangeTreeNode* node, BOOL* stop))block;

- (NSSet*)objectsInRangeWithLowValue:(double)lowValue
                              highValue:(double)highValue;

- (NSSet*)nodesInRangeWithLowValue:(double)lowValue
                            highValue:(double)highValue;

- (JXRangeTreeNode*)nodeForRangeWithLowValue:(double)lowValue
                                         highValue:(double)highValue;

@end
