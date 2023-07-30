//
//  UIImageView+Extension.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}

extension UIImageView {
    
    func loadImage(_ url: String) {
        
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        Task {
            guard let imageURL = URL(string: url) else {
                return
            }
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            
            DispatchQueue.main.async { [weak self] in
                if let image = UIImage(data: data) {
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    self?.image = image
                }
            }
        }
    }
}
