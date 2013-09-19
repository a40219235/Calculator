//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Shane Fu on 9/19/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain
@synthesize operandStack = _operandStack;

-(NSMutableArray *)operandStack
{
	if (!_operandStack) {
		_operandStack = [[NSMutableArray alloc] init];
	}
	return _operandStack;
}

-(void)pushOperand:(double)number
{
	[self.operandStack addObject:[NSNumber numberWithDouble:number]];
}

-(double)popOperand
{
	NSNumber *operandObject = [self.operandStack lastObject];
	if (self.operandStack) {
		[self.operandStack removeLastObject];
	}
	return [operandObject doubleValue];
}

-(double)performOperand:(NSString *)operand
{
	double result = 0;
	if ([operand isEqualToString:@"+"]) {
		result = [self popOperand] +[self popOperand];
	}if ([operand isEqualToString:@"*"]) {
		result = [self popOperand] * [self popOperand];
	}if ([operand isEqualToString:@"-"]) {
		double subtrahend = [self popOperand];
		result = subtrahend - [self popOperand];
	}if ([operand isEqualToString:@"/"]) {
		double divisor = [self popOperand];
		result = divisor/[self popOperand];
	}

	[self pushOperand:result];
	return result;
}


@end
