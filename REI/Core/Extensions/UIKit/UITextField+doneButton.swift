//
//  UITextField+doneButton.swift
//  REI
//
//  Created by User on 09.06.2023.
//

import Foundation
import UIKit

extension UITextField {
    /// Adding a done button on the keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    /// Done button callback
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
