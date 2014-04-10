//
//  Deck.h
//  Matchismo
//
//  Created by Dave Carpenter on 3/22/14.
//  Copyright (c) 2014 Dave Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard:(Card *)card atTop:(BOOL)atTop;
- (void) addCard:(Card *)card;

- (Card *) drawRandomCard;

@end
