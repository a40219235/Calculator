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
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

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

@end
