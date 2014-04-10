//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dave Carpenter on 3/22/14.
//  Copyright (c) 2014 Dave Carpenter. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (weak, nonatomic) IBOutlet UISwitch *twoCardSwitch;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation CardGameViewController

- (CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *) createDeck
{
   return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    self.twoCardSwitch.enabled = NO;
    
    [self updateUI];
}

- (void) updateUI
{
    for (UIButton* cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score ];
    
    self.historySlider.value = 1.0;
    self.flipDescription.alpha = 1.0;
    if (self.game && [self.game.lastCardsArray count] > 0)
    {
        self.flipDescription.text = [self flipDescriptionForTime:1.0];
    } else {
        self.flipDescription.text = @"";
    }
}

- (NSString *) titleForCard:(Card *) card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void) setNumCardsToMatch:(BOOL) isTwoCard
{
    self.game.numCardsToMatch = isTwoCard ? 2 : 3;
}

- (IBAction)twoCardSwitchChange:(UISwitch *)sender {
    [self setNumCardsToMatch:sender.on];
}

- (IBAction)touchResetButton:(id)sender {
    self.game = nil;
    self.twoCardSwitch.enabled = YES;
    [self setNumCardsToMatch:self.twoCardSwitch.on];
    [self updateUI];
}

- (NSString *) flipDescriptionForTime:(float) time
{
    if (time ==1)
        time = 0.9999;
    
    int historyIndex = (int)[self.game.lastCardsArray count] * time;
    
    NSString *description = @"";
    NSNumber *lastScore = self.game.lastScoreArray[historyIndex];
    NSArray *lastCards = self.game.lastCardsArray[historyIndex];
    
    if ([lastCards count]) {
        NSMutableArray *cardContents = [[NSMutableArray alloc] init];
        for (Card *card in lastCards) {
            [cardContents addObject:card.contents];
        }
        description = [cardContents componentsJoinedByString:@" "];
    }
    
    if (lastScore.integerValue > 0) {
        description = [NSString stringWithFormat:@"Matched %@ for %ld points!", description, (long)lastScore.integerValue];
    } else if (lastScore.integerValue < 0) {
        description = [NSString stringWithFormat:@"%@ don't match! %ld point penalty!", description, (long)lastScore.integerValue];
    }
    return description;
}

- (IBAction)historySliderChanged:(id)sender {
    self.flipDescription.alpha = 0.5;
    self.flipDescription.text = [self flipDescriptionForTime:self.historySlider.value];
}

@end
