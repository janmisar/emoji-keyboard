//
//  KeyboardView.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import UIKit
import ACKategories

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
    
    var color: UIColor {
        switch self {
        case .letter(_):
            return KeyStyle.letterBackgroundColor
        default:
            return KeyStyle.controlBackgroundColor
        }
    }
}

protocol KeyboardViewDelegate: class {
    func keyboardView(_ keyboardView: KeyboardView, didTap key: Key)
}

class KeyboardView: UIView {

    weak var delegate: KeyboardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let charToKeyButton: (Character) -> KeyButton = { char in
            let key = Key.letter(char)
            
            let keyButton = KeyButton(key: key)
            keyButton.addTarget(self, action: #selector(self.keyPressed(sender:)), for: .touchUpInside)
            return keyButton
        }
        
        let row1 = UIStackView(arrangedSubviews: "qwertzuiop".map(charToKeyButton))
        row1.distribution = .fillEqually
        addSubview(row1)
        row1.snp.makeConstraints({ (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(keySize.height+11)
        })
        
        
        let row2 = UIStackView(arrangedSubviews: "asdfghjkl".map(charToKeyButton))
        addSubview(row2)
        row2.arrangedSubviews.forEach { $0.snp.makeConstraints { $0.width.equalTo(row1.arrangedSubviews.first!.snp.width) } }
        row2.snp.makeConstraints({ (make) in
            make.top.equalTo(row1.snp.bottom)
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(keySize.height+11)
        })
        
        let row3 = UIStackView(arrangedSubviews: "yxcvbnm".map(charToKeyButton))
        addSubview(row3)
        row3.arrangedSubviews.forEach { $0.snp.makeConstraints { $0.width.equalTo(row1.arrangedSubviews.first!.snp.width) } }
        row3.snp.makeConstraints({ (make) in
            make.top.equalTo(row2.snp.bottom)
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(keySize.height+11)
            make.bottom.equalToSuperview()
        })
        
        let nextKeyboardButton = KeyButton(key: .nextKeyboard)
        addSubview(nextKeyboardButton)
        nextKeyboardButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(keySize.height+11)
            make.trailing.equalTo(row3.snp.leading).offset(-4)
        }
        nextKeyboardButton.addTarget(self, action: #selector(self.keyPressed(sender:)), for: .touchUpInside)
        
        let backspaceButton = KeyButton(key: .backspace)
        addSubview(backspaceButton)
        backspaceButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(keySize.height+11)
            make.leading.equalTo(row3.snp.trailing).offset(4)
        }
        backspaceButton.addTarget(self, action: #selector(self.keyPressed(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyPressed(sender: KeyButton) {
        delegate?.keyboardView(self, didTap: sender.key)
    }
}
