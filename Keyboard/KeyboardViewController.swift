//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import UIKit
import SnapKit

let keys = ["qwertzuiop", "asdfghjkl", "yxcvbnm"]

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    weak var resultsLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        let resultsLabel = UILabel()
        view.addSubview(resultsLabel)
        resultsLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        self.resultsLabel = resultsLabel
        
        let rows = keys.map { row -> UIStackView in
            
            let rowKeys = row.map { char -> KeyButton in
                let keyButton = KeyButton()
                keyButton.label.text = String(char)
                keyButton.addTarget(self, action: #selector(keyPressed(sender:)), for: .touchUpInside)
                return keyButton
            }
            let rowStackView = UIStackView(arrangedSubviews: rowKeys)
            rowStackView.distribution = .equalSpacing
            return rowStackView
        }
        
        let rowsStackView = UIStackView(arrangedSubviews: rows)
        rowsStackView.axis = .vertical
        view.addSubview(rowsStackView)
        rowsStackView.snp.makeConstraints { make in
            make.top.equalTo(resultsLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    var typedText: String = "" {
        didSet {
            resultsLabel.text = EmojiService.shared.emojis.filter { emoji in
                return !(emoji.short_names.filter { $0.contains(typedText) }.isEmpty)
                }.map { $0.content }.joined(separator: "|")
        }
    }
    
    @objc func keyPressed(sender: KeyButton) {
        let letter = sender.label.text!
        typedText.append(letter)
        
        (textDocumentProxy as UIKeyInput).insertText(letter)
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
