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
#import "FFDoubleTriangleView.h"
@interface TPViewController ()
@property (strong, nonatomic) FFDoubleTriangleView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic, readwrite) UIImage *image;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *speedIndicationLabels;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
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
- (void)viewDidLoad{
    
    _imageView = [[FFDoubleTriangleView alloc] initWithImage:[UIImage imageNamed:@"ww"] andFrame:CGRectMake(30, 30, 200, 400)];
    [self.view addSubview:self.imageView];
    [super viewDidLoad];
}

- (void)hideSpeedIndicators:(BOOL)hide{
    [self.speedIndicationLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setHidden:hide];
    }];
}

- (IBAction)buttonPressed:(id)sender {
    
    
    self.slider.enabled = NO;
    self.imageView.timerTimeInterval = (1.001f - self.slider.value) / 5.0f;
    if (self.switchControl.on) {
        [self.imageView startBlackAndWhiteWithCompletion:nil];
    }
    else {
        [self.imageView applyFilter];
    }
}
- (IBAction)switchFlipped:(UISwitch *)sender {
    if (sender.on) {
        self.slider.enabled = YES;
        [self hideSpeedIndicators:NO];
    }
    else {
        self.slider.enabled = NO;
        [self hideSpeedIndicators:YES];
    }
}


@end
