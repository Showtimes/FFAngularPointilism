//
//  FFShutteringView.h
//  TriangularPointilism
//
//  Created by James Graham on 8/29/14.
//  Copyright (c) 2014 FindandForm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFShutteringView : UIView
/**
 *  Start the automata
 */
- (void)sparkLife;

/**
 *  The amount of shuttering to show from the bottom up, and top down. A value of half the height will show all shuttering. A value of 0 - (2 * triangular height) will show no shuttering.
 */
@property (nonatomic) NSInteger topBottomMarginMaskLength;

/**
 *  The number of frames that will be called each second.
 */
@property (nonatomic) CGFloat frameRate;

/**
 *  The amount of time until the class automatically halts the life of each triangular cell. For infinite life, set to 0.
 *  Default is 0;
 */
@property (nonatomic) NSTimeInterval artificialLifeSpan;
/**
 *  This translates to triangle cell density. The higher this number, the less dense the cells. This figure represents the maximum amount of time a cell may exist with 0 alpha. 
 */
@property (nonatomic) NSUInteger maximumAllowedDeathTicks;
@end
