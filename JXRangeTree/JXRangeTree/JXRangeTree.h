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
                     forRange:(NSRange)range;

- (JXRangeTreeNode*)addObject:(id)object
         forRangeWithLowValue:(CFIndex)lowValue
                       highValue:(CFIndex)highValue;

- (id)removeObjectForRange:(NSRange)range;

- (id)removeObjectForRangeWithLowValue:(CFIndex)lowValue
                                highValue:(CFIndex)highValue;

- (id)deleteNode:(JXRangeTreeNode*)node;

#pragma mark Accessing objects and nodes

- (void)enumerateNodesInRange:(NSRange)range
                   usingBlock:(void (^)(JXRangeTreeNode* node, BOOL* stop))block;

- (void)enumerateNodesInRangeWithLowValue:(CFIndex)lowValue
                                   highValue:(CFIndex)highValue
                                  usingBlock:(void (^)(JXRangeTreeNode* node, BOOL* stop))block;

- (NSSet*)objectsInRange:(NSRange)range;

- (NSSet*)objectsInRangeWithLowValue:(CFIndex)lowValue
                              highValue:(CFIndex)highValue;

- (NSSet*)nodesInRange:(NSRange)range;

- (NSSet*)nodesInRangeWithLowValue:(CFIndex)lowValue
                            highValue:(CFIndex)highValue;

- (JXRangeTreeNode*)nodeForRange:(NSRange)range;

- (JXRangeTreeNode*)nodeForRangeWithLowValue:(CFIndex)lowValue
                                         highValue:(CFIndex)highValue;

@end
