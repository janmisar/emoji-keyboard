//
//  KeyboardView.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import UIKit
import ACKategories
import AudioToolbox

enum Key {
    case letter(Character)
    case backspace
    case nextKeyboard
    
    var title: String? {
        switch self {
        case .letter(let char):
            return String(char)
        default:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .backspace:
            return #imageLiteral(resourceName: "backIcon")
        case .nextKeyboard:
            return #imageLiteral(resourceName: "globeIcon")
        default:
            return nil
        }
    }
    
    func color(darkMode: Bool) -> UIColor {
        switch self {
        case .letter(_):
            return darkMode ? KeyStyle.letterBackgroundColorDark : KeyStyle.letterBackgroundColor
        default:
            return darkMode ? KeyStyle.controlBackgroundColorDark : KeyStyle.controlBackgroundColor
        }
    }
}

protocol KeyboardViewDelegate: class {
    func keyboardView(_ keyboardView: KeyboardView, didTap key: Key)
}

class KeyboardView: UIView {

    weak var delegate: KeyboardViewDelegate?
    
    var mode: UIKeyboardAppearance = .default {
        didSet {
            switch mode {
            case .default, .light:
                allKeyButtons.forEach { $0.darkMode = false }
            case .dark:
                allKeyButtons.forEach { $0.darkMode = true }
            }
        }
    }
    
    private var allKeyButtons: [KeyButton] = []
    
    init(inputViewController: UIInputViewController) {
        super.init(frame: .zero)
        
        let forwardingView = ForwardingView()
        addSubview(forwardingView)
        forwardingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let charToKeyButton: (Character) -> KeyButton = { char in
            let key = Key.letter(char)
            
            let keyButton = KeyButton(key: key)
            keyButton.addTarget(self, action: #selector(self.keyPressed(sender:)), for: .touchUpInside)
            keyButton.addTarget(self, action: #selector(self.playKeySound(sender:)), for: .touchDown)
            keyButton.addTarget(self, action: #selector(self.setKeyHighlighted), for: [.touchDown, .touchDragEnter, .touchDragInside])
            keyButton.addTarget(self, action: #selector(self.setKeyNormal), for: [.touchDragExit, .touchUpInside])
            return keyButton
        }
        
        let keyButtons1 = "qwertzuiop".map(charToKeyButton)
        allKeyButtons += keyButtons1
        let row1 = UIStackView(arrangedSubviews: keyButtons1)
        row1.distribution = .fillEqually
        forwardingView.addSubview(row1)
        row1.snp.makeConstraints({ (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(keySize.height+11)
        })
        
        let keyButtons2 = "asdfghjkl".map(charToKeyButton)
        allKeyButtons += keyButtons2
        let row2 = UIStackView(arrangedSubviews: keyButtons2)
        forwardingView.addSubview(row2)
        row2.arrangedSubviews.forEach { $0.snp.makeConstraints { $0.width.equalTo(row1.arrangedSubviews.first!.snp.width) } }
        row2.snp.makeConstraints({ (make) in
            make.top.equalTo(row1.snp.bottom)
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(keySize.height+11)
        })
        
        let keyButtons3 = "yxcvbnm".map(charToKeyButton)
        allKeyButtons += keyButtons3
        let row3 = UIStackView(arrangedSubviews: keyButtons3)
        forwardingView.addSubview(row3)
        row3.arrangedSubviews.forEach { $0.snp.makeConstraints { $0.width.equalTo(row1.arrangedSubviews.first!.snp.width) } }
        row3.snp.makeConstraints({ (make) in
            make.top.equalTo(row2.snp.bottom)
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(keySize.height+11)
            make.bottom.equalToSuperview()
        })
        
        if inputViewController.needsInputModeSwitchKey {
            let nextKeyboardButton = KeyButton(key: .nextKeyboard)
            forwardingView.addSubview(nextKeyboardButton)
            nextKeyboardButton.snp.makeConstraints { make in
                make.leading.bottom.equalToSuperview()
                make.height.equalTo(keySize.height+11)
                make.trailing.equalTo(row3.snp.leading).offset(-4)
            }
            nextKeyboardButton.addTarget(inputViewController, action: #selector(UIInputViewController.handleInputModeList(from:with:)), for: .allTouchEvents)
            nextKeyboardButton.addTarget(self, action: #selector(self.playKeySound(sender:)), for: .touchDown)
            
            allKeyButtons.append(nextKeyboardButton)
        }
        
        let backspaceButton = KeyButton(key: .backspace)
        forwardingView.addSubview(backspaceButton)
        backspaceButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(keySize.height+11)
            make.leading.equalTo(row3.snp.trailing).offset(4)
        }
        backspaceButton.addTarget(self, action: #selector(self.keyPressed(sender:)), for: .touchUpInside)
        backspaceButton.addTarget(self, action: #selector(self.playKeySound(sender:)), for: .touchDown)
        allKeyButtons.append(backspaceButton)
        
        forwardingView.keys = allKeyButtons
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func keyPressed(sender: KeyButton) {
        delegate?.keyboardView(self, didTap: sender.key)
    }
    
    @objc private func playKeySound(sender: KeyButton) {
        switch sender.key {
        case .letter(_):
            DispatchQueue.global(qos: .default).async(execute: {
                AudioServicesPlaySystemSound(SoundCode.letter.rawValue)
            })
        case .backspace:
            DispatchQueue.global(qos: .default).async(execute: {
                AudioServicesPlaySystemSound(SoundCode.backspace.rawValue)
            })
        case .nextKeyboard:
            DispatchQueue.global(qos: .default).async(execute: {
                AudioServicesPlaySystemSound(SoundCode.modifier.rawValue)
            })
        }
    }
    
    @objc private func setKeyHighlighted(sender: KeyButton) {
        sender.isHighlighted = true
    }
    
    @objc private func setKeyNormal(sender: KeyButton) {
        sender.isHighlighted = false
    }
}
