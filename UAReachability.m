//
//  UAReachability.m
//  ReachTest
//
//  Created by Owain Hunt on 10/01/2011.
//  Copyright 2011 Owain R Hunt. All rights reserved.
//

#import "UAReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation UAReachability

static void reachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
	//[[NSNotificationCenter defaultCenter] postNotificationName:UAGithubReachabilityStatusDidChangeNotification object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:nowReachable] forKey:@"isReachable"]];
	[[NSNotificationCenter defaultCenter] postNotificationName:UAGithubReachabilityStatusDidChangeNotification object:(UAReachability *)info];

}


- (id)init
{
	if (self = [super init])
	{
		reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [@"www.github.com" UTF8String]);
		SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
		SCNetworkReachabilitySetCallback(reachabilityRef, reachabilityCallback, &context);
		SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
	}
	
	return self;
}	


- (NetworkStatus)currentReachabilityStatus
{
	SCNetworkReachabilityFlags flags;
	return (SCNetworkReachabilityGetFlags(reachabilityRef, &flags) && (flags & kSCNetworkReachabilityFlagsReachable) && !(flags & kSCNetworkReachabilityFlagsConnectionRequired));
}


- (NetworkStatus)networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	return (flags & kSCNetworkReachabilityFlagsReachable) && !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
}
										   

@end