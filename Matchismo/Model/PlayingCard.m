//
//  PlayingCard.m
//  Matchismo
//
//  Created by Dave Carpenter on 3/22/14.
//  Copyright (c) 2014 Dave Carpenter. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *) contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    NSInteger numOtherCards = [otherCards count];
    
    if (numOtherCards) {
        for (PlayingCard *otherCard in otherCards) {
            if (otherCard.rank == self.rank) {
                score += 4;
            } else if ([otherCard.suit isEqualToString:self.suit]) {
                score += 1;
            }
        }
    }
    
    if ([otherCards count] > 1) {
        score += [[otherCards firstObject] match:[otherCards subarrayWithRange:NSMakeRange(1, numOtherCards-1)]];
    }
    
    return score;
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *) rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSArray *) validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

@end
