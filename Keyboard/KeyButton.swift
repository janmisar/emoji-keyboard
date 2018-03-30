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
        
        backgroundColor = keyboardBackgroundColor
        
        let shadowWrapper = UIView()
        shadowWrapper.isUserInteractionEnabled = false
        shadowWrapper.layer.shadowColor = KeyStyle.shadowColor
        shadowWrapper.layer.shadowOpacity = KeyStyle.shadowOpacity
        shadowWrapper.layer.shadowOffset = KeyStyle.shadowOffset
        shadowWrapper.layer.shadowRadius = KeyStyle.shadowRadius
        addSubview(shadowWrapper)
        shadowWrapper.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 5
        shadowWrapper.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(keysHorizontalSpacing_2)
            make.top.bottom.equalToSuperview().inset(keysVerticalSpacing_2)
        }
        self.backgroundView = backgroundView
        
        let label = UILabel()
        label.font = KeyStyle.font
        label.textColor = KeyStyle.textColor
        backgroundView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.label = label
        
        let iconView = UIImageView()
        iconView.tintColor = KeyStyle.textColor
        backgroundView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
