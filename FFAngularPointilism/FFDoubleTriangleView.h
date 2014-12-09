//
//  TPDoubleTriangleView.h
//  TriangularPointilism
//
//  Created by James Graham on 8/15/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDoubleTriangleViewEffect.h"

/**
 * ## This subclass supports both nib and programmatic instantiation ##
 */
@interface FFDoubleTriangleView : UIImageView

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame;

//Non-Animation Functionality
- (void)applyFilter;

// Animation Functionality
@property (nonatomic) NSTimeInterval timerTimeInterval;
@property (readonly) FFDoubleTriangleViewEffect currentlyAnimatingEffect;
- (void)startAnimatedEffect:(FFDoubleTriangleViewEffect)effect withCompletion:(void (^)(void))completion;

//the final black and white image -- only available after nib instantiation
@property (strong, nonatomic, readonly) UIImage *finalbwimage;

- (void)snapshotMatrix;

@end
