//
//  JXRangeTreeNode-Private.h
//  JXFoundation
//
//

#import "JXRangeTreeNode.h"

@interface JXRangeTreeNode ()

#pragma mark Accessing properties

@property (nonatomic, readwrite, strong) JXRangeTreeNode*    leftNode;
@property (nonatomic, readwrite, strong) JXRangeTreeNode*    rightNode;
@property (nonatomic, readwrite, weak)   JXRangeTreeNode*    parentNode;

@property (nonatomic, readwrite)        double                  key;
@property (nonatomic, readwrite)        double                  high;
@property (nonatomic, readwrite)        double                  maxHigh;
@property (nonatomic, readwrite)        BOOL                    isRed; 

#pragma mark Overlapping interval tree nodes

- (BOOL)overlapsWithIntervalWithLowValue:(double)lowValue
                               highValue:(double)highValue;

#pragma mark Accessing dot representation

@property (nonatomic, readonly) NSString* dotRepresentation;

@end
