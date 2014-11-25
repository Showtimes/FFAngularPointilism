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
@property (strong, nonatomic) FFShutteringView *shutteringView;
@property (weak, nonatomic) IBOutlet UIButton *buttonGod;

- (IBAction)sliderValueChanged:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UIView *containerShutteringView;
@end

@implementation FFShutteringViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.shutteringView.coordinateSquaresToOmit = @[@[@0, @0]];
    _shutteringView = [[FFShutteringView alloc] initWithFrame:self.view.bounds];
    [self.containerShutteringView addSubview:_shutteringView];
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
