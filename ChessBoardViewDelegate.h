//
//  ChessBoardViewDelegate.h
//  Chess
//
//  Created by Joshua Girard on 4/16/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChessBoardView;

@protocol ChessBoardViewDelegate <NSObject>
- (void)chessPieceAnimationFinished:(ChessBoardView *)sender;
@end
