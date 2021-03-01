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

    func thumbnail(forUser user: User) -> Observable<UIImage?> {
        guard let path = user.picture?.thumbnail else {
            return .just(nil)
        }
        if let image = thumbnailCache.object(forKey: NSString(string: path)) {
            return .just(image)
        }
        let image = userService.thumbnail(forUser: user)
            .asObservable()
        return Observable<UIImage?>.merge(.just(nil), image)
            .do(onNext: { [weak self] (image) in
                if let image = image {
                    self?.thumbnailCache.setObject(image, forKey: NSString(string: path))
               }
            })
    }

    func thumbnailOrPlaceholder(forUser user: User) -> Observable<UIImage?> {
        thumbnail(forUser: user)
            .catchAndReturn(UIImage(named: "User-Unknown"))
            .map { $0 ?? UIImage(named: "User-Unknown") }
    }

    private var thumbnailCache = NSCache<NSString, UIImage>()

}
