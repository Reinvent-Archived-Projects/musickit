//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#include "VMKScoreRenderer.h"


const CGFloat VMKScoreRenderer::scale = 2;
const CGFloat VMKScoreRenderer::maxWidth = 2048;


VMKScoreRenderer::VMKScoreRenderer(const mxml::ScoreGeometry& scoreGeometry) : _scoreGeometry(scoreGeometry), _lastPartGeometry() {
    // Find last part
    for (auto& geometry : scoreGeometry.geometries())
        _lastPartGeometry = static_cast<mxml::PartGeometry*>(geometry.get());
}

NSBitmapImageRep* VMKScoreRenderer::render() {
    if (!_lastPartGeometry)
        return nil;

    CGSize size = partSize(*_lastPartGeometry);
    CGSize scaledSize = CGSizeMake(std::ceil(size.width * scale), std::ceil(size.height * scale));

    _renderBounds.origin = CGPointZero;
    _renderBounds.size = size;

    // Create image
    NSImage* image = [[NSImage alloc] initWithSize:size];
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:scaledSize.width
                             pixelsHigh:scaledSize.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    [image addRepresentation:rep];
    [image lockFocus];

    CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextTranslateCTM(ctx, 0, size.height);
    CGContextScaleCTM(ctx, 1.f, -1.f);

    renderMeasures(ctx);
    renderWords(ctx);
    renderTies(ctx);
    [image unlockFocus];

    CGImageRef cgimage = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep* newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgimage];
    [newRep setSize:[image size]];
    return newRep;
}

CGSize VMKScoreRenderer::partSize(const mxml::PartGeometry& partGeometry) {
    CGFloat measuresWidth = 0.0;
    for (auto& measureGeometry : partGeometry.geometries()) {
        measuresWidth += measureGeometry->size().width;
        if (measuresWidth >= maxWidth)
            break;
    }

    CGSize size;
    size.width = std::min(measuresWidth, maxWidth);
    size.height = partGeometry.size().height;

    // Round to nearest pixel
    CGSize scaledSize = CGSizeMake(std::ceil(size.width * scale), std::ceil(size.height * scale));
    size.width = scaledSize.width / scale;
    size.height = scaledSize.height / scale;

    return size;
}

void VMKScoreRenderer::renderMeasures(CGContextRef ctx) {
    CGFloat measuresWidth = 0.0;
    for (auto& measureGeometry : _lastPartGeometry->measureGeometries()) {
        CGRect frame = getFrame(*measureGeometry);
        if (!CGRectIntersectsRect(frame, _renderBounds))
            continue;

        VMKMeasureLayer* layer = [[VMKMeasureLayer alloc] initWithGeometry:measureGeometry];
        [layer layoutIfNeeded];

        renderLayer(ctx, layer, frame);

        measuresWidth += layer.bounds.size.width;
        if (measuresWidth >= maxWidth)
            break;
    }
}

void VMKScoreRenderer::renderWords(CGContextRef ctx) {
    for (auto& directionGeometry : _lastPartGeometry->directionGeometries()) {
        CGRect frame = getFrame(*directionGeometry);
        if (!CGRectContainsRect(_renderBounds, frame))
            continue;

        if (const mxml::WordsGeometry* geom = dynamic_cast<const mxml::WordsGeometry*>(directionGeometry)) {
            VMKScoreElementLayer *layer = [[VMKWordsLayer alloc] initWithGeometry:geom];
            renderLayer(ctx, layer, frame);
        }
    }
}

void VMKScoreRenderer::renderTies(CGContextRef ctx) {
    for (auto& tieGeometry : _lastPartGeometry->tieGeometries()) {
        CGRect frame = getFrame(*tieGeometry);
        if (!CGRectIntersectsRect(frame, _renderBounds))
            continue;

        VMKTieLayer* layer = [[VMKTieLayer alloc] initWithTieGeometry:tieGeometry];
        [layer layoutIfNeeded];

        renderLayer(ctx, layer, frame);
    }
}

CGRect VMKScoreRenderer::getFrame(const mxml::Geometry& geometry) {
    CGRect frame = CGRectFromRect(geometry.frame());
    frame.origin.y -= _lastPartGeometry->contentOffset().y;
    return VMKRoundRect(frame);
}

void VMKScoreRenderer::renderLayer(CGContextRef ctx, VMKScoreElementLayer* layer, CGRect frame) {
    CGFloat dx = frame.origin.x - layer.bounds.origin.x;
    CGFloat dy = frame.origin.y - layer.bounds.origin.y;

    [layer layoutIfNeeded];
    CGContextTranslateCTM(ctx, dx, dy);
    [layer renderInContext:ctx];
    CGContextTranslateCTM(ctx, -dx, -dy);
}
