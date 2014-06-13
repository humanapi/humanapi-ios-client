# HumanAPI iOS Client

## What's inside

Overall folders description:

- `HumanAPI`: basic iOS client classes, can be used in other projects
- `HumanAPIDemo`: simple app which demonstrate client usage
- `HumanAPIClientTests`: tests folder

File named `Podfile` contains description of dependencies required for the client code. Processed by [CocoaPods](http://cocoapods.org/) dependency manager.

HumanAPI consists of two parts placed into respective files:

- `HumanAPIClient.[mh]`: client classes used to access Data API (requires access_token)
- `HumanAPIViewController.[mh]`: browser based UI for Authorize and Connect user flows 

## How to start demo

- Download files
- Install [CocoaPods](http://cocoapods.org/)
- `pod install` or `pod install --verbose` if you want to see details
- `open HumanAPIDemo.xcworkspace/`
- Hit _Cmd+R_ in XCode

## How to use in own project

- Add dependencies from `Podfile` to your project's `Podfile`
- `pod install`
- Drag-and-drop `HumanAPI` folder to your project tree through XCode
- Add `#import "HumanAPIViewController.h"` somewhere
- Rebuild your project

For HumanAPIClient usage examples see `HumanAPIClientTests/HumanAPIClientTests.m`

For HumanAPIViewController usage examples see `HumanAPIDemo/HumanAPIDemo/ViewController.m`