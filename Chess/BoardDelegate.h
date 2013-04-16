//
//  BoardDelegate.h
//  Chess
//
//  Created by Joshua Girard on 4/12/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCellState.h"
#import "PlayerTurnState.h"

@protocol BoardDelegate <NSObject>
- (void)cellStateChanged:(BoardCellState)state forColumn:(int)column andRow:(int)row;
- (void)playerTurnChanged:(PlayerTurnState)player;
@end
