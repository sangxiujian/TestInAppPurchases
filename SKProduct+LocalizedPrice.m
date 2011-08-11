//
//  SKProduct+LocalizedPrice.m
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKProduct+LocalizedPrice.h"


#import "SKProduct+LocalizedPrice.h" 

@implementation SKProduct (LocalizedPrice) 

- (NSString *)localizedPrice
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:self.priceLocale];
	NSString *formattedString = [numberFormatter stringFromNumber:self.price];
	[numberFormatter release];
	return formattedString;
} 

@end