//
//  FFShutteringView.m
//  TriangularPointilism
//
//  Created by James Graham on 8/29/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "FFShutteringView.h"
@interface FFShutteringView()
@property (strong, nonatomic) NSMutableArray *arrayOfTriangleLayers;
@property (strong, nonatomic) NSArray *images;

@property (nonatomic) BOOL shouldInvalidateTimer;
@end
@implementation FFShutteringView

- (NSInteger)topBottomMarginMaskLength{
    if (_topBottomMarginMaskLength == 0) {
        _topBottomMarginMaskLength = 100;
    }
    return _topBottomMarginMaskLength;
}

- (CGFloat)frameRate{
    if (_frameRate == 0) {
        _frameRate = 30.0f;
    }
    return _frameRate;
}

- (NSTimeInterval)artificialLifeSpan{
    return _artificialLifeSpan;
}

- (NSUInteger)maximumAllowedDeathTicks{
    if (_maximumAllowedDeathTicks == 0) {
        _maximumAllowedDeathTicks = 400;
    }
    return _maximumAllowedDeathTicks;
}

- (NSArray *)images{
    if (_images) {
        _images = @[[UIImage imageNamed:@"topRight"],
                    [UIImage imageNamed:@"topLeft"],
                    [UIImage imageNamed:@"bottomRight"],
                    [UIImage imageNamed:@"bottomLeft"]];
    }
    return _images;
}

- (NSMutableArray *)arrayOfTriangleLayers{
    if (!_arrayOfTriangleLayers) {
        _arrayOfTriangleLayers = [NSMutableArray array];
    }
    return _arrayOfTriangleLayers;
}

- (void)awakeFromNib{
    int width = 28;
    NSArray *grayscales = @[@0.3, @0.15, @0.6, @0.45, @0.75, @0.0];
    for (int i = 0; i <= self.bounds.size.width; i += width) {
        for (int j = 0; j <= self.bounds.size.height; j+=width) {
            if (j > self.topBottomMarginMaskLength && j < self.bounds.size.height - self.topBottomMarginMaskLength) {
                continue;
            }
            
            UIImageView *topLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLeft"]];
            UIImageView *topRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topRight"]];
            UIImageView *bottomLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomLeft"]];
            UIImageView *bottomRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomRight"]];
            
            UIImageView *topLeft2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLeft"]];
            UIImageView *topRight2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topRight"]];
            UIImageView *bottomLeft2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomLeft"]];
            UIImageView *bottomRight2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomRight"]];
            
            
            
            bottomRight.frame = CGRectMake(i, j, topLeft.frame.size.width, topLeft.frame.size.height);
            topLeft2.frame    = bottomRight.frame;
            bottomLeft.frame = CGRectMake(i + topLeft.frame.size.width, j, topRight.frame.size.width, topRight.frame.size.height);
            topRight2.frame = bottomLeft.frame;
            
            topRight.frame = CGRectMake(i, j + topLeft.frame.size.height, bottomLeft.frame.size.width, bottomLeft.frame.size.height);
            bottomLeft2.frame = topRight.frame;
            topLeft.frame = CGRectMake(i + bottomLeft.frame.size.width, j + topLeft.frame.size.height, bottomRight.frame.size.width, bottomRight.frame.size.height);
            bottomRight2.frame = topLeft.frame;
            topLeft.alpha = [grayscales[arc4random() % grayscales.count] floatValue];
            topLeft2.alpha = [grayscales[arc4random() % grayscales.count] floatValue];
            topRight.alpha = [grayscales[arc4random() % grayscales.count] floatValue];
            topRight2.alpha = [grayscales[arc4random() % grayscales.count] floatValue];
            bottomLeft.alpha = [grayscales[arc4random() % grayscales.count] floatValue];
            bottomLeft2.alpha = [grayscales[arc4random() % grayscales.count] floatValue];
            bottomRight.alpha = [grayscales[arc4random() % grayscales.count] floatValue];
            bottomRight2.alpha =[grayscales[arc4random() % grayscales.count] floatValue];
            
            
            [self addSubview:topLeft];
            [self addSubview:topLeft2];
            [self addSubview:topRight];
            [self addSubview:topRight2];
            [self addSubview:bottomLeft];
            [self addSubview:bottomLeft2];
            [self addSubview:bottomRight];
            [self addSubview:bottomRight2];
        }
    }
}


- (void)fire:(NSTimer *)timer{
    if (self.shouldInvalidateTimer) {
        [timer invalidate];
        self.shouldInvalidateTimer = NO;
    }
    for (UIView *subview in self.subviews) {
        
        
        if (subview.tag > 1 ){
            subview.tag--;
        }
        
        if (subview.tag == 1 || subview.tag == 0) {
            subview.alpha += subview.tag == 0 ? -0.01f : 0.01f;
        }
        
        if (subview.alpha >= 0.8f) {
            subview.tag = 0;
        }
        if (subview.alpha <= 0.0f) {
            //defines maximum possible amount of time a triangle may be dead (alpha 0) before coming back to life
            subview.tag = (arc4random() % self.maximumAllowedDeathTicks) + 1;
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f/self.frameRate target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self invalidateTimerAfterNumberOfSeconds:self.artificialLifeSpan];
}
- (void)invalidateTimerAfterNumberOfSeconds:(NSTimeInterval)seconds{
    if (seconds == 0) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shouldInvalidateTimer = YES;
    });
}
@end
