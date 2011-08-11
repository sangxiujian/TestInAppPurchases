//
//  SKProduct+LocalizedPrice.h
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h> 

@interface SKProduct (LocalizedPrice) 

@property (nonatomic, readonly) NSString *localizedPrice;

@end

