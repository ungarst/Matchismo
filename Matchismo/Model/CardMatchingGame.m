//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Dave Carpenter on 4/2/14.
//  Copyright (c) 2014 Dave Carpenter. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Cards

@property (nonatomic, readwrite) NSMutableArray *lastScoreArray;
@property (nonatomic, readwrite, strong) NSMutableArray *lastCardsArray;

@end

@implementation CardMatchingGame

- (NSMutableArray *) cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *) lastScoreArray
{
    if (!_lastScoreArray) {
        _lastScoreArray = [[NSMutableArray alloc] init];
    }
    return _lastScoreArray;
}

- (NSMutableArray *) lastCardsArray
{
    if (!_lastCardsArray) {
        _lastCardsArray = [[NSMutableArray alloc] init];
    }
    return _lastCardsArray;
}

- (NSInteger) numCardsToMatch
{
    if (_numCardsToMatch < 2) {
        _numCardsToMatch = 2;
    }
    return _numCardsToMatch;
}

- (instancetype) initWithCardCount:(NSInteger) count
                         usingDeck:(Deck *) deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            
        }
    }
    
    return self;
}

- (Card *) cardAtIndex:(NSInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define COST_TO_CHOOSE 1

- (void) chooseCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    int lastScore = 0;
    NSArray *lastCards = [[NSArray alloc] init];
    if (!card.isMatched) {
        if (card.isChosen)
        {
            card.chosen = NO;
        } else {
            // match against other chosen cards
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
            }
            lastCards = [otherCards arrayByAddingObject:card];
            if ([otherCards count] + 1 == self.numCardsToMatch) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    lastScore = matchScore * MATCH_BONUS;
                    for (Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;
                } else {
                    lastScore -= MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                }
            }
            self.score += lastScore;
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    [self.lastScoreArray addObject:[NSNumber numberWithInt:lastScore]];
    [self.lastCardsArray addObject:lastCards];
}

@end
