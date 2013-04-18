//
//  Board.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCellState.h"
//#import "MulticastDelegate.h"
//#import "PlayerTurnState.h"
#import "BoardCoordinateTypes.h"
#import "BoardDelegate.h"

@interface Board : NSObject

//@property (readonly) MulticastDelegate *boardDelegate;

@property (nonatomic, weak) id<BoardDelegate> boardDelegate;

- (BoardCellState)cellStateAtCoordinates:(BoardCoordinates)coordinates;

- (void)setCellState:(BoardCellState)state forCoordinates:(BoardCoordinates)coordinates;

- (void)clearBoard;


@end
