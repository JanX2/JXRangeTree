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
         forRangeWithLowValue:(CFIndex)lowValue
                       highValue:(CFIndex)highValue;

- (id)removeObjectForRangeWithLowValue:(CFIndex)lowValue
                                highValue:(CFIndex)highValue;

- (id)deleteNode:(JXRangeTreeNode*)node;

#pragma mark Accessing objects and nodes

- (void)enumerateNodesInRangeWithLowValue:(CFIndex)lowValue
                                   highValue:(CFIndex)highValue
                                  usingBlock:(void (^)(JXRangeTreeNode* node, BOOL* stop))block;

- (NSSet*)objectsInRangeWithLowValue:(CFIndex)lowValue
                              highValue:(CFIndex)highValue;

- (NSSet*)nodesInRangeWithLowValue:(CFIndex)lowValue
                            highValue:(CFIndex)highValue;

- (JXRangeTreeNode*)nodeForRangeWithLowValue:(CFIndex)lowValue
                                         highValue:(CFIndex)highValue;

@end
