//
//  EmojiService.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import Foundation

struct Emoji {
    let char: String
    let names: [String]
}

// TODO: deal with unsupported emoji https://stackoverflow.com/questions/41318999/is-there-a-way-to-know-if-an-emoji-is-supported-in-

class EmojiService {
    
    static let shared = EmojiService()
    
    static func emojis(for input: String, limit: Int = 100) -> [Emoji] {
        let filtered = allEmojis.filter { emoji in
            return !(emoji.names.filter { $0.contains(input) }.isEmpty)
        }
        return Array(filtered.prefix(limit))
    }
}
