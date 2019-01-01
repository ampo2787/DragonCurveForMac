//
//  DragonCurve.m
//  DragonCurveForMac
//
//  Created by JihoonPark on 22/10/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "DragonCurve.h"
#import "Direction.h"

#pragma mark - Declaration of Private Properties & methods
@interface DragonCurve()

@property (nonatomic) NSMutableArray * dragonPath;
@property (assign) Direction virtualDirection;

- (void) dragonReculsively:(int) order;
- (void) nogardReculsively:(int) order;

@end

#pragma mark - Implemetation of Methods
@implementation DragonCurve

#pragma mark - Private Methods
-(void) dragonReculsively:(int)order {
    if(order > 0){
        [self dragonReculsively:(order - 1)];
        self.virtualDirection = (self.virtualDirection+1) % 4;
        [self.dragonPath addObject:[NSNumber numberWithInt:self.virtualDirection]];
        [self nogardReculsively:(order - 1)];
    }
}

-(void) nogardReculsively:(int)order{
    if(order > 0){
        [self dragonReculsively:(order - 1)];
        self.virtualDirection = (self.virtualDirection+3) % Number_Of_Directions;
        [self.dragonPath addObject:[NSNumber numberWithInt:self.virtualDirection]];
        [self nogardReculsively:(order - 1)];
    }
}

#pragma mark - Public methods
-(NSArray *) dragonPath:(int)order{
    if(order < 0){
        return nil;
    }
    self.dragonPath = [[NSMutableArray alloc]init];
    self.virtualDirection = Direction_North;
    [self.dragonPath addObject:[NSNumber numberWithInt:self.virtualDirection]];
    [self dragonReculsively:order];
    return self.dragonPath;
}

@end
