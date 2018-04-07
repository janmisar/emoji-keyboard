//
//  EmojiSuggestionCell.swift
//  Keyboard
//
//  Created by Jan Misar on 07.04.18.
//

import UIKit

class EmojiSuggestionCell: UICollectionViewCell {
    
    var emoji: Emoji? {
        didSet {
            emojiLabel.text = emoji?.char
            nameLabel.text = emoji?.names.first
        }
    }
    
    private weak var roundedView: UIView!
    private weak var emojiLabel: UILabel!
    private weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let roundedView = UIView()
        roundedView.layer.cornerRadius = 10
        roundedView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 3))
        }
        self.roundedView = roundedView
        
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
        roundedView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.leading.equalTo(4)
            make.top.bottom.equalToSuperview().inset(2)
        }
        self.emojiLabel = emojiLabel
        
        let nameLabel = UILabel()
        roundedView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(emojiLabel.snp.trailing).offset(2)
            make.top.bottom.equalToSuperview().inset(2)
            make.trailing.equalTo(-4)
        }
        self.nameLabel = nameLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                roundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            } else {
                roundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
            }
        }
    }
}
