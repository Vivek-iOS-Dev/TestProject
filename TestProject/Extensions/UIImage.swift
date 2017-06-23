//
//  UIImage.swift
//  TestProject
//
//  Created by Vivek Karuppanaraj on 23/06/17.
//  Copyright © 2017 Vivek Karuppanaraj. All rights reserved.
//

import UIKit

extension UIImage {

    class func favIconImage() -> UIImage {
        return UIImage(named:"favIcon")!
    }

    class func enableFavIconImage() -> UIImage {
        return UIImage(named:"favourite")!
    }

    class func disableFavIconImage() -> UIImage {
        return UIImage(named:"unfavourite")!
    }

    class func placeHolderImage() -> UIImage {
        return UIImage(named:"placeHolder")!
    }

    class func imageFromURL(_ string: String) -> UIImage {
        let url = URL(string: string)
        if url != nil {
            if let data = try? Data(contentsOf: url!) {
                return UIImage(data: data) ?? UIImage.placeHolderImage()
            }
        }
        return UIImage.placeHolderImage()
    }

}
