//
//  ChessBoardView.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "ChessBoardView.h"
#import "BoardSquare.h"

@implementation ChessBoardView

- (id)initWithFrame:(CGRect)frame andBoard:(ChessBoard *)board
{
    if(self = [super initWithFrame:frame]){
		float rowHeight = frame.size.height / 8.0;
		float columnWidth = frame.size.width / 8.0;
		
		// Create 8x8 board
		for(int row=0;row<8;row++){
			for(int col=0;col<8;col++){
				BoardSquare *square = [[BoardSquare alloc] initWithFrame:CGRectMake(col*columnWidth, row*rowHeight, columnWidth, rowHeight) column:col row:row board:board];
				[self addSubview:square];
			}
		}
		
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
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
