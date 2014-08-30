//
//  FFShutteringViewController.m
//  TriangularPointilism
//
//  Created by James Graham on 8/20/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "FFShutteringViewController.h"
#import "FFShutteringView.h"

@interface FFShutteringViewController ()
@property (weak, nonatomic) IBOutlet FFShutteringView *shutteringView;
@property (weak, nonatomic) IBOutlet UIButton *buttonGod;

- (IBAction)sliderValueChanged:(UISlider *)sender;
@end

@implementation FFShutteringViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.shutteringView.maximumAllowedDeathTicks = 1.0/(sender.value) * 400;
}
- (IBAction)frameRateSliderValueChanged:(UISlider *)sender {
    self.shutteringView.frameRate = sender.value * 30;
}
- (IBAction)createLifeButtonReleased:(id)sender {
    [self.shutteringView sparkLife];
    self.buttonGod.enabled = NO;
}
@end
