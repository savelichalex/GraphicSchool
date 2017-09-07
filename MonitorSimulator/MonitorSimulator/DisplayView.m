//
//  DisplayView.m
//  MonitorSimulator
//
//  Created by Admin on 07.09.17.
//  Copyright © 2017 savelichalex. All rights reserved.
//

#import "DisplayView.h"
#define DISPLAY_X_SIZE 128
#define DISPLAY_Y_SIZE 128

@implementation DisplayView

-(id)init {
    if (self = [super init]) {
        self.displayBuffer = nil;
    }
    
    return self;
}

-(void)setDisplayBuffer:(char *)displayBuffer {
    _displayBuffer = displayBuffer;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    
    if (_displayBuffer == nil) {
        return;
    }
    
    int x, y;
    for (y = 0; y < DISPLAY_X_SIZE; y = y + 1) {
        for (x = 1; x <= DISPLAY_Y_SIZE; x = x + 1) {
            unsigned char cell = _displayBuffer[y + x];
            CGFloat color = (CGFloat)cell;
            NSLog(@"cell: %f, %i, %i, %i, %i", color, (x - 1) * 4, (x - 1) * 4, y * 4, y * 4);
            [[NSColor colorWithCalibratedRed:color green:color blue:color alpha:1.0] set];
            NSRectFill(NSMakeRect((x - 1) * 4, y * 4, (x - 1) * 4 + 4, y * 4 + 4));
        }
    }
}

@end
