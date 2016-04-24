# LeeGo

[![CI Status](http://img.shields.io/travis/wangshengjia/LeeGo.svg?style=flat)](https://travis-ci.org/wangshengjia/LeeGo)
[![Version](https://img.shields.io/cocoapods/v/LeeGo.svg?style=flat)](http://cocoapods.org/pods/LeeGo)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Coverage](https://img.shields.io/codecov/c/github/wangshengjia/LeeGo.svg)](https://codecov.io/github/wangshengjia/LeeGo?branch=develop)
[![Platform](https://img.shields.io/badge/Platform-iOS-lightgray.svg?style=flat)](http://developer.apple.com)
[![Swift](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)

LeeGo is a lightweight Swift framework that helps you decouple & modularise your UI component into small pieces of LEGO style's bricks, to make UI development declarative, configurable and highly reusable.

## Rational behind
I’ve talked this once in my [blog post](https://medium.com/@victor_wang/build-your-cells-in-a-way-of-lego-fbf6a1133bb1#.ud8o1v5zl) and also on [dotSwift’s talk](http://www.thedotpost.com/2016/01/victor-wang-build-ios-ui-in-the-way-of-lego-bricks). Please checkout through for more details.

## Features

**What may LeeGo helps you:**

- **Describe** your whole UI into small pieces of Lego style’s bricks. Let you configure your view as a `brick` whenever & wherever you want.
- No longer need to deal with a bunch of custom UIView’s subclasses. Instead, you only need to deal with different `Brick`s which is **lightweight** and **pure value type**.
- Designed to be **UIKit friendly** and **non-intrusive**. There is no need to inherit from other base class at all.
- Capable to **update remotely** almost everything via your JSON payload.
- Built-in convenience methods to make **UIStackView like layout** hassle-free.
- Built-in **self-sizing mechanism** to calculate cell’s height automatically.
- Benefits from Swift’s enum, let you put the whole UI in a single enum file.

**Compare with Facebook ComponentKit**

Both:
- Brings declarative, configurable & reusable UI development for iOS.

Pros:
- Written in Swift, built for Swift. No more Obj-C++ stuff.
- Lightweight and UIKit friendly: no heritage, dealing with standard UIView and Auto Layout directly.
- Totally smooth to begin with integrating only a small part, also free to drop all without any side effect.
- Possible to update any part of UI which powered by LeeGo remotely via JSON payload
- Powered by standard auto layout which you probably familiar with already.

Cons:
- Lack of high level features for the moment. Such as support of built-in configurable view controller, view animation, auto layout animation or UIControl component’s action.
- Powered by standard auto layout which may have some potential performance issues in some circumstances.
- Still requires the basic knowledge of standard auto layout and [Visual Format Language](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html).

## Usages
#### Basic bricks

```swift
import LeeGo

/// Create a `Brick` instance which named "title" as UILabel, with default text "title" and zero `numberOfLines`
let titleBrick = "title".build(UILabel).style([.text("title"), .numberOfLines(0)])

/// Create an `UILabel` instance, then configure it just as title brick
let titleLabel = UILabel().configureAs(titleBrick)

```

#### More complex bricks

```swift
import LeeGo

/// Create the bricks inside cell brick
let titleBrick = "title".build(UILabel).style([.text("title"), .numberOfLines(0)])
let subtitleBrick = "subtitle".build(UILabel)
let imageBrick = "image".build(UIImageView).style([.ratio(1.5)]).width(68)

/// Create a brick stand for `UIView` which contains a `title`, a `subtitle` and an `image` inside, layout them with standard auto layout VFL.
let cellBrick = "cell".build().style([.backgroundColor(UIColor.whiteColor())])
    .bricks(titleBrick, subtitleBrick, imageBrick) { title, subtitle, image in
        Layout(["H:|-left-[\(title)]-spaceH-[\(image)]-right-|",
                "H:|-left-[\(subtitle)]-spaceH-[\(image)]",
                "V:|-top-[\(title)]-spaceV-[\(subtitle)]-(>=bottom)-|",
                "V:|-top-[\(image)]-(>=bottom)-|"], 
                LayoutMetrics(20, 20, 20, 20, 10, 10))
}

/// Dequeue a standard `UICollectionViewCell` instance, then configure it as cell brick with `element` as data source
let cell = collectionView.dequeueCell…
cell.configureAs(cellBrick, dataSource: element[indexPath.item])
```

#### UIStackView inspired layout

```swift
import LeeGo

/// Create the bricks inside cell brick
let titleBrick = "title".build(UILabel).style([.text("title"), .numberOfLines(0)])
let imageBrick = "image".build(UIImageView).style([.ratio(1.5)])

/// Create a brick stand for `UIView` which contains a `title` and an `image` inside, layout them with `UIStackView` inspired layout helper method.
let cellBrick = "cell".build().bricks(imageBrick, titleBrick) { 
    image, title, in
        Layout(bricks: [image, title], axis: .Vertical, align: .Fill, distribution: .Fill)
}

let cell = collectionView.dequeueCell…
cell.configureAs(cellBrick, dataSource: element[indexPath.item])
```

#### Union different bricks

```swift
import LeeGo

/// Union different bricks to a new brick with `UIStackView` style’s layout
let brick = Brick.union(brickName, bricks: [
                title,
                subtitle,
                Brick.union("blocks", bricks: [
                    redBlock.height(50),
                    greenBlock.height(80),
                    blueBlock.height(30)], axis: .Horizontal, align: .Top, distribution: .FillEqually, metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())])
                ], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
                
let view = UIView().configureAs(brick)
```

#### More complex brick and build with an enum

```swift
import LeeGo

/// An enum which implement `BrickBuilderType`, used to centralise all `bricks` design in a single enum file
enum TwitterBrickSet: BrickBuilderType {
    // leaf bricks
    case username, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, retweetCount, likeButton, likeCount
    
    // complex bricks
    case retweetView, likeView
    case accountHeader, toolbarFooter, retweetHeader
    
    // root bricks
    case standardTweet

    static let brickClass: [Twitter: AnyClass] = [username: UILabel.self, account: UILabel.self, avatar: UIImageView.self, tweetText: UITextView.self, …]
    
    func brick() -> Brick {
        switch self {
        case .username:
            return build().style([.font(UIFont.boldSystemFontOfSize(14))])
        case .account:
            return build().style([.font(UIFont.systemFontOfSize(14))])
        case .avatar:
            return build().style([.ratio(1), .backgroundColor(UIColor.lightGrayColor()), .cornerRadius(3)]).width(50)
        case .tweetText:
            return build().style([.scrollEnabled(false)])
        …
        case .standardTweet:
            return build().style([.backgroundColor(UIColor.whiteColor())])
                .bricks(
                    avatar.brick(),
                    accountHeader.brick(),
                    tweetText.brick(),
                    tweetImage.brick(),
                    toolbarFooter.brick()
                ) { (avatar, accountHeader, tweetText, image, toolbarFooter) in
                    Layout(["H:|-10-[\(avatar)]-10-[\(tweetText)]-10-|",
                        "H:[\(avatar)]-10-[\(accountHeader)]-10-|",
                        "H:[\(avatar)]-10-[\(image)]-10-|",
                        "H:[\(avatar)]-10-[\(toolbarFooter)]-10-|",
                        "V:|-10-[\(avatar)]-(>=10)-|",
                        "V:|-10-[\(accountHeader)]-10-[\(tweetText)]-10-[\(image)]-10-[\(toolbarFooter)]-(>=10)-|"])
            }
        }
    }
}

let cell = collectionView.dequeueCell…
cell.configureAs(TwitterBrickSet.standardTweet.brick(), dataSource: element[indexPath.item])
```

## Update UI remotely
`Brick` is designed to be JSON convertible, which makes possible that you can control your app’s interface, from tweak some UIKit appearances to create view/cell with brand new design **remotely** via JSON payload. Please check out “JSON encodable & decodable” for more details.

## Best practices
- Semantic > Reusable
- Maintainable
- Brick name convention

## Installation
#### Cocoapods
LeeGo is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod "LeeGo"
```
#### Carthage
To integrate LeeGo into your Xcode project using Carthage, specify it in your Cartfile:

```
github "wangshengjia/LeeGo"
```

Then, run the following command to build the LeeGo framework:

```
$ carthage update
```

At last, you need to set up your Xcode project manually to add the LeeGo framework.

## Vision & Roadmap

## References