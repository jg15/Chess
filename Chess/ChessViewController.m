//
//  ChessViewController.m
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import "ChessViewController.h"
#import "ChessBoard.h"
#import "ChessBoardView.h"

@interface ChessViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIImageView *boardImage;
@end

@implementation ChessViewController{
	ChessBoard *_board;
}

- (UIImage *)getImageOfColor:(UIColor *)color withSize:(CGRect)rect{
	//CGRect rect = CGRectMake(0, 0, 1, 1);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	//  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
	CGContextFillRect(context, rect);
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.boardImage.image = [UIImage imageNamed:@"Board.png"];
	self.backgroundImage.image = [self getImageOfColor:[UIColor redColor] withSize:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Create board
	_board = [[ChessBoard alloc] init];
	
	// Create view
	ChessBoardView *chessBoard = [[ChessBoardView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height- self.view.bounds.size.width)*.5, self.view.bounds.size.width, self.view.bounds.size.width) andBoard:_board];
	[self.view addSubview:chessBoard];
	//self.backgroundImage.image = [UIImage imageNamed:@"Board.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
