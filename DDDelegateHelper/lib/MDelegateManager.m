//
//  MDelegateManager.m
//  DDDelegateHelper
//
//  Created by Dave Dribin on 1/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MDelegateManager.h"


@interface NSMethodSignature (objctypes)
+(NSMethodSignature*)signatureWithObjCTypes:(const char*)types;
@end

@implementation MDelegateManager
-(id)init
{
	_proxiedObject=nil;
	_justResponded=NO;
	_logOnNoResponse=NO;
	return self;
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature *sig;
	sig=[[_proxiedObject class] instanceMethodSignatureForSelector:selector];
	if(sig==nil)
	{
		// sig=[NSMethodSignature signatureWithObjCTypes:"@^v^c"];		
        sig = [[NSObject class] instanceMethodSignatureForSelector: @selector(init)];
	}
	_justResponded=NO;
	return sig;
}

-(void)forwardInvocation:(NSInvocation*)invocation
{
	if(_proxiedObject==nil)
	{
		if(_logOnNoResponse)
			NSLog(@"Warning: proxiedObject is nil! This is a debugging message!");
		return;
	}
	if([_proxiedObject respondsToSelector:[invocation selector]])
	{
		[invocation invokeWithTarget:_proxiedObject];
		_justResponded=YES;
	}
	else if(_logOnNoResponse)
	{
		NSLog(@"Object \"%@\" failed to respond to delegate message \"%@\"! This is a debugging message.",[[self proxiedObject] class],NSStringFromSelector([invocation selector]));
	}
	return;
}

-(id)proxiedObject
{
	return _proxiedObject;
}

-(void)setProxiedObject:(id)proxied
{
	_proxiedObject=proxied; //do not retain- could create circular references
}

-(BOOL)justResponded
{
	return _justResponded;
}

-(void)setLogOnNoResponse:(BOOL)log
{
	_logOnNoResponse=log;
}

-(BOOL)logOnNoResponse
{
	return _logOnNoResponse;
}
@end