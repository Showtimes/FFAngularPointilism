//
//  TPViewController.m
//  TriangularPointilism
//
//  Created by James Graham on 8/13/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "TPViewController.h"

@interface TPViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSMutableArray *array;
@end

@implementation TPViewController{
    NSUInteger row;
    NSUInteger pixel;
    CGFloat num;

}

- (void)viewDidLoad
{
    num = 18;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSTimer *timer = [ NSTimer timerWithTimeInterval:0.03f target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    CGFloat width = self.imageView.bounds.size.width;
    NSUInteger height = self.imageView.bounds.size.height;
    _array = [NSMutableArray array];
    for (int i = 0; i < width; i+=num) {
        [self.array addObject:[NSMutableArray array]];
    }
    for (int i = 0; i < self.array.count; i++) {
        for (int j = 0; j < self.array.count; j++) {
            [self.array[i] addObject:[TPViewController getRGBAsFromImage:self.imageView.image atX:j * 2 * num andY: i * 2 * num]];

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
    view.backgroundColor = self.view.backgroundColor;
    [self.imageView addSubview:view];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}
@end
