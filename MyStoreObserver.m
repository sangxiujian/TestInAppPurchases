//
//  MyStoreObserver.m
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 7/19/11.
//  Copyright 2011 JiaYuan. All rights reserved.
//

#import "MyStoreObserver.h"

#define kInAppPurchaseStampProductId @"com.samonia.product1"

@implementation MyStoreObserver


-(void)refreshTransaction
{
    if ([[[SKPaymentQueue defaultQueue]transactions]count]>0)
    {
        [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:[[SKPaymentQueue defaultQueue]transactions]];
    }
}
//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{

    
}

//
// posts a notification with the transaction result
//
- (void)notifyTransaction:(SKPaymentTransaction *)transaction changedToState:(SAInAppPurchaseState)purchaseState
{
	NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: purchaseState], @"state",transaction.payment.productIdentifier,@"productId",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kInAppPurchaseManagerTransactionStateChangedNotification object:self userInfo:userinfo];
} 

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"=========completeTransaction=========");
    [self notifyTransaction:transaction changedToState:SAInAppPurchaseStateSucessTransaction];
    [self recordTransaction:transaction];
	[self checkPurchase:transaction];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"=========restoreTransaction=========");
    [self notifyTransaction:transaction changedToState:SAInAppPurchaseStateSucessTransaction];
	[self recordTransaction:transaction];
	[self checkPurchase:transaction];
} 

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    [self notifyTransaction:transaction changedToState:SAInAppPurchaseStateFailedTransaction];
 
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (transaction.error.code != SKErrorPaymentCancelled)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"buy err", nil) message:[transaction.error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
} 




#pragma mark -
#pragma mark SKPaymentTransactionObserver methods 

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				break;
			default:
				break;
		}
	}
}

#pragma mark - Check

-(void)checkPurchase:(SKPaymentTransaction*)transaction{

//    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObject:
//                                     [self encode:(uint8_t*)[[transaction transactionReceipt] bytes]length:[[transaction transactionReceipt] length]] forKey:@"receipt-data"];
//    
//    NSString *jsonValue = [tempDict JSONRepresentation];
     [self notifyTransaction:transaction changedToState:SAInAppPurchaseStateCheckingPurchase];
  
}

-(void)checkPurchaseReturn:(NSDictionary*)dicReturn{

    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    //[self removeRecord];
    //if (sucess) {
//    [self notifyTransaction:transaction changedToState:SAInAppPurchaseStateSucessCheckPurchase];

   // }else{
//        [self notifyTransaction:transaction changedToState:SAInAppPurchaseStateFailedCheckPurchase];

    //}
}

- (NSString*)encode:(const uint8_t*)input length:(NSInteger)length {
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}
@end
