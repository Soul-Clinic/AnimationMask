//
//  ViewController.m
//  AnimationMask
//
//  Created by Can EriK Lu on 3/31/14.
//  Copyright (c) 2014 Can EriK Lu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGPoint _touchPoint;
    CALayer* _ocean;
    CAShapeLayer* layer;
    CAGradientLayer* gradient, *gradientHorizen;
    CALayer* layer2;
    CAShapeLayer* layerBack;
    CALayer* _animatingLayer;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _ocean = [self.view setBackgroundImage:[UIImage imageNamed:@"ocean.jpg"]];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];

    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
    tap2.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:tap2];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[UIActionSheet alloc] initWithTitle:@"Try tap one or two fingers" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil] showInView:self.view];
}

- (void)tap2:(UITapGestureRecognizer*)gesture
{
    static float radius = 70.0, radius2 = 500;
    static CGColorRef fillColor;
    if (!layer) {
        layer = [CAShapeLayer layer];
        layer.frame = self.view.bounds;
        fillColor = rgba(0, 0, 0, 0.6).CGColor;
        layer.fillColor = fillColor;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowRadius = 15;
        layer.shadowOffset = CGSizeZero;
        layer.shadowOpacity = 0.7;
//        layer.fillRule = kCAFillRuleEvenOdd;
        [self.view.layer addSublayer:layer];
        gradient = [CAGradientLayer layer];
        gradient.colors = @[(__bridge id)fillColor, (id)rgba(0, 0, 0, 0).CGColor, (id)rgba(0, 0, 0, 0).CGColor, (__bridge id)fillColor];
        gradient.locations = @[@0, @0.15, @0.85, @1];
        gradientHorizen = [CAGradientLayer layer];
        gradientHorizen.colors = @[ (__bridge id)fillColor, (__bridge id)fillColor, (id)rgba(0, 0, 0, 0).CGColor, (id)rgba(0, 0, 0, 0).CGColor, (__bridge id)fillColor, (__bridge id)fillColor];
        gradientHorizen.locations = @[@0, @0.04, @0.1, @0.9, @0.96, @1];
        gradientHorizen.startPoint = CGPointMake(0, 0.5);
        gradientHorizen.endPoint = CGPointMake(1, 0.5);

    }
    _touchPoint = [gesture locationInView:gesture.view];

    static CGMutablePathRef path, path2;
    path = CGPathCreateMutable();
    path2 = CGPathCreateMutable();
//    CGPathAddRoundedRect(path2, NULL, self.view.bounds, 10, 10);
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPoint pts[4] = {CGPointMake(0, self.view.bounds.size.height), CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height),
        CGPointMake(self.view.bounds.size.width, 0),  CGPointMake(0, 0) };
    CGPathAddLines(path, NULL, pts, 4);
    CGPathMoveToPoint(path2, NULL, 0, 0);
        CGPathAddLines(path2, NULL, pts, 4);
//    CGPathAddRoundedRect(path, NULL, self.view.bounds, 10, 10);

    CGRect beginRect = CGRectMake(_touchPoint.x - radius2 / 2, _touchPoint.y - radius2 / 2, radius2 * 1.3, radius2 * 0.7);
    CGRect endRect = CGRectMake(_touchPoint.x - radius / 2, _touchPoint.y - radius / 2, radius * 1.3, radius * 0.7);

    CGPathAddRect(path2, NULL, endRect);
    CGPathAddRect(path, NULL, beginRect);

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    pathAnimation.duration = .3f;
    pathAnimation.fromValue = (__bridge id)path;
    pathAnimation.toValue = (__bridge id)path2;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.delegate = self;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _animatingLayer = layer;
    [layer addAnimation:pathAnimation forKey:@"pathAnimation"];
    CGPathRelease(path);
    CGPathRelease(path2);
    return;

}
- (void)animationDidStart:(CAAnimation *)theAnimation
{
    NSArray* layers = self.view.layer.sublayers;
    for (CALayer* aLayer in layers) {
        if (aLayer.zPosition < 0) {
            continue;
        }
        if (aLayer != _animatingLayer) {
            aLayer.opacity = 0;
        }
        else {
            aLayer.opacity = 1;
        }

    }
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view.layer addSublayer:layer2];
//        [layerBack removeFromSuperlayer];
//    }];
    CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    shadowAnimation.duration = .7f;
//    shadowAnimation.fromValue = @5;
    shadowAnimation.toValue = @4;
    shadowAnimation.fillMode = kCAFillModeForwards;
    shadowAnimation.removedOnCompletion = NO;
//    shadowAnimation.autoreverses = YES;
    shadowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_animatingLayer addAnimation:shadowAnimation forKey:@"shadow"];
}

- (void)tap:(UITapGestureRecognizer*)tap
{

    static float radius = 100;
    CGPoint pt = [tap locationInView:tap.view];
    NSLog(@"Tap 2 %@", NSStringFromCGPoint(pt));

    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGColorRef fillColor = rgba(0, 0, 0, 0.7).CGColor;
    CGFloat locations[] = {0, 0.85, 0.9, 1};
    CGGradientRef g = CGGradientCreateWithColors(rgb,  (__bridge CFArrayRef)@[(__bridge id)rgba(0, 0, 0, 0.0).CGColor,
                                                                              (__bridge id)rgba(0, 0, 0, 0.0).CGColor,
                                                                              (__bridge id)rgba(0, 0, 0, 0.3).CGColor,
                                                                              (__bridge id)fillColor], locations);
    CGContextDrawRadialGradient(ctx, g, pt, 0, pt, radius, kCGGradientDrawsAfterEndLocation);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(ctx, self.view.bounds);
    CGContextDrawRadialGradient(ctx, g, pt, 0, pt, radius * 2, kCGGradientDrawsAfterEndLocation);
    UIImage* image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    static UIBezierPath* bezier, *framePath;
    if (!layer2) {
        layer2 = [CALayer layer];
        layer2.frame = self.view.bounds;

        layerBack = [CAShapeLayer layer];
//        layerBack.fillRule = kCAFillRuleEvenOdd;
        layerBack.fillColor = rgba(0, 0, 0, 0.0).CGColor;
        layerBack.frame = self.view.bounds;
        layerBack.shadowOffset = CGSizeZero;
        layerBack.shadowOpacity = 0.8;
        layerBack.shadowRadius = 10;
        layerBack.shadowColor = [UIColor blackColor].CGColor;
    }

    bezier = [UIBezierPath bezierPathWithRect:CGRectInset(self.view.bounds, -100, -100)];
    framePath = [UIBezierPath bezierPathWithRect:CGRectInset(self.view.bounds, -100, -100)];
    [bezier addArcWithCenter:pt radius:radius startAngle:M_PI* 2 endAngle:0 clockwise:NO];
    [framePath addArcWithCenter:pt radius:radius * 8 startAngle:M_PI* 2  endAngle:0 clockwise:NO];

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    pathAnimation.duration = .4f;
    pathAnimation.fromValue = (__bridge id)framePath.CGPath;
    pathAnimation.toValue = (__bridge id)bezier.CGPath;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.delegate = self;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];



    CABasicAnimation* contentAnimation = [CABasicAnimation animationWithKeyPath:@"content"];
    contentAnimation.duration = 1.0;
    contentAnimation.fromValue = (id)image2.CGImage;
    contentAnimation.toValue = (id)image.CGImage;

//    layer2.contents = (id)image.CGImage;


//    layerBack.shadowPath = bezier.CGPath;
    _animatingLayer = layerBack;
    [layerBack addAnimation:pathAnimation forKey:@"pathAnimation"];
//    layer2.contents = contentAnimation.toValue;
//    [layer2 addAnimation:contentAnimation forKey:@"content"];
//    [layerBack addSublayer:layer2];
    [self.view.layer addSublayer:layerBack];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};

    UIColor *centerColor = [UIColor orangeColor];
    UIColor *edgeColor = [UIColor purpleColor];

    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)centerColor.CGColor, (__bridge id)edgeColor.CGColor, nil];
    CGGradientRef g = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);

    // Scaling transformation and keeping track of the inverse
    CGAffineTransform scaleT = CGAffineTransformMakeScale(2, 1.0);
    CGAffineTransform invScaleT = CGAffineTransformInvert(scaleT);

    // Extract the Sx and Sy elements from the inverse matrix
    // (See the Quartz documentation for the math behind the matrices)
    CGPoint invS = CGPointMake(invScaleT.a, invScaleT.d);

    // Transform center and radius of gradient with the inverse
    CGPoint center = CGPointMake((self.view.bounds.size.width / 2) * invS.x, (self.view.bounds.size.height / 2) * invS.y);
    CGFloat radius = (self.view.bounds.size.width / 2) * invS.x;

    // Draw the gradient with the scale transform on the context
    CGContextScaleCTM(ctx, scaleT.a, scaleT.d);
    CGContextDrawRadialGradient(ctx, g, center, 0, center, radius, kCGGradientDrawsBeforeStartLocation);

    // Reset the context
    CGContextScaleCTM(ctx, invS.x, invS.y);

    // Continue to draw whatever else ...

    // Clean up the memory used by Quartz
    CGGradientRelease(g);
    CGColorSpaceRelease(colorSpace);
}







@end
