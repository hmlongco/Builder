//
//  UIImage+Extensions.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/26/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit

extension UIImage {

    /**
     Initializes and returns the image object of the specified color and size.
     */
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }

}
