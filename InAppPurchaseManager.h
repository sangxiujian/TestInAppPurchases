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

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>
{
	SKProductsRequest *_productsRequest;
}
@property (nonatomic ,strong)SKProductsRequest *productsRequest;
 

- (BOOL)canMakePurchases;
- (void)purchaseProduct:(NSString *)identifier;


@end
