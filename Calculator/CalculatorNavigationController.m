//
//  CalculatorNavigationController.m
//  Calculator
//
//  Created by Shane Fu on 10/2/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "CalculatorNavigationController.h"

@interface CalculatorNavigationController ()

@end

@implementation CalculatorNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
	return [self.topViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations{
	return [self.topViewController supportedInterfaceOrientations];
}

@end
