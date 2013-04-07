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

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processTranctionEvent:)
                                                     name: kInAppPurchaseManagerTransactionStateChangedNotification
                                                   object:nil];
    }
    return self;

    
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kInAppPurchaseManagerTransactionStateChangedNotification
                                                  object:nil];
    self.productsRequest = nil;
    [super dealloc];
}

-(void)processTranctionEvent:(NSNotification *)notification{
    
    //NSString * productId = [[notification userInfo] objectForKey:@"productId"];
    SAInAppPurchaseState state = [[[ notification userInfo ] objectForKey: @"state"] intValue];
    switch (state) {
        case SAInAppPurchaseStateSucessTransaction:
            ;
            break;
        case SAInAppPurchaseStateFailedTransaction:
            ;
            break;
        case SAInAppPurchaseStateCheckingPurchase:
            ;
            break;
        case SAInAppPurchaseStateSucessCheckPurchase:
            ;
            break;
        case SAInAppPurchaseStateFailedCheckPurchase:
            ;
            break;
        default:
            break;
    }
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
} 

//
//make purchase 
//
- (void)purchaseProduct:(NSString *)identifier
{
    
    if ([SKPaymentQueue canMakePayments])
    {
         // Display a store to the user.
        [self requestProductData:identifier];
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

- (void)requestProductData:(NSString *)identifier
{
	self.productsRequest.delegate = nil;
    
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:identifier]];
    self.productsRequest = request;
    [request release];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    SKProduct *product = [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (product == nil) {
        NSLog(@"Request products failed.");
        return;
    }
	if (product)
	{
		NSLog(@"Product title: %@" , product.localizedTitle);
		NSLog(@"Product description: %@" , product.localizedDescription);
		NSLog(@"Product price: %@" , product.price);
		NSLog(@"Product id: %@" , product.productIdentifier);
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	
	for (NSString *invalidProductId in response.invalidProductIdentifiers)
	{
		NSLog(@"Invalid product id: %@" , invalidProductId);
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

#pragma mark - 

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
	//if ([productId isEqualToString:kInAppPurchaseStampProductId])
	{
		// enable the pro features
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

@end
