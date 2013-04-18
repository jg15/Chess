//
//  ChessBoardView.h
//  Chess
//
//  Created by Joshua Girard on 4/10/13.
//  Copyright (c) 2013 Joshua Girard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessBoard.h"
#import "ChessBoardViewDelegate.h"

@interface ChessBoardView : UIView

@property (nonatomic, weak) id<ChessBoardViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *squares; // test as readonly

- (id)initWithFrame:(CGRect)frame andBoard:(ChessBoard *)board;
- (void)makeAnImageFlyFrom:(UIImageView *)imageViewA to:(UIImageView *)imageViewB duration:(NSTimeInterval)duration;
@end
