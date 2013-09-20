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
@property (weak, nonatomic) IBOutlet UILabel *resultDisplay;
@property (weak, nonatomic) IBOutlet UILabel *functionDisplay;
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
		self.resultDisplay.text = [self.resultDisplay.text stringByAppendingFormat:@"%@",[sender currentTitle]];
	}else{
		self.resultDisplay.text = [sender currentTitle];
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
	self.resultDisplay.text = [NSString stringWithFormat:@"%g",result];
}
- (IBAction)enterPressed {
	self.userIsInTheMiddleOfEnteringADigit = NO;
	[self.brain pushOperand:[self.resultDisplay.text doubleValue]];
}

@end
