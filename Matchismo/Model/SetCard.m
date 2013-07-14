//
//  SetCard.m
//  Matchismo
//
//  Created by Zeeshan Khaliq on 6/5/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 2)
    {
        NSArray *myThreeCards = @[self, otherCards[0], otherCards[1]];
        NSMutableSet *shapeSet = [[NSMutableSet alloc] init];
        NSMutableSet *colorSet = [[NSMutableSet alloc] init];
        NSMutableSet *shadingSet = [[NSMutableSet alloc] init];
        NSMutableSet *numberSet = [[NSMutableSet alloc] init];
        
        for (id card in myThreeCards)
        {
            if ([card isKindOfClass:[SetCard class]])
            {
                SetCard *myCard = (SetCard *)card;
                [shapeSet addObject:@(myCard.shape)];
                [colorSet addObject:@(myCard.color)];
                [shadingSet addObject:@(myCard.shading)];
                [numberSet addObject:@(myCard.number)];
            }
            
            if (shapeSet.count == 2 || shapeSet.count == 2 || colorSet.count == 2 || numberSet.count == 2)
            {
                score = 0;
            }
            else
            {
                score = 1;
            }
        }
    }
    
    return score;
}

+ (NSArray *)validShapes
{
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validColors
{
    return @[@(1), @(2), @(3)];
}

+ (NSArray *)validShadings
{
    return @[@(1), @(1), @(2)];
}

+ (NSArray *)validNumbers
{
    return @[@(1), @(2), @(3)];
}

@end
