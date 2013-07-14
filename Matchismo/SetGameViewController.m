//
//  SetGameViewController.m
//  ;
//
//  Created by Zeeshan Khaliq on 6/5/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"

#define GAME_MODE 3

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@end

@implementation SetGameViewController

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[SetCardDeck alloc] init] numberOfCardsToMatch:GAME_MODE];
    }
    
    return _game;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        NSAttributedString *contents = [self attributedContentsForCard:(SetCard *) card];
        [cardButton setAttributedTitle:contents forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0 : 1.0;
        
        if (card.isFaceUp || card.isUnplayable)
        {
            [cardButton setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.3]];
        }
        else
        {
            [cardButton setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if ([self.game.lastCards count])
    {
        if (self.game.lastResult == FLIP)
        {
            NSMutableAttributedString *attributedHistory = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Flipped up  : -%d", self.game.lastScore]];
            [attributedHistory insertAttributedString:[self attributedContentsForCard:(SetCard *)[self.game.lastCards lastObject]] atIndex:11];
            self.historyLabel.attributedText = attributedHistory;
        }
        else if (self.game.lastResult == MATCH)
        {
            NSMutableAttributedString *attributedHistory = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Matched      : +%d", self.game.lastScore]];
            [attributedHistory insertAttributedString:[self attributedContentsForCard:(SetCard *)self.game.lastCards[0]] atIndex:11];
            [attributedHistory insertAttributedString:[self attributedContentsForCard:(SetCard *)self.game.lastCards[1]] atIndex:10];
            [attributedHistory insertAttributedString:[self attributedContentsForCard:(SetCard *)self.game.lastCards[2]] atIndex:9];
            self.historyLabel.attributedText = attributedHistory;
        }
        else if (self.game.lastResult == MISMATCH)
        {
            NSMutableAttributedString *attributedHistory = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    don't match: -%d", self.game.lastScore]];
            [attributedHistory insertAttributedString:[self attributedContentsForCard:(SetCard *)self.game.lastCards[0]] atIndex:2];
            [attributedHistory insertAttributedString:[self attributedContentsForCard:(SetCard *)self.game.lastCards[1]] atIndex:1];
            [attributedHistory insertAttributedString:[self attributedContentsForCard:(SetCard *)self.game.lastCards[2]] atIndex:0];
            self.historyLabel.attributedText = attributedHistory;
        }
    }
    else
    {
        self.historyLabel.text = [NSString stringWithFormat:@""];
    }
}

- (NSAttributedString *)attributedContentsForCard:(SetCard *)card
{
    
    enum Color{RED=1, GREEN=2, PURPLE=3};
    enum Shape{SQUARE=1, TRIANGLE=2, CIRCLE=3};
    enum Shading{SOLID=1, SHADED=2, OPEN=3};
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    UIColor *color = [[UIColor alloc] init];
    UIColor *fillColor = [[UIColor alloc] init];
    NSMutableString *contents = [[NSMutableString alloc] initWithString:@""];
    
    if (card.shape == SQUARE)
    {
        for (unsigned i = 0; i < card.number; i++)
        {
            [contents appendString:@"☐"];
        }
    }
    else if (card.shape == TRIANGLE)
    {
        for (unsigned i = 0; i < card.number; i++)
        {
            [contents appendString:@"△"];
        }
    }
    else if (card.shape == CIRCLE)
    {
        for (unsigned i = 0; i < card.number; i++)
        {
            [contents appendString:@"○"];
        }
    }
    
    if (card.color == RED)
    {
        color = [UIColor redColor];
    }
    else if (card.color == GREEN)
    {
        color = [UIColor greenColor];
    }
    else if (card.color == PURPLE)
    {
        color = [UIColor purpleColor];
    }
    
    if (card.shading == SOLID)
    {
        fillColor = color;
    }
    else if (card.shading == SHADED)
    {
        fillColor = [color colorWithAlphaComponent:0.3];
    }	
    else if (card.shading == OPEN)
    {
        fillColor = [UIColor clearColor];
    }
    
    [attributes setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
    [attributes setObject:color forKey:NSStrokeColorAttributeName];
    [attributes setObject:fillColor forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *attributedContents = [[NSAttributedString alloc] initWithString:contents attributes:attributes];
    
    return attributedContents;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self updateUI];
}

@end
