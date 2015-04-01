//
//  BoardSquareView.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BoardSquareView.h"
#import "ChessPiece.h"

@interface BoardSquareView()


@end

@implementation BoardSquareView{
	BoardCoordinates _coordinates;
	CABasicAnimation *pulseAnimation;
}

- (id)initWithFrame:(CGRect)frame boardCellState:(BoardCellState)state andCoordinates:(BoardCoordinates)coordinates{
	
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"%f %f",frame.size.height, frame.size.width);
		_coordinates = coordinates;
		
		// Create (blank) Views for pieces:
		UIImage *image = [UIImage imageNamed:@"Pieces/blank.png"];
		self.pieceView = [[UIImageView alloc] initWithImage:image];
		self.pieceView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		[self addSubview:self.pieceView];
		
		[self updateWithCellState:state];
		
		// add tap recognizer
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
		[self addGestureRecognizer:tapRecognizer];

		// Animation Piece Image: Pulsate
		pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		pulseAnimation.autoreverses = YES;
		pulseAnimation.duration = 0.6;
		pulseAnimation.fromValue = [NSNumber numberWithFloat:0.3f];
		pulseAnimation.repeatCount = INFINITY;
		pulseAnimation.toValue = [NSNumber numberWithFloat:1.0f];
		
    }
    return self;
}

- (UIImage *)dotImageOfDiameter:(CGFloat)diameter
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGFloat radius = diameter * 0.5;
    CGColorSpaceRef baseColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[8] = { 0.56f, 0.78f, 0.94f, 1.0f,     // Opaque dot colour.
		0.56f, 0.78f, 0.94f, 0.0f };      // Transparent dot colour.
    CGGradientRef gradient = CGGradientCreateWithColorComponents (baseColorSpace, colors, NULL, 2);
	
    CGContextDrawRadialGradient(context, gradient, CGPointMake(radius, radius), 0.0f, CGPointMake(radius, radius), radius, kCGGradientDrawsAfterEndLocation);
	
    CGImageRef dotImageRef = CGBitmapContextCreateImage(context);
    UIImage *dotImage = [UIImage imageWithCGImage:dotImageRef];
	
    CGColorSpaceRelease(baseColorSpace);
    CGGradientRelease(gradient);
    CGImageRelease(dotImageRef);
	
    UIGraphicsEndImageContext();
	
    return dotImage;
}

- (void)updateWithCellState:(BoardCellState)state{

	self.pieceView.image = [ChessPiece pieceWithBoardCellState:state];

}

- (void)cellTapped:(UITapGestureRecognizer *)recognizer{
	//[self.pieceView.layer addAnimation:pulseAnimation forKey:@"opacity"];
	
	[self.delegate boardSquareCellTapped:self atCoordinates:_coordinates];

}

- (void)startPulsing{
	[self.pieceView.layer addAnimation:pulseAnimation forKey:@"opacity"];
}

- (void)stopPulsing{
	[self.pieceView.layer removeAnimationForKey:@"opacity"];
}

@end
