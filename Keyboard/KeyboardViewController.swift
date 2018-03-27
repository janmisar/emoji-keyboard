//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Jan Misar on 25.03.18.
//

import UIKit
import SnapKit

let keys = ["qwertzuiop", "asdfghjkl", "yxcvbnm"]

class KeyboardViewController: UIInputViewController, KeyboardViewDelegate {

    weak var autocompleteView: AutocompleteView!
    weak var keyboardView: KeyboardView!
    
    override func loadView() {
        super.loadView()
        
        let autocompleteView = AutocompleteView()
        view.addSubview(autocompleteView)
        autocompleteView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        self.autocompleteView = autocompleteView
        
        let keyboardView = KeyboardView()
        view.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { make in
            make.top.equalTo(autocompleteView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        self.keyboardView = keyboardView
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardView.delegate = self
    }
    
    var typedText: String = "" {
        didSet {
            autocompleteView.inputText = typedText
        }
    }
    
    func keyboardView(_ keyboardView: KeyboardView, didTap key: Key) {
        switch key {
        case .letter(let char):
            typedText.append(char)
            (textDocumentProxy as UIKeyInput).insertText(String(char))
        case .backspace:
            if !typedText.isEmpty {
                typedText.remove(at: typedText.index(before: typedText.endIndex))
            }
            (textDocumentProxy as UIKeyInput).deleteBackward()
        case .nextKeyboard:
            advanceToNextInputMode()
        }
        
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }

}
