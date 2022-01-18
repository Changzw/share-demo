//
//  ViewController.swift
//  share-demo
//
//  Created by 常仲伟 on 2022/1/6.
//

import UIKit
/*
 - 用户未安装要分享的应用时，点击toast提示“分享失败，您暂未安装
 Instagram / Facebook / Twitter / WhatsApp/ Telegram”
 */
class ViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  let image = Bundle.main.path(forResource: "test", ofType: "jpeg")
  let text = "11111122222333333333"
  var documentController: UIDocumentInteractionController!
  @IBOutlet weak var label: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    guard let i = image else { return }
    imageView.image = UIImage(contentsOfFile: i)
    label.text = text
  }

  @IBAction func more(_ sender: Any) {
    guard let img0 = imageView.image?.jpegData(compressionQuality: 1) else { return }
    guard let img1 = imageView.image?.pngData() else { return }
    let ac = UIActivityViewController(activityItems: [img0, img1], applicationActivities: nil)
    ac.excludedActivityTypes = [.print, .addToReadingList]
    ac.completionWithItemsHandler = { actionType, completed, returnItem, error in
      print(actionType)
      print(completed)
      print(returnItem)
      print(error)
    }
    present(ac, animated: true, completion: nil)
  }
  
  // Instagram：支持将图片分享至Feed、Stories、支持将图片/直播间分享给Chats（联系人）
  @IBAction func gotoInstagram(_ sender: Any) {
// https://stackoverflow.com/a/40338071/6103118
// https://developers.facebook.com/docs/instagram/sharing-to-stories#ios----
// https://developers.facebook.com/docs/instagram/sharing-to-feed#ios----
    print(#function)
    guard let img = imageView.image else { return }
    insPublisher.post(image: img) { e in
      print(e)
    }
    return
    
//    guard let url = URL(string: "instagram://") else { return }
//    if UIApplication.shared.canOpenURL(url) {
//      UIApplication.shared.open(url, options: [:]) {
//        if $0 {
//          print("open ins success")
//        }else {
//          print("open ins fail")
//        }
//      }
//    }else {
//
//    }
  }

// WhatsApp：支持将图片、可打开H5直播间的定制内容分享给联系人
  @IBAction func gotoWhatApp(_ sender: Any) {
// https://faq.whatsapp.com/iphone/how-to-link-to-whatsapp-from-a-different-app/?lang=zh_cn
// https://www.jianshu.com/p/350e757957d3
    print(#function)
    let urlWhats = "whatsapp://"
    guard let img = imageView.image else { return }
    
    if let whatsappURL = URL(string: urlWhats) {
      
      if UIApplication.shared.canOpenURL(whatsappURL) {
        
        if let imageData = img.jpegData(compressionQuality: 1.0) {
          let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")!
          do {
            try imageData.write(to: tempFile, options: .atomic)
            self.documentController = UIDocumentInteractionController(url: tempFile)
            self.documentController.uti = "net.whatsapp.image"
            self.documentController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
          } catch {
            print(error)
          }
        }
        
      } else {
        let ac = UIAlertController(title: "MessageAletTitleText", message: "AppNotFoundToShare", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OKButtonText", style: .default))
        present(ac, animated: true)
        
        print("Whatsapp isn't installed ")
        
        // Cannot open whatsapp
      }
    }
    return
    
    let goto = "快来#BIGOLIVE 观看霸҉✘琳諾🌸晚點開等我一下🏥 直播，结交新朋友！ https://slink.bigovideo.tv/1wxBpM"
    guard let text = "whatsapp://send?text=\(goto)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: text)
    else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:]) {
        if $0 {
          print("open whatapps success")
        }else {
          print("open whatapps fail")
        }
      }
    }else {
      //App not installed.
    }
    
//    guard let url = URL(string: "whatsapp://send") else { return }
//    if UIApplication.shared.canOpenURL(url) {
//      UIApplication.shared.open(url, options: [:]) {
//        if $0 {
//          print("open whatapps success")
//        }else {
//          print("open whatapps fail")
//        }
//      }
//    }else {
//      print("aaa")
//    }
  }

  lazy var insPublisher = InstagramPublisher()
  @IBAction func gotoTelegram(_ sender: Any) {
    print(#function)
    let goto = "快来#BIGOLIVE 观看霸҉✘琳諾🌸晚點開等我一下🏥 直播，结交新朋友！ https://slink.bigovideo.tv/1wxBpM"
    guard let text = "tg://msg?text=\(goto)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: text)
          else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:]) {
        if $0 {
          print("open whatapps success")
        }else {
          print("open whatapps fail")
        }
      }
    }else {
      //App not installed.
    }

//    return
    
// https://github.com/poholo/LDSDKManager_IOS/blob/master/SDK/TelegramPlatform/LDSDKTelegramDataVM.m
//    guard let url = URL(string: "tg:") else { return }
//    if UIApplication.shared.canOpenURL(url) {
//      UIApplication.shared.open(url, options: [:]) {
//        if $0 {
//          print("open whatapps success")
//        }else {
//          print("open whatapps fail")
//        }
//      }
//    }else {
//      print("aaa")
//    }
  }
}

