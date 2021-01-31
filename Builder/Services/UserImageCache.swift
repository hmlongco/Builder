//
//  UserImageCache.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift

class UserImageCache {
    
    @Injected var userService: UserServiceType

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        guard let path = user.picture?.thumbnail else {
            return .just(nil)
        }
        if let image = thumbnailCache.object(forKey: NSString(string: path)) {
            return .just(image)
        }
        return userService.thumbnail(forUser: user)
            .do(onSuccess: { [weak self] (image) in
                if let image = image {
                    self?.thumbnailCache.setObject(image, forKey: NSString(string: path))
               }
            })
    }

    private var thumbnailCache = NSCache<NSString, UIImage>()

}
