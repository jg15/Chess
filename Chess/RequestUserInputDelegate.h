//
//  RequestUserInputDelegate.h
//  Chess
//
//  Created by Joshua Girard on 4/14/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChessBoard;

@protocol RequestUserInputDelegate <NSObject>
- (void)requestPieceChoise:(ChessBoard *)sender;
@end
