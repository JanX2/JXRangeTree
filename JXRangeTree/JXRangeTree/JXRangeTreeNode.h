//
//  JXRangeTreeNode.h
//  JXRangeTree
//
//

@class JXRangeTreeNode;

@interface JXRangeTreeNode : NSObject

#pragma mark Managing life cycle

- (id)initWithObject:(id)object
            lowValue:(CFIndex)lowValue
           highValue:(CFIndex)highValue;

#pragma mark Accessing properties

@property (nonatomic, readwrite, strong)   id		object;
@property (nonatomic, readonly)            CFIndex	lowValue;
@property (nonatomic, readonly)            CFIndex	highValue;

@end
