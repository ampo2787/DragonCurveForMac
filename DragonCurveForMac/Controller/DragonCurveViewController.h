//
//  DragonCurveViewController.h
//  DragonCurveForMac
//
//  Created by JihoonPark on 22/10/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragonView.h"

@interface DragonCurveViewController : NSViewController <DragonViewDelegate>

@property (weak) IBOutlet DragonView *dragonView;
@property (weak) IBOutlet NSView *stepControlView;

@property (weak) IBOutlet NSTextField *dragonOrderField;
- (IBAction)dragonOrderFieldEnter:(NSTextField *)sender;

@property (weak) IBOutlet NSButton *singleDrawingButton;
- (IBAction)singleDrawingButtonTouched:(NSButton *)sender;

@property (weak) IBOutlet NSButton *mutipleDrawingButton;
- (IBAction)mutipleDrawingButtonTouched:(NSButton *)sender;

@property (weak) IBOutlet NSButton *stepButton;
- (IBAction)stepButtonTouched:(NSButton *)sender;

@property (weak) IBOutlet NSButton *stopButton;
- (IBAction)stopButtonTouched:(NSButton *)sender;

@property (weak) IBOutlet NSSlider *stepSizeSlider;

@end
