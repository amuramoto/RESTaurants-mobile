//
//  IXWeakTimerTarget.h
//  Ignite_iOS_Engine
//
//  Created by Robert Walsh on 2/24/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IXWeakTimerTarget;

@protocol IXWeakTimerTargetDelegate <NSObject>
@required
-(void)timerFired:(IXWeakTimerTarget*)timerTarget;
@end

@interface IXWeakTimerTarget : NSObject

@property (nonatomic,weak) id<IXWeakTimerTargetDelegate> delegate;

-(instancetype)initWithDelegate:(id<IXWeakTimerTargetDelegate>)delegate;
-(NSTimer*)createTimerWithInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats;

@end
