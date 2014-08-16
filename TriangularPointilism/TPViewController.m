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
#import "TPDoubleTriangleView.h"
@interface TPViewController ()
@property (weak, nonatomic) IBOutlet TPDoubleTriangleView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *array2;
@property (strong, nonatomic, readwrite) UIImage *image;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) TPDoubleTriangleView *ff;
@end

@implementation TPViewController
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

- (IBAction)buttonPressed:(id)sender {
    
    self.slider.enabled = NO;
    [self.imageView applyFilter];
}

@end
