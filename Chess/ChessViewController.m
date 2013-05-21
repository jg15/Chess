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
#import "ScoreView.h"

@interface ChessViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIImageView *boardImage;

@property (nonatomic, strong) ChessBoard *chessBoard;
@property (nonatomic, strong) ChessBoardView *chessBoardView;

@property (nonatomic, strong) ScoreView *whiteScoreView;
@property (nonatomic, strong) ScoreView *blackScoreView;

@property (nonatomic, strong) UIView *aboveBoardView;
@property (nonatomic, strong) UIView *bellowBoardView;

@property (nonatomic) BOOL localGameIsTwoPlayer;

@property (nonatomic, strong) NSMutableArray *whitesCapturedPieces;
@property (nonatomic, strong) NSMutableArray *blacksCapturedPieces;

- (void)loadChessBoard;

@end

@implementation ChessViewController{
	BoardCoordinates _firstTap;
	BOOL _firsttapIsset;
	
	BoardCoordinates _secondTap;
	
	BoardCoordinates _newPieceRealLocation;
	BOOL _newPieceIsBeingChosen;
	
	BOOL _pieceIsAnimated;
	
	BoardCoordinates _doNotMove;
	BOOL _shouldNotMove;
}

@synthesize whitesCapturedPieces = _whitesCapturedPieces;
@synthesize blacksCapturedPieces = _blacksCapturedPieces;

#pragma mark -
#pragma mark Init View

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Background Color
	self.backgroundImage.backgroundColor=[UIColor redColor];
	
	// Load Chess Board
	[self loadChessBoard];
	
	// Load Score Areas
	[self loadScoreAreas];
	
	self.localGameIsTwoPlayer = YES;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadScoreAreas{
	
	CGFloat a=(self.view.bounds.size.height-self.view.bounds.size.width)*.5*.5*.5;
	
	
	self.whiteScoreView = [[ScoreView alloc] initWithFrame:CGRectMake(0, a, self.view.bounds.size.width, (self.view.bounds.size.height-self.view.bounds.size.width)*.5*.5)];
	
	self.whiteScoreView.backgroundColor=[UIColor greenColor];
	
	[self.view addSubview:self.whiteScoreView];
	//self.blackScoreView = [[ScoreView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
}

#pragma mark -
#pragma mark Chess Board Controller

- (void)loadChessBoard{
	
	// Create board
	self.chessBoard = [[ChessBoard alloc] init];
	self.chessBoard.boardDelegate = self;
	
	// Create view
	self.chessBoardView = [[ChessBoardView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height- self.view.bounds.size.width)*.5, self.view.bounds.size.width, self.view.bounds.size.width) andBoard:self.chessBoard];
	
	self.chessBoardView.delegate = self;
	
	for (BoardSquareView *square in self.chessBoardView.squares) {
		square.delegate = self;
	}
	
	[self.view addSubview:self.chessBoardView];
	
	self.boardImage.image = [UIImage imageNamed:@"Board.png"];
	
	_firsttapIsset = NO;
	
	_playerTurn = PlayerTurnWhite;
	
	//if(_playerTurn == PlayerTurnBlack)[self rotateBoard];
}

- (void)updateBoardView{
	NSUInteger index=0;
	for (BoardSquareView *square in self.chessBoardView.squares) {
		[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){index%8, index/8}]];
		index++;
	}
}


- (void)boardSquareCellTapped:(BoardSquareView *)sender atCoordinates:(BoardCoordinates)coordinates{
	
	if(_pieceIsAnimated)return;
	
	NSLog(@"Player Turn: %d",_playerTurn);
	
	BoardCoordinates realCoordinates = coordinates;
	BoardCoordinates realFirstTapCoordinates = _firstTap;
	
	// If board is facing black, flip pieces
	if(_playerTurn == PlayerTurnBlack){
		realCoordinates.column = 7-coordinates.column;
		realCoordinates.row = 7-coordinates.row;
		realFirstTapCoordinates.column = 7-_firstTap.column;
		realFirstTapCoordinates.row = 7-_firstTap.row;
	}
	
	// Only allow current player to move
	BoardCellState piece = [self.chessBoard cellStateAtCoordinates:realCoordinates];
	if(((piece>0&&piece<=6&&_playerTurn==PlayerTurnWhite)||(piece>=7&&_playerTurn==PlayerTurnBlack))&&!_firsttapIsset)return;
	
	
	if(_firsttapIsset){
		BoardSquareView *fromSquare;
		BoardSquareView *toSquare;
		
		fromSquare=[self.chessBoardView.squares objectAtIndex:_firstTap.row*8+_firstTap.column];
		toSquare=[self.chessBoardView.squares objectAtIndex:coordinates.row*8+coordinates.column];
		
		[fromSquare stopPulsing];
		
		if([self.chessBoard isValidMoveFromCoordinates:realFirstTapCoordinates toCoordinates:realCoordinates]){
			NSLog(@"valid");
			//int index=_firstTap.row*8+_firstTap.column;
			
			_pieceIsAnimated=YES;
			_secondTap=coordinates;
			
			[self.chessBoardView makeAnImageFlyFrom:fromSquare.pieceView to:toSquare.pieceView duration:.5];
			
			
			// Castling
			
			piece = [self.chessBoard cellStateAtCoordinates:realFirstTapCoordinates];
			
			if(piece==BoardCellStateBlackKing||piece==BoardCellStateWhiteKing){
				if(abs(realCoordinates.column-realFirstTapCoordinates.column)==2){
					
					int from=0;
					int to=0;
					
					if(piece==BoardCellStateBlackKing&&realFirstTapCoordinates.column>realCoordinates.column){
						from=63;
						to=60;
					}else if(piece==BoardCellStateBlackKing&&realFirstTapCoordinates.column<realCoordinates.column){
						from=56;
						to=58;
					}else if(piece==BoardCellStateWhiteKing&&realFirstTapCoordinates.column>realCoordinates.column){
						from=56;
						to=59;
					}else if(piece==BoardCellStateWhiteKing&&realFirstTapCoordinates.column<realCoordinates.column){
						from=63;
						to=61;
					}
					fromSquare=[self.chessBoardView.squares objectAtIndex:from];
					toSquare=[self.chessBoardView.squares objectAtIndex:to];
						
					_shouldNotMove=YES;
					_doNotMove=realCoordinates;
					
					[self.chessBoardView makeAnImageFlyFrom:fromSquare.pieceView to:toSquare.pieceView duration:.5];
					
				}
			}
		}
	}else{
		//NSLog(@"1");
		BoardCellState state = [self.chessBoard cellStateAtCoordinates:realCoordinates];
		if(state==BoardCellStateEmpty)return;
		_firstTap=coordinates;
		[[self.chessBoardView.squares objectAtIndex:_firstTap.row*8+_firstTap.column] startPulsing];
	}
	_firsttapIsset=!_firsttapIsset;
}

- (void)chessPieceAnimationFinished:(ChessBoardView *)sender{
	
	BoardCoordinates realFirstCoordinates = _firstTap;
	BoardCoordinates realSecondCoordinates = _secondTap;
	
	if(_playerTurn == PlayerTurnBlack){
		realFirstCoordinates.column = 7-_firstTap.column;
		realFirstCoordinates.row = 7-_firstTap.row;
		realSecondCoordinates.column = 7-_secondTap.column;
		realSecondCoordinates.row = 7-_secondTap.row;
	}
	
	if(_shouldNotMove&&_doNotMove.column==realSecondCoordinates.column&&_doNotMove.row==realSecondCoordinates.row){
		_shouldNotMove=NO;
		return;
	}
	
	[self.chessBoard makeMoveFromCoordinates:realFirstCoordinates toCoordinates:realSecondCoordinates];
	
	BoardCellState state=[self.chessBoard cellStateAtCoordinates:realSecondCoordinates];
	if((state==BoardCellStateBlackPawn||state==BoardCellStateWhitePawn)&&(_secondTap.row==0||_secondTap.row==7)){

		_newPieceRealLocation=realSecondCoordinates;

		[self popup];
	}else if(self.localGameIsTwoPlayer){
		_playerTurn = !_playerTurn;
		[self rotateBoard];
	}
	_pieceIsAnimated=NO;
}


- (void)cellStateChanged:(BoardCellState)state forCoordinates:(BoardCoordinates)coordinates{
	if(coordinates.column==-1&&coordinates.row==-1){
		NSInteger index=0;
		for (BoardSquareView *square in self.chessBoardView.squares) {
			[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){index%8, index/8}]];
			index++;
		}
	}else{
		if(_playerTurn == PlayerTurnBlack){
			[[self.chessBoardView.squares objectAtIndex:(7-coordinates.row)*8+(7-coordinates.column)] updateWithCellState:state];
		}else{
			[[self.chessBoardView.squares objectAtIndex:coordinates.row*8+coordinates.column] updateWithCellState:state];
		}
	}
	
}

- (void)popup{
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select New Piece:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Queen", @"Rook", @"Bishop", @"Knight", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex<0){
		[self popup];
	}else{
		BoardCellState state;
		if(_newPieceRealLocation.row==0){ // White
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

		[self.chessBoard setCellState:state forCoordinates:_newPieceRealLocation];
		if(self.localGameIsTwoPlayer){
			_playerTurn = !_playerTurn;
			[self rotateBoard];
		}
	}
	//NSLog(@"Button #%d clicked",buttonIndex);
}


- (void)rotateBoard{
	NSUInteger index=0;
	if(_playerTurn == PlayerTurnWhite){
		for (BoardSquareView *square in self.chessBoardView.squares) {
			[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){index%8, index/8}]];
			index++;
		}
	}else{
		for (BoardSquareView *square in self.chessBoardView.squares) {
			[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){7-(index%8), 7-(index/8)}]];
			index++;
		}
	}
}


- (void)pieceWasTaken:(BoardCellState)piece{
	if(piece<=6){ // Black Piece
		[self.whitesCapturedPieces addObject:[NSNumber numberWithInt:piece]];
	}else if (piece>=7){ // White Piece
		[self.blacksCapturedPieces addObject:[NSNumber numberWithInt:piece]];
	}
}

- (IBAction)reset:(id)sender{
	_firsttapIsset = NO;
	if(_playerTurn == PlayerTurnBlack)[self rotateBoard];
	_playerTurn = PlayerTurnWhite;
	[self.chessBoard setToInitialState];
}

#pragma mark -
#pragma mark Scoring

- (NSMutableArray *)whitesCapturedPieces{
	if(!_whitesCapturedPieces){
		_whitesCapturedPieces = [[NSMutableArray alloc] init];
	}
	return _whitesCapturedPieces;
}

- (NSMutableArray *)blacksCapturedPieces{
	if(!_blacksCapturedPieces){
		_blacksCapturedPieces = [[NSMutableArray alloc] init];
	}
	return _blacksCapturedPieces;
}

- (void)setWhitesCapturedPieces:(NSMutableArray *)whitesCapturedPieces{
	_whitesCapturedPieces = whitesCapturedPieces;
	
	
}

- (void)setBlacksCapturedPieces:(NSMutableArray *)blacksCapturedPieces{
	_blacksCapturedPieces = blacksCapturedPieces;
	
	
}

@end
