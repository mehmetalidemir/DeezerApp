//
//  DownloadImage.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 14.05.2023.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(from urlString: String?, withPlaceholder placeholder: UIImage? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ]
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder, options: options)
    }
}

