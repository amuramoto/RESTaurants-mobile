ignite-iOS-engine
=================

Currently a work in progress, this engine is designed to parse JSON configuration files and generates native Objective-C objects, controls, and actions.

##PHP Preparser

A php preparser is used in the build process to parse int, float, and bool values, expand various shorthand implementations, and rewrite key:value paired controls to numbered array lists.

####Usage

 1. Ensure you have `php` >= 5.2.0 installed on your system.
 2. Pass a properly formatted iOS engine JSON file as an argument to *process.php* like so:
    `php process.php format_1.2.json`
 3. The preparser will append **_parsed** to the filename, and output the corrected file in the same directory.

---

##Todo List

####Buttons
- Add background touch/disabled colors

####Device properties
- ~~Fix up all except orientation to detect once at launch and not each time the function is called.~~

####Text/Text input

- Input constraints (lowercase, uppercase, regular expressions?)
- Inline styling / markdown?
- Wraparound/append/prepend text for input ("Email: bob@something.com" -- user typed bob@something.com, Email is prepended)
  - This should NOT affect the actual content of the input. Perhaps it draws a label on either side?
- Allow centering of text *on the text element* instead of the layout
- Allow setting height and width on text element and positioning text within (instead of having to test within a Layout) Alt: set line-height for text widget
- This: http://stackoverflow.com/questions/11259983/vertically-align-uilabel
- Set up a "next_id" - automatically focuses on specified target when next is pressed.
- set up "filter_datasource" for textInput - adds a hidden Refresh action that updates the filter on a datasource.
- [In portrait, keyboard is always swinging over from left of screen](http://stackoverflow.com/questions/3214548/ipad-keyboard-appears-in-wrong-orientation)
- Auto-sizing text

####Actions/Events:

- ~~Find a means of chaining actions together to avoid massive arrays of actions.~~
- ~~Ability to apply the same action to multiple IDs~~
- Ability to make touchable action area have a larger area than the element.
- ~~Change "id" in attributes field to "target" so it isn't so ambiguous~~
- ~~Why is "duration" under attributes and the target parameters under "parametesr"? Clean up and make it not ambiguous~~ : changed to "set"
- ~~Multiple even/action triggers for a single event on: [touch_up, touch_cancelled]~~
- ?? Change "None" (transition type) to "Default"
- Implement a built-in `UINavigationControllerDelegate` navigation style for slideout menus instead of manually building it in JSON.
- Alerts "Title" and "Text" instead of subtitle?
- Add "unwind on _____" (e.g. unwind on touch_up)
- darkens_image_on_touch actions working strangely around perimeter of device (40pt border) they don't work until you drag.
- listening to [[someID.that_ids_event]] for performing actions when other controls' events fire?
- Add separate action for variables, include UIImage/binary data too as type as well. Allow storing to local cache instead of RAM

e.g.

```
{
    "_type": "Set",
    "attributes": {
        "_target": "$session"
    },
    "on": "success",
    "set": {
        "emailAddress": "[[inputEmail.text]]"
    }
}
```

####Data:

- ~~Can we implement an option to auto-map entity_attributes so we don't need to specify them?~~
- ~~Perhaps a simpler way of coverting json into dict/array so we don't have to handle complex maps. As it is, it's really (uncessarily) convoluted~~
- ~~We should have simpler JSON serialization approach. Leave in complex stuff for fallback?~~
- ~~Perform actions directly in the on-load event of the datasource~~
- ~~Allow local/relative path data~~
- Allow for defining a basic data list inside JSON and using that as a datasource/tableview source
- Ability to add array objects as session variables with push, pop, unshift OR write to local JSON object?
- ~~Default auto_load: false (add new action for "load", "refresh")~~
- Ability to reference length of longest entry. For example:

    array = (asdf, asdfasdf, asdflkjlakjsdlkjsdf);
    array.maxlength (returns 19)

####Objects:

- Eventually plan to build a visualizer that identifies and audits elements. Need to be able to tell the difference between UI controls and content. If necessary, just make one a subclass of the other so we don't end up duplicating Obj-c
- Define Button type, other types (Image should actually be IMAGE not a button)
so we can apply different states (and have it auto-detect image based on -active -disabled, etc.). Also color overlay for different states (active: alpha:0, disabled:overlay-#FFFFFF, etc.)
- Allow background image on elements? With cover, contain, stretch, position/offset
- Change "images.default" to something simpler if there's only one image?

####Core:

- Properties need to be broken in to blocks rather than using underscores everywhere : partially completed
- ~~JSON should be true/false - parser should convert to YES/NO?~~
- Add into build parser a check for duplicate IDs? Or do we allow duplicate IDs?
- Mailbox style notification bar notices
- Ability to reload and reset all config
- Common naming convention/best practice for IDs
- Define a default inheritable style in _index (font, color, etc.)
- Support for raw retina position & dimension values (640px instead of 320pt)
- Rename AppConfig to something else not RFML like
- ~~Implement 'self' (or 'this') for actions and properties~~
- Support for multiple ongoing projects running off the same framework
- ~~swap "enabled: false" to "disabled: true" (industry standard)~~
- ~~update self in actions to target just "self" instead of having to use [[self._id]]~~- 
- ~~Ability to get x,y coordinates and width/height of control~~
- https://github.com/jaredsinclair/JSSlidingViewController and other awesome Jared Sinclair stuff here: https://github.com/jaredsinclair and in particular this: https://github.com/jaredsinclair/JTSSemanticReload
- **Add a default "toggle" event to all IXControls that sets toggles alpha and enabled**
- Need a deprecation method and a process for upgrading control properties.
- Fix up app level events and functions (currently only one for 'reset' needs to be implemented properly)

####Documentation:

- All of it. :| No seriously.

####Short-codes:

- ~~Clean up implementation (use industry standards like {{}})~~
- Regular expression validation : partially done
- Ability to use short-code methods on raw text w/out {{ }}
- ~~you can use {{ '[[id.text]]'.length }} - needs quotes. Or [[id.text:length]]~~

####Tables:

- Have a fade-out **option** for top and bottom (text fades as it slides out of view)
- Allow action to be applied to entire table cell
- Easy way of creating list objects? If not, data will do. How to implement local data sources? Should be able to define a local datasource directly in the table element
- variable height (Jared Sinclair)
- push, pop, unshift, check out Jared Sinclair stuff on GitHub.
- Should be able to manipulate local json *and* CoreData implementations in order to append and remove objects. Interface should be the same, instead we only need to specify "coredata": true/false
- Ability to [move items from one table to another](http://4.bp.blogspot.com/_B28NJpJ61hA/TQ9w0juGjKI/AAAAAAAAAR0/2oMl9Rleuic/s1600/CropperCapture%255B41%255D.Gif)
- Ability to programmatically manipulate a datasource (item.0:unshift, etc.)

####Formatting:
- need to properly define shorthand margin/padding etc.
- Define text styles in a separate file and reference them?
- Enhance tableview/Text to support horizontal formatting
- Default all elements to be 100% width or fill remaining width?
- change "layout_type" to "position"?

####Notes:

- ~~Visible YES/NO?? vs. Alpha 0? We should combine these~~

####Layouts:

- Default width should be 100%
- Improve layout_type to support right and left alignment; default shoudl be relative and wrap [one][besidethenext] (instead of requiring float and h_align right)
- [align_left] [align_right] <-- big deal, since this will improve scalability
- Think "anchors" and x,y distance from an anchor point. 0123456789 ??
- Fill remaining height/width (define a header and footer, say, and have middle body stretch to fit). Should go hand in hand with anchor layouts. (looks like this is done?)
- Add in struts?

####Images:

- Why are animated gif touch events disabled? IXImage line 110 for example.

####Styles:

- Programmatic font interface? else we include this in the docs- 
- horizontal/vertical_alignment screws up 100% h/w. Need to be more clear how this is performed (or if alignment is defined, either ignore height/width or include it in the calculation)
- Inheriting styles (default styles)- set default font, then it doesn't need to be defined (only font.size) (or color.text: inherit)
- add font.size separately so we can apply a default font at the app level.
- Ability to define font weights (font.weight: 300); defined at the app level

####Additional 3rd Party stuff
- OvershareKit?
- https://github.com/YannickL/YLMoment

####Navigation
- Option to save reference of viewController (for push pop navigation and saving state). This would require a "release" function on a view controller too.

####Image managemet, custom Camera, & Image Picker
- Add save to cache? ability to reference via [[$cache.<someId>]]
- add multiple qualities (or use resizemagick?)
- Ability to resize downloaded image (or even asset image using magick and have it store the lower res quality in the cache
- video (for imagePicker too)

####Bugs todo later
- Logging level -verbose causing action errors in Checkin app when taking photo. Investigate
- Checkin app post to IP address:port with binary image not working in simulator. Investigate
- Animate:spin stops working if app is backgrounded
- Setting a file path as a session variable and then loading it as an images.default path has a delay
