//
//  KeyButton.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import UIKit

class KeyButton: UIButton {

    private weak var backgroundView: UIView!
    weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 0
        
        let backgroundView = UIView()
        backgroundView.isUserInteractionEnabled = false
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 5
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-1)
        }
        self.backgroundView = backgroundView
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        backgroundView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.greaterThanOrEqualTo(6)
            make.trailing.bottom.lessThanOrEqualTo(-6)
        }
        self.label = label
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool{
        didSet {
            if isHighlighted {
                backgroundView.backgroundColor = UIColor(red: 172.0/255, green: 179.0/255, blue: 188.0/255, alpha: 1)
            } else {
                backgroundView.backgroundColor = .white
            }
        }
    }
}
