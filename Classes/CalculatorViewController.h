//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Ezra Spier on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController : UIViewController {
	IBOutlet UILabel* display;
	IBOutlet CalculatorBrain* brain;
	BOOL userIsInTheMiddleOfTypingANumber;
	GraphViewController * graphViewController;
}

@property (retain) GraphViewController* graphViewController;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)solvePressed;
- (IBAction)graphPressed;
@end
