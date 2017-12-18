//
//  DKImageResource.swift
//  DKImagePickerController
//
//  Created by ZhangAo on 15/8/11.
//  Copyright (c) 2015年 ZhangAo. All rights reserved.
//

import UIKit

public class DKImageResource: NSObject {
    
    private static let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Internationalization
    
    /// Add a hook for custom localization.
    public static var customLocalizationBlock: ((_ title: String) -> String?)?
    
    public class func localizedStringWithKey(_ key: String, value: String? = nil) -> String {
        return customLocalizationBlock?(key) ?? NSLocalizedString(key,
                                                                  tableName: "DKImagePickerController",
                                                                  bundle:Bundle.imagePickerControllerBundle(),
                                                                  value: value ?? "",
                                                                  comment: "")
    }
    
    // MARK: - Images
    
    public static var customImageBlock: ((_ imageName: String) -> UIImage?)?
	
    public class func checkedImage() -> UIImage {
        return imageForResource("checked_background", stretchable: true, cacheable: true)
            .withRenderingMode(.alwaysTemplate)
    }
    
    public class func blueTickImage() -> UIImage {
        return imageForResource("tick_blue", stretchable: false, cacheable: false)
    }
    
    public class func cameraImage() -> UIImage {
        return imageForResource("camera", stretchable: false, cacheable: false)
    }
    
    public class func videoCameraIcon() -> UIImage {
        return imageForResource("video_camera", stretchable: false, cacheable: true)
    }
	
	public class func emptyAlbumIcon() -> UIImage {
        return imageForResource("empty_album", stretchable: true, cacheable: false)
	}
    
    public class func photoGalleryCheckedImage() -> UIImage {
        return imageForResource("photoGalleryCheckedImage", stretchable: true, cacheable: true)
    }
    
    public class func photoGalleryUncheckedImage() -> UIImage {
        return imageForResource("photoGalleryUncheckedImage", stretchable: true, cacheable: true)
    }
    
    public class func imageForResource(_ name: String, stretchable: Bool = false, cacheable: Bool = false) -> UIImage {
        if let image = customImageBlock?(name) {
            return image
        }
        
        if cacheable {
            if let cache = self.cache.object(forKey: name as NSString) {
                return cache
            }
        }
        
        let bundle = Bundle.imagePickerControllerBundle()
        let imagePath = bundle.path(forResource: name, ofType: "png", inDirectory: "Images")
        var image = UIImage(contentsOfFile: imagePath!)!
        
        if stretchable {
            image = self.stretchImgFromMiddle(image)
        }
        
        if cacheable {
            self.cache.setObject(image, forKey: name as NSString)
        }
        
        return image
    }
    
    public class func stretchImgFromMiddle(_ image: UIImage) -> UIImage {
        let centerX = image.size.width / 2
        let centerY = image.size.height / 2
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: centerY, left: centerX, bottom: centerY, right: centerX))
    }
    
}

private extension Bundle {
    
    class func imagePickerControllerBundle() -> Bundle {
        let assetPath = Bundle(for: DKImageResource.self).resourcePath!
        return Bundle(path: (assetPath as NSString).appendingPathComponent("DKImagePickerController.bundle"))!
    }
    
}
