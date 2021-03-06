//
//  AlbumNavigationController.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos

class PHAssetManager {
    
    class func transformPHAssetToImage(with photoAsset: PHAsset, scaled: Bool = true, completed: @escaping (UIImage)->Void) {
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let newWidth: CGFloat = UIScreen.main.bounds.width
        var newSize: CGSize = CGSize()
        if scaled {
            if photoAsset.pixelWidth > Int(newWidth) {
                let newHeight: CGFloat = CGFloat(photoAsset.pixelHeight)/CGFloat(photoAsset.pixelWidth) * newWidth
                newSize = CGSize(width: newWidth, height:newHeight)
            } else {
                newSize = CGSize(width: CGFloat(photoAsset.pixelWidth), height: CGFloat(photoAsset.pixelHeight))
            }
        } else {
            newSize = PHImageManagerMaximumSize
        }
        
        PHImageManager.default().requestImage(
            for: photoAsset,
            targetSize: newSize,
            contentMode: .default,
            options: options
        ) { image, info in
            if let img = image {
                completed(img)
            }
        }
    }
}

open class AlbumPickerController: UINavigationController {
    
    open var completedSelected:(([UIImage])->Void)?
    open var limitImageCount: Int = 9
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.black
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        
        self.interactivePopGestureRecognizer?.delegate = nil
        let photosVC = PhotosViewController()
        photosVC.limitImageCount = self.limitImageCount
        viewControllers = [AlbumListViewController(),photosVC]
    }
}
