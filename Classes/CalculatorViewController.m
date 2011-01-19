//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ezra Spier on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//	

#import "CalculatorViewController.h"

@interface CalculatorViewController()

@property (readonly) CalculatorBrain * brain;

@end

@implementation CalculatorViewController
@synthesize graphViewController;

- (void)viewDidLoad {
	self.title = @"Graphing Calculator";
	[super viewDidLoad];
}

- (CalculatorBrain *)brain {
	if (!brain) {
		brain = [[CalculatorBrain alloc] init];
	}
	return brain;
}

- (GraphViewController *)graphViewController {
	if (!graphViewController) {
		graphViewController = [[GraphViewController alloc] init];
	}

	return graphViewController;
}

- (BOOL)displayContainsPeriod {
	NSRange range = [display.text rangeOfString:@"."];
	if (range.location == NSNotFound) {
		return NO;
	} else {
		return YES;
	}
}

- (IBAction)digitPressed:(UIButton *)sender {
	NSString *digit = sender.titleLabel.text;
	BOOL tryingToTypePeriodTwice = [digit isEqual:@"."] && [self displayContainsPeriod];
	
	if (!userIsInTheMiddleOfTypingANumber) {
		display.text = digit;
		userIsInTheMiddleOfTypingANumber = YES;
	} else if (!tryingToTypePeriodTwice) {
		if ([CalculatorBrain variablesInExpression:brain.expression]) {
			display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
		} else {
			display.text = [display.text stringByAppendingString:digit];
		}
	}
}

- (IBAction)operationPressed:(UIButton *)sender {
	if (userIsInTheMiddleOfTypingANumber) {
		[self.brain setOperand:[display.text doubleValue]];
		userIsInTheMiddleOfTypingANumber = NO;
	}
		 
	NSString *operation = sender.titleLabel.text;
	double result = [self.brain performOperation:operation];
	
	if ([CalculatorBrain variablesInExpression:brain.expression]) {
		display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
	} else {
		display.text = [NSString stringWithFormat:@"%g", result];
	}
}

- (IBAction)variablePressed:(UIButton *)sender {
	userIsInTheMiddleOfTypingANumber = NO;
	
	NSString * variable = sender.titleLabel.text;
	[self.brain setVariableAsOperand:variable];
	display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
}

- (void)prepareToSolve {
	if (userIsInTheMiddleOfTypingANumber) {
		[self.brain setOperand:[display.text doubleValue]];
		userIsInTheMiddleOfTypingANumber = NO;
	}
	
	if (![[CalculatorBrain descriptionOfExpression:brain.expression] hasSuffix:@"= "]) {
		[brain performOperation:@"="];
	}
}

- (IBAction)solvePressed {
	[self prepareToSolve];

	id expression = brain.expression;
	NSMutableDictionary * variableValues = [[NSMutableDictionary alloc] init];
	[variableValues setObject:[NSNumber numberWithInt:5] forKey:@"x"];
	[variableValues setObject:[NSNumber numberWithInt:10] forKey:@"y"];
	[variableValues setObject:[NSNumber numberWithInt:2] forKey:@"z"];
	
	double result = [CalculatorBrain evaluateExpression:expression usingVariableValues:variableValues];
	display.text = [NSString stringWithFormat:@"%@%g", [CalculatorBrain descriptionOfExpression:expression], result];
	[variableValues release];
}

- (IBAction)graphPressed {
	[self prepareToSolve];
	
	self.graphViewController.expression = brain.expression;

	if (self.graphViewController.view.window == nil) {
		[self.navigationController pushViewController:self.graphViewController animated:YES];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	BOOL shouldAutorotate = YES;
	BOOL isLandscape = ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
						(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	// change this to a more appropriate number once chosen
	if ((screenBounds.size.width < 700) && 
		(isLandscape)) {
		shouldAutorotate = NO;
	}
	return shouldAutorotate;
}

- (void)dealloc {
	[graphViewController release];
	[brain release];
    [super dealloc];
}

@end
