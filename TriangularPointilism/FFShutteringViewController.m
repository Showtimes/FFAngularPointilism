//
//  FFShutteringViewController.m
//  TriangularPointilism
//
//  Created by James Graham on 8/20/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import "FFShutteringViewController.h"

@interface FFShutteringViewController ()
@property (strong, nonatomic) NSMutableArray *arrayOfTriangleLayers;
@end

@implementation FFShutteringViewController

- (NSMutableArray *)arrayOfTriangleLayers{
    if (!_arrayOfTriangleLayers) {
        _arrayOfTriangleLayers = [NSMutableArray array];
    }
    return _arrayOfTriangleLayers;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    int width = 80;
    [super viewDidLoad];
    NSArray *grayscales = @[@0.3, @0.15, @0.6];
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.003f target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    for (int i = 0; i <= self.view.bounds.size.width; i += width) {
        for (int j = 0; j <= self.view.bounds.size.height; j+=width) {
            
   
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i, j, 80, 80)];
        view.backgroundColor = [UIColor colorWithWhite:[grayscales[i/width % 3] floatValue] alpha: [grayscales[i/width % 3] floatValue]];
        view.alpha = 1 - [grayscales[(i + j)/width % 3] floatValue];
        [self.view addSubview:view];
        
        }
    }
    // Do any additional setup after loading the view.
}
- (void)fire:(NSTimer *)timer{
    for (UIView *subview in self.view.subviews) {
        subview.alpha += subview.tag == 1 ? -0.001f : 0.001f;
        if (subview.alpha >= 0.8f) {
            subview.tag = 1;
        }
        if (subview.alpha <= 0.0f) {
            subview.tag = 0;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


                      

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
