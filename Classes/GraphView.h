//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Ezra Spier on 1/1/11.
//  Copyright 2011 Ezra Spier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@class GraphView;

@protocol GraphViewDelegate 
- (double)expressionResultForXValue: (CGFloat)x requestor: (GraphView *)graphView;
@end

@interface GraphView : UIView {
	id <GraphViewDelegate> delegate;
	CGFloat scale; //between 0.01 and 1000
	CGPoint	originOffset;
}

- (void)reset;

@property (assign) id <GraphViewDelegate> delegate;
@property (assign) CGFloat scale;
@property (assign) CGPoint originOffset;

@end
