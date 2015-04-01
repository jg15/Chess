//
//  ChessViewController.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerTurnState.h"
#import "BoardSquareViewDelegate.h"
#import "BoardDelegate.h"
#import "ChessBoardViewDelegate.h"
#import "EngineController.h"
#import "Move.h"

@interface ChessViewController : UIViewController <UIActionSheetDelegate,BoardSquareViewDelegate,BoardDelegate,ChessBoardViewDelegate>{
	PlayerTurnState _playerTurn;
    EngineController *engineController;
}

@property (readonly) struct{
	BOOL isset;
	NSInteger column;
	NSInteger row;
}firsttap;

@property BOOL singlePlayerMode;

- (void)displayPV:(NSString *)pv;
- (void)displaySearchStats:(NSString *)searchStats;
- (void)engineMadeMove:(NSArray *)array;

@end
