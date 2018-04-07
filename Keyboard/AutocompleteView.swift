//
//  AutocompleteView.swift
//  Keyboard
//
//  Created by Jan Misar on 27.03.18.
//

import UIKit

protocol AutocompleteViewDelegate: class {
    func autocompleteView(_ autocompleteView: AutocompleteView, didSelectEmoji emoji: Emoji)
}

final class AutocompleteView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var delegate: AutocompleteViewDelegate?
    
    var inputText: String? {
        didSet {
            emojis = inputText.flatMap({ EmojiService.emojis(for: $0) }) ?? []
            collectionView.reloadData()
        }
    }
    
    private var emojis: [Emoji] = []
    
    private weak var collectionView: UICollectionView!
    
    var handle: NSKeyValueObservation!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewLeftAlignedLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.collectionView = collectionView
        
        let separator = UIView()
        separator.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1/UIScreen.main.scale)
        }
        
        handle = collectionView.observe(\UICollectionView.contentSize) { [weak self] _, _ in
            self?.invalidateIntrinsicContentSize()
            self?.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: CollectionView
    
    private static let prototypeCell: EmojiSuggestionCell = EmojiSuggestionCell(frame: .zero)
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = AutocompleteView.prototypeCell
        cell.emoji = emojis[indexPath.item]
        cell.layoutIfNeeded()
        let size = cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return CGSize(width: min(size.width, self.frame.width), height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojis[indexPath.item]
        delegate?.autocompleteView(self, didSelectEmoji: emoji)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: collectionView.contentSize.width, height: min(collectionView.contentSize.height, 102))
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
        
        let roundedView = UIView()
        roundedView.layer.cornerRadius = 10
        roundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
}
