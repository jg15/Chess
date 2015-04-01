//
//  MenuViewController.m
//  MultiChess
//
//  Created by Joshua Girard on 7/7/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "MenuViewController.h"
//#import "GCHelper.h"
//#import "GCController.h"
#import "ChessViewController.h"


@interface MenuViewController ()
//@property (nonatomic,strong) GCController *gc;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	//[[GCHelper sharedInstance] authenticateLocalUser];
	
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)x:(id)sender{
	[self authPlayer];
	
}

-(void)authPlayer{
	
	
	
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
		if (viewController != nil) {
			// show the authentication dialog
			[self presentViewController:viewController animated:YES completion:nil];
			//SPEvent *event = [SPEvent eventWithType:@"showAuthenticationDialog" bubbles:YES];
			//event.userData = viewController;
			//[self dispatchEvent:event];
			NSLog(@"Authenticating...");
		} else if (localPlayer.authenticated) {
			// dispatch authenticated event to all listening objects
			//SPEvent *event = [SPEvent eventWithType:@"playerAuthenticated"];
			//[self broadcastEvent:event];
			NSLog(@"authenticated");
		} else {
			// dispatch not authenticated event to all listening objects
			//SPEvent *event = [SPEvent eventWithType:@"playerNotAuthenticated"];
			//[self broadcastEvent:event];
			NSLog(@"not authenticated");
		}
	};
	
	
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RecipeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
    }*/
    if([segue.identifier isEqualToString:@"StartChessSinglePlayer"]){
        ChessViewController *destViewController = segue.destinationViewController;
        destViewController.singlePlayerMode = YES;
    }else if([segue.identifier isEqualToString:@"StartChessMultiPlayer"]){
        ChessViewController *destViewController = segue.destinationViewController;
        destViewController.singlePlayerMode = NO;
    }
}


@end
