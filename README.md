# PPAssetsActionController

[![CI Status](http://img.shields.io/travis/pantuspavel/PPAssetsActionController.svg?style=flat)](https://travis-ci.org/pantuspavel/PPAssetsActionController)
[![codecov.io](https://codecov.io/gh/pantuspavel/PPAssetsActionController/branch/master/graphs/badge.svg)](https://codecov.io/gh/pantuspavel/PPAssetsActionController/branch/master)
[![Version](https://img.shields.io/cocoapods/v/PPAssetsActionController.svg?style=flat)](http://cocoapods.org/pods/PPAssetsActionController)
[![License](https://img.shields.io/cocoapods/l/PPAssetsActionController.svg?style=flat)](http://cocoapods.org/pods/PPAssetsActionController)
[![Platform](https://img.shields.io/cocoapods/p/PPAssetsActionController.svg?style=flat)](http://cocoapods.org/pods/PPAssetsActionController)
[![Swift Version](https://img.shields.io/badge/Swift-3.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Play with me ▶️🖐
If you want to play with me, just tap [here](https://appetize.io/app/r69q5w448qx8x3mryqc3d471zm?device=iphone6s&scale=75&orientation=portrait&osVersion=10.0) and enjoy! 🎩🕴


## Show me 🎪

![show-me](https://raw.githubusercontent.com/pantuspavel/PPAssetsActionController/master/Media/PPAssetsActionController.gif)

## Try me 📲
The easiest way to try me (make sure you read Requirements section first):
```ruby
pod try PPAssetsActionController
```

## Requirements 🖥

- 2 minutes of your time 😲
- [Xcode 8 or newer](https://developer.apple.com/download/)
- [Bundler](http://bundler.io/)
- [CocoaPods](http://cocoapods.org/)


## How to use me 🔩

It's super easy to start using PPAssetsActionController.

*Make sure to checkout example project that features quite a few usecases*

All you need to do is:
```
import PPAssetsActionController

func presentAssetsActionController() {
    let assetsPicker = PPAssetsActionController(with: [])
    present(assetsPicker, animated: true, completion: nil)
}
```


If you want to present couple of options, you do:
```
import PPAssetsActionController

func presentAssetsActionController() {
    let options = [
        PPOption(withTitle: option1String) { print("my option 1 callback") },
        PPOption(withTitle: option2String) { print("my option 2 callback") }
    ]
    let assetsPicker = PPAssetsActionController(with: options)
    present(assetsPicker, animated: true, completion: nil)
}
```


If you want to know what PPAssetsActionController has to say, become it's delegate:
```
import PPAssetsActionController

class CustomizationsViewController: UITableViewController {
    func presentAssetsActionController() {
        let options = [
            PPOption(withTitle: option1String) { print("my option 1 callback") },
            PPOption(withTitle: option2String) { print("my option 2 callback") }
        ]
        let assetsPicker = PPAssetsActionController(with: options)
        assetsPicker.deelgate = self
        present(assetsPicker, animated: true, completion: nil)
    }
}

extension CustomizationsViewController: PPAssetsActionControllerDelegate {
    /**
    Callbacks implementations you're interested in.
    */
}

```


If you want to customize PPAssetsActionController's appearance or behavior check out `PPAssetsActionConfig` struct and use it like this:
```
import PPAssetsActionController

func presentAssetsActionController() {
    let options = [
        PPOption(withTitle: option1String) { print("my option 1 callback") },
        PPOption(withTitle: option2String) { print("my option 2 callback") }
    ]
    var config = PPAssetsActionConfig()
    config.tintColor = UIColor.magenta
    let assetsPicker = PPAssetsActionController(with: options, aConfig: config)
    present(assetsPicker, animated: true, completion: nil)
}
```


## Localization 💪

Example project features complete localization to russian language including plurals.

If you want to check it out just run `PPAssetsActionController_Example_Rus` scheme.

For more info I suggest to check out [this nice tutorial](http://crunchybagel.com/localizing-plurals-in-ios-development/) by [Quentin Zervaas](https://github.com/HendX).

The article will put you up to speed with all intricacies of localization in no time.


## Example 🚀

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation 🤖

PPAssetsActionController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PPAssetsActionController'
```

PPAssetsActionController is also available through [Carthage](https://github.com/Carthage/Carthage).
Add the following line to your Cartfile:

```ruby
github "pantuspavel/PPAssetsActionController"
```

## Developer Setup 🤓

To open the project:
```bash
git clone git@github.com:pantuspavel/PPAssetsActionController.git
cd PPAssetsActionController
bundle
cd Example
pod install
open PPAssetsActionController.xcworkspace
```

## Feedback 👌

Feedback is very welcome. If you have an idea in mind don't hesitate to ping me on twitter [@pantusp](https://twitter.com/pantusp) or here.

Contributions are very welcome and encouraged. If you have something to say file an issue or open a PR to start a conversation going.

## Author 👋

Pavel Pantus, [@pantusp](https://twitter.com/pantusp), pantusp@gmail.com

## License 📖

PPAssetsActionController is available under the MIT license. See the LICENSE file for more info.
