//
//  ChessBoard.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "Board.h"
#import "PlayerTurnState.h"
#import "RequestUserInputDelegate.h"

@interface ChessBoard : Board

@property (nonatomic, weak) id<RequestUserInputDelegate> delegate;

@property (readonly) NSInteger whiteScore;
@property (readonly) NSInteger blackScore;

@property (readonly) PlayerTurnState currentPlayer;
@property (readonly) struct{
		BOOL isset;
		NSInteger column;
		NSInteger row;
	}firsttap;

- (void)setToInitialState;

- (void)newPieceChosen:(NSInteger)piece;

- (BOOL)isValidMoveFromColumn:(NSInteger)fromColumn andRow:(NSInteger)fromRow toColumn:(NSInteger)toColumn andRow:(NSInteger)toRow;
- (void)makeMoveFromColumn:(NSInteger)fromColumn andRow:(NSInteger)fromRow toColumn:(NSInteger)toColumn andRow:(NSInteger)toRow;
- (void)selectedSquareOfColumn:(NSInteger)column andRow:(NSInteger)row;

@end
