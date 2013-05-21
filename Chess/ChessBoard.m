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
	BoardCoordinates whiteKingLocation;
	BoardCoordinates blackKingLocation;
	BOOL blackKingIsInCheck;
	BOOL whiteKingIsInCheck;
}

- (id)init{
    if (self = [super init]) {
		//_delegate=self;
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
	[self commonInit];
	[super clearBoard];
	
	// Initialize Board
	
	[super setCellState:BoardCellStateWhiteRook forCoordinates:(BoardCoordinates){0, 7}];
	[super setCellState:BoardCellStateWhiteKnight forCoordinates:(BoardCoordinates){1, 7}];
	[super setCellState:BoardCellStateWhiteBishop forCoordinates:(BoardCoordinates){2, 7}];
	[super setCellState:BoardCellStateWhiteQueen forCoordinates:(BoardCoordinates){3, 7}];
	[super setCellState:BoardCellStateWhiteKing forCoordinates:(BoardCoordinates){4, 7}];
	[super setCellState:BoardCellStateWhiteBishop forCoordinates:(BoardCoordinates){5, 7}];
	[super setCellState:BoardCellStateWhiteKnight forCoordinates:(BoardCoordinates){6, 7}];
	[super setCellState:BoardCellStateWhiteRook forCoordinates:(BoardCoordinates){7, 7}];
	for(int i=0;i<8;i++){
		[super setCellState:BoardCellStateWhitePawn forCoordinates:(BoardCoordinates){i, 6}];
	}
	
	whiteKingLocation = (BoardCoordinates){4, 7};
	
	[super setCellState:BoardCellStateBlackRook forCoordinates:(BoardCoordinates){0, 0}];
	[super setCellState:BoardCellStateBlackKnight forCoordinates:(BoardCoordinates){1, 0}];
	[super setCellState:BoardCellStateBlackBishop forCoordinates:(BoardCoordinates){2, 0}];
	[super setCellState:BoardCellStateBlackQueen forCoordinates:(BoardCoordinates){3, 0}];
	[super setCellState:BoardCellStateBlackKing forCoordinates:(BoardCoordinates){4, 0}];
	[super setCellState:BoardCellStateBlackBishop forCoordinates:(BoardCoordinates){5, 0}];
	[super setCellState:BoardCellStateBlackKnight forCoordinates:(BoardCoordinates){6, 0}];
	[super setCellState:BoardCellStateBlackRook forCoordinates:(BoardCoordinates){7, 0}];
	for(int i=0;i<8;i++){
		[super setCellState:BoardCellStateBlackPawn forCoordinates:(BoardCoordinates){i, 1}];
	}
	
	blackKingLocation = (BoardCoordinates){4, 0};
	
	//[super setCellState:BoardCellStateBlackPawn forCoordinates:(BoardCoordinates){5, 5}];
	_whiteScore=0;
	_blackScore=0;
	
	// White moves first
	//self.currentPlayer = PlayerTurnWhite;
}

- (BOOL)willKingBeInCheckInSquareWithCoordinates:(BoardCoordinates)coordinates king:(BoardCellState)king newPieceLocation1:(BoardCoordinates)location1 piece1:(BoardCellState)piece1 location2:(BoardCoordinates)location2 piece2:(BoardCellState)piece2{
	
	[super copyBoard];
	[super setCellStateBoard2:piece1 forCoordinates:location1];
	[super setCellStateBoard2:piece2 forCoordinates:location2];
	
	BoardCellState piece;
	
	for(int col=0;col<8;col++){
		for(int row=0;row<8;row++){
			
			/*if(col==location1.column&&row==location1.row){
				piece = piece1;
			}else if(col==location2.column&&row==location2.row){
				piece = piece2;
			}else{
				piece = [super cellStateAtCoordinates:(BoardCoordinates){col, row}];
			}*/
			
			piece = [super cellStateAtCoordinatesBoard2:(BoardCoordinates){col,row}];
			
			if(piece!=BoardCellStateEmpty){
				if([self isValidMoveFromCoordinates:(BoardCoordinates){col, row} toCoordinates:coordinates withFromPiece:piece andToPiece:king alreadyRun:YES actualBoard:NO]){
					//NSLog(@"######################");
					NSLog(@"KING IN CHECK 2");
					//NSLog(@"######################");
					return YES;
				}
			}
		}
	}
	return NO;
}

- (BOOL)willKingBeInCheckInSquareWithCoordinates:(BoardCoordinates)coordinates king:(BoardCellState)king{

	for(int col=0;col<8;col++){
		for(int row=0;row<8;row++){
			BoardCellState piece = [super cellStateAtCoordinates:(BoardCoordinates){col, row}];
			if(piece!=BoardCellStateEmpty){
				if([self isValidMoveFromCoordinates:(BoardCoordinates){col, row} toCoordinates:coordinates withFromPiece:[super cellStateAtCoordinates:(BoardCoordinates){col, row}] andToPiece:king alreadyRun:YES actualBoard:NO]){
					//NSLog(@"######################");
					NSLog(@"KING IN CHECK");
					//NSLog(@"######################");
					return YES;
				}
			}
		}
	}
	return NO;
}

- (BOOL)isValidMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates{
	BoardCellState piece = [super cellStateAtCoordinates:fromCoordinates];
	BoardCellState toSquareState = [super cellStateAtCoordinates:toCoordinates];
	
	
	// Make sure king isn't in check
	if(piece<=6&&piece!=0){ // black's turn
		if(blackKingIsInCheck){
			
			BoardCoordinates kingLocation=blackKingLocation;
			if(piece==BoardCellStateBlackKing){
				kingLocation=toCoordinates;
			}
			if(!([self isValidMoveFromCoordinates:fromCoordinates toCoordinates:toCoordinates withFromPiece:piece andToPiece:toSquareState alreadyRun:NO actualBoard:YES]&&![self willKingBeInCheckInSquareWithCoordinates:kingLocation king:BoardCellStateBlackKing newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty])){
				return NO;
			}
		}
	}else if(piece>=7){ // white's turn
		if(whiteKingIsInCheck){
			BoardCoordinates kingLocation=whiteKingLocation;
			if(piece==BoardCellStateWhiteKing){
				kingLocation=toCoordinates;
			}
			if(!([self isValidMoveFromCoordinates:fromCoordinates toCoordinates:toCoordinates withFromPiece:piece andToPiece:toSquareState alreadyRun:NO actualBoard:YES]&&![self willKingBeInCheckInSquareWithCoordinates:kingLocation king:BoardCellStateWhiteKing newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty])){
				return NO;
			}
		}
	}
	
	return [self isValidMoveFromCoordinates:fromCoordinates toCoordinates:toCoordinates withFromPiece:piece andToPiece:toSquareState alreadyRun:NO actualBoard:YES];
}

- (BOOL)isValidMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates withFromPiece:(BoardCellState)piece andToPiece:(BoardCellState)toSquareState alreadyRun:(BOOL)alreadyRun actualBoard:(BOOL)actualBoard{

	// check for valid move
	
	BoardCellState king;
	BoardCoordinates kingCoordinates;
	
	if(piece<=6&&piece!=0){ // black
		king=BoardCellStateBlackKing;
		kingCoordinates=blackKingLocation;
	}else if (piece>=7){ // white
		king=BoardCellStateWhiteKing;
		kingCoordinates=whiteKingLocation;
	}
	
	
	if(piece==BoardCellStateBlackKing||piece==BoardCellStateWhiteKing){
		// King
		if(piece==BoardCellStateBlackKing){
			if(toSquareState<=6&&toSquareState!=0)return NO;
			// Castling
			if(!castling.blackKingMoved&&((toCoordinates.column==2&&!castling.blackLeftRookMoved)||(toCoordinates.column==6&&!castling.blackRightRookMoved))&&toCoordinates.row==0){
				if(fromCoordinates.column<toCoordinates.column){
					if([self canMovefromCoordinates:fromCoordinates toCoordinates:toCoordinates withNavigationFunction:BoardNavigationFunctionRight actualBoard:actualBoard]){
						if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
						return YES;
					}
				}else{
					if([self canMovefromCoordinates:fromCoordinates toCoordinates:(BoardCoordinates){toCoordinates.column-2, toCoordinates.row} withNavigationFunction:BoardNavigationFunctionLeft actualBoard:actualBoard]){
						if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
						return YES;
					}
				}
				//return YES;
			}
		}else if(piece==BoardCellStateWhiteKing){
			if(toSquareState>=7)return NO;
			// Castling
			if(!castling.whiteKingMoved&&((toCoordinates.column==2&&!castling.whiteRightRookMoved)||(toCoordinates.column==6&&!castling.whiteLeftRookMoved))&&toCoordinates.row==7){
				if(fromCoordinates.column<toCoordinates.column){
					if([self canMovefromCoordinates:fromCoordinates toCoordinates:toCoordinates withNavigationFunction:BoardNavigationFunctionRight actualBoard:actualBoard]){
						if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
						return YES;
					}
				}else{
					if([self canMovefromCoordinates:fromCoordinates toCoordinates:(BoardCoordinates){toCoordinates.column-2, toCoordinates.row} withNavigationFunction:BoardNavigationFunctionLeft actualBoard:actualBoard]){
						if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
						return YES;
					}
				}
				//return YES;
			}
		}
		if(abs(fromCoordinates.column-toCoordinates.column)>1||abs(fromCoordinates.row-toCoordinates.row)>1)return NO;
		if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
		return YES;
	}else if(piece==BoardCellStateBlackQueen||piece==BoardCellStateWhiteQueen){
		// Queen
		if(piece==BoardCellStateBlackQueen){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteQueen){
			if(toSquareState>=7)return NO;
		}
		if(abs(toCoordinates.column-fromCoordinates.column)!=abs(toCoordinates.row-fromCoordinates.row)&&(fromCoordinates.column!=toCoordinates.column&&fromCoordinates.row!=toCoordinates.row))return NO;
		BoardNavigationFunction bnf;
		if(toCoordinates.column>fromCoordinates.column)bnf=BoardNavigationFunctionRight;
		if(toCoordinates.column<fromCoordinates.column)bnf=BoardNavigationFunctionLeft;
		if(toCoordinates.row<fromCoordinates.row)bnf=BoardNavigationFunctionUp;
		if(toCoordinates.row>fromCoordinates.row)bnf=BoardNavigationFunctionDown;
		if(fromCoordinates.column<toCoordinates.column&&fromCoordinates.row>toCoordinates.row)bnf=BoardNavigationFunctionRightUp;
		if(fromCoordinates.column<toCoordinates.column&&fromCoordinates.row<toCoordinates.row)bnf=BoardNavigationFunctionRightDown;
		if(fromCoordinates.column>toCoordinates.column&&fromCoordinates.row>toCoordinates.row)bnf=BoardNavigationFunctionLeftUp;
		if(fromCoordinates.column>toCoordinates.column&&fromCoordinates.row<toCoordinates.row)bnf=BoardNavigationFunctionLeftDown;
		if([self canMovefromCoordinates:fromCoordinates toCoordinates:toCoordinates withNavigationFunction:bnf actualBoard:actualBoard]){
			if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
			return YES;
		}
	}else if(piece==BoardCellStateBlackRook||piece==BoardCellStateWhiteRook){
		// Rook
		if(piece==BoardCellStateBlackRook){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteRook){
			if(toSquareState>=7)return NO;
		}
		if(fromCoordinates.column!=toCoordinates.column&&fromCoordinates.row!=toCoordinates.row)return NO;
		BoardNavigationFunction bnf;
		if(toCoordinates.column>fromCoordinates.column)bnf=BoardNavigationFunctionRight;
		if(toCoordinates.column<fromCoordinates.column)bnf=BoardNavigationFunctionLeft;
		if(toCoordinates.row<fromCoordinates.row)bnf=BoardNavigationFunctionUp;
		if(toCoordinates.row>fromCoordinates.row)bnf=BoardNavigationFunctionDown;
		if([self canMovefromCoordinates:fromCoordinates toCoordinates:toCoordinates withNavigationFunction:bnf actualBoard:actualBoard]){
			if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
			return YES;
		}
	}else if(piece==BoardCellStateBlackBishop||piece==BoardCellStateWhiteBishop){
		// Bishop
		if(piece==BoardCellStateBlackBishop){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteBishop){
			if(toSquareState>=7)return NO;
		}
		if(abs(toCoordinates.column-fromCoordinates.column)!=abs(toCoordinates.row-fromCoordinates.row))return NO;
		BoardNavigationFunction bnf;
		if(fromCoordinates.column<toCoordinates.column&&fromCoordinates.row>toCoordinates.row)bnf=BoardNavigationFunctionRightUp;
		if(fromCoordinates.column<toCoordinates.column&&fromCoordinates.row<toCoordinates.row)bnf=BoardNavigationFunctionRightDown;
		if(fromCoordinates.column>toCoordinates.column&&fromCoordinates.row>toCoordinates.row)bnf=BoardNavigationFunctionLeftUp;
		if(fromCoordinates.column>toCoordinates.column&&fromCoordinates.row<toCoordinates.row)bnf=BoardNavigationFunctionLeftDown;
		if([self canMovefromCoordinates:fromCoordinates toCoordinates:toCoordinates withNavigationFunction:bnf actualBoard:actualBoard]){
			if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
			return YES;
		}
	}else if(piece==BoardCellStateBlackKnight||piece==BoardCellStateWhiteKnight){
		// Knight
		if(piece==BoardCellStateBlackKnight){
			if(toSquareState<=6&&toSquareState!=0)return NO;
		}else if(piece==BoardCellStateWhiteKnight){
			if(toSquareState>=7)return NO;
		}
		if((toCoordinates.row==fromCoordinates.row+1||toCoordinates.row==fromCoordinates.row-1)&&(toCoordinates.column==fromCoordinates.column+2||toCoordinates.column==fromCoordinates.column-2)){
			if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
			return YES;
		}
		if((toCoordinates.row==fromCoordinates.row+2||toCoordinates.row==fromCoordinates.row-2)&&(toCoordinates.column==fromCoordinates.column+1||toCoordinates.column==fromCoordinates.column-1)){
			if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
			return YES;
		}
	}else if(piece==BoardCellStateBlackPawn||piece==BoardCellStateWhitePawn){
		// Pawn
		if(piece==BoardCellStateBlackPawn){
			// Black Pawn
			if(toSquareState==BoardCellStateEmpty){
				// Move Forward
				if(fromCoordinates.column==toCoordinates.column){
					if(toCoordinates.row==fromCoordinates.row+1){
						if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
						return YES;
					}
					if(fromCoordinates.row==1&&toCoordinates.row==3&&[super cellStateAtCoordinates:(BoardCoordinates){fromCoordinates.column, fromCoordinates.row+1}]==BoardCellStateEmpty){
						if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
						return YES;
					}
				}
				// Un Passant
				if(un_passant.available&&
					un_passant.column==toCoordinates.column&&un_passant.row==fromCoordinates.row+1&&
					toCoordinates.row==fromCoordinates.row+1&&(toCoordinates.column==fromCoordinates.column-1||toCoordinates.column==fromCoordinates.column+1)&&
						fromCoordinates.row==4
				   ){
					if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
					return YES;
				}
			}else{
				// Take Piece
				if(toCoordinates.row==fromCoordinates.row+1&&(toCoordinates.column==fromCoordinates.column-1||toCoordinates.column==fromCoordinates.column+1)&&toSquareState>=7){
					if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
					return YES;
				}
			}
		}else if(piece==BoardCellStateWhitePawn){
			// White Pawn
			if(toSquareState==BoardCellStateEmpty){
				// Move Forward
				if(fromCoordinates.column==toCoordinates.column){
					if(toCoordinates.row==fromCoordinates.row-1)return YES;
					if(fromCoordinates.row==6&&toCoordinates.row==4&&[super cellStateAtCoordinates:(BoardCoordinates){fromCoordinates.column, fromCoordinates.row-1}]==BoardCellStateEmpty){
						if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
						return YES;
					}
				}
				// Un Passant
				if(un_passant.available&&
				   un_passant.column==toCoordinates.column&&un_passant.row==fromCoordinates.row-1&&
					toCoordinates.row==fromCoordinates.row-1&&(toCoordinates.column==fromCoordinates.column-1||toCoordinates.column==fromCoordinates.column+1)&&
						fromCoordinates.row==3
				   ){
					if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
					return YES;
				}
			}else{
				// Take Piece
				if(toCoordinates.row==fromCoordinates.row-1&&(toCoordinates.column==fromCoordinates.column-1||toCoordinates.column==fromCoordinates.column+1)&&toSquareState<=6){
					if(!alreadyRun)return ![self willKingBeInCheckInSquareWithCoordinates:kingCoordinates king:king newPieceLocation1:toCoordinates piece1:piece location2:fromCoordinates piece2:BoardCellStateEmpty];
					return YES;
				}
			}
		}
	}
	return NO;
}

- (void)makeMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates{
	// move piece to given location
	
	BoardCellState piece = [super cellStateAtCoordinates:fromCoordinates];
	BoardCellState toPiece = [super cellStateAtCoordinates:toCoordinates];
	
	if(toPiece!=BoardCellStateEmpty)[self.boardDelegate pieceWasTaken:toPiece];
	
	// Move piece
	[super setCellState:piece forCoordinates:toCoordinates];
	[super setCellState:BoardCellStateEmpty forCoordinates:fromCoordinates];
	
	// Check if enemy king is now in check
	
	if(piece<=6){ // black moved
		// check if white king is now in check
		if([self willKingBeInCheckInSquareWithCoordinates:whiteKingLocation king:BoardCellStateWhiteKing]){
			whiteKingIsInCheck=YES;
			NSLog(@"WHITE KING IN CHECK");
		}
		blackKingIsInCheck=NO;
	}else if(piece>=7){ // white moved
		// check if black king is now in check
		if([self willKingBeInCheckInSquareWithCoordinates:blackKingLocation king:BoardCellStateBlackKing]){
			blackKingIsInCheck=YES;
			NSLog(@"BLACK KING IN CHECK");
		}
		whiteKingIsInCheck=NO;
	}
	
	
	
	
	if(piece==BoardCellStateBlackKing){
		blackKingLocation = toCoordinates;

	}
	if(piece==BoardCellStateWhiteKing){
		whiteKingLocation = toCoordinates;
	}
		
	// Once the king has moved, don't allow castling
	if(piece==BoardCellStateBlackKing)castling.blackKingMoved=YES;
	if(piece==BoardCellStateWhiteKing)castling.whiteKingMoved=YES;
	
	// Once Rook has moved, don't allow castling with it
	if(piece==BoardCellStateBlackRook){
		if(fromCoordinates.column==0&&fromCoordinates.row==0){
			castling.blackRightRookMoved=YES;
		}else if(fromCoordinates.column==7&&fromCoordinates.row==0){
			castling.blackLeftRookMoved=YES;
		}
	}
	if(piece==BoardCellStateWhiteRook){
		if(fromCoordinates.column==0&&fromCoordinates.row==7){
			castling.whiteLeftRookMoved=YES;
		}else if(fromCoordinates.column==7&&fromCoordinates.row==7){
			castling.whiteRightRookMoved=YES;
		}
	}
	
	// Castling
	if(piece==BoardCellStateBlackKing||piece==BoardCellStateWhiteKing){
		if(abs(toCoordinates.column-fromCoordinates.column)==2){
			NSLog(@"CASTLE!");
			
			if(piece==BoardCellStateBlackKing&&fromCoordinates.column>toCoordinates.column)[self makeMoveFromCoordinates:(BoardCoordinates){0, 0} toCoordinates:(BoardCoordinates){3, 0}];

			if(piece==BoardCellStateBlackKing&&fromCoordinates.column<toCoordinates.column)[self makeMoveFromCoordinates:(BoardCoordinates){7, 0} toCoordinates:(BoardCoordinates){5, 0}];
			
			if(piece==BoardCellStateWhiteKing&&fromCoordinates.column>toCoordinates.column)[self makeMoveFromCoordinates:(BoardCoordinates){0, 7} toCoordinates:(BoardCoordinates){3, 7}];
			
			if(piece==BoardCellStateWhiteKing&&fromCoordinates.column<toCoordinates.column)[self makeMoveFromCoordinates:(BoardCoordinates){7, 7} toCoordinates:(BoardCoordinates){5, 7}];
		}
	}
	
	// Un Passant Taking
	if(un_passant.available&&(piece==BoardCellStateWhitePawn||piece==BoardCellStateBlackPawn)&&toCoordinates.column==un_passant.column&&toCoordinates.row==un_passant.row){
		if(piece==BoardCellStateBlackPawn){
			[super setCellState:BoardCellStateEmpty forCoordinates:(BoardCoordinates){un_passant.column, un_passant.row-1}];
		}else if(piece==BoardCellStateWhitePawn){
			[super setCellState:BoardCellStateEmpty forCoordinates:(BoardCoordinates){un_passant.column, un_passant.row+1}];
		}
	}
	
	// Un Passant Availability
	un_passant.available=NO; // reset availability
	if(piece==BoardCellStateBlackPawn&&toCoordinates.row-fromCoordinates.row==2){
		if(toCoordinates.column-1>=0){
			if([super cellStateAtCoordinates:(BoardCoordinates){toCoordinates.column-1, 3}]==BoardCellStateWhitePawn){
				un_passant.available=YES;
				un_passant.column=toCoordinates.column;
				un_passant.row=toCoordinates.row-1;
			}
		}
		if(toCoordinates.column+1<=7){
			if([super cellStateAtCoordinates:(BoardCoordinates){toCoordinates.column+1, 3}]==BoardCellStateWhitePawn){
				un_passant.available=YES;
				un_passant.column=toCoordinates.column;
				un_passant.row=toCoordinates.row-1;
			}
		}
	}else if(piece==BoardCellStateWhitePawn&&fromCoordinates.row-toCoordinates.row==2){
		if(toCoordinates.column-1>=0){
			if([super cellStateAtCoordinates:(BoardCoordinates){toCoordinates.column-1, 4}]==BoardCellStateBlackPawn){
				un_passant.available=YES;
				un_passant.column=toCoordinates.column;
				un_passant.row=toCoordinates.row+1;
			}
		}
		if(toCoordinates.column+1<=7){
			if([super cellStateAtCoordinates:(BoardCoordinates){toCoordinates.column+1, 4}]==BoardCellStateBlackPawn){
				un_passant.available=YES;
				un_passant.column=toCoordinates.column;
				un_passant.row=toCoordinates.row+1;
			}
		}
	}
	
	// change player turn
	//self.currentPlayer = !self.currentPlayer;
}
/*
- (void)setCurrentPlayer:(PlayerTurnState)currentPlayer{
	_currentPlayer=currentPlayer;
	[super informDelegateOfPlayerTurnChanged:currentPlayer];
}*/

- (BOOL)canMovefromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates  withNavigationFunction:(BoardNavigationFunction)navigationFunction actualBoard:(BOOL)actualBoard{
	
	NSInteger index=0;
	
    // advance to the next cell
    navigationFunction(&fromCoordinates.column,&fromCoordinates.row);
	
    // while within the bounds of the move
    while(fromCoordinates.column!=toCoordinates.column||fromCoordinates.row!=toCoordinates.row){
		
        BoardCellState currentCellState = actualBoard ? [super cellStateAtCoordinates:fromCoordinates] : [super cellStateAtCoordinatesBoard2:fromCoordinates];
		
		if(currentCellState!=BoardCellStateEmpty){
			return NO;
		}
		
		// Safety
		if(index++>7)break;
		
        // advance to the next cell
        navigationFunction(&fromCoordinates.column, &fromCoordinates.row);
    }
	
    return YES;
}

@end
