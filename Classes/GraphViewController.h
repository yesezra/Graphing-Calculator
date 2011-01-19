//
//  GraphViewController.h
//  GraphingCalculator
//
//  Created by Ezra Spier on 1/1/11.
//  Copyright 2011 Ezra Spier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController <GraphViewDelegate, UISplitViewControllerDelegate> {
	id expression;
	IBOutlet GraphView *graphView;
	IBOutlet UIButton *zoomIn;
	IBOutlet UIButton *zoomOut;
}

@property (copy) id expression;

- (IBAction)zoomIn;
- (IBAction)zoomOut;

@end
