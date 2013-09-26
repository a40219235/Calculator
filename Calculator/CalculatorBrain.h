//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Shane Fu on 9/19/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
+(double)calculateExpressFromString:(NSString *)expressionString encounterException:(void(^)(void))errorHandler;

+(double)calculateFunctionFromString:(NSString *)expressionString withValueOfX:(float)x;

@end
