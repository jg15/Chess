//
//  BoardDelegate.h
//  Chess
//
//  Created by Joshua Girard on 4/12/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCellState.h"
#import "BoardCoordinateTypes.h"

@protocol BoardDelegate <NSObject>
- (void)cellStateChanged:(BoardCellState)state forCoordinates:(BoardCoordinates)coordinates;
@end
