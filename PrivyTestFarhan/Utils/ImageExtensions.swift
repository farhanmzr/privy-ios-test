//
//  ImageExtensions.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 26/06/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
