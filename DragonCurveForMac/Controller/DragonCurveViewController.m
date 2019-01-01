//
//  DragonCurveViewController.m
//  DragonCurveForMac
//
//  Created by JihoonPark on 22/10/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "DragonCurveViewController.h"
#import "DragonCurve.h"

#pragma mark - Constants

#define DEFAULT_DRAGON_ORDER    2
#define MIN_DRAGON_ORDER        1

#pragma mark - Declaration of private Properties & Methods
@interface DragonCurveViewController ()

#pragma mark - Private Properties
@property (assign) int order;
@property (assign) BOOL singleDrwaing;
@property (assign) BOOL stepByStepDrawingEnabled;
@property (assign) int stepPathLength;

@property (nonatomic) DragonCurve* dragonCurve;
@property (nonatomic) NSArray * dragonPath;

#pragma mark - Private Methods
-(void) updateUI;
-(void) setTitleForStepButton;
-(void) setTitleForStopButton;
-(void) initStepControlAndView;
-(int) stepOrder;

@end

#pragma mark - Implementation
@implementation DragonCurveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dragonView.delegate = self;
    self.singleDrwaing = TRUE;
    self.singleDrawingButton.state = NSControlStateValueOn;
    self.mutipleDrawingButton.state = NSControlStateValueOff;
    
    [self initStepControlAndView];
    
    self.order = DEFAULT_DRAGON_ORDER;
    self.dragonPath = [self.dragonCurve dragonPath:self.order];
    [self updateUI];
}

- (void)setRepresentedObject:(id)representedObject{
    [super setRepresentedObject:representedObject];
}

#pragma mark - Private Methods
-(DragonCurve *) dragonCurve{
    if(_dragonCurve == nil){
        _dragonCurve = [[DragonCurve alloc]init];
    }
    return _dragonCurve;
}

-(void) updateUI {
    [self.dragonView setNeedsDisplay:TRUE];
}

-(void)setTitleForStepButton{
    NSColor *titleColor = [NSColor brownColor];
    NSMutableAttributedString* titleForStepButton = [[NSMutableAttributedString alloc]initWithAttributedString:[self.stepButton attributedTitle]];
    NSRange titleRange = NSMakeRange(0, titleForStepButton.length);
    [titleForStepButton addAttribute:NSForegroundColorAttributeName value:titleColor range:titleRange];
    [self.stepButton setAttributedTitle:titleForStepButton];
}

-(void)setTitleForStopButton{
    NSColor *titleColor = [NSColor brownColor];
    NSMutableAttributedString* titleForStopButton = [[NSMutableAttributedString alloc]initWithAttributedString:[self.stopButton attributedTitle]];
    NSRange titleRange = NSMakeRange(0, titleForStopButton.length);
    [titleForStopButton addAttribute:NSForegroundColorAttributeName value:titleColor range:titleRange];
    [titleForStopButton addAttribute:NSFontSizeAttribute value:[NSNumber numberWithFloat:30.0] range:titleRange];
    [self.stopButton setAttributedTitle:titleForStopButton];
}

- (void)initStepControlAndView{
    self.stepByStepDrawingEnabled = FALSE;
    [self.stepControlView.layer setBackgroundColor:NSColor.lightGrayColor.CGColor];
    [self.stepControlView setHidden:FALSE];
    
    [self setTitleForStepButton];
    [self setTitleForStopButton];
    [self.stepSizeSlider setIntValue:100];
}

-(int)stepOrder{
    return (int)((double)(self.order-1) * (self.stepSizeSlider.doubleValue - self.stepSizeSlider.minValue) / (self.stepSizeSlider.maxValue - self.stepSizeSlider.minValue));
}


#pragma mark - Action

- (IBAction)dragonOrderFieldEnter:(NSTextField *)sender {
    if(sender.intValue >= MIN_DRAGON_ORDER){
        self.order = sender.intValue;
    }
    else{
        self.order = DEFAULT_DRAGON_ORDER;
    }
    if(self.singleDrwaing){
        self.stepByStepDrawingEnabled = FALSE;
    }
    self.dragonPath = [self.dragonCurve dragonPath:self.order];
    [self updateUI];
}

- (IBAction)stepButtonTouched:(NSButton *)sender {
    if(!self.stepByStepDrawingEnabled){
        self.stepByStepDrawingEnabled = TRUE;
        self.stepPathLength = (int) pow(2.0, self.stepOrder);
    }else{
        if(self.stepPathLength < (int)self.dragonPath.count){
            self.stepPathLength += (int) pow(2.0, self.stepOrder);
            if(self.stepPathLength > (int)self.dragonPath.count){
                self.stepPathLength = (int)self.dragonPath.count;
            }
        }
        else{
            self.stepPathLength = 0;
        }
    }
    [self updateUI];
}

- (IBAction)stopButtonTouched:(NSButton *)sender {
    self.stepByStepDrawingEnabled = FALSE;
    [self updateUI];
}

- (IBAction)singleDrawingButtonTouched:(NSButton *)sender {
    if(!self.singleDrwaing){
        self.singleDrwaing = TRUE;
        self.mutipleDrawingButton.state = NSControlStateValueOff;
        self.stepByStepDrawingEnabled = FALSE;
        [self.stepControlView setHidden:FALSE];
        
        [self updateUI];
    }
}
- (IBAction)mutipleDrawingButtonTouched:(NSButton *)sender {
    if(self.singleDrwaing){
        self.singleDrwaing = FALSE;
        self.singleDrawingButton.state = NSControlStateValueOff;
        self.stepByStepDrawingEnabled = FALSE;
        [self.stepControlView setHidden:TRUE];
        
        [self updateUI];
    }
}





#pragma mark - DragonViewDelegate
-(int) dragonOrder: (DragonView*) requestor{
    return self.order;
}

-(NSArray *) dragonPath: (DragonView*) requestor{
    return self.dragonPath;
}

-(BOOL) stepByStepDrawingEnabled:(DragonView *)requester{
    return self.stepByStepDrawingEnabled;
}

-(int)stepPathLength:(DragonView*)requester{
    return self.stepPathLength;
}

- (BOOL)singleDrawing:(nonnull DragonView *)requester {
    return self.singleDrwaing;
}



@end
