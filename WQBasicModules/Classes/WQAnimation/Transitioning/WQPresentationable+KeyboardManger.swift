//
//  WQprens+KeyboardManger.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2019/1/20.
//

import Foundation

// MARK: - keyboard
public extension WQPresentationable {
    func addKeyboardObserver() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self,
                                  selector: #selector(keyboardWillChangeFrame(_:)),
                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                  object: nil)
        defaultCenter.addObserver(self,
                                  selector: #selector(keyboardDidChangeFrame(_:)),
                                  name: UIResponder.keyboardDidChangeFrameNotification,
                                  object: nil)
    }
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    @objc
    func keyboardWillChangeFrame(_ note: Notification) {
        keyboardChangeAnimation(note: note)
    }
    @objc
    func keyboardDidChangeFrame(_ note: Notification) {
        keyboardChangeAnimation(note: note)
    }
    private func keyboardChangeAnimation(note: Notification) {
        if contentViewInputs.isEmpty {
            contentViewInputs = self.containerView.subtextFieldViews
        }
        guard let textField = contentViewInputs.first(where: { textField -> Bool in
            if let inputView = textField as? UIResponder {
                return inputView.isFirstResponder
            }
            return false
        }),
            let inputView = textField as? UIView,
            let inputSuperView = inputView.superview else {
                return
        }
        guard let keyboardF = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ,
            let options = note.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationOptions,
            let keyWindow = UIApplication.shared.keyWindow else {
                return
        }
        let contentF = inputSuperView.convert(inputView.frame, to: keyWindow)
        let intersectFrame = contentF.intersection(keyboardF)
        let position = self.containerView.layer.position
        let targetPosition = CGPoint(x: position.x, y: position.y - intersectFrame.height - 10)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.containerView.layer.position = targetPosition
        })
    }
}
