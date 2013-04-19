//
//  ChessPiece.h
//  Chess
//
//  Created by Joshua Girard on 4/19/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardCellState.h"

@interface ChessPiece : UIImage

- (ChessPiece *)init;
- (ChessPiece *)initWithChessPiece:(BoardCellState)piece;

+ (ChessPiece *)pieceWithBoardCellState:(BoardCellState)state;

@end
