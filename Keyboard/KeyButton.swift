//
//  KeyButton.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import UIKit

class KeyButton: UIButton {

    private weak var backgroundView: UIView!
    private weak var label: UILabel!
    private weak var iconView: UIImageView!
    
    var key: Key {
        didSet {
            set(key: key)
        }
    }
    
    init(key: Key) {
        self.key = key
        super.init(frame: .zero)
        
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 0
        
        snp.makeConstraints { make in
            make.height.equalTo(43)
        }
        
        let backgroundView = UIView()
        backgroundView.isUserInteractionEnabled = false
        backgroundView.layer.cornerRadius = 5
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-1)
        }
        self.backgroundView = backgroundView
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        backgroundView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(7)
            make.trailing.lessThanOrEqualTo(-7)
        }
        self.label = label
        
        let iconView = UIImageView()
        iconView.tintColor = .black
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.trailing.lessThanOrEqualTo(9)
            make.leading.greaterThanOrEqualTo(-9)
        }
        self.iconView = iconView
        
        set(key: key)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func set(key: Key) {
        label.text = key.title
        iconView.image = key.image
        backgroundView.backgroundColor = key.color
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundView.backgroundColor = key.color.darkened()
            } else {
                backgroundView.backgroundColor = key.color
            }
        }
    }
}
