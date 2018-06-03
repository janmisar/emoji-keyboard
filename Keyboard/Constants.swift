//
//  Constants.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import ACKategories

let keySize = Device.size().keySize
let keysHorizontalSpacing_2 = 3
let keysVerticalSpacing_2 = 6

let keyboardBackgroundColor = UIColor(hex: 0xd2d5da)

enum KeyStyle {
    static let font = UIFont.systemFont(ofSize: 25, weight: .light)
    static let textColor = UIColor.black
    static let textColorDark = UIColor.white
    
    static let letterBackgroundColor = UIColor(hex: 0xffffff)
    static let letterBackgroundColorDark = UIColor(hex: 0x8F8F8F)
    
    static let controlBackgroundColor = UIColor(hex: 0xacb3bc)
    static let controlBackgroundColorDark = UIColor(hex: 0x747474)
    
    static let shadowColor = UIColor.black.cgColor
    static let shadowOpacity: Float = 0.35
    static let shadowOffset = CGSize(width: 0, height: 1.5)
    static let shadowRadius: CGFloat = 0
}

enum SoundCode: UInt32 {
    case letter = 1104
    case backspace = 1155
    case modifier = 1156
}
