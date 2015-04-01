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
#import "ChessPiece.h"

@implementation ChessBoardView{
	UIImageView *_origin;
	UIImageView *_origin2;
}

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


 
 
 - (void)makeAnImageFlyFrom:(UIImageView *)imageViewA to:(UIImageView *)imageViewB duration:(NSTimeInterval)duration{
	
	#define kORIGIN_TAG 127
	#define kDEST_TAG 128
	#define kANIMATION_IMAGE_TAG 129
	 
	imageViewA.tag=kORIGIN_TAG;
	if(_origin==nil){
		_origin=imageViewA;
	}else{
		_origin2=imageViewA;
	}
	imageViewB.tag=kDEST_TAG;
	 
	 UIImageView *animationView = [[UIImageView alloc] initWithImage:imageViewA.image];
	 animationView.tag = kANIMATION_IMAGE_TAG;
	 animationView.frame = imageViewA.frame;
	 [self addSubview:animationView];
 
	 imageViewA.alpha=0.0;
	 
	 // scale
	 CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
	 [resizeAnimation setFromValue:[NSValue valueWithCGSize:imageViewA.bounds.size]];
	 [resizeAnimation setToValue:[NSValue valueWithCGSize:imageViewB.bounds.size]];
 
	 // build the path
	 CGRect aRect = [imageViewA convertRect:imageViewA.bounds toView:self];
	 CGRect bRect = [imageViewB convertRect:imageViewB.bounds toView:self];
 
	 CGFloat startX = aRect.origin.x + aRect.size.width / 2.0;
	 CGFloat startY = aRect.origin.y + aRect.size.height / 2.0;
	 CGFloat endX = bRect.origin.x + bRect.size.width / 2.0;
	 CGFloat endY = bRect.origin.y + bRect.size.height / 2.0;
 
	 CGMutablePathRef path = CGPathCreateMutable();
	 CGPathMoveToPoint(path, NULL, startX, startY);
	 CGPathAddCurveToPoint(path, NULL, startX, startY, endX, endY, endX, endY);
 
	 // keyframe animation
	 CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	 keyframeAnimation.calculationMode = kCAAnimationPaced;
	 keyframeAnimation.fillMode = kCAFillModeForwards;
	 keyframeAnimation.removedOnCompletion = NO;
	 keyframeAnimation.path = path;

	 CGPathRelease(path);
 
	 CAAnimationGroup *group = [CAAnimationGroup animation];
	 group.fillMode = kCAFillModeForwards;
	 group.removedOnCompletion = NO;
	 [group setAnimations:[NSArray arrayWithObjects:keyframeAnimation, resizeAnimation, nil]];
	 group.duration = duration;
	 group.delegate = self;
 
	 [group setValue:animationView forKey:@"animationView"];
 
	 [animationView.layer addAnimation:group forKey:@"animationGroup"];
 }
 
 - (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
 {
	 // Delay After Animation
	 float delay = .1;
     
	 [self performSelector:@selector(animationIsFinishedIncludingDelay) withObject:nil afterDelay:delay];
 
 }
 
- (void)animationIsFinishedIncludingDelay{
	UIImageView *imageViewForAnimation = (UIImageView *)[self viewWithTag:kANIMATION_IMAGE_TAG];
	UIImageView *imageViewB = (UIImageView *)[self viewWithTag:kDEST_TAG];
	
	imageViewB.image = imageViewForAnimation.image;
	[imageViewForAnimation removeFromSuperview];
	
    //HACK
    _origin.image = [ChessPiece new];
    
    _origin.alpha=1.0;
	_origin2.alpha=1.0;
	_origin=nil;
	_origin2=nil;
	[self.delegate chessPieceAnimationFinished:self];
}
 
 
 



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
