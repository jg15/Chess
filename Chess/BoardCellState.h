//
//  BoardCellState.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#ifndef Chess_BoardCellState_h
#define Chess_BoardCellState_h

typedef NS_ENUM(NSUInteger, BoardCellState){
	BoardCellStateEmpty = 0,
	BoardCellStateBlackKing = 1,
	BoardCellStateBlackQueen = 2,
	BoardCellStateBlackRook = 3,
	BoardCellStateBlackBishop = 4,
	BoardCellStateBlackKnight = 5,
	BoardCellStateBlackPawn = 6,
	BoardCellStateWhiteKing = 7,
	BoardCellStateWhiteQueen = 8,
	BoardCellStateWhiteRook = 9,
	BoardCellStateWhiteBishop = 10,
	BoardCellStateWhiteKnight = 11,
	BoardCellStateWhitePawn = 12
};

#endif
