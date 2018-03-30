//
//  Size.swift
//  Device
//
//  Created by Lucas Ortis on 30/10/2015.
//  Copyright © 2015 Ekhoo. All rights reserved.
//

public enum Size: Int, Comparable {
    case unknownSize = 0
    case screen3_5Inch
    case screen4Inch
    case screen4_7Inch
    case screen5_5Inch
    case screen5_8Inch
    case screen7_9Inch
    case screen9_7Inch
    case screen10_5Inch
    case screen12_9Inch
    
    var keySize: CGSize {
        switch self {
        case .screen4Inch: return CGSize(width: 26, height: 38)
        case .screen4_7Inch: return CGSize(width: 31.5, height: 42)
        case .screen5_5Inch: return CGSize(width: 35, height: 45)
        case .screen5_8Inch: return CGSize(width: 31.5, height: 42)
        default: return CGSize(width: 31.5, height: 42)
        }
    }
}

public func <(lhs: Size, rhs: Size) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func ==(lhs: Size, rhs: Size) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
