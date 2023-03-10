# MySports

## Getting Started

This repository contains the source code for the **MySports** application. To get things running:

1. Make sure [Homebrew](https://brew.sh) is installed:

1. Grab the code:
    ```sh
    $ git clone https://github.com/sger/MySports
    $ cd MySports
    ```
1. Bootstrap the application:
    ```sh
    $ make bootstrap
    ```
1. Open the Xcode project `App/MySports.xcodeproj`.
1. To run the client locally, select the `isowords` target in Xcode and run (`⌘R`).
1. To run the linter and the tests
    ```sh
    $ make lint
    $ make test
    ```

### Architecture

I opted to use a style of **MVVM-C** using apple's **Combine** framework and **Clean Architecture** and for the UI I'm using **UIKit** and **storyboards/XIB** files. The storyboard is using components in the format of XIB files. **Model-View-ViewModel** is a software design pattern that is structured to separate application logic and the UI. The Coordinator pattern provides an encapsulation of navigation logic and also is responsible to pass the view model into the view controller and to set up all the service layers.

- Domain models contain the data from the server.
- Models contain the business logic for the application.
- ViewModel is responsible to connect the view and model layers.
- View contains a collection of visible UI elements.

The swift package **Sports** contains the following products:

- **AppFeature** contains common code like router, coordinators logic.
- **Models** contains the data tranfer objects from the server.
- **Networking** the data tranfer service implemenation.

In clean architecture we have different layers:

- Presentation layer (MVVM)
- Domain layer (Business logic)
- Data Layer (Repositories)

The presentation layer contains UI like the view controller and the XIB files. For the coordination responsible are the view models which they are using use cases in order to execute network calls. The domain layer contains use cases and repositories interfaces. The data layer contains repositories implementations and data sources. Repositories are responsible for the passing the data and manage from different implemenation sources.

FYI: the **without-combine** branch uses a version without apple's combine implemention.

### Modularization

The application uses a modular approach to manage dependencies like models and common code for the main Xcode project. The first thing is to extract commonly used code out of the main application target and into a module of its own. An example of this is the domain models in your application. This allows us to work on features without building the entire application. An example:

```sh
$ cd MySports
$ swift package init
```

### Snapshot testing

I'm using Pointfree's swift Snapshot Testing library for snapshot testing of the view controller. 

FYI: I ran the snapshot tests on the "iPhone 14 Pro" simulator. Unfortunately the snapshot library is not simulator agnostic, so if you use a different simulator there may well be mismatches.
