//
//  TPViewController.m
//  TriangularPointilism
//
//  Created by James Graham on 8/13/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "TPViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
@interface TPViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *array2;
@property (strong, nonatomic, readwrite) UIImage *image;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation TPViewController{
    NSUInteger row;
    NSUInteger pixel;
    CGFloat num;

}

- (UIImage *)image{
    if (!_image) {
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        {
            [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            _image = UIGraphicsGetImageFromCurrentImageContext();
        }
    }
    return _image;
}

- (void)viewDidLoad
{
    num = 12;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = self.imageView.bounds.size.width;
    _array = [NSMutableArray array];
    _array2 = [NSMutableArray array];
    for (int i = 0; i < width; i+=num) {
        [self.array addObject:[NSMutableArray array]];
        [self.array2 addObject:[NSMutableArray array]];
    }
    for (int i = 0; i < self.array.count; i++) {
        for (int j = 0; j < self.array.count; j++) {
            [self.array[i] addObject:[TPViewController getRGBAsFromImage:self.imageView.image atX:j * 2 * num andY: i * 2 * num]];
            int xIndex = ((j * 2 * num) - (num/2.0));
            int yIndex = ((i * 2 * num) + (num/2.0));
            xIndex %= (int)width * 2;
            yIndex %= (int)width * 2;
            NSLog(@"%d", xIndex);
            [self.array2[i] addObject:[TPViewController getRGBAsFromImage:self.imageView.image atX:xIndex andY: yIndex]];
            
        }
    }
}
+ (UIColor *)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy{
    UIColor *color;
    // First get the image into your data buffer
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
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.label.text = [NSString stringWithFormat:@"Row: %d Pixel: %d", row, pixel];

    self.view.backgroundColor = [self.array[row] objectAtIndex:pixel];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(pixel * num, row * num, num, num)];
    [self.imageView addSubview:view];

    drawTriangle(CGPointMake(view.frame.origin.x - view.frame.size.width/2.0, view.frame.origin.y - view.frame.size.height), CGPointMake(view.frame.origin.x - view.frame.size.width/2.0, view.frame.origin.y), CGPointMake(view.frame.origin.x + view.frame.size.width/2.0, view.frame.origin.y - view.frame.size.height));
    view.backgroundColor = self.view.backgroundColor;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(view.frame.origin.x , view.frame.origin.y + (view.frame.size.height))];
    [path addLineToPoint:CGPointMake(view.frame.origin.x , view.frame.origin.y )];
    [path addLineToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height)];
    [path closePath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
   // shapeLayer.fillColor = [((UIColor *)[self.array[row] objectAtIndex:(pixel + 1) % self.array.count]) CGColor];
    shapeLayer.fillColor = [((UIColor *)[self.array2[row] objectAtIndex:pixel]) CGColor];
    shapeLayer.lineWidth = 0;
   // shapeLayer.anchorPoint = CGPointMake(shapeLayer.anchorPoint.x, shapeLayer.anchorPoint.y + view.frame.size.height);
    [self.imageView.layer addSublayer:shapeLayer];
    self.image = nil;
   
}

void drawTriangle(CGPoint startPoint, CGPoint secondPoint, CGPoint lastPoint)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:secondPoint];
    [path addLineToPoint:lastPoint];
    [path closePath];
    [[UIColor redColor] setFill];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.fillColor = [[UIColor blueColor] CGColor];
    shapeLayer.lineWidth = 2;
}
- (IBAction)buttonPressed:(id)sender {
    [self executeTimer];
    self.slider.enabled = NO;
}

- (void)executeTimer{
    NSTimer *timer = [ NSTimer timerWithTimeInterval:(1.0f - self.slider.value) / 5.0f target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
@end
