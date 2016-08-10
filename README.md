# GKActionSheetPicker

[![CI Status](http://img.shields.io/travis/Gruber Kristóf/GKActionSheetPicker.svg?style=flat)](https://travis-ci.org/Gruber Kristóf/GKActionSheetPicker)
[![Version](https://img.shields.io/cocoapods/v/GKActionSheetPicker.svg?style=flat)](http://cocoapods.org/pods/GKActionSheetPicker)
[![License](https://img.shields.io/cocoapods/l/GKActionSheetPicker.svg?style=flat)](http://cocoapods.org/pods/GKActionSheetPicker)
[![Platform](https://img.shields.io/cocoapods/p/GKActionSheetPicker.svg?style=flat)](http://cocoapods.org/pods/GKActionSheetPicker)

GKActionSheetPicker is an easy-to-use drop-in solution for selecting values from many choices. It presents an overlay sheet animating from bottom and lets the user select the desired value from a `UIPickerView` then either confirm it by selecting the positive button or dismiss it.

## Functions

- Easy-to-use
- Fits into iOS design
- Supports strings, dates
- Extendible (a country picker example boundled)
- Supports multi column
- Supports model-display pairs (for example it displays a string and returns the corresponding ID when selected)
- Black overlay above other elements
- Dismiss on tapping the overlay
- Highly customizable
- Supports all resolutions (including iPad and landscape)

Here's how it looks like:

![image](https://raw.githubusercontent.com/gklka/GKActionSheetPicker/master/doc/screenshot_sm.png)

## Try it yourself

[Try on Appetize.io](https://appetize.io/app/v50wvvd3bx2mt104dexq35zhhm?device=iphone6&scale=100&orientation=portrait&osVersion=9.3)

## Requirements

- iOS 7
- ARC, obviously

## Installation

GKActionSheetPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GKActionSheetPicker"
```

## Usage

First of all, import it:

```objectivec
#import <GKActionSheetPicker/GKActionSheetPicker.h>
```

Then you shoul have a strong reference, for example you can have a property:

```objectivec
@property (nonatomic, strong) GKActionSheetPicker *actionSheetPicker;
```

You can open it like this:

```objectivec
NSArray *items = @[@"Apple", @"Orange", @"Peach", @"Pearl", @"Tomato"];

self.actionSheetPicker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
    NSLog(@"Hello! The value is: %@", selected);
} cancelCallback:nil];
            
[self.actionSheetPicker presentPickerOnView:self.view];
```

That's all.

You have different class methods for creating multi column, date, and country pickers. See the `.h` file.

### Custom values

Items can be either strings or instances of `GKActionSheetPickerItem`. If you want to get a different thing when the user selects the value than the string which is displayed, you should use this object:

```objectivec
NSArray *items = @[
                   [GKActionSheetPickerItem pickerItemWithTitle:@"Apple" value:@0],
                   [GKActionSheetPickerItem pickerItemWithTitle:@"Orange" value:@1],
                   [GKActionSheetPickerItem pickerItemWithTitle:@"Peach" value:@2],
                   [GKActionSheetPickerItem pickerItemWithTitle:@"Pearl" value:@3],
                   [GKActionSheetPickerItem pickerItemWithTitle:@"Tomato" value:@4]
                   ];
```

If you are using strings, the a `GKActionSheetPickerItem` will be created with the same value as the title.

### Setting the current value

You are responsible for setting the current value of the picker. You can do it after the picker has been presented:

```objectivec
// Present it
[self.actionSheetPicker presentPickerOnView:self.view];
            
// Set to previously selected value
[self.actionSheetPicker selectValue:self.twoRowsSelectedStrings[0] inComponent:0];
[self.actionSheetPicker selectValue:self.twoRowsSelectedStrings[1] inComponent:1];
```

Note: There's different select function for each type of the picker, for example the single column picker uses the `-selectValue:` message.

### Delegate method

If you don't like the callbacks, you can use the short version of the class methods and implement `GKActionSheetPickerDelegate` on your class. The delegate will be notified about positive button taps (`-actionSheetPicker:didSelectValue:`), value changes without closing (`-actionSheetPicker:didChangeValue:`), and cancels (`-actionSheetPickerDidCancel:`). Set the `delegate` property to your class and implement any of these.

### Customization

| Property | Description |
| -------- | ----------- |
| `selectCallback` | The block to be called when user presses the positive button or taps outside the picker and `dismissType` is `GKActionSheetPickerDismissTypeSelect`. |
| `cancelCallback` | The block to be called when user presses the negative button or taps outside the picker and `dismissType` is `GKActionSheetPickerDismissTypeCancel`. |
| `selectButtonTitle` | Label on the positive button. Default: OK |
| `cancelButtonTitle` | Label on the negative button. Default: Cancel |
| `cancelButtonEnabled` | Display the negative button on the left or not. Default is `YES` |
| `dismissType` | Control what happens when the user taps outside the picker. Default: `GKActionSheetPickerDismissTypeNone` |
| `overlayLayerColor` | Color of the overlay layer above the picker. Default: transparent black. |
| `title` | The title of the picker which will be displayed in the center, between the buttons |

### More examples

See [the example](https://github.com/gklka/GKActionSheetPicker/blob/master/Example/GKActionSheetPicker/GKTableViewController.m) or the [header file](https://github.com/gklka/GKActionSheetPicker/blob/master/Pod/Classes/GKActionSheetPicker.h) for more options.

## Author

Gruber Kristóf, gk@lka.hu, [@gklka](http://twitter.com/gklka) on Twitter

## License

GKActionSheetPicker is available under the MIT license. See the LICENSE file for more info.
