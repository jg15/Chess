//
//  Move.h
//  MultiChess
//
//  Created by Joshua Girard on 4/27/14.
//  Copyright (c) 2014 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoardCoordinateTypes.h"
#import "BoardCellState.h"

@interface Move : NSObject

@property (nonatomic, strong) NSString *move;

- (Move *)init;

- (Move *)initFromString:(NSString *)moveString;
- (Move *)initFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords;
- (Move *)initFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords withPromotion:(char)p;


- (NSString *)moveString;
- (BoardCoordinates)fromCoordinates;
- (BoardCoordinates)toCoordinates;

+ (Move *)moveFromString:(NSString *)moveString;
+ (Move *)moveFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords;
+ (Move *)moveFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords withPromotion:(char)p;

@end
