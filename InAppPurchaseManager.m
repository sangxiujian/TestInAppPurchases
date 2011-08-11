//
//  InAppPurchaseManager.m
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "AppDelegate_iPhone.h"


@implementation InAppPurchaseManager

#define kInAppPurchaseStampProductId @"com.jiayuan.jiayuaniphone.stamps2" 



- (void)requestProUpgradeProductData
{
	
	NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseStampProductId ];
	productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
	productsRequest.delegate = self;
	[productsRequest start];
	
	// we will release the request object in the delegate callback
} 

#pragma mark -
#pragma mark SKProductsRequestDelegate methods 

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *products = response.products;
    NSLog(@"count:%d",[products count]);
	proUpgradeProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
	if (proUpgradeProduct)
	{
		NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
		NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
		NSLog(@"Product price: %@" , proUpgradeProduct.price);
		NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
	}
	
	for (NSString *invalidProductId in response.invalidProductIdentifiers)
	{
		NSLog(@"Invalid product id: %@" , invalidProductId);
	}
	
	// finally release the reqest we alloc/init’ed in requestProUpgradeProductData
	[productsRequest release];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

-(void)doFireGo
{
    //SKPaymentTransaction *transaction = [[NSUserDefaults standardUserDefaults] valueForKey:@"proUpgradeTransactionReceipt"];
    //[[NSUserDefaults standardUserDefaults] setValue:transaction forKey:@"proUpgradeTransactionReceipt" ];
    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    NSUInteger count = [[[SKPaymentQueue defaultQueue]transactions]count];
    NSLog(@"unfinished count:%d",count);
    //[self showStore];
}

//
// call this method once on startup
//
//- (void)loadStore
//{
//	// restarts any purchases if they were interrupted last time the app was open
//	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//	
//	// get the product description (defined in early sections)
//	//[self requestProUpgradeProductData];
//} 

-(void)showStore
{
    // get the product description (defined in early sections)
	[self requestProUpgradeProductData];
}

-(void)dealUnfinished
{
    if ([[[SKPaymentQueue defaultQueue]transactions]count]==0) {
        return;
    }
    
    AppDelegate_iPhone *appdelegate = [UIApplication sharedApplication].delegate;
    
    SKPaymentTransaction *theTran = [[[SKPaymentQueue defaultQueue]transactions]objectAtIndex:0];
    [appdelegate.observer PurchasedTransaction:theTran];
    //[[SKPaymentQueue defaultQueue] finishTransaction:theTran];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
} 

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    if ([SKPaymentQueue canMakePayments])
    {
         // Display a store to the user.
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseStampProductId];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
         // Warn the user that purchases are disabled.
        NSString *errmsg = @"Warn the user that purchases are disabled.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PayMent"
                                                            message:errmsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
	
} 


@end
