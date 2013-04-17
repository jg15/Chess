//
//  ChessBoard.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//
//  Requires delegate be implemented.
//

#import "Board.h"
//#import "PlayerTurnState.h"
#import "RequestUserInputDelegate.h"


@interface ChessBoard : Board

//@property (nonatomic, weak) id<RequestUserInputDelegate> delegate;

@property (readonly) NSInteger whiteScore;
@property (readonly) NSInteger blackScore;

- (void)setToInitialState;
- (BOOL)isValidMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates;
//- (BOOL)isValidMoveFromColumn:(NSInteger)fromColumn andRow:(NSInteger)fromRow toColumn:(NSInteger)toColumn andRow:(NSInteger)toRow;
//- (void)makeMoveFromColumn:(NSInteger)fromColumn andRow:(NSInteger)fromRow toColumn:(NSInteger)toColumn andRow:(NSInteger)toRow;
- (void)makeMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates;

- (Board *)getSuperclass;

@end
