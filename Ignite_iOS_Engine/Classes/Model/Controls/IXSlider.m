//
//  IXSlider.m
//  Ignite_iOS_Engine
//
//  Created by Robert Walsh on 2/10/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "IXSlider.h"

#import "NSString+IXAdditions.h"

// Slider Properties
static NSString* const kIXInitialValue = @"value.default";
static NSString* const kIXImagesThumb = @"thumbImage";
static NSString* const kIXImagesMinimum = @"image.min";
static NSString* const kIXImagesMaximum = @"image.max";
static NSString* const kIXMinimumValue = @"value.min";
static NSString* const kIXMaximumValue = @"value.max";
static NSString* const kIXImagesMaximumCapInsets = @"capInsets.max";
static NSString* const kIXImagesMinimumCapInsets = @"capInsets.min";

// Slider Read-Only Properties
static NSString* const kIXValue = @"value";

// Slider Events
static NSString* const kIXValueChanged = @"valueChanged";
static NSString* const kIXTouch = @"touch";
static NSString* const kIXTouchUp = @"touchUp";

// Slider Functions
static NSString* const kIXUpdateSliderValue = @"setValue"; // Params : "animated"

// NSCoding Key Constants
static NSString* const kIXValueNSCodingKey = @"value";

@interface IXSlider ()

@property (nonatomic,strong) UISlider* slider;
@property (nonatomic,assign,getter=isFirstLoad) BOOL firstLoad;
@property (nonatomic,strong) NSNumber* encodedValue;

@end

@implementation IXSlider

-(void)dealloc
{
    [_slider removeTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_slider removeTarget:self action:@selector(sliderDragStarted:) forControlEvents:UIControlEventTouchDown];
    [_slider removeTarget:self action:@selector(sliderDragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [_slider removeTarget:self action:@selector(sliderDragEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [_slider removeTarget:self action:@selector(sliderDragEnded:) forControlEvents:UIControlEventTouchCancel];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:[NSNumber numberWithFloat:[[self slider] value]] forKey:kIXValueNSCodingKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self setEncodedValue:[aDecoder decodeObjectForKey:kIXValueNSCodingKey]];
    }
    return self;
}

-(void)buildView
{
    [super buildView];

    _firstLoad = YES;
    
    _slider = [[UISlider alloc] initWithFrame:CGRectZero];
    
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderDragStarted:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(sliderDragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(sliderDragEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [_slider addTarget:self action:@selector(sliderDragEnded:) forControlEvents:UIControlEventTouchCancel];
    
    [[self contentView] addSubview:_slider];
}

-(CGSize)preferredSizeForSuggestedSize:(CGSize)size
{
    CGSize returnSize = [[self slider] sizeThatFits:size];
    return returnSize;
}

-(void)layoutControlContentsInRect:(CGRect)rect
{
    [[self slider] setFrame:rect];
}

-(void)applySettings
{
    [super applySettings];
    
    UIImage* maxImage = [UIImage imageNamed:[[self propertyContainer] getStringPropertyValue:kIXImagesMaximum defaultValue:nil]];
    if( maxImage )
    {
        NSString* maxInsetsString = [[self propertyContainer] getStringPropertyValue:kIXImagesMaximumCapInsets defaultValue:nil];
        if( maxInsetsString )
        {
            UIEdgeInsets maxEdgeInsets = UIEdgeInsetsFromString(maxInsetsString);
            maxImage = [maxImage resizableImageWithCapInsets:maxEdgeInsets];
        }
        [[self slider] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    }
    
    UIImage* minImage = [UIImage imageNamed:[[self propertyContainer] getStringPropertyValue:kIXImagesMinimum defaultValue:nil]];
    if( minImage )
    {
        NSString* minInsetsString = [[self propertyContainer] getStringPropertyValue:kIXImagesMinimumCapInsets defaultValue:nil];
        if( minInsetsString )
        {
            UIEdgeInsets minEdgeInsets = UIEdgeInsetsFromString(minInsetsString);
            minImage = [minImage resizableImageWithCapInsets:minEdgeInsets];
        }
        [[self slider] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    }
    
    UIImage* thumbImage = [UIImage imageNamed:[[self propertyContainer] getStringPropertyValue:kIXImagesThumb defaultValue:nil]];
    if( thumbImage )
    {
        [[self slider] setThumbImage:thumbImage forState:UIControlStateNormal];
    }
    
    [[self slider] setMinimumValue:[[self propertyContainer] getFloatPropertyValue:kIXMinimumValue defaultValue:0.0f]];
    [[self slider] setMaximumValue:[[self propertyContainer] getFloatPropertyValue:kIXMaximumValue defaultValue:1.0f]];

    if( [self isFirstLoad] )
    {
        [self setFirstLoad:NO];
        if( [self encodedValue] != nil )
        {
            [self updateSliderValueWithValue:[[self encodedValue] floatValue] animated:YES];
        }
        else
        {
            CGFloat initialSlideValue = [[self propertyContainer] getFloatPropertyValue:kIXInitialValue defaultValue:0.0f];
            [self updateSliderValueWithValue:initialSlideValue animated:YES];
        }
    }
}

-(void)sliderValueChanged:(UISlider*)slider
{
    [[self actionContainer] executeActionsForEventNamed:kIXValueChanged];
}

-(void)sliderDragStarted:(UISlider*)slider
{
    [[self actionContainer] executeActionsForEventNamed:kIXTouch];
}

-(void)sliderDragEnded:(UISlider*)slider
{
    [[self actionContainer] executeActionsForEventNamed:kIXTouchUp];
}

-(void)updateSliderValueWithValue:(CGFloat)sliderValue animated:(BOOL)animated
{
    [[self slider] setValue:sliderValue animated:animated];
    [self sliderValueChanged:[self slider]];
}

-(void)applyFunction:(NSString *)functionName withParameters:(IXPropertyContainer *)parameterContainer
{
    if( [functionName isEqualToString:kIXUpdateSliderValue] )
    {
        CGFloat sliderValue = [parameterContainer getFloatPropertyValue:kIXValue defaultValue:[[self slider] value]];
        BOOL animated = YES;
        if( parameterContainer ) {
            animated = [parameterContainer getBoolPropertyValue:kIX_ANIMATED defaultValue:animated];
        }
        [self updateSliderValueWithValue:sliderValue animated:animated];
    }
    else
    {
        [super applyFunction:functionName withParameters:parameterContainer];
    }
}

-(NSString*)getReadOnlyPropertyValue:(NSString *)propertyName
{
    NSString* returnValue = nil;
    if( [propertyName isEqualToString:kIXValue] )
    {
        returnValue = [NSString ix_stringFromFloat:[[self slider] value]];
    }
    else
    {
        returnValue = [super getReadOnlyPropertyValue:propertyName];
    }
    return returnValue;
}

@end
