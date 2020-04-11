//
//  KeyboardManager.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 11.04.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class KeyboardManager: NSObject {
    
    enum State {
        case show
        case hide
    }
        
    var keyboardWillChangeState: ((State, CGRect) -> Void)?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardWillChangeState?(State.show, keyboardSize)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardWillChangeState?(State.hide, keyboardSize)
            }
        }
    }
}
