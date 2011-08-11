//
//  MyStoreObserver.h
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 7/19/11.
//  Copyright 2011 JiaYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h> 

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification" 

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification" 

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver> {
    
    NSMutableDictionary *transactionRecord;
	
}
@property (nonatomic,retain)NSMutableDictionary *transactionRecord;

-(void)PurchasedTransaction:(SKPaymentTransaction *)transaction;

@end

