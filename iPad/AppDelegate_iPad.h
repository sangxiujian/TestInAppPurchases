//
//  AppDelegate_iPad.h
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TestInAppPurchasesMainViewController.h"

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
	  UIWindow *window;
	TestInAppPurchasesMainViewController *mainViewCtr;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestInAppPurchasesMainViewController *mainViewCtr;

@end

