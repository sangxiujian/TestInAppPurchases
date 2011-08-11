//
//  AppDelegate_iPhone.h
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestInAppPurchasesMainViewController.h"
#import "MyStoreObserver.h"

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	TestInAppPurchasesMainViewController *mainViewCtr;
    MyStoreObserver *observer;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestInAppPurchasesMainViewController *mainViewCtr;
@property (nonatomic, retain) MyStoreObserver *observer;
@end

