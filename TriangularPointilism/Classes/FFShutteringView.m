//
//  FFShutteringView.m
//  TriangularPointilism
//
//  Created by James Graham on 8/29/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "FFShutteringView.h"
@interface FFShutteringView()
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSMutableArray *onScreenImageViews;
@property (nonatomic) BOOL shouldInvalidateTimer;

@end
@implementation FFShutteringView{
    int width;
}

- (NSMutableArray *)onScreenImageViews{
    if (!_onScreenImageViews) {
        _onScreenImageViews = [NSMutableArray array];
    }
    return _onScreenImageViews;
}

- (NSInteger)topBottomMarginMaskLength{
    if (_topBottomMarginMaskLength == 0) {
        _topBottomMarginMaskLength = 100;
    }
    return _topBottomMarginMaskLength;
}

@synthesize frameRate = _frameRate;
- (CGFloat)frameRate{
    if (_frameRate == 0) {
        _frameRate = 30.0f;
    }
    return _frameRate;
}

- (void)setFrameRate:(CGFloat)frameRate{
    _frameRate = frameRate;
    self.shouldInvalidateTimer = YES;
    [self sparkLife];
}

- (NSTimeInterval)artificialLifeSpan{
    return _artificialLifeSpan;
}

- (NSUInteger)maximumAllowedDeathTicks{
    if (_maximumAllowedDeathTicks == 0) {
        _maximumAllowedDeathTicks = 200;
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


- (void)awakeFromNib{
    width = 32;
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
            
            NSMutableArray *subMutArray = [NSMutableArray array];
            //one box
            [self addSubview:topLeft];
            [self addSubview:bottomRight2];

            //two box
            [self addSubview:bottomRight];
            [self addSubview:topLeft2];
            
            //three box
           /* [self addSubview:topRight];
            [self addSubview:bottomLeft2];
            
            //four
            [self addSubview:bottomLeft];
            [self addSubview:topRight2];*/
            
            FFShutteringViewRow *row = [[FFShutteringViewRow alloc] initWithItems:@[
                                                                                    [[FFShutteringViewRowItem alloc] initWithImageViewTop:topLeft
                                                                                                                          imageViewBottom:bottomRight2],
                                                                                    [[FFShutteringViewRowItem alloc] initWithImageViewTop:bottomRight
                                                                                                                          imageViewBottom:topLeft2],
                                                                                    [[FFShutteringViewRowItem alloc] initWithImageViewTop:topRight
                                                                                                                          imageViewBottom:bottomLeft2],
                                                                                    [[FFShutteringViewRowItem alloc] initWithImageViewTop:bottomLeft
                                                                                                                          imageViewBottom:topRight2]
                                                                                    ]];
            
            [_onScreenImageViews addObject:row];
        }
    }
}


- (void)fire:(NSTimer *)timer
{
    if (self.shouldInvalidateTimer)
    {
        [timer invalidate];
        
        self.shouldInvalidateTimer = NO;
    }
    
    for(FFShutteringViewRow *row in _onScreenImageViews)
    {
        for(FFShutteringViewRowItem *item in row.items)
        {
            for(UIImageView *imageView in item.imageViews)
            {
                if(imageView.tag > 1 )
                {
                    imageView.tag--;
                }
                
                if((imageView.tag == 1)
                   || (imageView.tag == 0))
                {
                    imageView.alpha += imageView.tag == 0 ? - 0.01f : 0.01f;
                }
                
                if(imageView.alpha >= 0.8f)
                {
                    imageView.tag = 0;
                }
                
                if(imageView.alpha <= 0.0f)
                {
                    //defines maximum possible amount of time a triangle may be dead (alpha 0) before coming back to life
                    
                    u_int32_t intRandom = arc4random();
                    
                    
                    if((imageView.frame.origin.y > self.topBottomMarginMaskLength / 2.0f)
                       && (imageView.frame.origin.y < self.frame.size.height - self.topBottomMarginMaskLength/2.0f))
                    {
                        //Hard coded layering. Middle halves closer to center experience 5x longer death than their further half counterparts
                        
                        imageView.tag = (intRandom % (self.maximumAllowedDeathTicks * 5)) + 1;
                    }
                    else
                    {
                        imageView.tag = (intRandom % self.maximumAllowedDeathTicks) + 1;
                    }
                }
            }
        }
    }
}

- (void)sparkLife{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f/self.frameRate target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self invalidateTimerAfterNumberOfSeconds:self.artificialLifeSpan];
    
    if (self.coordinateSquaresToOmit.count) {
        for (NSArray *coordinate in self.coordinateSquaresToOmit) {
            CGFloat xCoord = [((NSNumber *)[coordinate firstObject]) unsignedIntegerValue] * width + width/4.0;
            CGFloat yCoord = [((NSNumber *)[coordinate lastObject]) unsignedIntegerValue] * width + width/2.0;
            NSLog(@"%f, %f", xCoord, yCoord);
            
            UIView *underneathSubview = [self hitTest:[self convertPoint:CGPointMake(xCoord, yCoord) fromView:self.superview] withEvent:nil];
            if (underneathSubview != self) {
                underneathSubview.hidden = YES;

            }
            
            xCoord += width/2.0;
            //underneathSubview.hidden = YES;
            
          
        }
    }
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


@interface FFShutteringViewRow ()

@end

@implementation FFShutteringViewRow

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _items = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items
{
    self = [self init];
    
    if(self)
    {
        [_items addObjectsFromArray:items];
    }
    
    return self;
}

@end


@interface FFShutteringViewRowItem ()

@end

@implementation FFShutteringViewRowItem

- (instancetype)initWithImageViewTop:(UIImageView *)imageViewTop imageViewBottom:(UIImageView *)imageViewBottom
{
    self = [super init];
    
    if(self)
    {
        _imageViewTop = imageViewTop;
        _imageViewBottom = imageViewBottom;
    }
    
    return self;
}

- (NSArray *)imageViews
{
    NSMutableArray *arrayOfImageViews = [NSMutableArray array];
    
    if(_imageViewTop)
    {
        [arrayOfImageViews addObject:_imageViewTop];
    }
    
    if(_imageViewBottom)
    {
        [arrayOfImageViews addObject:_imageViewBottom];
    }
    
    return arrayOfImageViews;
}

@end

