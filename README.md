# MySports

## Installation

```sh
$ git clone https://github.com/sger/MySports
$ cd MySports
$ make bootstrap
$ make lint
$ make test
```

## Architecture

I opted to use a style of MVVM-C using Combine framework and for the UI I'm using UIKit and storyboards and also clean architecture. In addition the xcode project uses a modular approach in order to manage dependencies like models and common code for the main xcode project. The first thing is to exract commonly used code out of the main application target and into a module of its own. An example of this is the domain models in your application.

### Snapshot testing

I'm using Pointfree's Swift Snapshot Testing library for snapshot testing of the view controller. 

FYI: I ran the snapshot tests on the "iPhone 14 Pro" simulator. Unfortunately the snapshot library is not simulator agnostic, so if you use a different simulator there may well be mismatches.
