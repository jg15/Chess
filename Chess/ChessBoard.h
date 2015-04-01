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
#import "PlayerTurnState.h"
//#import "RequestUserInputDelegate.h"


@interface ChessBoard : Board{
    NSString *startFEN;
    NSMutableArray *moves;
    NSMutableArray *UCImoves;
}

//@property (nonatomic, weak) id<RequestUserInputDelegate> delegate;

@property (readonly) NSInteger whiteScore;
@property (readonly) NSInteger blackScore;

- (void)setToInitialState;
- (void)setToStateUsingMoves:(NSArray *)ma andUCIMoves:(NSArray *)UCIma;
- (BOOL)isValidMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates;
- (void)makeMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates;
- (void)makeMoveFromCoordinates:(BoardCoordinates)fromCoordinates toCoordinates:(BoardCoordinates)toCoordinates promotion:(char)p;
- (BOOL)isGameOverWithPlayerTurn:(PlayerTurnState)turn;

-(BOOL)isBlackKingInCheck;
-(BOOL)isWhiteKingInCheck;

- (NSString *)getStartFEN;
- (NSArray *)getMoveList;
- (NSArray *)getUCIMoveList;

- (NSString *)gameString;
- (NSString *)uciGameString;

- (void)DEBUG_PRINT_BOARD;

@end
