//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Shane Fu on 9/19/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *geometryOperationStack;//sin, cos, tan
@end

@implementation CalculatorBrain
@synthesize geometryOperationStack = _geometryOperationStack;

-(NSMutableArray *)geometryOperationStack
{
	if (!_geometryOperationStack) {
		_geometryOperationStack = [[NSMutableArray alloc] init];
	}
	return _geometryOperationStack;
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

+(BOOL)isNumber:(char)c
{
	//maybe dumb, but works the way i wanted
	if ( c=='0'|| c=='1'|| c=='2'|| c=='3'|| c=='4'|| c=='5'|| c=='6'|| c=='7'|| c=='8'|| c=='9'|| c=='.')
	{
		return YES;
	}
	return NO;
}


// if )3 or 3(, append * to make it )*3 or 3*(
+(NSString *)polishExpressionsWithMutilplyOperand:(NSString *)polishingString
{
	for (int i = 1; i < [polishingString length] -1; i++) {
		char currentChar = [polishingString characterAtIndex:i];
		if (currentChar == '(') {
			char previousChar = [polishingString characterAtIndex:i-1];
			if ([self isNumber:previousChar] || previousChar == ')') {
				NSMutableString *polishingStringMutCopy = [NSMutableString stringWithString:polishingString];
				[polishingStringMutCopy insertString:@"*" atIndex:i];
				polishingString = polishingStringMutCopy;
				return [self polishExpressionsWithMutilplyOperand:polishingString];
			}
		}else if (currentChar == ')'){
			char nextChar = [polishingString characterAtIndex:i + 1];
			if ([self isNumber:nextChar] || nextChar == '(' || (nextChar == 's' && [polishingString characterAtIndex:i + 2] == 'q')) {
				NSMutableString *polishingStringMutCopy = [NSMutableString stringWithString:polishingString];
				[polishingStringMutCopy insertString:@"*" atIndex:i+1];
				polishingString = polishingStringMutCopy;
				return [self polishExpressionsWithMutilplyOperand:polishingString];
			}
		}
	}

	NSLog(@"        polished string = %@", polishingString);
	return polishingString;
}

+(double)calculateExpressFromString:(NSString *)expressionString encounterException:(void (^)(void))errorHandler
{
	double result = 0;
	// get rid of space and convert π to value, and polish
	expressionString = [expressionString stringByReplacingOccurrencesOfString:@" " withString:@""];
	expressionString = [expressionString stringByReplacingOccurrencesOfString:@"π" withString:[NSString stringWithFormat:@"(%g)", M_PI]];
	expressionString = [self polishExpressionsWithMutilplyOperand:expressionString];
	
	if ([expressionString rangeOfString:@"sin("].location != NSNotFound || [expressionString rangeOfString:@"cos("].location != NSNotFound) {
		//string has sin() operation
		NSString *expressionStringCopy = [expressionString copy];
		NSArray *innerMostGeometryOperandAndOperation = [self getTheInnerMostGeometryOperation: expressionStringCopy];
		NSString *innerMostGeometryOperand = innerMostGeometryOperandAndOperation[0];
		NSString *innerMostGeometryOperation = innerMostGeometryOperandAndOperation[1];//array 1 index is operation
		
		NSRange innerMostGeometryStringRange = [expressionString rangeOfString:[NSString stringWithFormat:@"%@(%@)",innerMostGeometryOperand, innerMostGeometryOperation]];
		double innerMostGeometryStringResult = [self performCalculationWithString:innerMostGeometryOperation andGeometryOperand:innerMostGeometryOperand enccounterException:errorHandler];

		expressionString = [expressionString stringByReplacingCharactersInRange:innerMostGeometryStringRange withString:[NSString stringWithFormat:@"(%g)", innerMostGeometryStringResult]];
		NSLog(@"trimming String         = %@", expressionString);
		//maybe better using for or while loop, but i'll use recursive call for learning purpose
		return [self calculateExpressFromString:expressionString encounterException:errorHandler];
	}

	result = [self performCalculationWithString:expressionString andGeometryOperand:nil enccounterException:errorHandler];
		NSLog(@"result                  = %g", result);
	NSLog(@"finish ---------------------");
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
				leftParenthesisCount ++;
			} else if ([expressionStringCopy characterAtIndex:i] == ')') {
				leftParenthesisCount --;
			}
			if (leftParenthesisCount == 0) {
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
