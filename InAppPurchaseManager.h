//
//  InAppPurchaseManager.h
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h> 

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification" 

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification" 


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>
{
	SKProduct *proUpgradeProduct;
	SKProductsRequest *productsRequest;
}

 

// public methods
-(void)showStore;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;

@end
