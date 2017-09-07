//
//  ViewController.m
//  MonitorSimulator
//
//  Created by Admin on 04.09.17.
//  Copyright © 2017 savelichalex. All rights reserved.
//

#import "ViewController.h"
#import "DisplayView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view = [[DisplayView alloc] init];
    [self.view setFrame:NSMakeRect(0.f, 0.f, 480.f, 480.f)];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
