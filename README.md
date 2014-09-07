Angular Pointilism
==========
_Triangles for iOS!_

In summary, this library is build from two pieces. The first piece is the triangular-mosaic image blur which can be applied to any UIImageView as an alternative (and prettier) to UIBlurEffect. The second piece is the shuttering triangles animation which (as far as I know) has no practical application and was built purely for aesthetic pleasure.

You may dive right in with the included [demo](https://github.com/FindForm/FFAngularPointilism/archive/master.zip); simply open the .xcodeproj and run on a 4" display

### Feature set is twofold 

#####1. Animatable iOS mosaic-like image filter #####

Note: Currently this library only supports XIB instantiation and has no exposed property for changing triangle size. (Would love to see a PR adding such functionality)

![animatedGif]
(https://s3.amazonaws.com/Find-and-Form/portolio/TriangularPoint.gif)

###Output the filtered image###

![static]
(http://i.imgur.com/RVNZYe6.png)

<br />
##### 2. Animatable Shuttering & Undulation
![mov](https://s3.amazonaws.com/Find-and-Form/animatedangular-1.gif)

This shuttering effect is best described within the context of cellular automata. 
The following properties are available via public API (from FFShutteringView.h):
```objc
/**
 *  The amount of shuttering to show from the bottom up, and top down. A value of half the height will show all shuttering. A value of 0 - (2 * triangular height) will show no shuttering.
 *  Default is 100
 */
@property (nonatomic) NSInteger topBottomMarginMaskLength;

/**
 *  The number of frames that will be called each second.
 *  Default is 30 FPS.
 */
@property (nonatomic) CGFloat frameRate;

/**
 *  The amount of time until the class automatically halts the life of each triangular cell. For infinite life, set to 0.
 *  Default is 0;
 */
@property (nonatomic) NSTimeInterval artificialLifeSpan;
/**
 *  This translates to triangle cell density. The higher this number, the less dense the cells. This figure represents the maximum amount of time a cell may exist with 0 alpha. 
 *  Default is 200
 */
@property (nonatomic) NSUInteger maximumAllowedDeathTicks;
```


Note: Currently, in order to use this feature, one must copy the 4 triangles for the xcassets folder into their working directory with identical names. This will change in future updates.
