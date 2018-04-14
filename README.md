# Swift Code Snippet for iOS Application Development

## Table of contents

1. [Loop Through Multiple Arrays Simultaneously](https://github.com/Luur/SwiftTips#1-safe-way-to-return-element-at-specified-index)

## Contents

### 1. Loop Through Multiple Arrays Simultaneously

Use `zip` to do this.

{% highlight swift %}
let arr1 = ["hello", "world", "it", "is", "swift"]
let arr2 = [0, 1, 2, 3, 4]

// zip Method: zip(sequence1: Sequence, sequence2: Sequence)
for (str, num) in zip(arr1, arr2) {
    // do something
    print("\(num): \(str)")
}
{% endhighlight %}

When looping sequences of different lengths together, the loop is terminated based on a short-length array.

{% highlight swift %}
let arr1 = ["hello", "world", "it", "is", "swift"]
let dict1: [String: Int] = ["Hello": 0, "Swift": 1]

for (str, (key: key, value: value)) in zip(arr1, dict1) {
    print("\(str): \(value) - \(key)")
}
{% endhighlight %}

If you want to loop through triple or more? Do it like this. 😀

{% highlight swift %}
let arr1 = ["hello", "world", "it", "is", "swift"]
let arr2 = [0, 1, 2, 3, 4]
let arr3 = ["a", "b", "c", "d", "e"]

for (label, (str, num)) in zip(arr3, (zip(arr1, arr2))) {
    print("\(label), \(num): \(str)")
}
{% endhighlight %}
