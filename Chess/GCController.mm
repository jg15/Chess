//
//  GCController.m
//  MultiChess
//
//  Created by Joshua Girard on 7/14/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "GCController.h"
#import "GCViewController.h"

@interface GCController ()

@property (nonatomic,strong) GCViewController *viewController;

@property (nonatomic,strong) GKMatchmakerViewController *controller;

@end


@implementation GCController

- (id)init{
	self = [super init];
	return self;
}

- (void)startMatch{
	GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init];
	matchRequest.minPlayers = 2;
	matchRequest.maxPlayers = 2;
	
	self.controller = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchRequest];
	self.controller.matchmakerDelegate = self;
	//[self.viewController presentViewController:controller animated:YES completion:nil];
	NSLog(@"hi");
}

- (UIViewController *)vc{
	return self.controller;
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match{
	match.delegate=self;
	NSLog(@"hi2");
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController{
	
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error{
	
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID{
	
}

@end
