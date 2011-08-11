//
//  MyStoreObserver.m
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 7/19/11.
//  Copyright 2011 JiaYuan. All rights reserved.
//

#import "MyStoreObserver.h"
#define kInAppPurchaseStampProductId @"com.jiayuan.jiayuaniphone.stamps2" 

@implementation MyStoreObserver

@synthesize transactionRecord;

#pragma -
#pragma Purchase helpers 

- (NSString *)loginArchivePath {
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
	
	return [docDir stringByAppendingPathComponent:@"jylogin.dat"];
}
- (NSString *)transactionArchivePath {
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
	
	return [docDir stringByAppendingPathComponent:@"jytransation.dat"];
    
}

-(void)loadHistoryRecord
{
    
    self.transactionRecord = [NSKeyedUnarchiver unarchiveObjectWithFile:[self transactionArchivePath]];
    if (self.transactionRecord == nil) {
        self.transactionRecord = [NSMutableDictionary dictionary];
    }
    
    [self refreshTransaction];
    
    
}


//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    //self.lastTransaction = transaction;
    
    NSString *strUid = [NSString stringWithFormat:@"%d",111111];
    
    NSUInteger oldUid = [[transactionRecord objectForKey:transaction.transactionIdentifier]intValue];
    if (oldUid == 0) {
        [transactionRecord setObject:strUid forKey:transaction.transactionIdentifier];
    }
    
    [NSKeyedArchiver archiveRootObject:transactionRecord toFile:[self transactionArchivePath]];
    NSLog(@"recordTransaction:%@------",[transactionRecord description]);
    
} 




//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
	NSLog(@"provideContent");
	if ([productId isEqualToString:kInAppPurchaseStampProductId])
	{
		// enable the pro features
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
} 

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
	
    
	
	// remove the transaction from the payment queue.
	//[[SKPaymentQueue defaultQueue] finishTransaction:transaction];//sxj
	NSString *errmsg;
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
	if (wasSuccessful)
	{
		// send out a notification that we’ve finished the transaction
		[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
		errmsg = @"sucessful";
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"finishSwitchOn" ]) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//sxj
            NSLog(@"has finished");
        }
	}
	else
	{
		// send out a notification for the failed transaction
		[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
		errmsg = [transaction.error localizedDescription];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//sxj
	}
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PayMent"
														message:errmsg
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
} 

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"=========completeTransaction=========");//1000000004154062
	[self recordTransaction:transaction];
	[self provideContent:transaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
} 

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"=========restoreTransaction=========");
	[self recordTransaction:transaction.originalTransaction];
	[self provideContent:transaction.originalTransaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
} 

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		NSLog(@"failedTransaction:cancelled:%@",[transaction.error localizedDescription]);
		// error!
		[self finishTransaction:transaction wasSuccessful:NO];
	}
	else
	{
		NSLog(@"failedTransaction:cancelled222");
		// this is fine, the user just cancelled, so don’t notify
		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	}
} 

-(void)refreshTransaction
{
    NSLog(@"refresh:%d",[[[SKPaymentQueue defaultQueue]transactions]count]);
    if ([[[SKPaymentQueue defaultQueue]transactions]count]>0) 
    {
        
        [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:[[SKPaymentQueue defaultQueue]transactions]];
    }
}

-(void)PurchasedTransaction:(SKPaymentTransaction *)transaction {
	
	NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
	[self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
	[transactions release];
	
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods 

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"satate:changed");
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
				//[self restoreTransaction:transaction];
				break;
			default:
				break;
		}
	}
}

@end
