//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Zeeshan Khaliq on 5/29/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        _game.numberOfCardsToMatch = 2;
    }
    
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;

        [cardButton setImage:([cardButton isSelected]) ? [[UIImage alloc] init] : [UIImage imageNamed:@"cardback.png"]
                    forState:UIControlStateNormal];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if ([self.game.lastCards count])
    {
        if (self.game.lastResult == FLIP)
        {
            self.historyLabel.text = [NSString stringWithFormat:@"Flipped up %@: -%d",
                                      [[self.game.lastCards lastObject] contents], self.game.lastScore];
        }
        else if (self.game.lastResult == MATCH)
        {
            self.historyLabel.text = [NSString stringWithFormat:@"Matched %@ %@: +%d", [self.game.lastCards[0] contents],
                                      [self.game.lastCards[1] contents], self.game.lastScore];
        }
        else if (self.game.lastResult == MISMATCH)
        {
            self.historyLabel.text = [NSString stringWithFormat:@"%@ %@ don't match: -%d", [self.game.lastCards[0] contents],
                                      [self.game.lastCards[1] contents], self.game.lastScore];
        }
    }
    else
    {
        self.historyLabel.text = [NSString stringWithFormat:@""];
    }
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)deal
{
    self.flipCount = 0;
    self.game = nil;
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self updateUI];
}

@end
