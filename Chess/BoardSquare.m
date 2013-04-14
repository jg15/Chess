//
//  BoardSquare.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "BoardSquare.h"

@interface BoardSquare()
@property (nonatomic,strong) UIImageView *pieceView;
@end

@implementation BoardSquare{
	int _row;
	int _column;
	ChessBoard *_board;
}

- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(ChessBoard *)board
{
    self = [super initWithFrame:frame];
    if (self) {
        
		_row = row;
		_column = column;
		_board = board;
		
		// Create (blank) Views for pieces:
		
		UIImage *image = [UIImage imageNamed:@"Pieces/blank.png"];
		self.pieceView = [[UIImageView alloc] initWithImage:image];
		self.pieceView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		[self addSubview:self.pieceView];
		
		[self update];
		[_board.boardDelegate addDelegate:self];
		
		// add tap recognizer
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
		[self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)update{
	BoardCellState state = [_board cellStateAtColumn:_column andRow:_row];

	NSArray *imageFileNames = @[@"blank",@"blackKing",@"blackQueen",@"blackRook",@"blackBishop",@"blackKnight",@"blackPawn",@"whiteKing",@"whiteQueen",@"whiteRook",@"whiteBishop",@"whiteKnight",@"whitePawn"];
	
	self.pieceView.image = [UIImage imageNamed:
						[NSString stringWithFormat:@"Pieces/%@.png",
						 [imageFileNames objectAtIndex:state]]];

}

- (void)cellStateChanged:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row{
	if((column==_column&&row==_row)||(column==-1&&row==-1)){
		[self update];
	}
}

- (void)cellTapped:(UITapGestureRecognizer *)recognizer{
	NSLog(@"tap");
	[_board selectedSquareOfColumn:_column andRow:_row];
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
