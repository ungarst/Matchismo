//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Dave Carpenter on 4/2/14.
//  Copyright (c) 2014 Dave Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype) initWithCardCount:(NSInteger) count
                        usingDeck:(Deck *) deck;

- (void) chooseCardAtIndex:(NSInteger) index;

- (Card *) cardAtIndex:(NSInteger) index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSMutableArray *lastScoreArray;
@property (nonatomic, strong, readonly) NSMutableArray *lastCardsArray; // of Cards

@property (nonatomic) NSInteger numCardsToMatch;

@end
