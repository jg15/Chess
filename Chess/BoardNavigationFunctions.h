//
//  BoardNavigationFunctions.h
//  Chess
//
//  Created by Joshua Girard on 4/14/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BoardNavigationFunction)(int*, int*);

BoardNavigationFunction BoardNavigationFunctionRight = ^(int *c, int *r){
    (*c)++;
};

BoardNavigationFunction BoardNavigationFunctionLeft = ^(int *c, int *r){
    (*c)--;
};

BoardNavigationFunction BoardNavigationFunctionUp = ^(int *c, int *r){
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionDown = ^(int *c, int *r){
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionRightUp = ^(int *c, int *r){
    (*c)++;
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionRightDown = ^(int *c, int *r){
    (*c)++;
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionLeftUp = ^(int *c, int *r){
    (*c)--;
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionLeftDown = ^(int *c, int *r){
    (*c)--;
    (*r)++;
};
