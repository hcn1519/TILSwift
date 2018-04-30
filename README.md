# Swift Code Snippet for iOS Application Development

## Table of contents

1. [Loop Through Multiple Arrays Simultaneously](https://github.com/hcn1519/iOS_Swift_Snippet#loop-through-multiple-arrays-simultaneously)
2. [Set Custom Decoder](https://github.com/hcn1519/iOS_Swift_Snippet#set-custom-decoder)
3. [Nested Enum](https://github.com/hcn1519/iOS_Swift_Snippet#nested-enum)
4. [UIImage With Insets](https://github.com/hcn1519/iOS_Swift_Snippet#uiimage-with-insets)
5. [Gradient Layer On UITableViewCell](https://github.com/hcn1519/iOS_Swift_Snippet#gradient-layer-on-uITableViewCell)
6. [Use Default Value in Protocol](https://github.com/hcn1519/iOS_Swift_Snippet#use-default-value-in-protocol)
7. [Handy Unwrapping Optionals](https://github.com/hcn1519/iOS_Swift_Snippet#nandy-unwrapping-optionals)
8. [Device Size Inspection](https://github.com/hcn1519/iOS_Swift_Snippet#device-size-inspection)

## Contents

### Loop Through Multiple Arrays Simultaneously

Use `zip` to do this.

```swift
let arr1 = ["hello", "world", "it", "is", "swift"]
let arr2 = [0, 1, 2, 3, 4]

// zip Method: zip(sequence1: Sequence, sequence2: Sequence)
for (str, num) in zip(arr1, arr2) {
    print("\(num): \(str)")
}
```

When looping through different lengths of sequences together, the loop is terminated based on a short-length array.

```swift
let arr1 = ["hello", "world", "it", "is", "swift"]
let dict1: [String: Int] = ["Hello": 0, "Swift": 1]

for (str, (key: key, value: value)) in zip(arr1, dict1) {
    print("\(str): \(value) - \(key)")
}
```

If you want to loop through triple or more? Do it like this. 😀

```swift
let arr1 = ["hello", "world", "it", "is", "swift"]
let arr2 = [0, 1, 2, 3, 4]
let arr3 = ["a", "b", "c", "d", "e"]

for (label, (str, num)) in zip(arr3, (zip(arr1, arr2))) {
    print("\(label), \(num): \(str)")
}
```

### Set Custom Decoder

Sometimes we need to initialize struct which conforms `Codable` protocol in different ways when initializing it.

For example, your struct has `Bool` type property, but your server API send that property with `Int` type. In this case, if your job is only for `decode`, it does not matters. However if you try to `encode` that property to `Bool` type, you will get in trouble. To resolve this kind of situation, you can give your `CodingUserInfo` to your `decoder` and initialize both cases.

1. Give your `decoder` some `userInfo` whatever you want.

```swift
let decoder = JSONDecoder()
if let userInfoKey = CodingUserInfoKey(rawValue: "type") {
    let codingUserInfo: [CodingUserInfoKey: Any] = [userInfoKey: "decodeJson"]
    decoder.userInfo = codingUserInfo
}
```

2. Use `userInfo` from `init(from decoder: Decoder)`

```swift
struct Computer: Codable {
  let isRunnig: Bool

  enum CodingKeys: String, CodingKey {
      case isRunnig = "isRunnig"
  }
}
extension Computer {
  init(from decoder: Decoder) throws {
      let codingKey = try decoder.container(keyedBy: CodingKeys.self)

      let isRunning: Bool = try {
        if let userInfo = decoder.userInfo[CodingUserInfoKey(rawValue: "type")!] as? String {
          if userInfo == "decodeJson" {
              let isRunningValue = try codingKey.decode(Int.self, forKey: .isRunnig)
              return isRunningValue == 1 ? true : false
          } else {
              return try codingKey.decode(Bool.self, forKey: .complete)
          }
        }
        return false
      }()
  }
}
```

### Nested Enum

You can use nested enum for complex situation. Here is an example. You have an editor for upload texts or images. And You want to keep track of your editor by using `ContentState` property. In this case, you can use `enum`. So your first approach will be like this.

```swift
class Editor {
  enum ContentState {
    case writingText, settingImage
  }

  var contentState: ContentState
}
```

After few weeks later, You have received a proposal for an editor with a new feature. For example, your editor only had Adding feature, but now it can edit or delete text or images. So, In this case you need to update your `ContentState`.

```swift
class Editor {
  enum ContentState {
      case addText, editText, deleteText, addImage, editImage, deleteImage
  }
  var contentState: ContentState
}
```
It's not that bad 🤔. But there are things that are not satisfactory. We know that text and images are clearly different. However, `ContentState` does not seperate those. In this case you can use `Nested Enum`. Here is new `ContentState`

```swift
class Editor {
  enum ContentState {
      enum TextType {
          case addText, editText, deleteText
      }
      enum ImageType {
          case addImage, editImage, deleteImage
      }
      case text(TextType)
      case image(ImageType)
      case none
  }
  var contentState: ContentState
}
```

Readability gets better! 😄. You now can see that `ContentState` has `TextType` or `ImageType` with each cases.

You can set your `contentState` property like this.

```swift
contentState = ContentState.image(.addImage)
```

And enum with `switch`,

```swift
switch contentState {
  case .text(.editText):
    break
  case .image(.setActorImage):
    break
  case .image(.setBackgroundImage):
    break
  case .image(.setMessageImage):
  default:
    break
}
```

### UIImage With Insets

There are some cases that Modifing `imageView`'s' frame not works. For example, if you want to set custom back image in `navigationBar`, you cannot move your image with your `leftBarButtonItem` frame. In this case you need to set inset of your image and move it.

Below `UIImage` extenstion is for modifing your image's inset.

```swift
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom),
            false, self.scale)
        guard UIGraphicsGetCurrentContext() != nil else { return UIImage() }
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        guard let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
```

#### Usage
```swift
let defaultImage = UIImage()
let insetImage = defaultImage.imageWithInsets(insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
```

### Gradient Layer On UITableViewCell

Adding `GradientLayer`(or some other subLayer) on `UITableViewCell` requires you to set `frame`. For example, if you want to set `GradientLayer` overlapping whole cell's frame, you need to specify `GradientLayer`'s frame. If you don't you will see some weird frame of `GradientLayer`.


```swift
extension UIView {
    func addGradient(with layer: CAGradientLayer, gradientFrame: CGRect? = nil, colorSet: [UIColor], locations: [Double]) {
        layer.frame = gradientFrame ?? self.bounds
        layer.frame.origin = .zero

        let layerColorSet = colorSet.map { $0.cgColor }
        let layerLocations = locations.map { $0 as NSNumber }

        layer.colors = layerColorSet
        layer.locations = layerLocations

        self.layer.insertSublayer(layer, above: self.layer)
    }
}
```

#### Usage

1. Make `CAGradientLayer` on your `UITableViewCell`.
```swift
class TableViewCell: UITableViewCell {}
    let gradientLayer = CAGradientLayer()
}
```

2. Set `func layoutSublayers(of:)` to use your layer as `UITableViewCell` as subLayer.

```swift
class TableViewCell: UITableViewCell {

    let gradientLayer = CAGradientLayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
    }
```

3. Call the extension above like this.

```swift
class TableViewCell: UITableViewCell {

    let gradientLayer = CAGradientLayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)

        // Gradient layer options
        let colorSet = [UIColor.sameRGB(divideBy255From: 255, alpha: 0.0),
                        UIColor.sameRGB(divideBy255From: 0, alpha: 0.4)]
        let location = [0.0, 1.0]

        // Add Gradient layer wherever you want.
        // ⚠️ Warning: Without setting gradient frame, you will get weird frame of your layer.
        backImageView.addGradient(with: gradientLayer, gradientFrame: self.frame, colorSet: colorSet, locations: location)
    }
}
```



### Use Default Value in Protocol

```swift
protocol Message {
    var content: String { get set }
    func updateContent(content: String?)
}
```

```swift
extension Message {
    func updateContent(content: String? = nil) {
        return updateContent(content: "No Content")
    }
}
```

#### Usage
```swift

struct MyMessage: Message {
    var content: String
}

let message1 = MyMessage(content: "Hello")
let message2 = MyMessage(content: "World")

```

### Handy Unwrapping Optionals


```swift
let helveticaNeueRegular = UIFont(name: "HelveticaNeue", size: 14) ?? UIFont()
let helveticaNeueBold = UIFont(name: "HelveticaNeue-Bold", size: 17) ?? UIFont()

// Type of helveticaNeueRegular and helveticaNeueBold is UIFont(not UIFont?)
```

### Device Size Inspection

```swift
import UIKit

extension UIDevice {

    public var isiPhoneSE: Bool {
        return checkDevice(type: .phone, resolution: CGSize(width: 320, height: 568))
    }

    public var isiPhonePlus: Bool {
        return checkDevice(type: .phone, resolution: CGSize(width: 736, height: 414))
    }

    public var isiPhoneX: Bool {
        return checkDevice(type: .phone, resolution: CGSize(width: 375, height: 812))
    }

    public var isiPad: Bool {
        return checkDevice(type: .pad, resolution: CGSize(width: 768, height: 1024))
    }

    public var isiPadPro105: Bool {
        return checkDevice(type: .pad, resolution: CGSize(width: 834, height: 1112))
    }

    public var isiPadPro12: Bool {
        return checkDevice(type: .pad, resolution: CGSize(width: 1024, height: 1366))
    }

    func checkDevice(type: UIUserInterfaceIdiom, resolution: CGSize) -> Bool {
        return (UIDevice.current.userInterfaceIdiom == type && (UIScreen.main.bounds.size.width == resolution.width && UIScreen.main.bounds.size.height == resolution.height))
    }
}
```

#### Usage

```swift
if UIDevice.current.isiPhoneX {
  // iPhoneX
} else if UIDevice.current.isiPhoneSE {
  // iPhoneSE
} else if UIDevice.current.isiPadPro105 {
  // iPad 10.5 inch
}
```
