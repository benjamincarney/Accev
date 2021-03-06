# Accev

A crowd-sourced iOS application for mapping out accessibility features among local businesses, buildings, and landmarks.

![](Accev.png) ![](Accev2.png)

For EECS 497: Human-Centered Software Design

Contributers: Connor Svrcek, Janet Vu, Casper Hsu, and Benjamin Carney

Supports: iOS 10.x and above

## Branches:

* master - stable app releases
* develop - development branch, merge your feature branches here

## Dependencies:

The project is using cocoapods for managing external libraries and a Gemfile for managing the cocoapods version.

Get Bundler

```
sudo gem install bundler
```

To install the specific cocoapods version run

```
bundle install
```

Then install the pods

```
bundle exec pod install
```

### Core Dependencies

* Swiftlint - A tool to enforce Swift style and conventions.
* R.swift - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects

## Project structure:

* Resources - fonts, strings, images, generated files etc.
* SupportingFiles - configuration plist files
* Models - model objects
* Modules - contains app modules (UI + Code)
* Helpers - protocols, extension and utility classes
