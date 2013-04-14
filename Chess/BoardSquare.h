//
//  BoardSquare.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessBoard.h"
#import "BoardDelegate.h"

@interface BoardSquare : UIView <BoardDelegate>

- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(ChessBoard *)board;

@end
