//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Shane Fu on 9/19/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)number;

-(double)performOperand:(NSString *)operand;

@property (readonly) id program;

+(double)runProgram:(id)program;
+(NSString *)descriptionOfProgram:(id)program;

+(double)calculateExpressFromString:(NSString *)expressionString;

@end
