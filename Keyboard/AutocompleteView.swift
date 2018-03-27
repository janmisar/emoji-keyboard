//
//  AutocompleteView.swift
//  Keyboard
//
//  Created by Jan Misar on 27.03.18.
//

import UIKit

final class AutocompleteView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var inputText: String? {
        didSet {
            emojis = inputText.flatMap({ EmojiService.emojis(for: $0) }) ?? []
            collectionView.reloadData()
        }
    }
    
    private var emojis: [Emoji] = []
    
    private weak var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 20)


        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.collectionView = collectionView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmojiSuggestionCell = collectionView.dequeueCell(for: indexPath)
        cell.emoji = emojis[indexPath.item]
        return cell
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: superview?.frame.size.width ?? 0, height: 100)
    }
}

class EmojiSuggestionCell: UICollectionViewCell {
    
    var emoji: Emoji? {
        didSet {
            emojiLabel.text = emoji?.char
            nameLabel.text = emoji?.names.first
        }
    }
    
    private weak var emojiLabel: UILabel!
    private weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let emojiLabel = UILabel()
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        self.emojiLabel = emojiLabel
        
        let nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(emojiLabel.snp.trailing)
            make.trailing.top.bottom.equalToSuperview()
        }
        self.nameLabel = nameLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
