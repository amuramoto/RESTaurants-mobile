//
//  UIImagePickerController+IXAdditions.h
//  Ignite_iOS_Engine
//
//  Created by Robert Walsh on 11/25/13.
//  Copyright (c) 2013 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (IXAdditions)

+(UIImagePickerControllerSourceType)stringToSourceType:(NSString*)sourceTypeString;
+(UIImagePickerControllerCameraDevice)stringToCameraDevice:(NSString*)cameraDeviceString;

@end
