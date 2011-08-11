    //
//  TestInAppPurchasesMainViewController.m
//  TestInAppPurchases 
//
//  Created by Sang HsiuJane on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestInAppPurchasesMainViewController.h"


@implementation TestInAppPurchasesMainViewController

@synthesize manager;
@synthesize showStr;
@synthesize label;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake(10, 100, 100, 40);
	[btn addTarget:self action:@selector(doUndeal:) forControlEvents:UIControlEventTouchUpInside];
	[btn setTitle:@"确认未完成产品" forState:UIControlStateNormal];
	[self.view addSubview:btn];
	
	
	UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn2.frame = CGRectMake(10, 200, 100, 40);
	[btn2 addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
	[btn2 setTitle:@"购买" forState:UIControlStateNormal];
	[self.view addSubview:btn2];
    

    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn0.frame = CGRectMake(10, 10, 100, 40);
	[btn0 addTarget:self action:@selector(fire:) forControlEvents:UIControlEventTouchUpInside];
	[btn0 setTitle:@"获取未完成队列" forState:UIControlStateNormal];
	[self.view addSubview:btn0];
    
    
    UISwitch *onOFF = [[[UISwitch alloc]initWithFrame:CGRectMake(10, 300, 100, 40)]autorelease];
    [onOFF addTarget:self action:@selector(openClose:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:onOFF];
    onOFF.on = YES;
	
	label = [[UILabel alloc]initWithFrame:CGRectMake(110, 100, 100, 200)];
	label.numberOfLines = 10;
	[self.view addSubview:label];
	
	
	manager = [[InAppPurchaseManager alloc]init];
	
	
}
-(void)openClose:(id)sender
{
    UISwitch *onOF = (UISwitch*)sender;
    
    [[NSUserDefaults standardUserDefaults] setBool:onOF.on forKey:@"finishSwitchOn" ];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)scheduleNotificationForDate:(NSDate *)theDate {
	
	UIApplication *app = [UIApplication sharedApplication];
	NSArray *oldNotifications = [app scheduledLocalNotifications];
	
	// Clear out the old notification before scheduling a new one.
	if (0 < [oldNotifications count]) {
		
		[app cancelAllLocalNotifications];
	}
	
	// Create a new notification
	UILocalNotification *alarm = [[UILocalNotification alloc] init];
	if (alarm) {
		
		alarm.fireDate = theDate;
		alarm.timeZone = [NSTimeZone defaultTimeZone];
		alarm.repeatInterval = 0;
		alarm.soundName = @"ping.caf";//@"default";
		alarm.alertBody = [NSString stringWithFormat:@"Time to wake up!Now is\n[%@]", 
						   [NSDate dateWithTimeIntervalSinceNow:10]];
		alarm.applicationIconBadgeNumber = 1;
		
		[app scheduleLocalNotification:alarm];
		[alarm release];
	}
} 
/*
- (void)scheduleNotificationWithItem:(ToDoItem *)item interval:(int)minutesBefore {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:item.day];
    [dateComps setMonth:item.month];
    [dateComps setYear:item.year];
    [dateComps setHour:item.hour];
    [dateComps setMinute:item.minute];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    [dateComps release];
	
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate addTimeInterval:-(minutesBefore*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil),
							item.eventName, minutesBefore];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
	
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
	
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
    localNotif.userInfo = infoDict;
	
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}
*/
-(IBAction)fire:(UIButton*)sender
{
    [manager doFireGo];
}
-(IBAction)show:(UIButton*)sender
{
	
	
	[manager showStore];
}
-(IBAction)doUndeal:(UIButton*)sender
{
    [manager dealUnfinished];
    
}

-(IBAction)buy:(UIButton*)sender
{
	
	
	[manager purchaseProUpgrade];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[label release];
	[manager release];
    [super dealloc];
}


@end
