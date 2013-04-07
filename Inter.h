//
//  Inter.h
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 4/7/13.
//
//

#ifndef TestInAppPurchases__Inter_h
#define TestInAppPurchases__Inter_h

typedef enum
{
    SAInAppPurchaseStateSucessTransaction = 0,
    SAInAppPurchaseStateFailedTransaction,
    SAInAppPurchaseStateCheckingPurchase,
    SAInAppPurchaseStateSucessCheckPurchase,
    SAInAppPurchaseStateFailedCheckPurchase
}SAInAppPurchaseState;


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

#define kInAppPurchaseManagerTransactionStateChangedNotification @"kInAppPurchaseManagerTransactionStateChangedNotification"


#endif
