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
	self.functionDisplay.placeholder = @"x + a = 5";
	[self.functionDisplay becomeFirstResponder];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)digitPressed:(UIButton *)sender {
	//get the current cursor index and appending operand from that index
	UITextRange *selectionRange = self.functionDisplay.selectedTextRange;
	UITextPosition *selectedStartPosition = selectionRange.start;
	int cursorIndex = [self.functionDisplay offsetFromPosition:self.functionDisplay.beginningOfDocument toPosition:selectedStartPosition];
	NSRange index = NSMakeRange(cursorIndex, 0);
	
	if (self.userIsInTheMiddleOfEnteringADigit) {
		self.functionDisplay.text = [self.functionDisplay.text stringByReplacingCharactersInRange:index withString:sender.currentTitle];
	}else{
		self.functionDisplay.text = sender.currentTitle;
		self.userIsInTheMiddleOfEnteringADigit = YES;
	}
	
	//reset the cursor index after appending the text, otherwise the cursor would go to the beginingOfDocument, not sure why
	UITextPosition *repositionCursor = [self.functionDisplay positionFromPosition:self.functionDisplay.beginningOfDocument offset:cursorIndex + [sender.currentTitle length]];
	UITextRange *newRange = [self.functionDisplay textRangeFromPosition:repositionCursor toPosition:repositionCursor];
	[self.functionDisplay setSelectedTextRange:newRange];
}

- (IBAction)operationPressed:(UIButton *)sender {
	//get the current cursor index and appending operand from that index
	UITextRange *selectionRange = self.functionDisplay.selectedTextRange;
	UITextPosition *selectedStartPosition = selectionRange.start;
	int cursorIndex = [self.functionDisplay offsetFromPosition:self.functionDisplay.beginningOfDocument toPosition:selectedStartPosition];
	NSRange index = NSMakeRange(cursorIndex, 0);

	self.functionDisplay.text = [self.functionDisplay.text stringByReplacingCharactersInRange:index withString:sender.currentTitle];
	
	//reset the cursor index after appending the text, otherwise the cursor would go to the beginingOfDocument, not sure why
	UITextPosition *repositionCursor = [self.functionDisplay positionFromPosition:self.functionDisplay.beginningOfDocument offset:cursorIndex + [sender.currentTitle length]];
	UITextRange *newRange = [self.functionDisplay textRangeFromPosition:repositionCursor toPosition:repositionCursor];
	[self.functionDisplay setSelectedTextRange:newRange];
}

//enterButton just run the program and update the result
- (IBAction)enterPressed {
	
}

- (IBAction)moveCursor:(UIButton *)sender {
	UITextPosition *endOfDocument = self.functionDisplay.endOfDocument;

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
