import Foundation

protocol Message {
    func updateContent(content: String?)
}

extension Message {
    func updateContent(content: String? = nil) {
        if let content = content {
            return updateContent(content: content)
        }
        return updateContent(content: "No Content")
    }
}

struct MyMessage: Message {
    var content: String
}

let message1 = MyMessage(content: "Hello")
let message2 = MyMessage(content: "World")

message1.updateContent()
message2.updateContent(content: "This is New Content")

print(message1.content) // No Content
print(message2.content) // This is New Content
