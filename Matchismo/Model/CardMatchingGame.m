//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Zeeshan Khaliq on 5/30/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic, readwrite) NSMutableArray *lastCards;
@property (nonatomic, readwrite) enum Result lastResult;
@property (nonatomic, readwrite) NSInteger lastScore;
@end

@implementation CardMatchingGame

- (NSMutableArray *)lastCards
{
    if (!_lastCards) _lastCards = [[NSMutableArray alloc] init];
    return _lastCards;
}

- (NSMutableArray *)cards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            
            if (!card)
            {
                self = nil;
            }
            else
            {
                self.cards[i] = card;
            }
        }
        self.numberOfCardsToMatch = numberOfCardsToMatch;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (self.numberOfCardsToMatch == 2)
    {
        const unsigned MATCH_BONUS = 4;
        if (!card.isUnplayable)
        {
            if (!card.isFaceUp)
            {
                [self.lastCards removeAllObjects];
                [self.lastCards addObject:card];
                self.lastResult = FLIP;
                self.lastScore = FLIP_COST;
                
                // see if flipping this card up creates a match
                for (Card *otherCard in self.cards)
                {
                    // see if there is another playable card that is face up
                    if (otherCard.isFaceUp && !otherCard.isUnplayable)
                    {
                        int matchScore = [card match:@[otherCard]];
                        // if it's a match, both cards become unplayable and score increases
                        if (matchScore)
                        {
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            
                            [self.lastCards removeAllObjects];
                            [self.lastCards addObjectsFromArray:@[card, otherCard]];
                            self.lastResult = MATCH;
                            self.lastScore = matchScore * MATCH_BONUS;
                        }
                        else
                        {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            
                            [self.lastCards removeAllObjects];
                            [self.lastCards addObjectsFromArray:@[card, otherCard]];
                            self.lastResult = MISMATCH;
                            self.lastScore = MISMATCH_PENALTY;
                        }
                        break;
                    }
                }
                self.score -= FLIP_COST;
            }
            card.faceUp = !card.isFaceUp;
        }
    }
    else if (self.numberOfCardsToMatch == 3)
    {
        const unsigned MATCH_BONUS = 16;
        if (!card.isUnplayable)
        {
            if (!card.isFaceUp)
            {
                [self.lastCards removeAllObjects];
                [self.lastCards addObject:card];
                self.lastResult = FLIP;
                self.lastScore = FLIP_COST;
                
                for (Card *secondCard in self.cards)
                {
                    if (secondCard.isFaceUp && !secondCard.isUnplayable)
                    {
                        unsigned secondCardIndex = [self.cards indexOfObject:secondCard];
                        
                        for (Card *thirdCard in self.cards)
                        {
                            if (secondCardIndex != [self.cards indexOfObject:thirdCard])
                            {
                                if (thirdCard.isFaceUp && !thirdCard.isUnplayable)
                                {
                                    int matchScore = [card match:@[secondCard, thirdCard]];
                                    
                                    if (matchScore)
                                    {
                                        secondCard.unplayable = YES;
                                        thirdCard.unplayable = YES;
                                        card.unplayable = YES;
                                        self.score += matchScore * MATCH_BONUS;
                                        
                                        [self.lastCards removeAllObjects];
                                        [self.lastCards addObjectsFromArray:@[card, secondCard, thirdCard]];
                                        self.lastResult = MATCH;
                                        self.lastScore = matchScore * MATCH_BONUS;
                                    }
                                    else
                                    {
                                        secondCard.faceUp = NO;
                                        thirdCard.faceUp = NO;
                                        self.score -= MISMATCH_PENALTY;
                                        
                                        [self.lastCards removeAllObjects];
                                        [self.lastCards addObjectsFromArray:@[card, secondCard, thirdCard]];
                                        self.lastResult = MISMATCH;
                                        self.lastScore = MISMATCH_PENALTY;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                self.score -= FLIP_COST;
            }
            card.faceUp = !card.isFaceUp;
        }
    }
}

@end
