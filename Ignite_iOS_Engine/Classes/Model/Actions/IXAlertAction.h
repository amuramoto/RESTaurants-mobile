//
//  IXAlertAction.h
//  Ignite iOS Engine (IX)
//
//  Created by Robert Walsh on 10/9/13.
//  Copyright (c) 2013 Apigee, Inc. All rights reserved.
//

/*
 
 ACTION
 
 - TYPE : "Alert"
 
 - PROPERTIES
 
    * name="confirm_button_title"    default="OK"        type="STRING"
    * name="shows_cancel_button"     default="NO"        type="BOOL"
    * name="cancel_button_title"     default="Cancel"    type="STRING"   notes="Only applied when "shows_cancel_button" is set to YES"
 
 - EVENTS
 
    * name="will_present_alert"          when="Occurs before alert is shown to user"
    * name="did_present_alert"           when="Occurs after the alert is shown to the user"
    * name="cancel_button_pressed"       when="Occurs when the cancel button is pressed"
    * name="confirm_button_pressed"      when="Occurs when the confirm button is pressed"
 
 */

#import "IXBaseAction.h"

@interface IXAlertAction : IXBaseAction

@end

@interface IXDevalertAction : IXAlertAction

@end
