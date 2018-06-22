//
//  ViewController.m
//  KWSpreadLayer
//
//  Created by KW on 2018/6/22.
//  Copyright © 2018年 KW. All rights reserved.
//

#import "ViewController.h"

#define Width self.bounds.size.width
#define Height self.bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) UIView *bgView;
/** 扩散涟漪layer */
@property (nonatomic, strong) CAShapeLayer *extensionLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.bgView.center = self.view.center;
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 150;
    [self.view addSubview:self.bgView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self extensionWithAnimation];
}

- (CGRect)extensionRect {
    return self.bgView.frame;
}

- (CGRect)makeEndRect {
    CGRect endRect = [self extensionRect];
    CGFloat radius = -100;
    endRect = CGRectInset(endRect, radius, radius);
    return endRect;
}

-(void)extensionWithAnimation {
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:[self extensionRect]];
    self.extensionLayer.path = beginPath.CGPath;
    [self.view.layer insertSublayer:self.extensionLayer below:self.bgView.layer];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:[self makeEndRect]];
    self.extensionLayer.path = endPath.CGPath;
    self.extensionLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 3.f;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 3.f;
    
    [self.extensionLayer addAnimation:opacityAnimation forKey:@""];
    [self.extensionLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:self.extensionLayer afterDelay: 3.f];
}

-(CAShapeLayer *)extensionLayer {
    if (!_extensionLayer) {
        _extensionLayer = [CAShapeLayer layer];
        _extensionLayer.path = [UIBezierPath bezierPathWithOvalInRect:[self extensionRect]].CGPath;
        _extensionLayer.fillColor = [UIColor clearColor].CGColor;
        _extensionLayer.strokeColor = [UIColor redColor].CGColor;
        _extensionLayer.lineWidth = 5;
        _extensionLayer.lineCap = kCALineCapRound;
    }
    return _extensionLayer;
}

- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer {
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
