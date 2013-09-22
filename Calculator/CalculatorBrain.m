//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Shane Fu on 9/19/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableArray *geometryOperationStack;//sin, cos, tan
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;
@synthesize geometryOperationStack = _geometryOperationStack;

-(NSMutableArray *)geometryOperationStack
{
	if (!_geometryOperationStack) {
		_geometryOperationStack = [[NSMutableArray alloc] init];
	}
	return _geometryOperationStack;
}

-(NSMutableArray *)programStack
{
	if (!_programStack) {
		_programStack = [[NSMutableArray alloc] init];
	}
	return _programStack;
}

-(void)pushOperand:(double)number
{
	[self.programStack addObject:[NSNumber numberWithDouble:number]];
}

-(double)performOperand:(NSString *)operand
{
	[self.programStack addObject:operand];
	return [CalculatorBrain runProgram:self.program];
}

-(id)program
{
	return [self.programStack copy];
}

+(double)runProgram:(id)program
{
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}
	return [self popOperandOffStack:stack];//self is a class in class method
}

+(NSString *)descriptionOfProgram:(id)program{
	return nil;
}

+(double)popOperandOffStack:(NSMutableArray *)stack
{
	double result = 0;
	
	id topOfStack = [stack lastObject];
	if (topOfStack) [stack removeLastObject];
	
	if ([topOfStack isKindOfClass:[NSNumber class]]) {
		result = [topOfStack doubleValue];
	}else if ([topOfStack isKindOfClass:[NSString class]])
	{
		NSString *operand = topOfStack;
		if ([operand isEqualToString:@"+"]) {
			result = [self popOperandOffStack:stack] +[self popOperandOffStack:stack];
		}if ([operand isEqualToString:@"*"]) {
			result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
		}if ([operand isEqualToString:@"-"]) {
			double subtrahend = [self popOperandOffStack:stack];
			result = subtrahend - [self popOperandOffStack:stack];
		}if ([operand isEqualToString:@"/"]) {
			double divisor = [self popOperandOffStack:stack];
			result = divisor/[self popOperandOffStack:stack];
		}
	}
	return result;
}

//if geometryOperand is nil, then just return the expression calculation
+(double)performCalculationWithString:(NSString *)expressionString andGeometryOperand:(NSString *)geometryOperand enccounterException:(void(^)(void))errorHandler
{
	double result = 0;
	NSExpression *expression;
	@try {
		expression = [NSExpression expressionWithFormat:expressionString];
	}
	@catch (NSException *exception) {
		NSLog(@"expression error = %@", exception);
		errorHandler();
		return 0;
	}
	
	result = [[expression expressionValueWithObject:nil context:nil] doubleValue];
	if ([geometryOperand hasPrefix:@"sin"]) {
		result = sin(result);
	}else if ([geometryOperand hasPrefix:@"cos"]){
		result = cos(result);
	}
	return result;
}

+(double)calculateExpressFromString:(NSString *)expressionString encounterException:(void (^)(void))errorHandler
{
	double result = 0;
	//convert π,
	expressionString = [expressionString stringByReplacingOccurrencesOfString:@"π" withString:[NSString stringWithFormat:@"%g", M_PI]];
	
	if ([expressionString rangeOfString:@"sin("].location != NSNotFound || [expressionString rangeOfString:@"cos("].location != NSNotFound) {
		NSLog(@"expressionStringBefore = %@", expressionString);
		//string has sin() operation
		NSString *expressionStringCopy = [expressionString copy];
		NSArray *innerMostGeometryOperandAndOperation = [self getTheInnerMostGeometryOperation: expressionStringCopy];
		NSString *innerMostGeometryOperand = innerMostGeometryOperandAndOperation[0];
		NSString *innerMostGeometryOperation = innerMostGeometryOperandAndOperation[1];//array 1 index is operation
		NSLog(@"innerMostGeometryOperandAndOperation = %@", [innerMostGeometryOperandAndOperation description]);
		
		NSRange innerMostGeometryStringRange = [expressionString rangeOfString:[NSString stringWithFormat:@"%@(%@)",innerMostGeometryOperand, innerMostGeometryOperation]];
		double innerMostGeometryStringResult = [self performCalculationWithString:innerMostGeometryOperation andGeometryOperand:innerMostGeometryOperand enccounterException:errorHandler];
		NSLog(@"expressionStringBefore = %@", expressionString);
		expressionString = [expressionString stringByReplacingCharactersInRange:innerMostGeometryStringRange withString:[NSString stringWithFormat:@"%g", innerMostGeometryStringResult]];
		NSLog(@"expressionStringAfter = %@", expressionString);
		return [self calculateExpressFromString:expressionString encounterException:errorHandler];
	}

	NSLog(@"expression result = %@", expressionString);
	result = [self performCalculationWithString:expressionString andGeometryOperand:nil enccounterException:errorHandler];
	NSLog(@"result = %g", result);
	
	return result;
}

//return array should contain operand (sin, cos), and operation(functions inside sin, cos. e.x sin(function))
+(NSArray *)getTheInnerMostGeometryOperation:(NSString*)geometryString
{
	NSMutableArray *operandAndOperation = [[NSMutableArray alloc] init];
	NSRange range = [geometryString rangeOfString:@"sin("];
	int geometryOperationStartIndex = range.location + range.length;
	int geometryOperationEndIndex = 0;
	int leftParenthesisCount = 1;//when this reaches 0, it means the sin function is closed
	NSString *geometryOperand;
	if (range.location != NSNotFound) {
		NSString *expressionStringCopy = [geometryString copy];
		for (int i = geometryOperationStartIndex; i < [expressionStringCopy length]; i++) {
			if ([expressionStringCopy characterAtIndex:i] == '(') {
//				NSLog(@"(found, index = %d", i);
				leftParenthesisCount ++;
			} else if ([expressionStringCopy characterAtIndex:i] == ')') {
//				NSLog(@")found, index = %d", i);
				leftParenthesisCount --;
			}
			if (leftParenthesisCount == 0) {
//				NSLog(@"finished index = %d", i);
				geometryOperationEndIndex = i;
				break;
			}
		}
		geometryOperand = @"sin";
	}else if ([geometryString rangeOfString:@"cos("].location != NSNotFound){
		range = [geometryString rangeOfString:@"cos("];
		geometryOperationStartIndex = range.location + range.length;
		leftParenthesisCount = 1;
	
		NSString *expressionStringCopy = [geometryString copy];
		for (int i = geometryOperationStartIndex; i < [expressionStringCopy length]; i++) {
			if ([expressionStringCopy characterAtIndex:i] == '(') {
				//				NSLog(@"(found, index = %d", i);
				leftParenthesisCount ++;
			} else if ([expressionStringCopy characterAtIndex:i] == ')') {
				//				NSLog(@")found, index = %d", i);
				leftParenthesisCount --;
			}
			if (leftParenthesisCount == 0) {
				//				NSLog(@"finished index = %d", i);
				geometryOperationEndIndex = i;
				break;
			}
		}
		geometryOperand = @"cos";
	}
	
	NSRange geometryOperationRange = NSMakeRange(geometryOperationStartIndex, geometryOperationEndIndex - geometryOperationStartIndex);
	geometryString = [geometryString substringWithRange:geometryOperationRange];
//	NSLog(@"expressionString = %@", geometryString);
	if ([geometryString rangeOfString:@"sin("].location != NSNotFound || [geometryString rangeOfString:@"cos("].location != NSNotFound) {
		return [self getTheInnerMostGeometryOperation:geometryString];
	}
	[operandAndOperation addObject:geometryOperand];
	[operandAndOperation addObject:geometryString];
	geometryString = [NSString stringWithFormat:@"%@(%@)",geometryOperand,geometryOperand];
	return [operandAndOperation copy];
}

+(NSRange)findSubString:(NSString *)subString inString:(NSString *)string
{
	NSRange range = [string rangeOfString:subString];
	return range;
}

@end
