//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import <AppKit/AppKit.h>
#import <MusicKit/MusicKit.h>

#include <mxml/geometry/ScoreGeometry.h>
#include <mxml/geometry/PartGeometry.h>


class VMKScoreRenderer {
public:
    /**
     The scale used to render the score.
     */
    static const CGFloat scale;

    /**
     The number of measures to include in the rendering.
     */
    static const int numberOfMeasures;
    
public:
    /**
     Construct a score renderer for the score geometry.
     */
    VMKScoreRenderer(const mxml::ScoreGeometry& scoreGeometry);

    /**
     Render the first `numberOfMeasures` measures of the last part of the score.

     @return An NSBitmatImageRep of the rendered score.
     */
    NSBitmapImageRep* render();

protected:
    static CGSize partSize(const mxml::PartGeometry& partGeometry);

    void renderMeasures(CGContextRef ctx);
    void renderDirections(CGContextRef ctx);
    void renderTies(CGContextRef ctx);
    
    CGRect getFrame(const mxml::Geometry& geometry);
    void renderLayer(CGContextRef ctx, VMKScoreElementLayer* layer, CGRect frame);

private:
    const mxml::ScoreGeometry& _scoreGeometry;
    const mxml::PartGeometry* _lastPartGeometry;

    CGRect _renderBounds;
};
