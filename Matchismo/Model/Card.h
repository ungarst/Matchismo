//
//  Card.h
//  Matchismo
//
//  Created by Dave Carpenter on 3/22/14.
//  Copyright (c) 2014 Dave Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int) match:(NSArray *)otherCards;

@end
