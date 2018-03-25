//
//  EmojiService.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import Foundation

struct Emoji: Codable {
    let content: String
    let short_names: [String]
    let keywords: [String]
}

class EmojiService {
    
    static let shared = EmojiService()
    
    let emojis: [Emoji]
    
    init() {
        
        let emojiData = try! Data(contentsOf: Bundle.main.url(forResource: "emoji", withExtension: "json")!)
        emojis = try! JSONDecoder().decode([Emoji].self, from: emojiData)
    }
}
