//
//  BoardNavigationFunctions.h
//  Chess
//
//  Created by Joshua Girard on 4/14/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BoardNavigationFunction)(NSInteger*, NSInteger*);

BoardNavigationFunction BoardNavigationFunctionRight = ^(NSInteger *c, NSInteger *r){
    (*c)++;
};

BoardNavigationFunction BoardNavigationFunctionLeft = ^(NSInteger *c, NSInteger *r){
    (*c)--;
};

BoardNavigationFunction BoardNavigationFunctionUp = ^(NSInteger *c, NSInteger *r){
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionDown = ^(NSInteger *c, NSInteger *r){
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionRightUp = ^(NSInteger *c, NSInteger *r){
    (*c)++;
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionRightDown = ^(NSInteger *c, NSInteger *r){
    (*c)++;
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionLeftUp = ^(NSInteger *c, NSInteger *r){
    (*c)--;
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionLeftDown = ^(NSInteger *c, NSInteger *r){
    (*c)--;
    (*r)++;
};
