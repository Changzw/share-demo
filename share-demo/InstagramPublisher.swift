//
//  InstagramPublisher.swift
//  share-demo
//
//  Created by 常仲伟 on 2022/1/7.
//

import UIKit
import Photos

enum PostInstagramError: Error {
  case openApp,
       fileUrl,
       imageToFileWriting(Error),
       imageDecoding,
       photoLibraryOperating(Error),
       none
}

final class InstagramPublisher: NSObject {
  private lazy var documentsController: UIDocumentInteractionController = {
    let r = UIDocumentInteractionController()
    r.delegate = self
    return r
  }()
 
  private // 暂时用不到
  func post(image: UIImage, view: UIView, result:((PostInstagramError)->Void)? = nil) {
    guard let insUrl = URL(string: "instagram://") else { result?(.fileUrl); return }
    guard UIApplication.shared.canOpenURL(insUrl) else { result?(.openApp); return }
    
    let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagramShare.igo")
    let fileUrl = URL(fileURLWithPath: jpgPath)
    
    guard let image = image.jpegData(compressionQuality: 1.0) else { result?(.imageDecoding); return }
    do {
      try image.write(to: fileUrl, options: .atomic)
    } catch let e {
      result?(.imageToFileWriting(e))
    }
    
    documentsController.delegate = self
    documentsController.url = fileUrl
    documentsController.uti = "com.instagram.exclusivegram"
    documentsController.presentOpenInMenu(from: view.bounds, in: view, animated: true)
    result?(.none)
  }
  
  func post(image: UIImage, result:((PostInstagramError)->Void)? = nil) {
    guard let insUrl = URL(string: "instagram://app") else { result?(.fileUrl); return  }
    guard let image = image.scaleImageWithAspect(to: 640) else { result?(.imageDecoding); return }
    
    do {
      try PHPhotoLibrary.shared().performChangesAndWait {
        let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
        
        let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
        let shareUrl = "instagram://library?LocalIdentifier=" + assetID
        
        guard UIApplication.shared.canOpenURL(insUrl),
              let urlForRedirect = URL(string: shareUrl) else {
          result?(.openApp); return
        }
        UIApplication.shared.open(urlForRedirect, options: [:]) { r in
          if r {
            result?(.none)
          }else {
            result?(.openApp)
          }
        }
      }
    } catch let e{
      result?(.photoLibraryOperating(e))
    }
  }
}

extension InstagramPublisher : UIDocumentInteractionControllerDelegate {
  
}
