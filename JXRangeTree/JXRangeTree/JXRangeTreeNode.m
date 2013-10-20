//
//  JXRangeTreeNode.m
//  JXRangeTree
//
//

#import "JXRangeTreeNode-Private.h"

@implementation JXRangeTreeNode

#pragma mark Managing life cycle

- (id)initWithObject:(id)object
            lowValue:(CFIndex)lowValue
           highValue:(CFIndex)highValue
{
	if (self = [super init]) {
		_object = object;
        
		_key = lowValue;
		_high = highValue;
		_maxHigh = highValue;
	}
    
	return self;
}

- (id)initNilNode
{
	if (self = [super init]) {
		_leftNode = self;
		_rightNode = self;
		_parentNode = self;
		_isRed = NO;
		_key = kCFNotFound;
		_high = kCFNotFound;
		_maxHigh = kCFNotFound;
		_object = nil;
	}
    
	return self;
}

- (id)initRootNodeWithNilNode:(JXRangeTreeNode *)nilNode
{
	if (self = [super init]) {
		_leftNode = nilNode;
		_rightNode = nilNode;
		_parentNode = nilNode;
		_isRed = NO;
		_key = LONG_MAX;
		_high = LONG_MAX;
		_maxHigh = LONG_MAX;
		_object = nil;
	}
    
	return self;
}

#pragma mark Accessing properties

- (CFIndex)lowValue
{
	return _key;
}

- (CFIndex)highValue
{
	return _high;
}

#pragma mark Overlapping interval tree nodes

- (BOOL)overlapsWithRangeWithLowValue:(CFIndex)lowValue
                            highValue:(CFIndex)highValue
{
	BOOL overlaps;
    
	if (_key <= lowValue) {
		overlaps = (lowValue < _high);
	}
	else { /* lowValue < _key */
		overlaps = (_key < highValue);
	}
    
	return overlaps;
}

#pragma mark Accessing dot representation

- (NSString *)dotRepresentation
{
	NSMutableString *dotRepresentation;
    
	if (_object) {
		dotRepresentation = [[NSMutableString alloc] init];
        
		[dotRepresentation appendFormat:@"%ld [%@ label=\"%ld - %ld\" fontsize=12 %@];\n", (long)_key, @"shape=box", (long)_key,
		 (long)_high, _isRed ? @"color=\"0.000 1.000 1.000\"":@"color=\"0.000 0.000 0.000\""];
		if (_leftNode) {
			NSString *leftNodeDotRepresentation = _leftNode.dotRepresentation;
			if (leftNodeDotRepresentation) {
				[dotRepresentation appendFormat:@"%@", leftNodeDotRepresentation];
				if ( (_key != _leftNode.key) && (_leftNode.key != _parentNode.key) ) {
					[dotRepresentation appendFormat:@"%ld -> %ld;\n", (long)_key, (long)_leftNode.key];
				}
			}
		}
		if (_rightNode && _rightNode->_object) {
			NSString *rightNodeDotRepresentation = _rightNode.dotRepresentation;
			if (rightNodeDotRepresentation) {
				[dotRepresentation appendFormat:@"%@", rightNodeDotRepresentation];
				if ( (_key != _rightNode.key) && (_rightNode.key != _parentNode.key) ) {
					[dotRepresentation appendFormat:@"%ld -> %ld;\n", (long)_key, (long)_rightNode.key];
				}
			}
		}
	}
    
	return dotRepresentation;
}

@end