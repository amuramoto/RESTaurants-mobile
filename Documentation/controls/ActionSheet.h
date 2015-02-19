//
//  ActionSheet.ixdoc
//  Documentation
//  Ignite_iOS_Engine
//
//  Created by Jeremy Anticouni on 2/6/2015.
//  Copyright (c) 2015 Ignite. All rights reserved.
//

/** Native iOS UI control that displays a menu from the bottom of the screen.
*/

@implementation ActionSheet

/***************************************************************/

/** ActionSheet has the following attributes:
 
 @param style Style of sheet<ul><li>*default*</li><li>automatic</li><li>black.translucent</li><li>black.opaque</li></ul>
 @param buttons.cancel Text displayed on cancel button<br><code>string</code> *Cancel*
 @param buttons.others Text displayed on other buttons (comma-separated)<br><code>string</code>
 @param buttons.destructive Text displayed on the destructive (red) button<br><code>string</code>
 @param title Title of sheet<br><code>string</code>
 
 */

-(void)Attributes
{
}
/***************************************************************/
/***************************************************************/

/** ActionSheet has the following events:
 
 @param %@ A named (other) button was pressed
 @param cancelled The cancel button was pressed
 
 */

-(void)Events
{
}
/***************************************************************/
/***************************************************************/

/** ActionSheet has the following functions:
 
 @param dismiss Dismisses the action sheet
 <pre class=""brush: js; toolbar: false;"">
 
 
 
 </pre>
 
 @param present Presents the action sheet
 <pre class=""brush: js; toolbar: false;"">
 
 
 
 </pre>
 
 */

-(void)Functions
{
}
/***************************************************************/
/***************************************************************/

/** ActionSheet returns 42 values.
 
 */

-(void)Returns
{
}
/***************************************************************/
/***************************************************************/

/** Go on, try it out!
 
 <pre class="brush: js; toolbar: false;">
{
    "_id": "actionSheetTest",
    "_type": "ActionSheet",
    "actions": [
        {
            "_type": "Alert",
            "attributes": {
                "title": "Cancel Pressed"
            },
            "on": "cancel"
        },
        {
            "_type": "Alert",
            "attributes": {
                "title": "other pressed [[app.bundle.version]]"
            },
            "on": "other"
        },
        {
            "_type": "Alert",
            "attributes": {
                "title": "someOther2 pressed"
            },
            "on": "someOther2"
        },
        {
            "_type": "Alert",
            "attributes": {
                "title": "destructiveButtonTitle pressed"
            },
            "on": "destructive"
        }
    ],
    "attributes": {
        "buttons.cancel": "cancelButtonTitle",
        "buttons.destructive": "destructiveButtonTitle",
        "buttons.others": "other,someOther2",
        "style": "black.opaque",
        "title": "sheetTitle"
    }
}
 </pre>
 */

-(void)Example
{
}

/***************************************************************/

@end