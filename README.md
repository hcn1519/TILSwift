# Swift Code Snippet for iOS Application Development

## Table of contents

1. [Loop Through Multiple Arrays Simultaneously](https://github.com/hcn1519/iOS_Swift_Snippet#loop-through-multiple-arrays-simultaneously)

2. [Set Custom Decoder](https://github.com/hcn1519/iOS_Swift_Snippet#set-custom-decoder)
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

For example, your struct has 'Bool' type property, but your server API send that property with `Int` type. In this case, if your job is only for `decode` it does not matters. However if you try to `encode` that property to `Bool` type, you will get in trouble. To resolve this kind of situation, you can give your `CodingUserInfo` to your `decoder` and initialize both cases.

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
