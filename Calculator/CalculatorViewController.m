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
@property (nonatomic, strong) NSMutableArray *stack;

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

#pragma mark-Helper Method

-(int)getCursorCurrentIndex
{
	UITextRange *selectionRange = self.functionDisplay.selectedTextRange;
	UITextPosition *selectedStartPosition = selectionRange.start;
	int cursorCurrentIndex = [self.functionDisplay offsetFromPosition:self.functionDisplay.beginningOfDocument toPosition:selectedStartPosition];
	return cursorCurrentIndex;
}

-(void)repositionCursorSoItsNotGoingOffToTheBegining:(int)offSet
{
	//reset the cursor index after appending the text, otherwise the cursor would go to the beginingOfDocument, not sure why
	UITextPosition *repositionCursor = [self.functionDisplay positionFromPosition:self.functionDisplay.beginningOfDocument offset:offSet];
	UITextRange *newRange = [self.functionDisplay textRangeFromPosition:repositionCursor toPosition:repositionCursor];
	[self.functionDisplay setSelectedTextRange:newRange];
}

#pragma mark-Button Pressed

- (IBAction)digitPressed:(UIButton *)sender {
	//get the current cursor index and appending operand from that index
	int cursorCurrentIndex = [self getCursorCurrentIndex];
	NSRange index = NSMakeRange(cursorCurrentIndex, 0);
	
	if (self.userIsInTheMiddleOfEnteringADigit) {
		self.functionDisplay.text = [self.functionDisplay.text stringByReplacingCharactersInRange:index withString:sender.currentTitle];
	}else{
		self.functionDisplay.text = sender.currentTitle;
		self.userIsInTheMiddleOfEnteringADigit = YES;
	}
	
	[self repositionCursorSoItsNotGoingOffToTheBegining:cursorCurrentIndex + [sender.currentTitle length]];
}

- (IBAction)operationPressed:(UIButton *)sender {
	//get the current cursor index and appending operand from that index
	int cursorCurrentIndex = [self getCursorCurrentIndex];
	NSRange index = NSMakeRange(cursorCurrentIndex, 0);

	self.functionDisplay.text = [self.functionDisplay.text stringByReplacingCharactersInRange:index withString:sender.currentTitle];
	
	[self repositionCursorSoItsNotGoingOffToTheBegining:cursorCurrentIndex + [sender.currentTitle length]];
}

- (IBAction)deletePressed {
	if ([self.functionDisplay.text length]){
		int cursorCurrentIndex = [self getCursorCurrentIndex];
		NSLog(@"cursorCurrentIndex = %d", cursorCurrentIndex);
		NSRange index = NSMakeRange(cursorCurrentIndex - 1, 1);
		
		self.functionDisplay.text = [self.functionDisplay.text stringByReplacingCharactersInRange:index withString:@""];
		[self repositionCursorSoItsNotGoingOffToTheBegining:cursorCurrentIndex];
	}
}



//enterButton just run the program and update the result
- (IBAction)enterPressed {
	double result = [CalculatorBrain calculateExpressFromString:self.functionDisplay.text];
	NSLog(@"tested       result = %g", cos(sin(cos(5)))+ cos(2)*sin(-5) - cos(sin(35)-cos(63*sqrt(cos(2+sin(43))))));
	NSLog(@"enterPressed result = %g", result);
}

- (IBAction)moveCursor:(UIButton *)sender {
	int cursorCurrentIndex = [self getCursorCurrentIndex];
	if ([sender.currentTitle isEqualToString:@"->"]) {
		cursorCurrentIndex ++;
		if (cursorCurrentIndex > [self.functionDisplay.text length]) {
			cursorCurrentIndex = [self.functionDisplay.text length];
		}
		NSLog(@"cursorCurrentIndex = %d",cursorCurrentIndex);
	}else if ([sender.currentTitle isEqualToString:@"<-"]) {
		cursorCurrentIndex --;
		if (cursorCurrentIndex < 0) {
			cursorCurrentIndex = 0;
		}
		NSLog(@"cursorCurrentIndex = %d",cursorCurrentIndex);
	}
	
	UITextPosition *cursorNewPosition = [self.functionDisplay positionFromPosition:self.functionDisplay.beginningOfDocument offset:cursorCurrentIndex];
	UITextRange *newRange = [self.functionDisplay textRangeFromPosition:cursorNewPosition toPosition:cursorNewPosition];
	[self.functionDisplay setSelectedTextRange:newRange];
}
@end
