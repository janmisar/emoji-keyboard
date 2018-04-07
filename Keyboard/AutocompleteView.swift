//
//  AutocompleteView.swift
//  Keyboard
//
//  Created by Jan Misar on 27.03.18.
//

import UIKit

let favorites = [
    "🙂", "😊", "😄", "😂", "😐", "😕", "😞", "😢",
    "🤔", "😏", "😮", "🙄", "😬", "😱", "😈", "😜",
    "❤️", "😍", "👻", "😎", "😠", "🤷‍♂️", "👎", "👍"
]

protocol AutocompleteViewDelegate: class {
    func autocompleteView(_ autocompleteView: AutocompleteView, didSelectEmoji emoji: Emoji)
    func autocompleteView(_ autocompleteView: AutocompleteView, didSelectEmoji emoji: String)
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
        
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let layout = UICollectionViewLeftAlignedLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.001)
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojis.count == 0 ? favorites.count : 0
        case 1:
            return emojis.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: FavoriteEmojiCell = collectionView.dequeueCell(for: indexPath)
            cell.emoji = Character(favorites[indexPath.item])
            return cell
        case 1:
            let cell: EmojiSuggestionCell = collectionView.dequeueCell(for: indexPath)
            cell.emoji = emojis[indexPath.item]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width/8, height: 35)
        case 1:
            let cell = AutocompleteView.prototypeCell
            cell.emoji = emojis[indexPath.item]
            cell.layoutIfNeeded()
            let size = cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            return CGSize(width: min(size.width, self.frame.width), height: size.height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let emoji = favorites[indexPath.item]
            delegate?.autocompleteView(self, didSelectEmoji: emoji)
        case 1:
            let emoji = emojis[indexPath.item]
            delegate?.autocompleteView(self, didSelectEmoji: emoji)
        default:
            break
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: collectionView.contentSize.width, height: min(collectionView.contentSize.height, 110))
    }
}

class FavoriteEmojiCell: UICollectionViewCell {
    var emoji: Character? {
        didSet {
            emojiLabel.text = emoji.map { String($0) }
        }
    }
    
    private weak var roundedView: UIView!
    private weak var emojiLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let roundedView = UIView()
        roundedView.layer.cornerRadius = 10
        contentView.addSubview(roundedView)
        roundedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.roundedView = roundedView
        
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
        emojiLabel.textAlignment = .center
        //emojiLabel.backgroundColor = UIColor.random()
        emojiLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.emojiLabel = emojiLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                roundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            } else {
                roundedView.backgroundColor = .clear
            }
        }
    }
}
