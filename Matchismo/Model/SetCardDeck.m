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
        for (NSString *shape in [SetCard validShapes])
        {
            for (NSString *color in [SetCard validColors])
            {
                for (NSString *shading in [SetCard validShadings])
                {
                    for (NSNumber *number in [SetCard validNumbers])
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.color = color;
                        card.shading = shading;
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
