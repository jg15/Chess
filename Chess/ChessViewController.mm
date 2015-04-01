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
#import "GCHelper.h"

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
	
	BOOL _gameIsOver;
    
    BOOL shouldRotateBoard;
    
    BOOL isPondering;
    Move *ponderMove;
    NSUInteger engineSearchTimeMS;
    
    BOOL alertCheck;
    
    char _promotion;
}

@synthesize whitesCapturedPieces = _whitesCapturedPieces;
@synthesize blacksCapturedPieces = _blacksCapturedPieces;

#pragma mark -
#pragma mark Init View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _promotion = '0';
    
    if(!self.singlePlayerMode){
        self.localGameIsTwoPlayer = YES;
        shouldRotateBoard = YES;
    }else{
        self.localGameIsTwoPlayer = NO;
        shouldRotateBoard = NO;
    }
    
    if(!self.localGameIsTwoPlayer){
        // Start the Chess Engine
        engineSearchTimeMS = 10;
        [self startEngine];
    }
    
	// Background Color
	//self.backgroundImage.backgroundColor=[UIColor redColor];
	
	// Load Chess Board
	[self loadChessBoard];
	
	// Load Score Areas
	//[self loadScoreAreas];
	
	_gameIsOver = NO;
	
    
    //NSString *mvlist = @"e2e4 b8c6 f1b5 g8f6 g1f3 f6e4 d1e2 d7d5 b1c3 e4c3 d2c3 d8d6 c3c4 a7a6 b5c6 b7c6 c1d2 a8b8 a1b1 d6g6 d2f4 b8b4 b2b3 d5c4 f4c7 b4b7 c7a5 c4b3 b1b3 b7b3 c2b3 g6g2 h1g1 g2h3 e2d2 h3e6 e1f1 e6d5 a5b6 d5b5 f1g2 b5b6 g1d1 f7f6 f3d4 e7e5 d4c6 b6c6 g2g1 c8h3 d2d8 e8f7 d1d7 h3d7 d8d7 c6d7 f2f4 f8c5";// g1h1";// d7d5";
    
    NSString *mvlist = @"e2e4 e7e5 g1f3 g8f6 f3e5 f6e4 f1d3 f8d6 d3e4 d6e5 d1e2 d8e7 b1c3 b8c6 e4c6 e5c3 e2e7 e8e7 d2c3 d7c6 f2f4 f7f5 h1f1 h8d8 c1e3 d8d1 a1d1 c8e6 d1d6 a8d8 d6e6 e7f7 e6c6 d8d3 c6c7 f7e6 c7b7 d3e3 e1d1 e3c3 b7a7 c3c2 a7a4 c2b2 a4a3 b2a2 a3b3 a2f2 b3a3 f2f1 d1d2 f1f4 a3b3 f4e4 b3a3 f5f4 a3b3 f4f3 b3a3 f3f2";
    
    //[self initGameWithMoveListString:mvlist andUCIMoveListString:mvlist];
    
	//GKTurnBasedMatch *k;
}

- (void)initGameWithMoveListString:(NSString *)mvlist andUCIMoveListString:(NSString *)UCImvlist{
    [self reset:nil];
    
    NSMutableArray *movearray = [[NSMutableArray alloc] init];
    
    for(NSString *m in [mvlist componentsSeparatedByString:@" "]){
        [movearray addObject:[Move moveFromString:m]];
    }
    
    NSMutableArray *UCImovearray = [[NSMutableArray alloc] init];
    
    for(NSString *m in [UCImvlist componentsSeparatedByString:@" "]){
        [UCImovearray addObject:[Move moveFromString:m]];
    }
    
    [self.chessBoard setToStateUsingMoves:movearray andUCIMoves:UCImovearray];
    [self updateBoardView];
}

- (void)startEngine {
    isPondering = NO;
    engineController = [[EngineController alloc] initWithGameController: self];
    [engineController sendCommand: @"uci"];
    [engineController sendCommand:@"setoption name OwnBook"];
    [engineController sendCommand: @"isready"];
    [engineController sendCommand: @"ucinewgame"];
    /*[engineController sendCommand:
     [NSString stringWithFormat:
      @"setoption name Play Style value %@",
      [[Options sharedOptions] playStyle]]];*/
    [engineController sendCommand:@"setoption name Play Style value Active"];
    //if ([[Options sharedOptions] permanentBrain])
    //    [engineController sendCommand: @"setoption name Ponder value true"];
    //else
        [engineController sendCommand: @"setoption name Ponder value false"];
    
    //if ([[Options sharedOptions] strength] == 2500) // Max strength
        [engineController
         sendCommand: @"setoption name UCI_LimitStrength value false"];
    //else
    //    [engineController
    //     sendCommand: @"setoption name UCI_LimitStrength value true"];
    /*[engineController sendCommand:
     [NSString stringWithFormat:
      @"setoption name UCI_Elo value %d",
      [[Options sharedOptions] strength]]];*/
    [engineController sendCommand:@"setoption name UCI_Elo value 2500"];
    [engineController commitCommands];
    
    //[self showBookMoves];
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
    
    alertCheck = NO;
	
	//if(_playerTurn == PlayerTurnBlack)[self rotateBoard];
}

- (void)nextTurn{
	//NSLog(@"%@ %@",self.whitesCapturedPieces,self.blacksCapturedPieces);
    NSLog(@"Game State: %@", [self.chessBoard gameString]);
    NSLog(@"UCI Game State: %@", [self.chessBoard uciGameString]);
	_playerTurn = (PlayerTurnState)!_playerTurn;
    
    
    
    
    if([self.chessBoard isBlackKingInCheck] || [self.chessBoard isWhiteKingInCheck]){
        
        NSString *alertMessage = @"Check!";
        
        if([self.chessBoard isGameOverWithPlayerTurn:_playerTurn]){
            _gameIsOver = YES;
            if(_playerTurn==PlayerTurnBlack){
                if([self.chessBoard isBlackKingInCheck]){
                    NSLog(@"White Wins");
                    alertMessage = @"Game Over, White Wins";
                }else{
                    NSLog(@"Stalemate");
                    alertMessage = @"Game Over, Stalemate";
                }
            }else{
                if([self.chessBoard isWhiteKingInCheck]){
                    NSLog(@"Black Wins");
                    alertMessage = @"Game Over, Black Wins";
                }else{
                    NSLog(@"Stalemate");
                    alertMessage = @"Game Over, Stalemate";
                }
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertMessage message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
        
    }
    
	
    if (!self.localGameIsTwoPlayer && _playerTurn == PlayerTurnBlack && !_gameIsOver){
        [self engineGo];
    }
}

- (void)updateBoardView{
    int index=0;
	if(_playerTurn == PlayerTurnBlack && shouldRotateBoard){
		for (BoardSquareView *square in self.chessBoardView.squares) {
			[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){7-(index%8), 7-(index/8)}]];
			index++;
		}
	}else{
        for (BoardSquareView *square in self.chessBoardView.squares) {
			[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){index%8, index/8}]];
			index++;
		}
	}
}


- (void)boardSquareCellTapped:(BoardSquareView *)sender atCoordinates:(BoardCoordinates)coordinates{

	if(_gameIsOver)return;
	
	if(_pieceIsAnimated)return;
	
	NSLog(@"Player Turn: %hd",_playerTurn);
	
	BoardCoordinates realCoordinates = coordinates;
	BoardCoordinates realFirstTapCoordinates = _firstTap;
	
	// If board is facing black, flip pieces
	if(_playerTurn == PlayerTurnBlack && shouldRotateBoard){
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
	_pieceIsAnimated=NO;
    
	BoardCoordinates realFirstCoordinates = _firstTap;
	BoardCoordinates realSecondCoordinates = _secondTap;
	
	if(_playerTurn == PlayerTurnBlack && shouldRotateBoard){
		realFirstCoordinates.column = 7-_firstTap.column;
		realFirstCoordinates.row = 7-_firstTap.row;
		realSecondCoordinates.column = 7-_secondTap.column;
		realSecondCoordinates.row = 7-_secondTap.row;
	}
	
	if(_shouldNotMove&&_doNotMove.column==realSecondCoordinates.column&&_doNotMove.row==realSecondCoordinates.row){
		_shouldNotMove=NO;
		return;
	}
	
    
    
	BoardCellState state=[self.chessBoard cellStateAtCoordinates:realFirstCoordinates];
	if((state==BoardCellStateBlackPawn||state==BoardCellStateWhitePawn)&&(_secondTap.row==0||_secondTap.row==7)){
        if(_promotion=='0'){ // user needs to select piece for promotion
            //_newPieceRealLocation=realSecondCoordinates;
            _newPieceRealLocation=realFirstCoordinates;
            
            //[self.chessBoardView.squares]
            
            //[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){7-(index%8), 7-(index/8)}]];
            
            //[self updateBoardView];
            [self popup];
        }else{
            NSLog(@"Moving from: %d %d %d %d   Promotion: %c",realFirstCoordinates.column, realFirstCoordinates.row, realSecondCoordinates.column, realSecondCoordinates.row,_promotion);
            [self.chessBoard makeMoveFromCoordinates:realFirstCoordinates toCoordinates:realSecondCoordinates promotion:_promotion];
            [self updateBoardView];
            _promotion='0';
            if(shouldRotateBoard) [self rotateBoard];
            [self nextTurn];
        }
		
	}else if(shouldRotateBoard){
        NSLog(@"Should Rotate Board");
        NSLog(@"Moving from: %d %d %d %d",realFirstCoordinates.column, realFirstCoordinates.row, realSecondCoordinates.column, realSecondCoordinates.row);
        [self.chessBoard makeMoveFromCoordinates:realFirstCoordinates toCoordinates:realSecondCoordinates];
        [self updateBoardView];
        [self nextTurn];
		[self rotateBoard];
	}else{
        NSLog(@"Moving from: %d %d %d %d",realFirstCoordinates.column, realFirstCoordinates.row, realSecondCoordinates.column, realSecondCoordinates.row);
        [self.chessBoard makeMoveFromCoordinates:realFirstCoordinates toCoordinates:realSecondCoordinates];
        [self updateBoardView];
		[self nextTurn];
	}
	[self.chessBoard DEBUG_PRINT_BOARD];
}

- (void)kingInCheck{
	alertCheck=YES;
}

- (void)alertCheck{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
	[alert show];
}

- (void)cellStateChanged:(BoardCellState)state forCoordinates:(BoardCoordinates)coordinates{
	if(coordinates.column==-1&&coordinates.row==-1){
		int index=0;
		for (BoardSquareView *square in self.chessBoardView.squares) {
			[[self.chessBoardView.squares objectAtIndex:index] updateWithCellState:[self.chessBoard cellStateAtCoordinates:(BoardCoordinates){index%8, index/8}]];
			index++;
		}
	}else{
		if(_playerTurn == PlayerTurnBlack && shouldRotateBoard){
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
		//BoardCellState state;
        char p;
		if(_newPieceRealLocation.row==0){ // White
			switch (buttonIndex) {
				case 0:
					//state=BoardCellStateWhiteQueen;
                    p='Q';
					break;
				case 1:
					//state=BoardCellStateWhiteRook;
                    p='R';
					break;
				case 2:
					//state=BoardCellStateWhiteBishop;
                    p='B';
					break;
				case 3:
					//state=BoardCellStateWhiteKnight;
                    p='N';
					break;
			}
		}else{ // Black
			switch (buttonIndex) {
				case 0:
					//state=BoardCellStateBlackQueen;
                    p='q';
					break;
				case 1:
					//state=BoardCellStateBlackRook;
                    p='r';
					break;
				case 2:
					//state=BoardCellStateBlackBishop;
                    p='b';
					break;
				case 3:
					//state=BoardCellStateBlackKnight;
                    p='n';
					break;
			}
		}

        
        BoardCoordinates realFirstCoordinates = _firstTap;
        BoardCoordinates realSecondCoordinates = _secondTap;
        
        if(_playerTurn == PlayerTurnBlack && shouldRotateBoard){
            realFirstCoordinates.column = 7-_firstTap.column;
            realFirstCoordinates.row = 7-_firstTap.row;
            realSecondCoordinates.column = 7-_secondTap.column;
            realSecondCoordinates.row = 7-_secondTap.row;
        }
        
        NSLog(@"Moving from: %d %d %d %d",realFirstCoordinates.column, realFirstCoordinates.row, realSecondCoordinates.column, realSecondCoordinates.row);
        [self.chessBoard makeMoveFromCoordinates:realFirstCoordinates toCoordinates:realSecondCoordinates promotion:p];
        [self updateBoardView];
        
		//[self.chessBoard setCellState:state forCoordinates:_newPieceRealLocation];
        [self nextTurn];
		if(shouldRotateBoard){
			[self rotateBoard];
		}/*else{
			[self nextTurn];
		}*/
	}
	//NSLog(@"Button #%d clicked",buttonIndex);
}


- (void)rotateBoard{
    int index=0;
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
	_gameIsOver = NO;
	_firsttapIsset = NO;
	if(_playerTurn == PlayerTurnBlack && shouldRotateBoard)[self rotateBoard];
	_playerTurn = PlayerTurnWhite;
	[self.chessBoard setToInitialState];
    _promotion='0';
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

#pragma mark -
#pragma mark Engine Stuff

-(void)passTurnToEngine{
    [engineController abortSearch];
    [engineController commitCommands];
}

- (void)engineGoPonder:(NSString *)pMove{
    [engineController sendCommand:
     [NSString stringWithFormat: @"%@ %@",
      [self.chessBoard uciGameString], pMove]];
    isPondering = YES;
    ponderMove = [Move moveFromString:[pMove substringFromIndex:MAX((int)[pMove length]-4, 0)]];
    [engineController sendCommand: [NSString stringWithFormat: @"go ponder infinite"]];
    [engineController commitCommands];
}

- (void)displayPV:(NSString *)pv {
    //NSLog(@"%@",pv);
}

- (void)displaySearchStats:(NSString *)searchStats {
    //NSLog(@"%@",searchStats);
}

- (BOOL)engineIsThinking {
    return [engineController engineIsThinking];
}

inline int letterToNum(char c){
	return (int)c-97;
}

/// engineGo is called directly after the user has made a move.  It checks
/// the game mode, and sends a UCI "go" command to the engine if necessary.

- (void)engineGo {
    if (!engineController)
        [self startEngine];
    
        if (isPondering) {
            if ([[[self.chessBoard getMoveList] lastObject] moveString] == [ponderMove moveString]) {
                [engineController ponderhit];
                isPondering = NO;
                return;
            }
            else {
                NSLog(@"REAL pondermiss");
                [engineController pondermiss];
                while ([engineController engineIsThinking]);
            }
            isPondering = NO;
        }
    
            // Computer's turn to move.  First look for a book move.  If no book move
            // is found, start a search.
    
            /*Move m;
            if ([[Options sharedOptions] strength] > 2200 ||
                [game currentMoveIndex] < 10 ||
                [game currentMoveIndex] < [[Options sharedOptions] strength] / 70)
                m = [game getBookMove];
            else
                m = MOVE_NONE;
            if (m != MOVE_NONE)
                [self doEngineMove: m];
            else {
                // Update play style, if necessary
                if ([[Options sharedOptions] playStyleWasChanged]) {
                    NSLog(@"play style was changed to: %@",
                          [[Options sharedOptions] playStyle]);
                    [engineController sendCommand:
                     [NSString stringWithFormat:
                      @"setoption name Play Style value %@",
                      [[Options sharedOptions] playStyle]]];
                    [engineController commitCommands];
                }
                // Update strength, if necessary
                if ([[Options sharedOptions] strengthWasChanged]) {
                    [engineController sendCommand: @"setoption name Clear Hash"];
                    if ([[Options sharedOptions] strength] == 2500) // Max strength
                        [engineController
                         sendCommand: @"setoption name UCI_LimitStrength value false"];
                    else
                        [engineController
                         sendCommand: @"setoption name UCI_LimitStrength value true"];
                    [engineController sendCommand:
                     [NSString stringWithFormat:
                      @"setoption name UCI_Elo value %d",
                      [[Options sharedOptions] strength]]];
                    [engineController commitCommands];
                }*/
                // Start thinking.
                    [engineController sendCommand: [self.chessBoard uciGameString]];
                    [engineController sendCommand: [NSString stringWithFormat: @"go movetime %d",(unsigned)engineSearchTimeMS]];

                    [engineController commitCommands];
    
    
}

/// engineMadeMove: is called by the engine controller whenever the engine
/// makes a move.  The input is an NSArray which is assumed to consist of two
/// NSStrings, representing a move and a ponder move.  The reason we stuff the
/// move strings into an array is that the method is called from another thread,
/// using the performSelectorOnMainThread:withObject:waitUntilDone: method,
/// and this method can only pass a single argument to the selector.

- (void)engineMadeMove:(NSArray *)array {
    assert([array count] <= 2);
    //Move m = [game moveFromString: [array objectAtIndex: 0]];
    
    const char *move = [[array objectAtIndex: 0] UTF8String];
    
    unsigned col_from = letterToNum(move[0]);
    unsigned row_from = 7-(unsigned)(move[1]-'0'-1);
    
    unsigned col_to = letterToNum(move[2]);
    unsigned row_to = 7-(unsigned)(move[3]-'0'-1);
    

    NSLog(@"AI: %s",move);
    if([[array objectAtIndex:0] length] == 4){
        NSLog(@"Interp: %d %d %d %d",col_from, row_from, col_to, row_to);
    }else if ([[array objectAtIndex:0] length] == 5){
        NSLog(@"Interp: %d %d %d %d  Promotion: %c",col_from, row_from, col_to, row_to, move[4]);
        _promotion=move[4];
    }else{
        NSLog(@"ERROR: UNKNOWN MOVE TYPE");
        assert(false); // Unknown move type
    }
    
    _firstTap = (BoardCoordinates){(int)col_from, (int)row_from};
    _secondTap = (BoardCoordinates){(int)col_to, (int)row_to};
    
    BoardSquareView *fromView = [self.chessBoardView.squares objectAtIndex: row_from*8+col_from];
    BoardSquareView *toView = [self.chessBoardView.squares objectAtIndex: row_to*8+col_to];
    
    [self.chessBoardView makeAnImageFlyFrom:fromView.pieceView to:toView.pieceView duration:.5];
    //assert(m != MOVE_NONE);
    //[game setHintForCurrentPosition: m];
    //if (engineIsPlaying) {
        //[self doEngineMove: m];
        //[self playClickSound];
        if ([array count] == 2 && ![[array objectAtIndex:1] isEqualToString:@"(none)"]) {
            //NSLog(@"The Ponder Move: %@",[array objectAtIndex:1]);
            //Move *pMove = [Move moveFromString:[array objectAtIndex:1]];
            //[game setHintForCurrentPosition: ponderMove];
            //if ([[Options sharedOptions] permanentBrain])
                //[self engineGoPonder: ponderMove];
            [self engineGoPonder: [NSString stringWithFormat:@"%@ %@",[array objectAtIndex:0],[array objectAtIndex:1]]];
        }
        //[self gameEndTest];
    //}
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if(engineController)
        [engineController quit];
}



@end
