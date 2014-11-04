//  Created by Alejandro Isaza on 2014-03-31.
//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <UIKit/UIKit.h>
#include <mxml/geometry/Geometry.h>


@interface VMScoreElementView : UIView

/** Designated initializer. */
- (id)initWithGeometry:(const mxml::Geometry*)geometry;

/** Geometry object. */
@property(nonatomic) const mxml::Geometry* geometry;

/** The foreground color. */
@property(nonatomic, strong) UIColor* foregroundColor;

/** Location of the element's anchor point in normal measure coordinates.
 
 Normal measure coordinates have the same scale as the coordinates defined in the MusicXML specification. The origin is
 the top line of the top staff. Coordinates increase down and to the right. The distance between staff lines is 10
 units. Because of these properties the location will stay the same regardless of the value of scale. This differs from
 view properties such as `center`, which will change depending on the scale, the parent view and the size of the
 measure view.
 */
@property(nonatomic, readonly) CGPoint location;

/** Anchor point in inside the view's bounds.
 
 The anchor is a point in normalized coordinates - `(0, 0)` is the top left corner of the bounds rect, `(1, 1)` is
 the bottom right corner. Defaults to `(0.5, 0.5)`, i.e. the center of the bounds.
 */
@property(nonatomic, readonly) CGPoint anchorPoint;

/** Geometry origin. */
@property(nonatomic, readonly) CGPoint geometryOrigin;

/** Geometry size. */
@property(nonatomic, readonly) CGSize geometrySize;

/** Geometry frame. */
@property(nonatomic, readonly) CGRect geometryFrame;

/** This method is called from init to setup the view.
 
 Implementing all possible init methods for a view is cumbersome and prone to error. Instead all subclasses should put
 their setup code in this method. Don't forget to call super's implementation.
 */
- (void)setup;

/** Update the view's properties to match the geometry.
 */
- (void)updateView;

@end
