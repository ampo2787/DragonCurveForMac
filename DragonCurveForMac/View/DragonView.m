
//
//  DragonView.m
//  DragonCurveForMac
//
//  Created by JihoonPark on 22/10/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "DragonView.h"
#import "Direction.h"

#pragma mark - Declaration of private properties & methods
@interface DragonView()

@property (assign)  CGFloat unitLength;
@property (assign)  CGPoint startingPoint;
@property (nonatomic) NSArray* dragonPath;
@property (assign) BOOL singleDrawing;
@property (assign) BOOL stepByStepDrawingEnabled;
@property (assign) int  stepPathLength;
@property (assign) int  order;

-(void) determineStartingPointAndUnitLength;
-(void) drawCurveWithStartingDirection: (Direction) startingActualDirection;

@end

#pragma mark - static variable for class method
static NSArray* _strokeColors;

#pragma mark - Implementation of "DragonView" methods
@implementation DragonView

#pragma mark - Class Method
+(CGColorRef) strokeColorForDirection:(Direction) direction{
    if(_strokeColors == nil){
        _strokeColors = @[NSColor.greenColor, NSColor.orangeColor,NSColor.cyanColor,NSColor.brownColor,];
    }
    return ((NSColor*)_strokeColors[direction]).CGColor;
}

#pragma mark - Overriding the method "isFlipped"
-(BOOL)isFlipped{
    return YES;
}

#pragma mark - Implemetation of private methods
-(void) determineStartingPointAndUnitLength{
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width /2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    CGFloat windowSize = fminf(self.bounds.size.width, self.bounds.size.height);
    CGFloat windowHalfSize = windowSize/2;
    CGFloat windowQuarterSize = windowSize/4;
    CGFloat sqrt2 = sqrt(2.0);
    CGFloat sqrt2toOrder = powf(sqrt2, (CGFloat)self.order);
    
    if(!self.singleDrawing){
        self.startingPoint = midPoint;
        self.unitLength = windowHalfSize/sqrt2toOrder/sqrt2;
    }else{
        self.unitLength = windowHalfSize/sqrt2toOrder;
        
        int directionFromCenterToStartingPoint = (self.order-1) % 8;
        CGPoint startingPoint;
        if(directionFromCenterToStartingPoint == 0){
            
            startingPoint.x = midPoint.x + windowQuarterSize/sqrt2;
            startingPoint.y = midPoint.y + (windowQuarterSize/sqrt2 - 0.06*windowSize);
            
        }else if(directionFromCenterToStartingPoint == 1){
            
            startingPoint.x = midPoint.x + 0.08*windowSize;
            startingPoint.y = midPoint.y + (windowQuarterSize - 0.04*windowSize);
            
        }else if(directionFromCenterToStartingPoint == 2){
            
            startingPoint.x = midPoint.x - (windowQuarterSize/sqrt2 - 0.06*windowSize);
            startingPoint.y = midPoint.y + windowQuarterSize/sqrt2;
            
        }
        else if(directionFromCenterToStartingPoint == 3){
            
            startingPoint.x = midPoint.x - (windowQuarterSize - 0.04*windowSize);
            startingPoint.y = midPoint.y + 0.08 * windowSize;
            
        }else if(directionFromCenterToStartingPoint == 4){
            
            startingPoint.x = midPoint.x - windowQuarterSize/sqrt2;
            startingPoint.y = midPoint.y - (windowQuarterSize/sqrt2 - 0.06*windowSize);
            
        }else if(directionFromCenterToStartingPoint == 5){
            
            startingPoint.x = midPoint.x - 0.08*windowSize;
            startingPoint.y = midPoint.y - (windowQuarterSize - 0.04*windowSize);
            
        }else if(directionFromCenterToStartingPoint == 6){
            
            startingPoint.x = midPoint.x + (windowQuarterSize/sqrt2 - 0.06*windowSize);
            startingPoint.y = midPoint.y - windowQuarterSize/sqrt2;
            
        }else{
            
            startingPoint.x = midPoint.x + (windowQuarterSize - 0.04*windowSize);
            startingPoint.y = midPoint.y - 0.08*windowSize;
            
        }
        self.startingPoint = startingPoint;
    }
}

-(void)drawCurveWithStartingDirection:(Direction)startingActualDirection{
    CGContextRef context = NSGraphicsContext.currentContext.graphicsPort;
    
    CGColorRef strokeColor = [DragonView strokeColorForDirection:startingActualDirection];
    CGContextSetStrokeColorWithColor(context, strokeColor);
    
    CGContextMoveToPoint(context, self.startingPoint.x, self.startingPoint.y);
    
    CGPoint currentPoint = self.startingPoint;
    int currentPathLength = (self.stepByStepDrawingEnabled)?
    self.stepPathLength: (int) [self.dragonPath count];
    for(int i=0; i< currentPathLength; i++){
        CGPoint nextPoint = currentPoint;
        Direction currentVirtualDirection = (Direction)((NSNumber*)[self.dragonPath objectAtIndex:i]).intValue;
        Direction actualDirection = (startingActualDirection + currentVirtualDirection) % Number_Of_Directions;
        if(actualDirection == Direction_North){
            nextPoint.y -= self.unitLength;
        }else if(actualDirection == Direction_South){
            nextPoint.y += self.unitLength;
        }else if(actualDirection == Direction_East){
            nextPoint.x += self.unitLength;
        }else{
            nextPoint.x -= self.unitLength;
        }
        CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
        currentPoint = nextPoint;
    }
    CGContextStrokePath(context);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self.layer setBackgroundColor:NSColor.whiteColor.CGColor];
    
    self.order = [self.delegate dragonOrder:self];
    self.dragonPath = [self.delegate dragonPath:self];
    self.singleDrawing = [self.delegate singleDrawing:self];
    self.stepByStepDrawingEnabled = [self.delegate stepByStepDrawingEnabled:self];
    self.stepPathLength = [self.delegate stepPathLength:self];
    
    [self determineStartingPointAndUnitLength];
    
    int numberOfDrawing = 1;
    if(!self.singleDrawing){
        numberOfDrawing = Number_Of_Directions;
    }
    Direction startingActualDirection = Direction_West;
    for(int directionCount = 0; directionCount < numberOfDrawing; directionCount++){
        [self drawCurveWithStartingDirection:startingActualDirection];
        startingActualDirection = (startingActualDirection+1) % Number_Of_Directions;
    }
}

@end
