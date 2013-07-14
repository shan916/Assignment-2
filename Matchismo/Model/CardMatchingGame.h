//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Zeeshan Khaliq on 5/30/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

enum Result {FLIP, MATCH, MISMATCH};

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
usingDeck:(Deck *)deck numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (strong, nonatomic, readonly) NSMutableArray *lastCards;
@property (nonatomic, readonly) enum Result lastResult;
@property (nonatomic, readonly) NSInteger lastScore;
@property (nonatomic) NSUInteger numberOfCardsToMatch;

@end
