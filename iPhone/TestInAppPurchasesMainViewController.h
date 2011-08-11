//
//  TestInAppPurchasesMainViewController.h
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"

@interface TestInAppPurchasesMainViewController : UIViewController {
	InAppPurchaseManager *manager;
	NSString *showStr;
	UILabel *label;

}
@property(nonatomic,copy)NSString *showStr;
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)InAppPurchaseManager *manager;
@end
