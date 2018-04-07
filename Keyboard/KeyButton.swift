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
    
    var darkMode: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    let key: Key
    
    init(key: Key) {
        self.key = key
        super.init(frame: .zero)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.001) // not zero to be touchable
        
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
        
        updateAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppearance() {
        label.text = key.title
        label.textColor = darkMode ? KeyStyle.textColorDark : KeyStyle.textColor
        iconView.image = key.image
        iconView.tintColor = darkMode ? KeyStyle.textColorDark : KeyStyle.textColor
        backgroundView.backgroundColor = key.color(darkMode: darkMode)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundView.backgroundColor = key.color(darkMode: darkMode).darkened()
            } else {
                backgroundView.backgroundColor = key.color(darkMode: darkMode)
            }
        }
    }
}
