//
//  GraphViewController.m
//  GraphingCalculator
//
//  Created by Ezra Spier on 1/1/11.
//  Copyright 2011 Ezra Spier. All rights reserved.
//

#import "GraphViewController.h"


@implementation GraphViewController
@synthesize expression;

- (void)viewDidLoad {
	UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:graphView action:@selector(pinch:)];
	[graphView addGestureRecognizer:pinchGR];
	[pinchGR release];
	
	UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:graphView action:@selector(doubleTap:)];
	tapGR.numberOfTapsRequired = 2;
	[graphView addGestureRecognizer:tapGR];
	[tapGR release];
	
	UIPanGestureRecognizer* panGR = [[UIPanGestureRecognizer alloc] initWithTarget:graphView action:@selector(pan:)];
	[graphView addGestureRecognizer:panGR];
	[panGR release];
}

//- (void)loadView {
//	CGRect test = CGRectMake(0, 100, 100, 100);
//	graphView = [[GraphView alloc] initWithFrame:test];
//	graphView.delegate = self;
//	self.view = graphView;
//}

- (void)setExpression:(id) anExpression {
	[expression release];
	expression = [anExpression copy];
	
	self.title = [CalculatorBrain descriptionOfExpression:self.expression];
	[graphView reset];
	[graphView setNeedsDisplay];
}

- (double)expressionResultForXValue:(CGFloat)x requestor:(GraphView *)graphView {
	NSDictionary * variableValues = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"];
	return [CalculatorBrain evaluateExpression:self.expression usingVariableValues:variableValues];
}

- (IBAction)zoomIn {
	graphView.scale *= 2;
	[graphView setNeedsDisplay];
}

- (IBAction)zoomOut {
	graphView.scale /= 2;
	[graphView setNeedsDisplay];	
}

#pragma mark UISplitViewController delegate methods

- (void)splitViewController:(UISplitViewController *)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)pc {
	barButtonItem.title = aViewController.title;
	self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark Boilerplate

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[graphView release];
}


- (void)dealloc {
	[expression release];

    [super dealloc];
}


@end
