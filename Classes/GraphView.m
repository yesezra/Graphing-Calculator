//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Ezra Spier on 1/1/11.
//  Copyright 2011 Ezra Spier. All rights reserved.
//

#import "GraphView.h"

#define DEFAULT_SCALE 10.000

@implementation GraphView
@synthesize delegate;
@synthesize scale;
@synthesize originOffset;

- (void)setup {
	self.scale = DEFAULT_SCALE;
	self.originOffset = CGPointMake(0, 0);
	self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (void)awakeFromNib {
	[self setup];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Properties

- (void)setScale:(CGFloat)newScale {
	if (newScale < 1000 && newScale > 0.01) {
		scale = newScale;
		[self setNeedsDisplay];
	}
}

- (void)setOriginOffset:(CGPoint)newOffset {
	//bounds checking goes here
	originOffset = newOffset;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGPoint midpoint;
	midpoint.x = self.bounds.origin.x + self.bounds.size.width/2 + originOffset.x;
	midpoint.y = self.bounds.origin.y + self.bounds.size.height/2 + originOffset.y;

	[[UIColor blueColor] setStroke];
	[AxesDrawer drawAxesInRect:self.bounds originAtPoint:midpoint scale:self.scale*self.contentScaleFactor];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
//	self.contentScaleFactor //CGFloat; number of pixels per point
//	self.scale //CGFloat; number of points per axis unit
	
	for (CGFloat i = 0; i <= self.bounds.size.width; i++) {
		CGPoint nextPointInViewCoordinates;
		nextPointInViewCoordinates.x = i;
		
		CGPoint nextPointInGraphCoordinates;
		nextPointInGraphCoordinates.x = (nextPointInViewCoordinates.x - midpoint.x)/(self.scale * self.contentScaleFactor);
		nextPointInGraphCoordinates.y = ([self.delegate expressionResultForXValue:nextPointInGraphCoordinates.x 
																		requestor:self]);
		nextPointInViewCoordinates.y = midpoint.y - (nextPointInGraphCoordinates.y * self.scale * self.contentScaleFactor);
		
		if (i == 0) {
			CGContextMoveToPoint(context, nextPointInViewCoordinates.x, nextPointInViewCoordinates.y);
		} else {
			CGContextAddLineToPoint(context, nextPointInViewCoordinates.x, nextPointInViewCoordinates.y);
		}

//		NSLog(@"gx: %f gy: %f vx:%f vy:%f",nextPointInGraphCoordinates.x,nextPointInGraphCoordinates.y, nextPointInViewCoordinates.x,nextPointInViewCoordinates.y);
	}
	
	[[UIColor redColor] setStroke];
	CGContextDrawPath(context, kCGPathStroke);

}

#pragma mark Gesture Recognizers
- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
	if ((recognizer.state == UIGestureRecognizerStateChanged) ||
		(recognizer.state == UIGestureRecognizerStateEnded)) {
		self.scale = self.scale * recognizer.scale;
		recognizer.scale = 1.0;
	}
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateRecognized) {
		[self reset];
	}
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
	if ((recognizer.state == UIGestureRecognizerStateChanged) ||
		(recognizer.state == UIGestureRecognizerStateEnded)) {
		CGPoint translation = [recognizer translationInView:self];
		CGPoint newOffset = CGPointMake(self.originOffset.x + translation.x,
										self.originOffset.y + translation.y);
		self.originOffset = newOffset;
		[recognizer setTranslation:CGPointZero inView:self];
	}
}

#pragma mark -

- (void)reset {
	self.originOffset = CGPointMake(0, 0);
	self.scale = DEFAULT_SCALE;
}
@end
