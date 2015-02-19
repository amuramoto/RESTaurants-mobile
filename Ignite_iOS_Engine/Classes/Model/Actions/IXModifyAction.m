//
//  IXModifyAction.m
//  Ignite iOS Engine (IX)
//
//  Created by Robert Walsh on 10/15/13.
//  Copyright (c) 2013 Apigee, Inc. All rights reserved.
//

#import "IXModifyAction.h"

#import "IXSandbox.h"
#import "IXBaseObject.h"
#import "IXActionContainer.h"
#import "IXAppManager.h"
#import "IXViewController.h"
#import "IXNavigationViewController.h"
#import "IXLayout.h"
#import "IXBaseControl.h"
#import "IXBaseDataProvider.h"

// IXModifyAction Properties
static NSString* const kIXDuration = @"duration";
static NSString* const kIXAnimationStyle = @"animationStyle";

// kIXAnimationStyle Types
static NSString* const kIXEaseInOut = @"easeInOut";
static NSString* const kIXEaseIn = @"easeIn";
static NSString* const kIXEaseOut = @"easeOut";
static NSString* const kIXLinear = @"linear";

static NSString* const kIXStaggerDelay = @"staggerDelay";

@implementation IXModifyAction

-(void)modifyObjectID:(NSString *)objectID withOwnerObject:(IXBaseObject *)ownerObject withSandbox:(IXSandbox *)sandbox
{
    if( [objectID isEqualToString:kIX_SESSION] )
    {
        IXPropertyContainer* sessionProperties = [[IXAppManager sharedAppManager] sessionProperties];
        [sessionProperties addPropertiesFromPropertyContainer:[self parameterProperties] evaluateBeforeAdding:YES replaceOtherPropertiesWithTheSameName:YES];
        [[IXAppManager sharedAppManager] storeSessionProperties];
    }
    else if( [objectID isEqualToString:kIX_APP] )
    {
        IXPropertyContainer* appProperties = [[IXAppManager sharedAppManager] appProperties];
        [appProperties addPropertiesFromPropertyContainer:[self parameterProperties] evaluateBeforeAdding:YES replaceOtherPropertiesWithTheSameName:YES];
        [[IXAppManager sharedAppManager] applyAppProperties];
    }
    else
    {
        NSArray* objectsWithID = [sandbox getAllControlsAndDataProvidersWithID:objectID
                                                                withSelfObject:ownerObject];
        for( IXBaseObject* baseObject in objectsWithID )
        {
            [[baseObject propertyContainer] addPropertiesFromPropertyContainer:[self parameterProperties] evaluateBeforeAdding:YES replaceOtherPropertiesWithTheSameName:YES];
            
            [baseObject applySettings];
            
            if( [baseObject isKindOfClass:[IXBaseDataProvider class]] )
            {
                [((IXBaseDataProvider*)baseObject) loadData:NO];
            }
        }
    }
}

-(void)performModify
{
    NSArray* objectIDs = [[self actionProperties] getCommaSeperatedArrayListValue:kIX_TARGET defaultValue:nil];
    
    if( [objectIDs count] > 0 && [self parameterProperties] != nil )
    {
        IXBaseObject* ownerObject = [[self actionContainer] ownerObject];
        IXSandbox* sandbox = [ownerObject sandbox];
        for( NSString* objectID in objectIDs )
        {
            [self modifyObjectID:objectID withOwnerObject:ownerObject withSandbox:sandbox];
        }

        if( [[self parameterProperties] hasLayoutProperties] )
        {
            [[[[IXAppManager sharedAppManager] currentIXViewController] containerControl] layoutControl];
        }
        
        [self actionDidFinishWithEvents:nil];
    }
}

-(void)performStaggeredModifyWithDuration:(CGFloat)duration
                       withAnimationCurve:(UIViewAnimationCurve)animationCurve
                         withStaggerDelay:(CGFloat)staggerDelay
{
    NSArray* objectIDs = [[self actionProperties] getCommaSeperatedArrayListValue:kIX_TARGET defaultValue:nil];
    if( [objectIDs count] && [self parameterProperties] != nil )
    {
        IXBaseObject* ownerObject = [[self actionContainer] ownerObject];
        IXSandbox* sandbox = [ownerObject sandbox];
        CGFloat delay = 0.0f;
        for( NSString* objectID in objectIDs )
        {
            //[NSThread sleepForTimeInterval:1];
            [UIView animateWithDuration:duration
                                  delay:delay
                                options: animationCurve | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self modifyObjectID:objectID withOwnerObject:ownerObject withSandbox:sandbox];
                             } completion:nil];
            delay += staggerDelay;
        }
        
        if( [[self parameterProperties] hasLayoutProperties] )
        {
            [[[[IXAppManager sharedAppManager] currentIXViewController] containerControl] layoutControl];
        }
        
        [self actionDidFinishWithEvents:nil];
    }
}

-(void)execute
{
    CGFloat duration = [[self actionProperties] getFloatPropertyValue:kIXDuration defaultValue:0.0f];
    CGFloat staggerDelay = [self.actionProperties getFloatPropertyValue:kIXStaggerDelay defaultValue:0.0f];
    NSString *animationStyle = [[self actionProperties] getStringPropertyValue:kIXAnimationStyle defaultValue:nil];
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseInOut;

    if (animationStyle)
    {
        if ( [animationStyle isEqualToString:kIXEaseInOut] )
            animationCurve = UIViewAnimationCurveEaseInOut;
        else if ( [animationStyle isEqualToString:kIXEaseIn] )
            animationCurve = UIViewAnimationCurveEaseIn;
        else if ( [animationStyle isEqualToString:kIXEaseOut] )
            animationCurve = UIViewAnimationCurveEaseOut;
        else if ( [animationStyle isEqualToString:kIXLinear] )
            animationCurve = UIViewAnimationCurveLinear;
    }
    
    if( duration > 0.0f )
    {
        if (staggerDelay > 0)
        {
            [self performStaggeredModifyWithDuration:duration withAnimationCurve:animationCurve withStaggerDelay:staggerDelay];
        }
        else
        {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:duration
                                  delay:0.0f
                                options: animationCurve | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [weakSelf performModify];
                             } completion:nil];
        }
    }
    else
    {
        [self performModify];
    }
}

@end
