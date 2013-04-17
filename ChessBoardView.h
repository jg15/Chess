//
//  ChessBoardView.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessBoard.h"

@interface ChessBoardView : UIView

@property (nonatomic, strong) NSMutableArray *squares; // test as readonly

- (id)initWithFrame:(CGRect)frame andBoard:(ChessBoard *)board;

@end
