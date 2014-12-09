//
//  TPDoubleTriangleView.m
//  TriangularPointilism
//
//  Created by James Graham on 8/15/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "FFDoubleTriangleView.h"
#import <CoreGraphics/CoreGraphics.h>

#define FFDoubleTriangleView_DefaultTimerTimeInterval 0.03

@interface FFDoubleTriangleView()

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *array2;


@property (strong, nonatomic) UIImageView *imageGrayscaleView;


@property (strong, nonatomic) NSMutableArray *ksubviews;
@property (strong, nonatomic) NSMutableArray *ksublayers;

@property (strong, nonatomic) UIView *viewMask;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@property (strong, nonatomic, readwrite) UIImage *finalbwimage;

@property (nonatomic, strong) void (^completionBlock)(void);

@end

@implementation FFDoubleTriangleView{
    NSUInteger row;
    NSUInteger pixel;
    CGFloat num;
    
    NSUInteger rowRem;
    NSUInteger pixelRem;
    
    CGRect currentRect;
}

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame
{
    self = [super initWithImage:image];
    
    if(self)
    {
        if(!CGRectIsInfinite(frame))
        {
            self.frame = frame;
            
            _currentlyAnimatingEffect = FFDoubleTriangleViewEffectNone;
        }
        
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    return [self initWithImage:image andFrame:CGRectInfinite];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //[self loadMatrix];
}

- (void)snapshotMatrix{
    [self loadMatrix];

}

#pragma mark Property accessors

- (NSMutableArray *)ksubviews
{
    if(!_ksubviews)
    {
        _ksubviews = [NSMutableArray array];
    }
    
    return _ksubviews;
}

- (NSMutableArray *)ksublayers
{
    if(!_ksublayers)
    {
        _ksublayers = [NSMutableArray array];
    }
    
    return _ksublayers;
}

- (NSTimeInterval)timerTimeInterval
{
//    NSAssert(_timerTimeInterval >= 0, @"TIME CANNOT BE LESS THAN 0");
    
    if(_timerTimeInterval == 0)
    {
        return FFDoubleTriangleView_DefaultTimerTimeInterval;
    }
    
    return _timerTimeInterval;
}

#pragma mark Public methods

- (void)startAnimatedEffect:(FFDoubleTriangleViewEffect)effect withCompletion:(void (^)(void))completion
{
    _currentlyAnimatingEffect = effect;
    _completionBlock = [completion copy];
    
    [self executeTimer];
}

#pragma mark Private methods

- (void)loadMatrix
{
    num = self.frame.size.width/14;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat theBiggestSideLength = MAX(width, height);
    
    _array = [NSMutableArray array];
    _array2 = [NSMutableArray array];
    
    for(int i = 0; i < theBiggestSideLength; i += num)
    {
        [self.array addObject:[NSMutableArray array]];
        [self.array2 addObject:[NSMutableArray array]];
    }
    
    for(int i = 0; i < self.array.count; i++)
    {
        for(int j = 0; j < self.array.count; j++)
        {
            [self.array[i] addObject:[self getRGBAsFromImage:self.image
                                                         atX:j * 2 * num * (width / self.frame.size.width)
                                                        andY:i * 2 * num * (height / self.frame.size.height)]];
            
            int xIndex = ((j * 2 * num * (width / self.frame.size.width)) - (num / 2.0));
            int yIndex = ((i * 2 * num * (height / self.frame.size.height)) + (num / 2.0));
            xIndex %= (int)width * 2;
            yIndex %= (int)width * 2;
            NSLog(@"%d", xIndex);
            
            [self.array2[i] addObject:[self getRGBAsFromImage:self.image
                                                          atX:xIndex
                                                         andY:yIndex]];
        }
    }
    
    _imageGrayscaleView = [[UIImageView alloc] initWithImage:[self convertToGreyscale:self.image]];
    _finalbwimage = self.imageGrayscaleView.image;
    _imageGrayscaleView.frame = self.bounds;
    [self insertSubview:_imageGrayscaleView atIndex:0];
    
    _viewMask = [[UIView alloc] initWithFrame:self.frame];
    
    _viewMask.center = CGPointMake(_viewMask.center.x,
                                   _viewMask.center.y + _viewMask.frame.size.height / 2.0f);
    
//     [self addSubview:_viewMask];
//     self.imageGrayscaleView.maskView = _viewMask;
    
    _shapeLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = CGRectZero;
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    _shapeLayer.path = path;
    CGPathRelease(path);
    self.imageGrayscaleView.layer.mask = _shapeLayer;
}

- (void)updateMaskToRect:(CGRect)rect
{
    _shapeLayer.path = CGPathCreateWithRect(rect, NULL);
    currentRect = rect;
//    [_shapeLayer setNeedsDisplay];
    self.imageGrayscaleView.layer.mask = _shapeLayer;
}

- (UIColor *)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy{
    /**
     * Modified logic from Olie via http://stackoverflow.com/a/1262893
     */
     
    UIColor *color;
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef) ;
    NSUInteger height = CGImageGetHeight(imageRef) * (self.frame.size.width / self.bounds.size.width);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    unsigned long byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    byteIndex += 4;
   
    CGFloat lStar;
    //first
    CGFloat gamma = 2.2f;
    CGFloat y = red * pow(red, gamma) + green * pow(green, gamma) + blue * pow(blue, gamma);
    lStar = 116 * pow(y, 1.0f/3.0f);
    lStar/=255.0f;
    
    //second
//    lStar = (MAX(blue, MAX(red, green)) + MIN(blue, MIN(red, green))) / 2.0f;
    color = [UIColor colorWithWhite: lStar alpha:1.0f];
    free(rawData);
    return color;
}

- (void)fire:(NSTimer *)timer
{
    pixel++;
    
    BOOL startRawGray = row * self.array.count + pixel > 5 * self.array.count + 5;
    
    if(pixel == 5 && row == 2)
    {
//        s_imageGrayscaleView.hidden = NO;
//        [self startRemovingFromBeginning];
        [self removeTile];
    }
    
    if(pixel >= self.array.count)
    {
        pixel = 0;
        row++;
    }
    
    if(row >= self.array.count)
    {
//        [timer invalidate];
//        
//        
//        [self bringSubviewToFront:_imageGrayscaleView];
//        return;
    }
    else
    {
        [self drawTile];
    }
    
    switch(_currentlyAnimatingEffect)
    {
        case FFDoubleTriangleViewEffectBlackAndWhite:
        {
            if(startRawGray)
            {
                CGRect newRect = CGRectMake(0, 0, self.frame.size.width, (num ) * (rowRem +1 ));
                [self updateMaskToRect:newRect];
                
                pixelRem++;
                
                if(pixelRem >= self.array.count)
                {
                    pixelRem = 0;
                    rowRem++;
                }
                
                //Otherwise index overflow
                if(rowRem * self.array.count + pixelRem == self.array.count * self.array.count - 1)
                {
                    [timer invalidate];
                    
                    _currentlyAnimatingEffect = FFDoubleTriangleViewEffectNone;
                    
                    if (_completionBlock)
                    {
                        _completionBlock();
                        _completionBlock = nil;
                    }
                    
                    return;
                }
                
                [self removeTile];
            }
            
            break;
        }
        case FFDoubleTriangleViewEffectMosaicFilter:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)executeTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.timerTimeInterval
                                             target:self
                                           selector:@selector(fire:)
                                           userInfo:nil
                                            repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSDefaultRunLoopMode];
}

- (void)applyFilter
{
    while(row < self.array.count)
    {
        pixel++;
        
        if (pixel >= self.array.count)
        {
            pixel = 0;
            row++;
        }
        
        if(row == self.array.count)
        {
            self.image = self.imageGrayscaleView.image;
//             [self startRemovingFromBeginning];
            [self sizeToFit];
            break;
        }
        
        [self drawTile];
    }
}

- (void)removeTile
{
    NSUInteger index = rowRem * self.array.count + pixelRem;
    
    CAShapeLayer *layer = self.ksublayers[index];
    [layer removeFromSuperlayer];
    
    UIView *view = self.ksubviews[index];
    [view removeFromSuperview];
}

- (void)drawTile
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(pixel * num, row * num, num, num)];
    view.backgroundColor = [self.array[row] objectAtIndex:pixel];
    [self addSubview:view];
    [self.ksubviews addObject:view];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(view.frame.origin.x , view.frame.origin.y + (view.frame.size.height))];
    [path addLineToPoint:CGPointMake(view.frame.origin.x , view.frame.origin.y)];
    [path addLineToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height)];
    [path closePath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.fillColor = [((UIColor *)[self.array2[row] objectAtIndex:pixel]) CGColor];
    shapeLayer.lineWidth = 0;
    [self.layer addSublayer:shapeLayer];
    [self.ksublayers addObject:shapeLayer];
}


- (UIImage *)convertToGreyscale:(UIImage *)i
{
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *)malloc(m_width * m_height);
    
    for(int y = 0; y < m_height; y++)
    {
        for(int x = 0; x < m_width; x++)
        {
            uint32_t rgbPixel = rgbImage[y * m_width + x];
            uint32_t sum = 0;
            uint32_t count = 0;
            
            if(colors & kRed)
            {
                sum += (rgbPixel >> 24) & 255;
                count++;
            }
            
            if(colors & kGreen)
            {
                sum += (rgbPixel>>16)&255;
                count++;
            }
            
            if(colors & kBlue)
            {
                sum += (rgbPixel >> 8) & 255;
                count++;
            }
            
            m_imageData[y * m_width + x] = sum / count;
        }
    }
    
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *)calloc(m_width * m_height * sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++)
    {
        result[i * 4] = 0;
        int val = m_imageData[i];
        result[i * 4 + 1] = val;
        result[i * 4 + 2] = val;
        result[i * 4 + 3] = val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    context = CGBitmapContextCreate(result,
                                    m_width,
                                    m_height,
                                    8,
                                    m_width * sizeof(uint32_t),
                                    colorSpace,
                                    kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result
                         length:m_width * m_height];
    
    return resultUIImage;
}

@end
