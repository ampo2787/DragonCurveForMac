//
//  DragonView.h
//  DragonCurveForMac
//
//  Created by JihoonPark on 22/10/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DragonView;

#pragma mark - Declaration of <DragonViewDelegate> Protocol
@protocol DragonViewDelegate

-(int) dragonOrder: (DragonView *) requestor;
-(NSArray *) dragonPath: (DragonView*) requester;
-(BOOL) singleDrawing:(DragonView*) requester;
-(BOOL) stepByStepDrawingEnabled:(DragonView *) requestor;
-(int) stepPathLength:(DragonView *)requestor;

@end

#pragma mark - Declaration of Public methods
@interface DragonView : NSView

@property (nonatomic) id<DragonViewDelegate> delegate;
@end

