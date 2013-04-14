//
//  Board.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCellState.h"
#import "MulticastDelegate.h"

@interface Board : NSObject

@property (readonly) MulticastDelegate *boardDelegate;

- (BoardCellState)cellStateAtColumn:(NSInteger)column andRow:(NSInteger)row;

- (void)setCellState:(BoardCellState)state forColumn:(NSUInteger)column andRow:(NSUInteger)row;

- (void)clearBoard;

@end
