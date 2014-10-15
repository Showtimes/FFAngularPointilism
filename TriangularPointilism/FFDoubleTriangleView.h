//
//  TPDoubleTriangleView.h
//  TriangularPointilism
//
//  Created by James Graham on 8/15/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * ## This subclass supports both nib and programmatic instantiation ##
 */
@interface FFDoubleTriangleView : UIImageView


//Non-Animation Functionality
- (void)applyFilter;

// Animation Functionality
@property (nonatomic) NSTimeInterval timerTimeInterval;
- (void)startWithCompletion:(void (^)(void))completion;

//the final black and white image -- only available after nib instantiation
@property (strong, nonatomic, readonly) UIImage *finalbwimage;
@end
