//
//  Move.m
//  MultiChess
//
//  Created by Joshua Girard on 4/27/14.
//  Copyright (c) 2014 Joshua Girard. All rights reserved.
//

#import "Move.h"

@implementation Move

// Call "initFromString" instead
- (Move *)init{
    return nil;
}

- (Move *)initFromString:(NSString *)moveString{
    if(self=[super init]){
        assert([moveString length]==4 || [moveString length]==5);
		self.move = moveString;
	}
	return self;
}

- (Move *)initFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords{
    
    // Coordinates are stored internally backwards so flip the rows:
    fromCoords.row = 7-fromCoords.row;
    toCoords.row = 7-toCoords.row;
    
    char m[5];
    
    m[0]=(char)fromCoords.column+97;
    m[1]=(char)fromCoords.row+49;
    m[2]=(char)toCoords.column+97;
    m[3]=(char)toCoords.row+49;
    m[4]='\0';
    
    return [self initFromString:[NSString stringWithUTF8String:m]];
}

- (Move *)initFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords withPromotion:(char)p{
    Move *m = [self initFromBoardCoordinatesFrom:fromCoords to:toCoords];
    
    return [Move moveFromString:[NSString stringWithFormat:@"%@%c",[m moveString],p]];
}

- (NSString *)moveString{
    return self.move;
}


- (BoardCoordinates)fromCoordinates{
    
    const char *m = [self.move UTF8String];
    
    int bc[2];
    
    bc[0] = m[0]-97;
    bc[1] = 7 - (m[1]-49);
    
    return (BoardCoordinates){bc[0],bc[1]};
    
}

- (BoardCoordinates)toCoordinates{
    
    const char *m = [self.move UTF8String];
    
    int bc[2];
    
    bc[0] = m[2]-97;
    bc[1] = 7 - (m[3]-49);
    
    return (BoardCoordinates){bc[0],bc[1]};
    
}


+ (Move *)moveFromString:(NSString *)moveString{
    return [[Move alloc] initFromString:moveString];
}

+ (Move *)moveFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords{
    return [[Move alloc] initFromBoardCoordinatesFrom:fromCoords to:toCoords];
}

+ (Move *)moveFromBoardCoordinatesFrom:(BoardCoordinates)fromCoords to:(BoardCoordinates)toCoords withPromotion:(char)p{
    return [[Move alloc] initFromBoardCoordinatesFrom:fromCoords to:toCoords withPromotion:p];
}

@end
