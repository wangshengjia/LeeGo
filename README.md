# LeeGo

[![CI Status](http://img.shields.io/travis/wangshengjia/LeeGo.svg?style=flat)](https://travis-ci.org/wangshengjia/LeeGo)
[![Coverage](https://img.shields.io/codecov/c/github/wangshengjia/LeeGo.svg)](https://codecov.io/github/wangshengjia/LeeGo?branch=develop)
[![Version](https://img.shields.io/cocoapods/v/LeeGo.svg?style=flat)](http://cocoapods.org/pods/LeeGo)
[![Platform](https://img.shields.io/badge/Platform-iOS-lightgray.svg?style=flat)](http://developer.apple.com)
[![Swift](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)

LeeGo is a lightweight but powerful library which helps you decouple & modularise your UI component into small pieces of LEGO style's bricks, to make UI development declarative, configurable and highly reusable.


## Features

**What can LeeGo helps you:**

- **Describe** your whole UI into small pieces of Lego style’s bricks. Let you configure your view as a `brick` whenever & wherever you want.
- No need any more to deal with a bunch of custom UIView’s subclasses. Instead, you only need to deal with different `Brick`s which is **lightweight and totally value type**.
- Designed to be **UIKit friendly and non-intrusive**. There is no need to inherit from other base class at all.
- Capable to **update remotely** almost everything via your JSON payload.
- Built-in convenience methods to make **UIStackView like layout** hassle-free.
- Built-in **self-sizing mechanism** to calculate cell’s height automatically.
- Benefits from Swift’s enum, let you put the whole UI in a single enum file.

**Compare with Facebook ComponentKit**

Both:
- Declarative, configurable & reusable UI development for iOS.

Pros:
- Written in Swift, built for Swift. No more Obj-C++ stuff.
- Lightweight and UIKit friendly: no heritage, dealing with standard UIView directly.
- Totally smooth to begin with integrating only a small part, also free to drop all without any side effect.
- Possible to update any part of UI which powered by LeeGo remotely via JSON payload
- Powered by standard auto layout which you probably familiar with already.

Cons:
- Lack of high level features. Such as support of built-in configurable view controller, animation or action.
- Powered by standard auto layout which may have some potential performance issues in some circumstances.

## Usages
#### Basic brick

```swift
/// create a `Brick` instance from `String`, named "title"
let titleBrick = "title".build(UILabel).style([.text("title"), .numberOfLines(0)])
/// create a UILabel instance as title brick
let titleLabel = UILabel().configureAs(titleBrick)

```

#### More complex brick

```swift
let titleBrick = "title".build(UILabel).style([.text("title"), .numberOfLines(0)])
let subtitleBrick = "subtitle".build(UILabel)
let imageBrick = "image".build(UIImageView).style([.ratio(1.5)]).width(68)

let cellBrick = "cell".build().style([.backgroundColor(UIColor.whiteColor())])
    .bricks(titleBrick, subtitleBrick, imageBrick) { title, subtitle, image in
        Layout(["H:|-left-[\(title)]-spaceH-[\(image)]-right-|",
                "H:|-left-[\(subtitle)]-spaceH-[\(image)]",
                "V:|-top-[\(title)]-spaceV-[\(subtitle)]-(>=bottom)-|",
                "V:|-top-[\(image)]-(>=bottom)-|"], 
                LayoutMetrics(20, 20, 20, 20, 10, 10))
}

let cell = collectionView.dequeueCell…
cell.configureAs(cellBrick, dataSource: element[indexPath.item])
```

#### UIStackView inspired layout

```swift
let titleBrick = "title".build(UILabel).style([.text("title"), .numberOfLines(0)])
let imageBrick = "image".build(UIImageView).style([.ratio(1.5)])

let cellBrick = "cell".build().bricks(imageBrick, titleBrick) { 
    image, title, in
        Layout(bricks: [image, title], axis: .Vertical, align: .Fill, distribution: .Fill)
}

let cell = collectionView.dequeueCell…
cell.configureAs(cellBrick, dataSource: element[indexPath.item])
```

#### Convenience functions for combine brick

```swift
Brick.union(brickName, bricks: [
                title.brick().style([.text("Showcase 1")]),
                description.brick().style(LeeGoShowcase.descriptionStyle + [.text("Layout 3 blocks with `Top` alignment and `FillEqually` distribution")]),
                Brick.union("blocks", bricks: [
                    redBlock.brick().height(50),
                    greenBlock.brick().height(80),
                    blueBlock.brick().height(30)], axis: .Horizontal, align: .Top, distribution: .FillEqually, metrics: LayoutMetrics(0, 0, 0, 0, 10, 10)).style([.backgroundColor(UIColor.brownColor())])
                ], axis: .Vertical, align: .Fill, distribution: .Fill, metrics: defaultMetrics)
```

#### More complex brick and build with an enum

```swift
enum TwitterBrickSet: BrickBuilderType {
  case username, account, avatar, tweetText, tweetImage, date, replyButton, retweetButton, retweetCount, likeButton, likeCount
    case retweetView, likeView
    case accountHeader, toolbarFooter, retweetHeader
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
```

## Best practices
- Semantic > Reusable
- Maintainable
- Brick name convention

## Installation

LeeGo is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LeeGo"
```
## Todo List

## References