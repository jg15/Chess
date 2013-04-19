//
//  BoardSquareView.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardCoordinateTypes.h"
#import "BoardCellState.h"
#import "BoardSquareViewDelegate.h"
#import "ChessPiece.h"

@interface BoardSquareView : UIView

@property (nonatomic, strong) UIImageView *pieceView;
@property (nonatomic, weak) id<BoardSquareViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame boardCellState:(BoardCellState)state andCoordinates:(BoardCoordinates)coordinates;
- (void)updateWithCellState:(BoardCellState)state;

@end
