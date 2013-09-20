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
@property (weak, nonatomic) IBOutlet UITextField *functionDisplay;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringADigit;
@property (nonatomic) BOOL userHasEnteredAnOpration;
@property (nonatomic, strong) UITextPosition *cursorNewPosition;

@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController
@synthesize brain = _brain;
@synthesize cursorNewPosition = _cursorNewPosition;

-(UITextPosition *)cusorNewPosition
{
	if (_cursorNewPosition) {
		_cursorNewPosition = [[UITextPosition alloc] init];
	}
	return _cursorNewPosition;
}

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
	self.functionDisplay.inputView = [[UIView alloc] initWithFrame:CGRectZero];
	self.functionDisplay.text = @"nihaola";
	[self.functionDisplay becomeFirstResponder];
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
	if (!self.userHasEnteredAnOpration)
	{
		NSString *operation = [sender currentTitle];
		double result = [self.brain performOperand:operation];
		self.resultDisplay.text = [NSString stringWithFormat:@"%g",result];
	}
}

//enterButton just run the program and update the result
- (IBAction)enterPressed {
}

- (IBAction)moveCursor:(UIButton *)sender {
	UITextPosition *endOfDocument = [self.functionDisplay endOfDocument];

	UITextRange *selectionRange = self.functionDisplay.selectedTextRange;
	UITextPosition *selectedStartPosition = selectionRange.start;
	int cursorIndex = [self.functionDisplay offsetFromPosition:self.functionDisplay.endOfDocument toPosition:selectedStartPosition];
	
	if ([sender.currentTitle isEqualToString:@"->"]) {
		// Calculate the new position, - for left and + for right
		cursorIndex ++;
		NSLog(@"cursorIndex = %d", cursorIndex);
		self.cursorNewPosition = [self.functionDisplay positionFromPosition:endOfDocument offset:cursorIndex];
		
	}else{
		// Calculate the new position, - for left and + for right
		cursorIndex --;
		NSLog(@"cursorIndex = %d", cursorIndex);
		self.cursorNewPosition = [self.functionDisplay positionFromPosition:endOfDocument offset:cursorIndex];
	}
	
	UITextRange *newRange = [self.functionDisplay textRangeFromPosition:self.cursorNewPosition toPosition:self.cursorNewPosition];
	
	// Set new range
	[self.functionDisplay setSelectedTextRange:newRange];
	
}
@end
