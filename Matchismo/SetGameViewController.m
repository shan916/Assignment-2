//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Zeeshan Khaliq on 6/5/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"

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
                                                  usingDeck:[[SetCardDeck alloc] init]];
        _game.numberOfCardsToMatch = 3;
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
    
    /* if ([self.game.history count])
    {
        self.historyLabel.text = [NSString stringWithFormat:@"%@", [self.game.history lastObject]];
    }
    else
    {
        self.historyLabel.text = [NSString stringWithFormat:@""];
    }
    */
}

- (NSAttributedString *)attributedContentsForCard:(SetCard *)card
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    UIColor *color = [[UIColor alloc] init];
    UIColor *fillColor = [[UIColor alloc] init];
    
    if ([card.color isEqualToString:@"red"])
    {
        color = [UIColor redColor];
    }
    else if ([card.color isEqualToString:@"green"])
    {
        color = [UIColor greenColor];
    }
    else if ([card.color isEqualToString:@"purple"])
    {
        color = [UIColor purpleColor];
    }
    
    if ([card.shading isEqualToString:@"solid"])
    {
        fillColor = color;
    }
    else if ([card.shading isEqualToString:@"shaded"])
    {
        fillColor = [color colorWithAlphaComponent:0.3];
    }	
    else if ([card.shading isEqualToString:@"open"])
    {
        fillColor = [UIColor clearColor];
    }
    
    [attributes setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
    [attributes setObject:color forKey:NSStrokeColorAttributeName];
    [attributes setObject:fillColor forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *contents = [[NSAttributedString alloc] initWithString:card.contents attributes:attributes];
    
    return contents;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self updateUI];
}

@end
