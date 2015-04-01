//
//  GCController.h
//  MultiChess
//
//  Created by Joshua Girard on 7/14/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCController : NSObject <GKMatchmakerViewControllerDelegate,GKMatchDelegate>

- (void)startMatch;
- (UIViewController *)vc;

@end
