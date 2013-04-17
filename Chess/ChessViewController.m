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
#import "BoardCoordinateTypes.h"
#import "BoardSquareView.h"

@interface ChessViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIImageView *boardImage;

@property (nonatomic, strong) ChessBoard *chessBoard;
@property (nonatomic, strong) ChessBoardView *chessBoardView;

- (void)loadChessBoard;

@end

@implementation ChessViewController{
	BoardCoordinates _firstTap;
	BOOL _firsttapIsset;
	
	BoardCoordinates _newPieceLocation;
}

#pragma mark -
#pragma mark Init View

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Background Color
	self.backgroundImage.backgroundColor=[UIColor redColor];
	
	// Load Chess Board
	[self loadChessBoard];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Chess Board Controller

- (void)loadChessBoard{
	
	// Create board
	self.chessBoard = [[ChessBoard alloc] init];
	//self.chessBoard.delegate = self;
	self.chessBoard.boardDelegate = self;
	// Create view
	self.chessBoardView = [[ChessBoardView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height- self.view.bounds.size.width)*.5, self.view.bounds.size.width, self.view.bounds.size.width) andBoard:self.chessBoard];
	
	for (BoardSquareView *square in self.chessBoardView.squares) {
		square.delegate = self;
	}
	
	[self.view addSubview:self.chessBoardView];
	
	self.boardImage.image = [UIImage imageNamed:@"Board.png"];
	
	_firsttapIsset=NO;
	
	_playerTurn = PlayerTurnWhite;
	
	if(_playerTurn == PlayerTurnBlack)[self rotateBoard];
}


- (void)boardSquareCellTapped:(BoardSquareView *)sender atCoordinates:(BoardCoordinates)coordinates{
	
	// If board is facing black, flip pieces
	if(_playerTurn == PlayerTurnBlack){
		coordinates.column=7-coordinates.column;
		coordinates.row=7-coordinates.row;
	}
	
	// Only allow current player to move
	BoardCellState piece = [self.chessBoard cellStateAtCoordinates:coordinates];
	if(((piece>0&&piece<=6&&_playerTurn==PlayerTurnWhite)||(piece>=7&&_playerTurn==PlayerTurnBlack))&&!_firsttapIsset)return;
	
	
	if(_firsttapIsset){
		if([self.chessBoard isValidMoveFromCoordinates:_firstTap toCoordinates:coordinates]){
			NSLog(@"valid");
			[self.chessBoard makeMoveFromCoordinates:_firstTap toCoordinates:coordinates];
			//_playerTurn = !_playerTurn;
			[self rotateBoard];
		}
	}else{
		//NSLog(@"1");
		BoardCellState state = [self.chessBoard cellStateAtCoordinates:coordinates];
		if(state==BoardCellStateEmpty)return;
		_firstTap=coordinates;
	}
	_firsttapIsset=!_firsttapIsset;
}

- (void)cellStateChanged:(BoardCellState)state forCoordinates:(BoardCoordinates)coordinates{
	[[self.chessBoardView.squares objectAtIndex:coordinates.row*8+coordinates.column] updateWithCellState:state];
	if((state==BoardCellStateBlackPawn||state==BoardCellStateWhitePawn)&&(coordinates.row==0||coordinates.row==7)){
		_newPieceLocation=coordinates;
		[self popup];
	}
}

- (void)popup{
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select New Piece:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Queen", @"Rook", @"Bishop", @"Knight", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex<0){
		[self popup];
	}else{
		BoardCellState state;
		if(_newPieceLocation.row==0){ // White
			switch (buttonIndex) {
				case 0:
					state=BoardCellStateWhiteQueen;
					break;
				case 1:
					state=BoardCellStateWhiteRook;
					break;
				case 2:
					state=BoardCellStateWhiteBishop;
					break;
				case 3:
					state=BoardCellStateWhiteKnight;
					break;
			}
		}else{ // Black
			switch (buttonIndex) {
				case 0:
					state=BoardCellStateBlackQueen;
					break;
				case 1:
					state=BoardCellStateBlackRook;
					break;
				case 2:
					state=BoardCellStateBlackBishop;
					break;
				case 3:
					state=BoardCellStateBlackKnight;
					break;
			}
		}
		[self.chessBoard setCellState:state forCoordinates:_newPieceLocation];
		//[super setCellState:state forColumn:_newPieceLocation.column andRow:_newPieceLocation.row];
		
	}
	//NSLog(@"Button #%d clicked",buttonIndex);
}


- (void)rotateBoard{
	//NSUInteger invert = _playerTurn == PlayerTurnWhite ? 0 : 7;
	NSUInteger index=0;
	if(_playerTurn == PlayerTurnWhite){
		for (BoardSquareView *square in self.chessBoardView.squares) {
			[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){index%8, index/8}]];
			index++;
		}
	}else{
	for (BoardSquareView *square in self.chessBoardView.squares) {
		[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){7-index%8, 7-index/8}]];
		index++;
	}
	}
}

/*
- (void)newPieceChosen:(NSInteger)piece{
	BoardCellState state;
	if(_newPieceLocation.row==0){ // White
		switch (piece) {
			case 0:
				state=BoardCellStateWhiteQueen;
				break;
			case 1:
				state=BoardCellStateWhiteRook;
				break;
			case 2:
				state=BoardCellStateWhiteBishop;
				break;
			case 3:
				state=BoardCellStateWhiteKnight;
				break;
		}
	}else{ // Black
		switch (piece) {
			case 0:
				state=BoardCellStateBlackQueen;
				break;
			case 1:
				state=BoardCellStateBlackRook;
				break;
			case 2:
				state=BoardCellStateBlackBishop;
				break;
			case 3:
				state=BoardCellStateBlackKnight;
				break;
		}
	}
	[super setCellState:state forColumn:_newPieceLocation.column andRow:_newPieceLocation.row];
}*/









/*
- (void)selectedSquareOfColumn:(NSInteger)column andRow:(NSInteger)row{
	if(_firsttap.isset){
		if([self isValidMoveFromColumn:_firsttap.column andRow:_firsttap.row toColumn:column andRow:row]){
			[self makeMoveFromColumn:_firsttap.column andRow:_firsttap.row toColumn:column andRow:row];
		}
	}else{
		if([super cellStateAtColumn:column andRow:row]==BoardCellStateEmpty)return;
		_firsttap.column=column;
		_firsttap.row=row;
	}
	_firsttap.isset=!_firsttap.isset;
}

*/

























/*


- (void)popup{
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select New Piece:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Queen", @"Rook", @"Bishop", @"Knight", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}

- (void)requestPieceChoise:(ChessBoard *)sender{
	[self popup];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex<0){
		[self popup];
	}else{
		[self.chessBoard newPieceChosen:buttonIndex];
	}
	//NSLog(@"Button #%d clicked",buttonIndex);
}*/

@end
