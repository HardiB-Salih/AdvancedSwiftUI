//
//  PasswordSecureField.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import SwiftUI

struct PasswordSecureField: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String
    var onEditingChanged: ((Bool) -> Void)?

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onEditingChanged: ((Bool) -> Void)?

        init(text: Binding<String>, onEditingChanged: ((Bool) -> Void)?) {
            _text = text
            self.onEditingChanged = onEditingChanged
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            onEditingChanged?(true)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            onEditingChanged?(false)
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onEditingChanged: onEditingChanged)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none // Set autocapitalization behavior
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

