//
//  JXRangeUtilities.h
//  JXRangeTree
//
//  Created by Jan on 20.10.13.
//

NS_INLINE NSRange JXMakeRangeFromTo(NSUInteger start, NSUInteger end)
{
	NSRange r;
	r.location = start;
	r.length = end - start;
	return r;
}
