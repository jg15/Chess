//
//  BoardSquareView.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BoardSquareView.h"

@interface BoardSquareView()
@property (nonatomic, strong) UIImageView *pieceView;

@end

@implementation BoardSquareView{
	BoardCoordinates _coordinates;
	CABasicAnimation *pulseAnimation;
}

- (id)initWithFrame:(CGRect)frame boardCellState:(BoardCellState)state andCoordinates:(BoardCoordinates)coordinates{
	
    self = [super initWithFrame:frame];
    if (self) {
        
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
    CGFloat colours[8] = { 0.56f, 0.78f, 0.94f, 1.0f,     // Opaque dot colour.
		0.56f, 0.78f, 0.94f, 0.0f };      // Transparent dot colour.
    CGGradientRef gradient = CGGradientCreateWithColorComponents (baseColorSpace, colours, NULL, 2);
	
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
/*
	if(_playerTurn==PlayerTurnBlack){
		state = [_board cellStateAtColumn:7-_column andRow:7-_row];
	}else{
		state = [_board cellStateAtColumn:_column andRow:_row];
	}*/
	
	NSArray *imageFileNames = @[@"blank",@"blackKing",@"blackQueen",@"blackRook",@"blackBishop",@"blackKnight",@"blackPawn",@"whiteKing",@"whiteQueen",@"whiteRook",@"whiteBishop",@"whiteKnight",@"whitePawn"];
	
	self.pieceView.image = [UIImage imageNamed:
						[NSString stringWithFormat:@"Pieces/%@.png",
						 [imageFileNames objectAtIndex:state]]];

}
/*
- (void)cellStateChanged:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row{
	if(column==-1&&row==-1){
		[self update];
		return;
	}
	if(_playerTurn==PlayerTurnBlack&&(column==7-_column&&row==7-_row)){
		[self update];
	}else if(column==_column&&row==_row){
		[self update];
	}
	//(column==_column&&row==_row)||
}*/
/*
- (void)playerTurnChanged:(PlayerTurnState)player{
	_playerTurn=player;
	[self update];
}
*/
- (void)cellTapped:(UITapGestureRecognizer *)recognizer{
	NSLog(@"tap");
	//[self.pieceView.layer addAnimation:pulseAnimation forKey:@"opacity"];
	[self.delegate boardSquareCellTapped:self atCoordinates:_coordinates];
	/*
	if(_playerTurn==PlayerTurnBlack){
		[_board selectedSquareOfColumn:7-_column andRow:7-_row];
	}else{
		[_board selectedSquareOfColumn:_column andRow:_row];
	}
	 */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)hi{
	NSLog(@"hi");
}

@end
