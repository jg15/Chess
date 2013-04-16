//
//  ChessBoard.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "ChessBoard.h"
#import "BoardNavigationFunctions.h"

@implementation ChessBoard{
	struct{
		BOOL whiteKingMoved;
		BOOL whiteLeftRookMoved;
		BOOL whiteRightRookMoved;
		BOOL blackKingMoved;
		BOOL blackLeftRookMoved;
		BOOL blackRightRookMoved;
	}castling;
	struct{
		BOOL available;
		NSInteger column;
		NSInteger row;
	}un_passant;
	struct{
		NSInteger column;
		NSInteger row;
	}_newPieceLocation;
}

- (id)init{
    if (self = [super init]) {
		//_delegate=self;
        [self commonInit];
        [self setToInitialState];
    }
    return self;
}

- (void)commonInit{
	castling.whiteKingMoved=NO;
	castling.whiteLeftRookMoved=NO;
	castling.whiteRightRookMoved=NO;
	castling.blackKingMoved=NO;
	castling.blackLeftRookMoved=NO;
	castling.blackRightRookMoved=NO;
	un_passant.available=NO;
}

-(void)setToInitialState{
	[super clearBoard];
	
	// Initialize Board
	
	[super setCellState:BoardCellStateWhiteRook forColumn:0 andRow:7];
	[super setCellState:BoardCellStateWhiteKnight forColumn:1 andRow:7];
	[super setCellState:BoardCellStateWhiteBishop forColumn:2 andRow:7];
	[super setCellState:BoardCellStateWhiteQueen forColumn:3 andRow:7];
	[super setCellState:BoardCellStateWhiteKing forColumn:4 andRow:7];
	[super setCellState:BoardCellStateWhiteBishop forColumn:5 andRow:7];
	[super setCellState:BoardCellStateWhiteKnight forColumn:6 andRow:7];
	[super setCellState:BoardCellStateWhiteRook forColumn:7 andRow:7];
	for(int i=0;i<8;i++){
		[super setCellState:BoardCellStateWhitePawn forColumn:i andRow:6];
	}
	
	[super setCellState:BoardCellStateBlackRook forColumn:0 andRow:0];
	[super setCellState:BoardCellStateBlackKnight forColumn:1 andRow:0];
	[super setCellState:BoardCellStateBlackBishop forColumn:2 andRow:0];
	[super setCellState:BoardCellStateBlackQueen forColumn:3 andRow:0];
	[super setCellState:BoardCellStateBlackKing forColumn:4 andRow:0];
	[super setCellState:BoardCellStateBlackBishop forColumn:5 andRow:0];
	[super setCellState:BoardCellStateBlackKnight forColumn:6 andRow:0];
	[super setCellState:BoardCellStateBlackRook forColumn:7 andRow:0];
	for(int i=0;i<8;i++){
		[super setCellState:BoardCellStateBlackPawn forColumn:i andRow:1];
	}
	
	_whiteScore=0;
	_blackScore=0;
	
	// White moves first
	self.currentPlayer = PlayerTurnWhite;
}

- (BOOL)willKingBeInCheckInSquareOfColumn:(NSInteger)column andRow:(NSInteger)row{
	// TODO
	return NO;
}

- (BOOL)isValidMoveFromColumn:(NSInteger)fromColumn andRow:(NSInteger)fromRow toColumn:(NSInteger)toColumn andRow:(NSInteger)toRow{
	// check for valid move
	NSLog(@"check");
	
	BoardCellState piece = [super cellStateAtColumn:fromColumn andRow:fromRow];
	BoardCellState toSquareState = [super cellStateAtColumn:toColumn andRow:toRow];
	
	// Only let player of current turn move
	if(piece>0&&piece<=6&&self.currentPlayer==PlayerTurnWhite){
		return NO;
	}else if(piece>=7&&self.currentPlayer==PlayerTurnBlack){
		return NO;
	}
	
	if(piece==BoardCellStateBlackKing||piece==BoardCellStateWhiteKing){
		// King
		if(piece==BoardCellStateBlackKing){
			if(toSquareState<=6&&toSquareState!=0)return NO;
			// Castling
			if(!castling.blackKingMoved&&((toColumn==2&&!castling.blackLeftRookMoved)||(toColumn==6&&!castling.blackRightRookMoved))&&toRow==0){
				if(fromColumn<toColumn){
					if([self canMoveFromColumn:fromColumn andRow:fromRow toColumn:toColumn andRow:toRow withNavigationFunction:BoardNavigationFunctionRight])return YES;
				}else{
					if([self canMoveFromColumn:fromColumn andRow:fromRow toColumn:toColumn-2 andRow:toRow withNavigationFunction:BoardNavigationFunctionLeft])return YES;
				}
				//return YES;
			}
		}else if(piece==BoardCellStateWhiteKing){
			if(toSquareState>=7)return NO;
			// Castling
			if(!castling.whiteKingMoved&&((toColumn==2&&!castling.whiteRightRookMoved)||(toColumn==6&&!castling.whiteLeftRookMoved))&&toRow==7){
				if(fromColumn<toColumn){
					if([self canMoveFromColumn:fromColumn andRow:fromRow toColumn:toColumn andRow:toRow withNavigationFunction:BoardNavigationFunctionRight])return YES;
				}else{
					if([self canMoveFromColumn:fromColumn andRow:fromRow toColumn:toColumn-2 andRow:toRow withNavigationFunction:BoardNavigationFunctionLeft])return YES;
				}
				//return YES;
			}
		}
		if(abs(fromColumn-toColumn)>1||abs(fromRow-toRow)>1)return NO;
		return ![self willKingBeInCheckInSquareOfColumn:toColumn andRow:toRow];
	}else if(piece==BoardCellStateBlackQueen||piece==BoardCellStateWhiteQueen){
		// Queen
		if(piece==BoardCellStateBlackQueen){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteQueen){
			if(toSquareState>=7)return NO;
		}
		if(abs(toColumn-fromColumn)!=abs(toRow-fromRow)&&(fromColumn!=toColumn&&fromRow!=toRow))return NO;
		BoardNavigationFunction bnf;
		if(toColumn>fromColumn)bnf=BoardNavigationFunctionRight;
		if(toColumn<fromColumn)bnf=BoardNavigationFunctionLeft;
		if(toRow<fromRow)bnf=BoardNavigationFunctionUp;
		if(toRow>fromRow)bnf=BoardNavigationFunctionDown;
		if(fromColumn<toColumn&&fromRow>toRow)bnf=BoardNavigationFunctionRightUp;
		if(fromColumn<toColumn&&fromRow<toRow)bnf=BoardNavigationFunctionRightDown;
		if(fromColumn>toColumn&&fromRow>toRow)bnf=BoardNavigationFunctionLeftUp;
		if(fromColumn>toColumn&&fromRow<toRow)bnf=BoardNavigationFunctionLeftDown;
		if([self canMoveFromColumn:fromColumn andRow:fromRow toColumn:toColumn andRow:toRow withNavigationFunction:bnf])return YES;
	}else if(piece==BoardCellStateBlackRook||piece==BoardCellStateWhiteRook){
		// Rook
		if(piece==BoardCellStateBlackRook){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteRook){
			if(toSquareState>=7)return NO;
		}
		if(fromColumn!=toColumn&&fromRow!=toRow)return NO;
		BoardNavigationFunction bnf;
		if(toColumn>fromColumn)bnf=BoardNavigationFunctionRight;
		if(toColumn<fromColumn)bnf=BoardNavigationFunctionLeft;
		if(toRow<fromRow)bnf=BoardNavigationFunctionUp;
		if(toRow>fromRow)bnf=BoardNavigationFunctionDown;
		if([self canMoveFromColumn:fromColumn andRow:fromRow toColumn:toColumn andRow:toRow withNavigationFunction:bnf])return YES;
	}else if(piece==BoardCellStateBlackBishop||piece==BoardCellStateWhiteBishop){
		// Bishop
		if(piece==BoardCellStateBlackBishop){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteBishop){
			if(toSquareState>=7)return NO;
		}
		if(abs(toColumn-fromColumn)!=abs(toRow-fromRow))return NO;
		BoardNavigationFunction bnf;
		if(fromColumn<toColumn&&fromRow>toRow)bnf=BoardNavigationFunctionRightUp;
		if(fromColumn<toColumn&&fromRow<toRow)bnf=BoardNavigationFunctionRightDown;
		if(fromColumn>toColumn&&fromRow>toRow)bnf=BoardNavigationFunctionLeftUp;
		if(fromColumn>toColumn&&fromRow<toRow)bnf=BoardNavigationFunctionLeftDown;
		if([self canMoveFromColumn:fromColumn andRow:fromRow toColumn:toColumn andRow:toRow withNavigationFunction:bnf])return YES;
	}else if(piece==BoardCellStateBlackKnight||piece==BoardCellStateWhiteKnight){
		// Knight
		if(piece==BoardCellStateBlackKnight){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteKnight){
			if(toSquareState>=7)return NO;
		}
		if((toRow==fromRow+1||toRow==fromRow-1)&&(toColumn==fromColumn+2||toColumn==fromColumn-2))return YES;
		if((toRow==fromRow+2||toRow==fromRow-2)&&(toColumn==fromColumn+1||toColumn==fromColumn-1))return YES;
	}else if(piece==BoardCellStateBlackPawn||piece==BoardCellStateWhitePawn){
		// Pawn
		if(piece==BoardCellStateBlackPawn){
			// Black Pawn
			if(toSquareState==BoardCellStateEmpty){
				// Move Forward
				if(fromColumn==toColumn){
					if(toRow==fromRow+1)return YES;
					if(fromRow==1&&toRow==3&&[super cellStateAtColumn:fromColumn andRow:fromRow+1]==BoardCellStateEmpty)return YES;
				}
				// Un Passant
				if(un_passant.available&&
					un_passant.column==toColumn&&un_passant.row==fromRow+1&&
					toRow==fromRow+1&&(toColumn==fromColumn-1||toColumn==fromColumn+1)&&
						fromRow==4
				   )return YES;
			}else{
				// Take Piece
				if(toRow==fromRow+1&&(toColumn==fromColumn-1||toColumn==fromColumn+1)&&toSquareState>=7)return YES;
			}
		}else if(piece==BoardCellStateWhitePawn){
			// White Pawn
			if(toSquareState==BoardCellStateEmpty){
				// Move Forward
				if(fromColumn==toColumn){
					if(toRow==fromRow-1)return YES;
					if(fromRow==6&&toRow==4&&[super cellStateAtColumn:fromColumn andRow:fromRow-1]==BoardCellStateEmpty)return YES;
				}
				// Un Passant
				if(un_passant.available&&
				   un_passant.column==toColumn&&un_passant.row==fromRow-1&&
					toRow==fromRow-1&&(toColumn==fromColumn-1||toColumn==fromColumn+1)&&
						fromRow==3
				   )return YES;
			}else{
				// Take Piece
				if(toRow==fromRow-1&&(toColumn==fromColumn-1||toColumn==fromColumn+1)&&toSquareState<=6)return YES;
			}
		}
	}
	return NO;
}

- (void)makeMoveFromColumn:(NSInteger)fromColumn andRow:(NSInteger)fromRow toColumn:(NSInteger)toColumn andRow:(NSInteger)toRow{
	// move piece to given location
	NSLog(@"Move");
	
	BoardCellState piece = [super cellStateAtColumn:fromColumn andRow:fromRow];
	
	// Move piece
	[super setCellState:piece forColumn:toColumn andRow:toRow];
	[super setCellState:BoardCellStateEmpty forColumn:fromColumn andRow:fromRow];
	
	// Get New Piece When Pawn Reaches The End
	if(piece==BoardCellStateBlackPawn||piece==BoardCellStateWhitePawn){
		if(toRow==0||toRow==7){
			_newPieceLocation.column=toColumn;
			_newPieceLocation.row=toRow;
			if([self.delegate respondsToSelector:@selector(requestPieceChoise:)])
				[self.delegate requestPieceChoise:self];
			else
				[NSException raise:NSInternalInconsistencyException format:@"Required Delegate Not Implemented"];
		}
	}
	
	// Once the king has moved, don't allow castling
	if(piece==BoardCellStateBlackKing)castling.blackKingMoved=YES;
	if(piece==BoardCellStateWhiteKing)castling.whiteKingMoved=YES;
	
	// Once Rook has moved, don't allow castling with it
	if(piece==BoardCellStateBlackRook){
		if(fromColumn==0&&fromRow==0){
			castling.blackRightRookMoved=YES;
		}else if(fromColumn==7&&fromRow==0){
			castling.blackLeftRookMoved=YES;
		}
	}
	if(piece==BoardCellStateWhiteRook){
		if(fromColumn==0&&fromRow==7){
			castling.whiteLeftRookMoved=YES;
		}else if(fromColumn==7&&fromRow==7){
			castling.whiteRightRookMoved=YES;
		}
	}
	
	// Castling
	if(piece==BoardCellStateBlackKing||piece==BoardCellStateWhiteKing){
		if(abs(toColumn-fromColumn)==2){
			NSLog(@"CASTLE!");
			if(piece==BoardCellStateBlackKing&&fromColumn>toColumn)[self makeMoveFromColumn:0 andRow:0 toColumn:3 andRow:0];
			if(piece==BoardCellStateBlackKing&&fromColumn<toColumn)[self makeMoveFromColumn:7 andRow:0 toColumn:5 andRow:0];
			if(piece==BoardCellStateWhiteKing&&fromColumn>toColumn)[self makeMoveFromColumn:0 andRow:7 toColumn:3 andRow:7];
			if(piece==BoardCellStateWhiteKing&&fromColumn<toColumn)[self makeMoveFromColumn:7 andRow:7 toColumn:5 andRow:7];
		}
	}
	
	// Un Passant Taking
	if(un_passant.available&&(piece==BoardCellStateWhitePawn||piece==BoardCellStateBlackPawn)&&toColumn==un_passant.column&&toRow==un_passant.row){
		if(piece==BoardCellStateBlackPawn){
			[super setCellState:BoardCellStateEmpty forColumn:un_passant.column andRow:un_passant.row-1];
		}else if(piece==BoardCellStateWhitePawn){
			[super setCellState:BoardCellStateEmpty forColumn:un_passant.column andRow:un_passant.row+1];
		}
	}
	
	// Un Passant Availability
	un_passant.available=NO; // reset availability
	if(piece==BoardCellStateBlackPawn&&toRow-fromRow==2){
		if(toColumn-1>=0){
			if([super cellStateAtColumn:toColumn-1 andRow:3]==BoardCellStateWhitePawn){
				un_passant.available=YES;
				un_passant.column=toColumn;
				un_passant.row=toRow-1;
			}
		}
		if(toColumn+1<=7){
			if([super cellStateAtColumn:toColumn+1 andRow:3]==BoardCellStateWhitePawn){
				un_passant.available=YES;
				un_passant.column=toColumn;
				un_passant.row=toRow-1;
			}
		}
	}else if(piece==BoardCellStateWhitePawn&&fromRow-toRow==2){
		if(toColumn-1>=0){
			if([super cellStateAtColumn:toColumn-1 andRow:4]==BoardCellStateBlackPawn){
				un_passant.available=YES;
				un_passant.column=toColumn;
				un_passant.row=toRow+1;
			}
		}
		if(toColumn+1<=7){
			if([super cellStateAtColumn:toColumn+1 andRow:4]==BoardCellStateBlackPawn){
				un_passant.available=YES;
				un_passant.column=toColumn;
				un_passant.row=toRow+1;
			}
		}
	}
	
	// change player turn
	//self.currentPlayer = !self.currentPlayer;
}

- (void)setCurrentPlayer:(PlayerTurnState)currentPlayer{
	_currentPlayer=currentPlayer;
	[super informDelegateOfPlayerTurnChanged:currentPlayer];
}

- (void)selectedSquareOfColumn:(NSInteger)column andRow:(NSInteger)row{
	if(_firsttap.isset){
		if([self isValidMoveFromColumn:_firsttap.column andRow:_firsttap.row toColumn:column andRow:row]){
			[self makeMoveFromColumn:_firsttap.column andRow:_firsttap.row toColumn:column andRow:row];
		}
	}else{
		if([super cellStateAtColumn:column andRow:row]==BoardCellStateEmpty)return;
		_firsttap.column=column;
		_firsttap.row=row;
	}
	_firsttap.isset=!_firsttap.isset;
}

- (BOOL)canMoveFromColumn:(NSInteger)fromColumn andRow:(NSInteger)fromRow toColumn:(NSInteger)toColumn andRow:(NSInteger)toRow withNavigationFunction:(BoardNavigationFunction)navigationFunction{
	
	NSInteger index=0;
	
    // advance to the next cell
    navigationFunction(&fromColumn,&fromRow);
	
    // while within the bounds of the move
    while(fromColumn!=toColumn||fromRow!=toRow){
		
        BoardCellState currentCellState = [super cellStateAtColumn:fromColumn andRow:fromRow];
		
		if(currentCellState!=BoardCellStateEmpty){
			return NO;
		}
		
		// Safety
		if(index++>7)break;
		
        // advance to the next cell
        navigationFunction(&fromColumn, &fromRow);
    }
	
    return YES;
}

- (void)newPieceChosen:(NSInteger)piece{
	BoardCellState state;
	if(_newPieceLocation.row==0){ // White
		switch (piece) {
			case 0:
				state=BoardCellStateWhiteQueen;
				break;
			case 1:
				state=BoardCellStateWhiteRook;
				break;
			case 2:
				state=BoardCellStateWhiteBishop;
				break;
			case 3:
				state=BoardCellStateWhiteKnight;
				break;
		}
	}else{ // Black
		switch (piece) {
			case 0:
				state=BoardCellStateBlackQueen;
				break;
			case 1:
				state=BoardCellStateBlackRook;
				break;
			case 2:
				state=BoardCellStateBlackBishop;
				break;
			case 3:
				state=BoardCellStateBlackKnight;
				break;
		}
	}
	[super setCellState:state forColumn:_newPieceLocation.column andRow:_newPieceLocation.row];
}

@end
