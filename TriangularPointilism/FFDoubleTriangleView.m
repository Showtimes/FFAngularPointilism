//
//  TPDoubleTriangleView.m
//  TriangularPointilism
//
//  Created by James Graham on 8/15/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "FFDoubleTriangleView.h"
@interface FFDoubleTriangleView()
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *array2;
@end
@implementation FFDoubleTriangleView{
    NSUInteger row;
    NSUInteger pixel;
    CGFloat num;
    
}

- (NSTimeInterval)timerTimeInterval{
    NSAssert(_timerTimeInterval > 0, @"TIME CANNOT BE LESS THAN 0");
    if (_timerTimeInterval == 0) {
        return 0.03;
    }
    return _timerTimeInterval;
}
- (void)awakeFromNib{
    num = 12;
    
    CGFloat width = self.bounds.size.width;
    _array = [NSMutableArray array];
    _array2 = [NSMutableArray array];
    for (int i = 0; i < width; i+=num) {
        [self.array addObject:[NSMutableArray array]];
        [self.array2 addObject:[NSMutableArray array]];
    }
    for (int i = 0; i < self.array.count; i++) {
        for (int j = 0; j < self.array.count; j++) {
            [self.array[i] addObject:[[self class] getRGBAsFromImage:self.image atX:j * 2 * num andY: i * 2 * num]];
            int xIndex = ((j * 2 * num) - (num/2.0));
            int yIndex = ((i * 2 * num) + (num/2.0));
            xIndex %= (int)width * 2;
            yIndex %= (int)width * 2;
            NSLog(@"%d", xIndex);
            [self.array2[i] addObject:[[self class] getRGBAsFromImage:self.image atX:xIndex andY: yIndex]];
            
        }
    }
}
+ (UIColor *)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy{
    /**
     * Modified logic from Olie via http://stackoverflow.com/a/1262893
     */
     
    UIColor *color;
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
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
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    byteIndex += 4;
    color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return color;
}
- (void)fire:(NSTimer *)timer{
    pixel++;
    if (pixel >= self.array.count) {
        pixel = 0;
        row++;
    }
    if (row >= self.array.count) {
        [timer invalidate];
        return;
    }
    
    [self drawTile];
    
}

- (void)start{
    
    [self executeTimer];
}

- (void)executeTimer{
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.timerTimeInterval target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)applyFilter{
    while (row < self.array.count) {
    pixel++;
    if (pixel >= self.array.count) {
        pixel = 0;
        row++;
    }
        if (row == self.array.count) {
            break;
        }
    
        [self drawTile];
    }
}

- (void)drawTile{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(pixel * num, row * num, num, num)];
    view.backgroundColor = [self.array[row] objectAtIndex:pixel];
    [self addSubview:view];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(view.frame.origin.x , view.frame.origin.y + (view.frame.size.height))];
    [path addLineToPoint:CGPointMake(view.frame.origin.x , view.frame.origin.y )];
    [path addLineToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height)];
    [path closePath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.fillColor = [((UIColor *)[self.array2[row] objectAtIndex:pixel]) CGColor];
    shapeLayer.lineWidth = 0;
    [self.layer addSublayer:shapeLayer];
}

@end
