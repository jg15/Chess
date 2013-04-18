//
//  Board.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "Board.h"

@interface Board ()

@end

@implementation Board{
	NSUInteger _board[8][8];
}

- (id)init{
	if(self=[super init]){
		[self clearBoard];
	}
	return self;
}

- (BoardCellState)cellStateAtCoordinates:(BoardCoordinates)coordinates{
    [self checkBoundsForCoordinates:coordinates];
    return _board[coordinates.column][coordinates.row];
}

- (void)setCellState:(BoardCellState)state forCoordinates:(BoardCoordinates)coordinates{
    [self checkBoundsForCoordinates:coordinates];
    _board[coordinates.column][coordinates.row] = state;
	[self.boardDelegate cellStateChanged:state forCoordinates:coordinates];
}

- (void)checkBoundsForCoordinates:(BoardCoordinates)coordinates{
    if (coordinates.column<0||coordinates.column>7||coordinates.row<0||coordinates.row>7){
		[NSException raise:NSRangeException format:@"row or column out of bounds"];
	}
}

- (void)clearBoard{
	memset(_board, 0, sizeof(NSUInteger)*8*8);
	[self.boardDelegate cellStateChanged:BoardCellStateEmpty forCoordinates:(BoardCoordinates){-1,-1}];
}

@end
