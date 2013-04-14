//
//  Board.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "Board.h"
#import "BoardDelegate.h"

@implementation Board{
	NSUInteger _board[8][8];
	id<BoardDelegate> _delegate;
}

- (id)init{
	if(self=[super init]){
		[self clearBoard];
		_boardDelegate = [[MulticastDelegate alloc] init];
		_delegate = (id)_boardDelegate;
	}
	return self;
}

- (void)informDelegateOfStateChanged:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row{
	if([_delegate respondsToSelector:@selector(cellStateChanged:forColumn:andRow:)]){
		[_delegate cellStateChanged:state forColumn:column andRow:row];
	}
}

- (BoardCellState)cellStateAtColumn:(NSInteger)column andRow:(NSInteger)row
{
    [self checkBoundsForColumn:column andRow:row];
    return _board[column][row];
}

- (void)setCellState:(BoardCellState)state forColumn:(NSUInteger)column andRow:(NSUInteger)row
{
    [self checkBoundsForColumn:column andRow:row];
    _board[column][row] = state;
	[self informDelegateOfStateChanged:state forColumn:column andRow:row];
}

- (void)checkBoundsForColumn:(NSInteger)column andRow:(NSInteger)row
{
    if (column<0||column>7||row<0||row>7){
		[NSException raise:NSRangeException format:@"row or column out of bounds"];
	}
}

- (void)clearBoard{
	memset(_board, 0, sizeof(NSUInteger)*8*8);
	[self informDelegateOfStateChanged:BoardCellStateEmpty forColumn:-1 andRow:-1];
}

@end
