//
//  GraphingCalculatorAppDelegate.h
//  GraphingCalculator
//
//  Created by Ezra Spier on 1/1/11.
//  Copyright 2011 Ezra Spier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorViewController.h"

@interface GraphingCalculatorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

