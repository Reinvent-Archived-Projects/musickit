//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKImageStore.h"
#import "VMKMeasureView.h"
#import "VMKMeasureLayer.h"

static const NSTimeInterval kAnimationDuration = 0.5;


@interface VMKMeasureView ()

@property(nonatomic, strong, readonly) VMKMeasureLayer* measureLayer;
@property(nonatomic, strong) UILabel* bookmarkedNumberLabel;
@property(nonatomic, strong) UIImageView* bookmarkImageView;

@end


@implementation VMKMeasureView

+ (Class)layerClass {
    return [VMKMeasureLayer class];
}

- (VMKMeasureLayer*)measureLayer {
    return (VMKMeasureLayer*)self.layer;
}

- (instancetype)initWithMeasure:(const mxml::MeasureGeometry*)measureGeometry {
    self = [super initWithGeometry:measureGeometry];
    if (!self)
        return nil;

    self.measureLayer.measureGeometry = measureGeometry;
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];

    [self setupBookmarkViews];

    return self;
}

- (void)setupBookmarkViews {
    _bookmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-bookmark"]];
    _bookmarkImageView.layer.anchorPoint = CGPointMake(0, 1);
    _bookmarkImageView.hidden = YES;
    [self addSubview:_bookmarkImageView];

    _bookmarkedNumberLabel = [[UILabel alloc] init];
    _bookmarkedNumberLabel.layer.anchorPoint = CGPointMake(0, 1);
    _bookmarkedNumberLabel.textAlignment = NSTextAlignmentCenter;
    _bookmarkedNumberLabel.textColor = [UIColor whiteColor];
    _bookmarkedNumberLabel.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:11];
    _bookmarkedNumberLabel.text = @"1";
    _bookmarkedNumberLabel.hidden = YES;
    [self addSubview:_bookmarkedNumberLabel];
}


#pragma mark - Bookmakrs

- (void)setBookmarked:(BOOL)bookmarked {
    [self setBookmarked:bookmarked animated:NO];
}

- (void)setBookmarked:(BOOL)bookmarked animated:(BOOL)animated {
    static const CGFloat kMinimumScale = 0.2;
    static const CGAffineTransform kMinimumScaleTransform = CGAffineTransformMakeScale(kMinimumScale, kMinimumScale);

    _bookmarked = bookmarked;

    if (bookmarked) {
        _bookmarkImageView.hidden = NO;
        _bookmarkedNumberLabel.hidden = NO;

        void (^setupBlock)() = ^() {
            _bookmarkImageView.alpha = 0;
            _bookmarkImageView.transform = kMinimumScaleTransform;
            _bookmarkedNumberLabel.alpha = 0;
            _bookmarkedNumberLabel.transform = kMinimumScaleTransform;
        };
        void (^animationBlock)() = animationBlock = ^() {
            _bookmarkImageView.alpha = 1;
            _bookmarkImageView.transform = CGAffineTransformIdentity;
            _bookmarkedNumberLabel.alpha = 1;
            _bookmarkedNumberLabel.transform = CGAffineTransformIdentity;
            //_numberLabel.alpha = 0;
        };

        if (animated) {
            setupBlock();
            [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:50 options:0 animations:animationBlock completion:nil];
        } else {
            animationBlock();
        }
    } else {
        _bookmarkImageView.hidden = YES;
        _bookmarkedNumberLabel.hidden = YES;
        //_numberLabel.alpha = 1;
    }
}


#pragma mark -

- (void)setBookmarkedColor:(UIColor *)bookmarkedColor {
    _bookmarkedColor = bookmarkedColor;
    _bookmarkImageView.image = [VMKImageStore maskFillImage:[VMKImage imageNamed:@"bg-bookmark"] withColor:bookmarkedColor];
}

- (const mxml::MeasureGeometry*)measureGeometry {
    return static_cast<const mxml::MeasureGeometry*>(self.measureLayer.measureGeometry);
}

- (void)setMeasureGeometry:(const mxml::MeasureGeometry *)measureGeometry {
    self.measureLayer.measureGeometry = measureGeometry;

    if (measureGeometry) {
        const mxml::dom::Measure& measure = self.measureGeometry->measure();
        _bookmarkedNumberLabel.text = [NSString stringWithUTF8String:measure.number().c_str()];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _bookmarkImageView.center = CGPointMake(0, 0);

    _bookmarkedNumberLabel.center = CGPointMake(0, -2);
    _bookmarkedNumberLabel.bounds = {CGPointZero, _bookmarkImageView.bounds.size};
}

@end
