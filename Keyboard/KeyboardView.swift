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
            return letterKeyColor
        default:
            return controlKeyColor
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
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.bottom.equalTo(-5)
            make.leading.equalTo(3)
            make.trailing.equalTo(-3)
        }
        
        let row1 = "qwertzuiop".map { Key.letter($0) }
        let row2 = "asdfghjkl-".map { Key.letter($0) }
        let row3: [Key] = [.nextKeyboard] + "yxcvbnm".map({ .letter($0) }) + [.backspace]
        
        let rows = [row1, row2, row3].map { row -> UIStackView in
            
            let rowKeys = row.map { key -> KeyButton in
                let keyButton = KeyButton(key: key)
                keyButton.addTarget(self, action: #selector(keyPressed(sender:)), for: .touchUpInside)
                return keyButton
            }
            let rowStackView = UIStackView(arrangedSubviews: rowKeys)
            rowStackView.distribution = .equalCentering
            return rowStackView
        }
        
        let rowsStackView = UIStackView(arrangedSubviews: rows)
        rowsStackView.axis = .vertical
        rowsStackView.spacing = 11
        contentView.addSubview(rowsStackView)
        rowsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyPressed(sender: KeyButton) {
        delegate?.keyboardView(self, didTap: sender.key)
    }
}
