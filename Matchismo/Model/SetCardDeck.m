//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Zeeshan Khaliq on 6/5/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self)
    {
        for (NSNumber *shape in [SetCard validShapes])
        {
            for (NSNumber *color in [SetCard validColors])
            {
                for (NSNumber *shading in [SetCard validShadings])
                {
                    for (NSNumber *number in [SetCard validNumbers])
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = [shape unsignedIntegerValue];
                        card.color = [color unsignedIntegerValue];
                        card.shading = [shading unsignedIntegerValue];
                        card.number = [number unsignedIntegerValue];
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
