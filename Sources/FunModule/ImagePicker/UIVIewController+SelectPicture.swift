//
//  UIVIewController+SelectPicture.swift
//  HeathyWidget
//
//  Created by iMacHuaSheng on 2020/10/23.
//

import Foundation
import Photos
public extension PHAuthorizationStatus {
    var isAvailable: Bool {
        if #available(iOS 14.0, *) {
            return self == .authorized || self == .limited
        } else {
            return self == .authorized
        }
    }
}
public extension UIViewController {
    fileprivate struct AssociatedKeys {
        static let imageInfoKey = UnsafeRawPointer(bitPattern: "imageInfoKey".hashValue)!
    }
    static let imagePickerDidCancelCode: Int = -1000
    static let imagePickerAuthorizationDeniedCode: Int = -2000
     
    typealias PickerResult = Result<[AnyHashable: Any], Error>
    typealias PickerCompletion = ((PickerResult) -> Void)
    
    /// 申请权限
    private func requestImagePickerAuthorization(_ completion: @escaping ((PHAuthorizationStatus) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            if #available(iOS 14.0, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { stat in
                    DispatchQueue.main.async {
                        completion(stat)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { stat in
                    DispatchQueue.main.async {
                        completion(stat)
                    }
                }
            }
        } else {
            completion(status)
        }
    }
    
    func showSheetSelectImage(_ completion: @escaping PickerCompletion) {
         self.requestImagePickerAuthorization { [weak self] status  in
            guard let `self` = self else { return }
            if status.isAvailable {
                self.presentImageSelector(completion)
            } else {
                let fail = PickerResult.failure(NSError(domain: "selectImage", code: UIViewController.imagePickerAuthorizationDeniedCode, userInfo: ["status": status, NSLocalizedDescriptionKey: "请先授权访问权限"]))
                completion(fail)
            }
        }
    }
    
    private func presentImageSelector(_ completion: @escaping PickerCompletion) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "相机", style: .default) { action in
            self.showImagePicker(.camera, completion: completion)
        }
        let action2 = UIAlertAction(title: "相册", style: .default) { action in
            self.showImagePicker(.photoLibrary, completion: completion)
        }
        let action3 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(_ type: UIImagePickerController.SourceType, completion: @escaping PickerCompletion) {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            let fail = PickerResult.failure(NSError(domain: "selectImage", code: -2000, userInfo: ["type": type, NSLocalizedDescriptionKey: "当前设备不支持此功能"]))
            completion(fail)
            return
        }
        self.requestImagePickerAuthorization { [weak self] status in
            guard let `self` = self else { return }
            if status.isAvailable {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = type
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
                objc_setAssociatedObject(self, AssociatedKeys.imageInfoKey, completion, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            } else {
                let fail = PickerResult.failure(NSError(domain: "selectImage", code: UIViewController.imagePickerAuthorizationDeniedCode, userInfo: ["status": status, NSLocalizedDescriptionKey: "请先授权访问权限"]))
                completion(fail)
            }
        }
    }
    
}
extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        if let completion = objc_getAssociatedObject(self, AssociatedKeys.imageInfoKey) as? PickerCompletion {
            completion(PickerResult.failure(NSError(domain: "selectImage", code: UIViewController.imagePickerDidCancelCode, userInfo: [NSLocalizedDescriptionKey: "取消了选择照片"])))
            objc_setAssociatedObject(self, AssociatedKeys.imageInfoKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let completion = objc_getAssociatedObject(self, AssociatedKeys.imageInfoKey) as? PickerCompletion {
            completion(PickerResult.success(info))
            objc_setAssociatedObject(self, AssociatedKeys.imageInfoKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
          if #available(iOS 11.0, *),
              let cls = NSClassFromString("PUPhotoPickerHostViewController"),
              viewController.isKind(of: cls){
              for subView in viewController.view.subviews {
                  if subView.frame.width < 42 {
                      viewController.view.sendSubviewToBack(subView)
                      break
                  }
              }
          }
      }

}
