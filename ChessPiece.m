//
//  ChessPiece.m
//  Chess
//
//  Created by Joshua Girard on 4/19/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "ChessPiece.h"

@implementation ChessPiece

- (ChessPiece *)init{
	return [self initWithChessPiece:BoardCellStateEmpty];
}

- (ChessPiece *)initWithChessPiece:(BoardCellState)piece{
	NSArray *imageFileNames = @[@"blank",@"blackKing",@"blackQueen",@"blackRook",@"blackBishop",@"blackKnight",@"blackPawn",@"whiteKing",@"whiteQueen",@"whiteRook",@"whiteBishop",@"whiteKnight",@"whitePawn"];
	
	self = (ChessPiece *)[UIImage imageNamed:[NSString stringWithFormat:@"Pieces/%@.png",[imageFileNames objectAtIndex:piece]]];

	return self;
}

+ (ChessPiece *)pieceWithBoardCellState:(BoardCellState)state{
	return [[ChessPiece alloc] initWithChessPiece:state];
}

@end
