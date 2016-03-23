# HumanAPI iOS SDK - Human Connect

The purpose of this SDK is to handle the Human Connect popup to allow your users to easily authenticate their data within your application. Specifically, it handles the launch of and events from Human Connect, while passing on the `sessionTokenObject` to your server for secure token exchange.

### What's Here
- `HumanConnectViewController.[mh]`: browser based UI to launch Human Connect

## How To Use in Your Project
Check out the guide on our Developer Hub: http://hub.humanapi.co/docs/mobile-guide-ios

*see the `connectDemo` branch of this repository for an example project*

# Changelog

## 1.1 - 3/23/2016
* Added support for `language` and `mode`
* Fixed issue with opening external links

## 1.0 - 2/18/2016
* Added version numbers to the top of each file for tracking
* Removed pod dependencies from project to make integrations simpler
