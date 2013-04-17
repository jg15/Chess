//
//  ChessBoardView.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "ChessBoardView.h"
#import "BoardSquareView.h"
#import "BoardCoordinateTypes.h"

@implementation ChessBoardView

@synthesize squares = _squares;

- (NSMutableArray *)squares{
	if(!_squares)
		_squares=[[NSMutableArray alloc] init];
	return _squares;
}

- (id)initWithFrame:(CGRect)frame andBoard:(ChessBoard *)board
{
    if(self = [super initWithFrame:frame]){
		float rowHeight = frame.size.height / 8.0;
		float columnWidth = frame.size.width / 8.0;
		
		// Create 8x8 board
		for(int row=0;row<8;row++){
			for(int col=0;col<8;col++){
				BoardCellState state = [board cellStateAtCoordinates:(BoardCoordinates){col, row}];
				BoardSquareView *square = [[BoardSquareView alloc] initWithFrame:CGRectMake(col*columnWidth, row*rowHeight, columnWidth, rowHeight) boardCellState:state andCoordinates:(BoardCoordinates){col, row}];
				[self addSubview:square];
				[self.squares addObject:square];
			}
		}
		
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

/*
 
 
 - (void)makeAnImageFlyFrom:(UIImageView *)imageViewA to:(UIImageView *)imageViewB duration:(NSTimeInterval)duration {
 
 // it's simpler but less general to not pass in the path.  i chose simpler because
 // there's a lot of geometry work using the imageView frames here anyway.
 
 UIImageView *animationView = [[UIImageView alloc] initWithImage:imageViewA.image];
 animationView.tag = kANIMATION_IMAGE_TAG;
 animationView.frame = imageViewA.frame;
 [self addSubview:animationView];
 
 // scale
 CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
 [resizeAnimation setFromValue:[NSValue valueWithCGSize:imageViewA.bounds.size]];
 [resizeAnimation setToValue:[NSValue valueWithCGSize:imageViewB.bounds.size]];
 
 // build the path
 CGRect aRect = [imageViewA convertRect:imageViewA.bounds toView:self];
 CGRect bRect = [imageViewB convertRect:imageViewB.bounds toView:self];
 
 // unclear why i'm doing this, but the rects converted to this view's
 // coordinate system seemed have origin's offset negatively by half their size
 CGFloat startX = aRect.origin.x + aRect.size.width / 2.0;
 CGFloat startY = aRect.origin.y + aRect.size.height / 2.0;
 CGFloat endX = bRect.origin.x + bRect.size.width / 2.0;
 CGFloat endY = bRect.origin.y + bRect.size.height / 2.0;
 
 CGFloat deltaX = endX - startX;
 CGFloat deltaY = endY - startY;
 
 // these control points suited the path i needed.  your results may vary
 CGFloat cp0X = startX + 0.3*deltaX;
 CGFloat cp0Y = startY - 1.3*deltaY;
 CGFloat cp1X = endX + 0.1*deltaX;
 CGFloat cp1Y = endY - 0.5*deltaY;
 
 CGMutablePathRef path = CGPathCreateMutable();
 CGPathMoveToPoint(path, NULL, startX, startY);
 CGPathAddCurveToPoint(path, NULL, cp0X, cp0Y, cp1X, cp1Y, endX, endY);
 
 // keyframe animation
 CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
 keyframeAnimation.calculationMode = kCAAnimationPaced;
 keyframeAnimation.fillMode = kCAFillModeForwards;
 keyframeAnimation.removedOnCompletion = NO;
 keyframeAnimation.path = path;
 
 // assuming i need to manually release, despite ARC, but not sure
 CGPathRelease(path);
 
 // a little unclear about the fillMode, but it works
 // also unclear about removeOnCompletion, because I remove the animationView
 // but that seems to be insufficient
 CAAnimationGroup *group = [CAAnimationGroup animation];
 group.fillMode = kCAFillModeForwards;
 group.removedOnCompletion = NO;
 [group setAnimations:[NSArray arrayWithObjects:keyframeAnimation, resizeAnimation, nil]];
 group.duration = duration;
 group.delegate = self;
 
 // unclear about what i'm naming with the keys here, and why
 [group setValue:animationView forKey:@"animationView"];
 
 [animationView.layer addAnimation:group forKey:@"animationGroup"];
 }
 
 // clean up after like this
 
 - (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
 {
 UIImageView *imageViewForAnimation = (UIImageView *)[self viewWithTag:kANIMATION_IMAGE_TAG];
 // get the imageView passed to the animation as the destination
 UIImageView *imageViewB = (UIImageView *)[self viewWithTag:kDEST_TAG];
 
 imageViewB.image = imageViewForAnimation.image;
 [imageViewForAnimation removeFromSuperview];
 }
 
 
 
 
 */



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
