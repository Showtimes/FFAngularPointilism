//
//  TPDoubleTriangleView.h
//  TriangularPointilism
//
//  Created by James Graham on 8/15/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * ## This subclass currently requires nib instantiation ##
 */
@interface TPDoubleTriangleView : UIImageView


//Non-Animation Functionality
- (void)applyFilter;

// Animation Functionality
@property (nonatomic) NSTimeInterval timerTimeInterval;
- (void)start;
@end
