//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Shane Fu on 9/19/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringADigit;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController
@synthesize brain = _brain;

-(CalculatorBrain *)brain
{
	if (!_brain) {
		_brain = [[CalculatorBrain alloc] init];
	}
	return _brain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)digitPressed:(UIButton *)sender {
	if (self.userIsInTheMiddleOfEnteringADigit) {
		self.display.text = [self.display.text stringByAppendingFormat:@"%@",[sender currentTitle]];
	}else{
		self.display.text = [sender currentTitle];
		self.userIsInTheMiddleOfEnteringADigit = YES;
	}
}
- (IBAction)operationPressed:(UIButton *)sender {
	if (self.userIsInTheMiddleOfEnteringADigit)
	{
		[self enterPressed];
	}
	
	NSString *operation = [sender currentTitle];
	double result = [self.brain performOperand:operation];
	self.display.text = [NSString stringWithFormat:@"%g",result];
}
- (IBAction)enterPressed {
	self.userIsInTheMiddleOfEnteringADigit = NO;
	[self.brain pushOperand:[self.display.text doubleValue]];
}

@end
