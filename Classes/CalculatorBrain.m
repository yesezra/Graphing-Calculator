//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Ezra Spier on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

#define VARIABLE_PREFIX @"%"

@implementation CalculatorBrain

@synthesize operand;

- (void)addObjectToInternalExpression:(id)expressionComponent {
	if (!internalExpression) {
		internalExpression = [[NSMutableArray alloc] init];
	}
	
	//NSLog(@"Object added to Internal Expression: %@ \t", expressionComponent);
	//NSLog(@"IE: %@", internalExpression);
	[internalExpression addObject:expressionComponent];
}

- (void)setOperand:(double)aDouble {
	[self addObjectToInternalExpression:[NSNumber numberWithDouble:aDouble]];
	operand = aDouble;
}

- (void)setVariableAsOperand:(NSString *)variableName {
	NSString * variablePrefix = VARIABLE_PREFIX;
	NSString * variable = [variablePrefix stringByAppendingString:variableName];
	[self addObjectToInternalExpression:variable];	
}

- (void)performWaitingOperation {
	if ([@"+" isEqual:waitingOperation]) {
		operand = waitingOperand + operand;
	} else if ([@"*" isEqual:waitingOperation]) {
		operand = waitingOperand * operand;
	} else if ([@"-" isEqual:waitingOperation]) {
		operand = waitingOperand - operand;
	} else if ([@"/" isEqual:waitingOperation]) {
		if (operand) {
			operand = waitingOperand / operand;			
		}
	} 
}

- (double)performOperation:(NSString *)operation {
	[self addObjectToInternalExpression:operation];
	if ([operation isEqual:@"sqrt"]) {
		operand = sqrt(operand);
	} else if ([operation isEqual:@"sin"]) {
		operand = sin(operand);
	} else if ([operation isEqual:@"cos"]) {
		operand = cos(operand);
	} else if ([@"+/-" isEqual:operation]) {
		operand = - operand;
	} else if ([operation isEqual:@"1/x"]) {
		if (operand) {
			operand = 1 / operand;
		}
	} else if ([operation isEqual:@"M"]) {
		memoryOperand = operand;
	} else if ([operation isEqual:@"MR"]) {
		operand = memoryOperand;
	} else if ([operation isEqual:@"M+"]) {
		memoryOperand += operand;
	} else if ([operation isEqual:@"C"]) {
		operand = 0;
		[waitingOperation release];
		waitingOperation = nil;
		waitingOperand = 0;
		memoryOperand = 0;
		[internalExpression removeAllObjects];
	} else {
		[self performWaitingOperation];
		[waitingOperation release];
		waitingOperation = operation;
		[waitingOperation retain];
		waitingOperand = operand;
	}

	return operand;
}

- (id)expression {
	return [[internalExpression copy] autorelease];
}

#pragma mark helperMethods
+ (BOOL)stringIsVariable:(NSString *)aString {
	BOOL isVariable = NO;
	NSString * variablePrefix = VARIABLE_PREFIX;
	
	if ([aString hasPrefix:variablePrefix]) {
		isVariable = YES;
	}
	
	return isVariable;
}

+ (NSString *)stringByStrippingVariablePrefix:(NSString *)aString {
	NSString * variablePrefix = VARIABLE_PREFIX;
	return [aString substringFromIndex:[variablePrefix length]];
}

#pragma mark Class Methods

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables {
	CalculatorBrain * workerBrain = [[CalculatorBrain alloc] init];

	for (id expressionComponent in anExpression) {
		if ([expressionComponent isKindOfClass:[NSNumber class]]) {
			workerBrain.operand = [expressionComponent doubleValue];
		} else if ([expressionComponent isKindOfClass:[NSString class]]) {

			if ([CalculatorBrain stringIsVariable:expressionComponent]) {
				NSString * variable = [CalculatorBrain stringByStrippingVariablePrefix:expressionComponent];
				double variableValue = [[variables objectForKey:variable] doubleValue];
				workerBrain.operand = variableValue;
			} else {
				[workerBrain performOperation:expressionComponent];
			}
		}
	}
	double result = workerBrain.operand;
	[workerBrain release];
	return result;
}

+ (NSSet *)variablesInExpression:(id)anExpression {
	NSMutableSet * variableSet = [[NSMutableSet alloc] init];
	
	for (id expressionComponent in anExpression) {
		if ([expressionComponent isKindOfClass:[NSString class]] && [CalculatorBrain stringIsVariable:expressionComponent]) {
			NSString * variable = [CalculatorBrain stringByStrippingVariablePrefix:expressionComponent];
			if (![variableSet member:variable]) {
				[variableSet addObject:variable];
			}
		}
	}
	
	if ([variableSet count] == 0) {
		[variableSet release];
		variableSet = nil;
	} else {
		[variableSet autorelease];
	}
	
	return variableSet;
}

+ (NSString *)descriptionOfExpression:(id)anExpression {
	NSMutableString * description = [[NSMutableString alloc] init];
	
	for (id expressionComponent in anExpression) {
		if ([expressionComponent isKindOfClass:[NSNumber class]]) {
			[description appendString:[expressionComponent stringValue]];
		} else if ([expressionComponent isKindOfClass:[NSString class]]) {
			if ([CalculatorBrain stringIsVariable:expressionComponent]) {
				[description appendString:[CalculatorBrain stringByStrippingVariablePrefix:expressionComponent]];
			} else {
				[description appendString:expressionComponent];
			}

		}
		[description appendString:@" "];
	}
	return [description autorelease];
}

+ (id)propertyListForExpression:(id)anExpression {
	return [[anExpression copy] autorelease];
}

+ (id)expressionForPropertyList:(id)propertyList {
	return [[propertyList copy] autorelease];
}


- (void) dealloc {
	[waitingOperation release];
	[internalExpression release];
	[super dealloc];
}

@end
