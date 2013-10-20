//
//  JXRangeTreeNode-Private.h
//  JXRangeTree
//
//

#import "JXRangeTreeNode.h"

@interface JXRangeTreeNode ()

#pragma mark Managing life cycle

- (instancetype)initNilNode;
- (instancetype)initRootNodeWithNilNode:(JXRangeTreeNode *)nilNode;

#pragma mark Accessing properties

@property (nonatomic, readwrite, strong) JXRangeTreeNode *leftNode;
@property (nonatomic, readwrite, strong) JXRangeTreeNode *rightNode;
@property (nonatomic, readwrite, weak)   JXRangeTreeNode *parentNode;

@property (nonatomic, readwrite)        CFIndex                 key;
@property (nonatomic, readwrite)        CFIndex                 high;
@property (nonatomic, readwrite)        CFIndex                 maxHigh;
@property (nonatomic, readwrite)        BOOL                    isRed; 

#pragma mark Overlapping interval tree nodes

- (BOOL)overlapsWithRangeWithLowValue:(CFIndex)lowValue
                            highValue:(CFIndex)highValue;

#pragma mark Accessing dot representation

@property (nonatomic, readonly) NSString *dotRepresentation;

@end
