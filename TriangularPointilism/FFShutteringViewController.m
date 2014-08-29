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

@end

@implementation FFShutteringViewController
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.shutteringView sparkLife];
}
@end
