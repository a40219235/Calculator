//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Shane Fu on 9/19/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewConroller.h"
#import "GraphicView.h"

enum{
	kTestFunction1,
	kTestFunction2,
	kTestFunction3
}testFunctions;

@interface CalculatorViewController () <GraphicViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *resultDisplay;
@property (weak, nonatomic) IBOutlet UITextField *functionDisplay;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringADigit;
@property (nonatomic, strong) UITextPosition *cursorNewPosition;
@property (nonatomic) int testNumber;

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
	if (!self.userIsInTheMiddleOfEnteringADigit) self.userIsInTheMiddleOfEnteringADigit = YES;
	int cursorCurrentIndex = [self getCursorCurrentIndex];
	NSRange index = NSMakeRange(cursorCurrentIndex, 0);

	self.functionDisplay.text = [self.functionDisplay.text stringByReplacingCharactersInRange:index withString:sender.currentTitle];
	if ([sender.currentTitle length] > 1) {
		//make the cursor stays inside the parenthesis
		[self repositionCursorSoItsNotGoingOffToTheBegining:cursorCurrentIndex + [sender.currentTitle length] -1];
	}else{
		[self repositionCursorSoItsNotGoingOffToTheBegining:cursorCurrentIndex + [sender.currentTitle length]];
	}
}

- (IBAction)deletePressed {
	int cursorCurrentIndex = [self getCursorCurrentIndex];
	if (!cursorCurrentIndex ) {
		return; //do nothing if cursor is at the begining of the text
	}
	NSRange index = NSMakeRange(cursorCurrentIndex - 1, 1);
	
	self.functionDisplay.text = [self.functionDisplay.text stringByReplacingCharactersInRange:index withString:@""];
	[self repositionCursorSoItsNotGoingOffToTheBegining:cursorCurrentIndex -1];
}

//enterButton just run the program and update the result
- (IBAction)enterPressed {
	NSLog(@"start ++++++++++++++++++++++");
	NSLog(@"Calculation Expression  = %@", self.functionDisplay.text);
	__block BOOL encounterExceptionError = NO;
	double result = [CalculatorBrain calculateExpressFromString:self.functionDisplay.text encounterException:^{
		encounterExceptionError = YES;
	}];
	if (encounterExceptionError){
		self.resultDisplay.text = @"Invalid Expression";
	}else{
		self.resultDisplay.text = [NSString stringWithFormat:@"%g", result];
	}
}

- (IBAction)moveCursor:(UIButton *)sender {
	int cursorCurrentIndex = [self getCursorCurrentIndex];
	if ([sender.currentTitle isEqualToString:@"->"]) {
		cursorCurrentIndex ++;
		if (cursorCurrentIndex > [self.functionDisplay.text length]) {
			cursorCurrentIndex = [self.functionDisplay.text length];
		}
	}else if ([sender.currentTitle isEqualToString:@"<-"]) {
		cursorCurrentIndex --;
		if (cursorCurrentIndex < 0) {
			cursorCurrentIndex = 0;
		}
	}
	
	UITextPosition *cursorNewPosition = [self.functionDisplay positionFromPosition:self.functionDisplay.beginningOfDocument offset:cursorCurrentIndex];
	UITextRange *newRange = [self.functionDisplay textRangeFromPosition:cursorNewPosition toPosition:cursorNewPosition];
	[self.functionDisplay setSelectedTextRange:newRange];
}

- (IBAction)testsPressed:(UIButton *)sender {
	self.testNumber ++;
	double testResult;
	switch (self.testNumber) {
		case 1:
			self.functionDisplay.text = @"sin(cos(sin(sqrt(56)))) + sin(6)cos(5πsqrt(3))";
			testResult = sin(cos(sin(sqrt(56)))) + sin(6)*cos(5*M_PI*sqrt(3));
			break;
			
		case 2:
			self.functionDisplay.text = @"cos(sin(5)cos(20)*sin(123)8)sqrt(134)sin(π)cos(2π)";
			testResult = cos(sin(5)*cos(20)*sin(123)*8)*sqrt(134)*sin(M_PI)*cos(2*M_PI);
			break;
		case 3:
			self.functionDisplay.text = @"sqrt(-100)";
			testResult = sqrt(-100);
			self.testNumber = 0;
	}
	[self enterPressed];
	NSLog(@"test Result   = %g", testResult);
	NSLog(@"screen Result = %@", self.resultDisplay.text);
}

- (IBAction)clearPressed:(id)sender {
	self.functionDisplay.text = nil;
	self.resultDisplay.text = @"0";
	self.userIsInTheMiddleOfEnteringADigit = NO;
}

- (IBAction)graphPressed:(id)sender {
	if ([self splitViewGraphViewController]) {
		[self splitViewGraphViewController].graphicView.dataSource = self;
		[[self splitViewGraphViewController].graphicView setNeedsDisplay];
	}
}

#pragma mark - GraphicViewDataSource
-(CGFloat)getYValueAtX:(CGFloat)x sender:(GraphicView *)sender{
	NSString *functionwithX = self.functionDisplay.text;
	functionwithX = [functionwithX stringByReplacingOccurrencesOfString:@"x" withString:[NSString stringWithFormat:@"%f",x]];
	double result = [CalculatorBrain calculateExpressFromString:functionwithX encounterException:nil];
	
	return result;
}

-(void)didFinishDrawing{
//	[self splitViewGraphViewController].graphicView.dataSource = nil;
}

#pragma mark - splitView
-(GraphViewConroller *)splitViewGraphViewController{
	id splitViewDetailView = [self.splitViewController.viewControllers lastObject];
	if (![splitViewDetailView isKindOfClass:[GraphViewConroller class]]) {
		splitViewDetailView = nil;
	}
	return splitViewDetailView;
}

#pragma mark - autoRotation
//or u can set from the target
-(BOOL)shouldAutorotate
{
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}

@end
