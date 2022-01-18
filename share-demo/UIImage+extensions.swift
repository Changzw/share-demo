//
//  UIImage+extensions.swift
//  share-demo
//
//  Created by 常仲伟 on 2022/1/7.
//

import UIKit

extension UIImage {
  func scaleImageWithAspect(to width: CGFloat) -> UIImage? {
    let oldWidth = size.width
    let scaleFactor = width / oldWidth
    
    let newHeight = self.size.height * scaleFactor
    let newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
