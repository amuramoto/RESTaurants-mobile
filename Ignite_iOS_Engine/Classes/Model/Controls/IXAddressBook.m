//
//  IXAddressBook.m
//  Ignite_iOS_Engine
//
//  Created by Robert Walsh on 7/18/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "IXAddressBook.h"

#import "IXAppManager.h"
#import "IXNavigationViewController.h"
#import "NSString+IXAdditions.h"

@import AddressBook;
@import AddressBookUI;

// Attributes
IX_STATIC_CONST_STRING kIXNameFirst = @"name.first";
IX_STATIC_CONST_STRING kIXNameLast = @"name.last";
IX_STATIC_CONST_STRING kIXCompanyName = @"company.name";
IX_STATIC_CONST_STRING kIXCompanyTitle = @"company.title";
IX_STATIC_CONST_STRING kIXPhoneMobile = @"phone.mobile";
IX_STATIC_CONST_STRING kIXPhoneMain = @"phone.main";
IX_STATIC_CONST_STRING kIXEmailHome = @"email.home";
IX_STATIC_CONST_STRING kIXEmailWork = @"email.work";
IX_STATIC_CONST_STRING kIXUsernameTwitter = @"username.twitter";
IX_STATIC_CONST_STRING kIXUsernameLinkedIn = @"username.linkedIn";
IX_STATIC_CONST_STRING kIXUsernameFacebook = @"username.facebook";
IX_STATIC_CONST_STRING kIXURLHome = @"url.home";
IX_STATIC_CONST_STRING kIXURLHomePage = @"url.homePage";
IX_STATIC_CONST_STRING kIXURLWork = @"url.work";
IX_STATIC_CONST_STRING kIXURLLinkedIn = @"url.linkedIn";
IX_STATIC_CONST_STRING kIXURLFacebook = @"url.facebook";
IX_STATIC_CONST_STRING kIXNotes = @"notes";

// Attribute Accepted Values

// Attribute Defaults

// Returns
IX_STATIC_CONST_STRING kIXAccessGranted = @"isAllowed";

// Events
IX_STATIC_CONST_STRING kIXAddContactSuccess = @"success";
IX_STATIC_CONST_STRING kIXAddContactFailed = @"error";

// Functions
IX_STATIC_CONST_STRING kIXAddContact = @"addContact";

@interface IXAddressBook () <ABNewPersonViewControllerDelegate>

@property (nonatomic,assign) BOOL accessWasGranted;
@property (nonatomic,strong) NSString* firstName;
@property (nonatomic,strong) NSString* lastName;
@property (nonatomic,strong) NSString* companyName;
@property (nonatomic,strong) NSString* companyTitle;
@property (nonatomic,strong) NSString* mobilePhone;
@property (nonatomic,strong) NSString* mainPhone;
@property (nonatomic,strong) NSString* homeEmail;
@property (nonatomic,strong) NSString* workEmail;
@property (nonatomic,strong) NSString* twitterUsername;
@property (nonatomic,strong) NSString* linkedInUsername;
@property (nonatomic,strong) NSString* facebookUsername;
@property (nonatomic,strong) NSString* homeURL;
@property (nonatomic,strong) NSString* homePageURL;
@property (nonatomic,strong) NSString* workURL;
@property (nonatomic,strong) NSString* linkedInURL;
@property (nonatomic,strong) NSString* facebookURL;
@property (nonatomic,strong) NSString* notes;

@end

@implementation IXAddressBook

-(void)buildView
{
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        [self setAccessWasGranted:granted];
    });
}

-(void)applySettings
{
    [super applySettings];

    [self setFirstName:[[self propertyContainer] getStringPropertyValue:kIXNameFirst defaultValue:nil]];
    [self setLastName:[[self propertyContainer] getStringPropertyValue:kIXNameLast defaultValue:nil]];
    [self setCompanyName:[[self propertyContainer] getStringPropertyValue:kIXCompanyName defaultValue:nil]];
    [self setCompanyTitle:[[self propertyContainer] getStringPropertyValue:kIXCompanyTitle defaultValue:nil]];
    [self setMobilePhone:[[self propertyContainer] getStringPropertyValue:kIXPhoneMobile defaultValue:nil]];
    [self setMainPhone:[[self propertyContainer] getStringPropertyValue:kIXPhoneMain defaultValue:nil]];
    [self setHomeEmail:[[self propertyContainer] getStringPropertyValue:kIXEmailHome defaultValue:nil]];
    [self setWorkEmail:[[self propertyContainer] getStringPropertyValue:kIXEmailWork defaultValue:nil]];
    [self setTwitterUsername:[[self propertyContainer] getStringPropertyValue:kIXUsernameTwitter defaultValue:nil]];
    [self setLinkedInUsername:[[self propertyContainer] getStringPropertyValue:kIXUsernameLinkedIn defaultValue:nil]];
    [self setFacebookUsername:[[self propertyContainer] getStringPropertyValue:kIXUsernameFacebook defaultValue:nil]];
    [self setHomeURL:[[self propertyContainer] getStringPropertyValue:kIXURLHome defaultValue:nil]];
    [self setHomePageURL:[[self propertyContainer] getStringPropertyValue:kIXURLHomePage defaultValue:nil]];
    [self setWorkURL:[[self propertyContainer] getStringPropertyValue:kIXURLWork defaultValue:nil]];
    [self setLinkedInURL:[[self propertyContainer] getStringPropertyValue:kIXURLLinkedIn defaultValue:nil]];
    [self setFacebookURL:[[self propertyContainer] getStringPropertyValue:kIXURLFacebook defaultValue:nil]];
    [self setNotes:[[self propertyContainer] getStringPropertyValue:kIXNotes defaultValue:nil]];
}

-(NSString *)getReadOnlyPropertyValue:(NSString *)propertyName
{
    NSString* returnValue = nil;
    if( [propertyName isEqualToString:kIXAccessGranted] )
    {
        returnValue = [NSString ix_stringFromBOOL:[self accessWasGranted]];
    }
    else
    {
        returnValue = [super getReadOnlyPropertyValue:propertyName];
    }
    return returnValue;
}

+(NSDictionary*)createSocialDictionaryWithServiceType:(NSString*)serviceType andUserName:(NSString*)userName
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithObject:(NSString*)serviceType forKey:(NSString*)kABPersonSocialProfileServiceKey];
    [dictionary setObject:userName forKey:(NSString*)kABPersonSocialProfileUsernameKey];
    return dictionary;
}

-(void)applyFunction:(NSString *)functionName withParameters:(IXPropertyContainer *)parameterContainer
{
    if( [self accessWasGranted] && [functionName isEqualToString:kIXAddContact] )
    {
        ABRecordRef person = ABPersonCreate();

        if( [self firstName] )
            ABRecordSetValue(person, kABPersonFirstNameProperty,(__bridge CFStringRef)[self firstName], NULL);
        if( [self lastName] )
            ABRecordSetValue(person, kABPersonLastNameProperty,(__bridge CFStringRef)[self lastName], NULL);
        if( [self companyName] )
            ABRecordSetValue(person, kABPersonOrganizationProperty,(__bridge CFStringRef)[self companyName], NULL);
        if( [self companyTitle] )
            ABRecordSetValue(person, kABPersonJobTitleProperty,(__bridge CFStringRef)[self companyTitle], NULL);
        if( [self notes] )
            ABRecordSetValue(person, kABPersonNoteProperty, (__bridge CFStringRef)[self notes], NULL);

        if( [self mobilePhone] )
        {
            ABMutableMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);

            if( [self mobilePhone] )
                ABMultiValueAddValueAndLabel(phones, (__bridge CFTypeRef)([self mobilePhone]), kABPersonPhoneMobileLabel, NULL);
            if( [self mainPhone] )
                ABMultiValueAddValueAndLabel(phones, (__bridge CFTypeRef)([self mainPhone]), kABPersonPhoneMainLabel, NULL);

            ABRecordSetValue(person, kABPersonPhoneProperty, phones, NULL);
            CFRelease(phones);
        }

        if( [self workEmail] || [self homeEmail] )
        {
            ABMutableMultiValueRef emails = ABMultiValueCreateMutable(kABMultiStringPropertyType);

            if( [self workEmail] )
                ABMultiValueAddValueAndLabel(emails, (__bridge CFTypeRef)([self workEmail]), kABWorkLabel, NULL);
            if( [self homeEmail] )
                ABMultiValueAddValueAndLabel(emails, (__bridge CFTypeRef)([self homeEmail]), kABHomeLabel, NULL);

            ABRecordSetValue(person, kABPersonEmailProperty, emails, NULL);
            CFRelease(emails);
        }

        if( [self linkedInURL] || [self facebookURL] || [self homeURL] || [self workURL] || [self homePageURL] )
        {
            ABMutableMultiValueRef urls = ABMultiValueCreateMutable(kABMultiStringPropertyType);

            if( [self linkedInURL] )
                ABMultiValueAddValueAndLabel(urls, (__bridge CFTypeRef)([self linkedInURL]), kABPersonSocialProfileServiceLinkedIn, NULL);
            if( [self facebookURL] )
                ABMultiValueAddValueAndLabel(urls, (__bridge CFTypeRef)([self facebookURL]), kABPersonSocialProfileServiceFacebook, NULL);
            if( [self homePageURL] )
                ABMultiValueAddValueAndLabel(urls, (__bridge CFTypeRef)([self homePageURL]), kABPersonHomePageLabel, NULL);
            if( [self workURL] )
                ABMultiValueAddValueAndLabel(urls, (__bridge CFTypeRef)([self workURL]), kABWorkLabel, NULL);
            if( [self homeURL] )
                ABMultiValueAddValueAndLabel(urls, (__bridge CFTypeRef)([self homeURL]), kABHomeLabel, NULL);

            ABRecordSetValue(person, kABPersonURLProperty, urls, NULL);
            CFRelease(urls);
        }

        if( [self facebookUsername] || [self twitterUsername] || [self linkedInUsername] )
        {
            ABMutableMultiValueRef multiSocial =  ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);

            if( [self facebookUsername] )
            {
                NSDictionary* dictionary = [IXAddressBook createSocialDictionaryWithServiceType:(NSString*)kABPersonSocialProfileServiceFacebook andUserName:[self facebookUsername]];
                ABMultiValueAddValueAndLabel(multiSocial, (__bridge CFTypeRef)(dictionary), kABPersonSocialProfileServiceFacebook, NULL);
            }
            if( [self linkedInUsername] )
            {
                NSDictionary* dictionary = [IXAddressBook createSocialDictionaryWithServiceType:(NSString*)kABPersonSocialProfileServiceLinkedIn andUserName:[self linkedInUsername]];
                ABMultiValueAddValueAndLabel(multiSocial, (__bridge CFTypeRef)(dictionary), kABPersonSocialProfileServiceLinkedIn, NULL);
            }
            if( [self twitterUsername] )
            {
                NSDictionary* dictionary = [IXAddressBook createSocialDictionaryWithServiceType:(NSString*)kABPersonSocialProfileServiceTwitter andUserName:[self twitterUsername]];
                ABMultiValueAddValueAndLabel(multiSocial, (__bridge CFTypeRef)(dictionary), kABPersonSocialProfileServiceTwitter, NULL);
            }

            ABRecordSetValue(person, kABPersonSocialProfileProperty, multiSocial, nil);
            CFRelease(multiSocial);
        }

        ABNewPersonViewController *newPersonController = [[ABNewPersonViewController alloc] init];
        [newPersonController setNewPersonViewDelegate:self];
        [newPersonController setDisplayedPerson:person];

        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newPersonController];
        [[[IXAppManager sharedAppManager] rootViewController] presentViewController:navController animated:YES completion:nil];
    }
    else
    {
        [super applyFunction:functionName withParameters:parameterContainer];
    }
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [[[IXAppManager sharedAppManager] rootViewController] dismissViewControllerAnimated:YES completion:^{
        if( person == NULL )
        {
            [[self actionContainer] executeActionsForEventNamed:kIXAddContactFailed];
        }
        else
        {
            [[self actionContainer] executeActionsForEventNamed:kIXAddContactSuccess];
        }
    }];
}

@end
