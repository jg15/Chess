//
//  BoardSquareViewDelegate.h
//  Chess
//
//  Created by Joshua Girard on 4/15/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCoordinateTypes.h"

@class BoardSquareView;

@protocol BoardSquareViewDelegate <NSObject>
- (void)boardSquareCellTapped:(BoardSquareView *)sender atCoordinates:(BoardCoordinates)coordinates;
@end
