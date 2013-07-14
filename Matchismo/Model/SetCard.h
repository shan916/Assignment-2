//
//  SetCard.h
//  Matchismo
//
//  Created by Zeeshan Khaliq on 6/5/13.
//  Copyright (c) 2013 Zeeshan Khaliq. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger number;

+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSArray *)validShadings;
+ (NSArray *)validNumbers;

@end
