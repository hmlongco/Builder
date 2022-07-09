//
//  UserImageCache.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Factory
import RxSwift

class UserImageCache {
    
    @Injected(Container.userServiceType) var userService: UserServiceType

    func thumbnail(forUser user: User) -> Observable<UIImage?> {
        guard let path = user.picture?.medium else {
            return .just(nil)
        }
        if let image = imageCache.object(forKey: NSString(string: path)) {
            return .just(image)
        }
        let image = userService.thumbnail(forUser: user)
            .asObservable()
        return Observable<UIImage?>.merge(.just(nil), image)
            .do(onNext: { [weak self] (image) in
                if let image = image {
                    self?.imageCache.setObject(image, forKey: NSString(string: path))
               }
            })
    }

    func thumbnailOrPlaceholder(forUser user: User) -> Observable<UIImage?> {
        thumbnail(forUser: user)
            .catchAndReturn(UIImage(named: "User-Unknown"))
            .map { $0 ?? UIImage(named: "User-Unknown") }
    }

    func photo(forUser user: User) -> Observable<UIImage?> {
        guard let path = user.picture?.large else {
            return .just(nil)
        }
        if let image = imageCache.object(forKey: NSString(string: path)) {
            return .just(image)
        }
        let image = userService.photo(forUser: user)
            .asObservable()
        return Observable<UIImage?>.merge(.just(nil), image)
            .do(onNext: { [weak self] (image) in
                if let image = image {
                    self?.imageCache.setObject(image, forKey: NSString(string: path))
               }
            })
    }

    func photoOrPlaceholder(forUser user: User) -> Observable<UIImage?> {
        photo(forUser: user)
            .catchAndReturn(UIImage(named: "User-Unknown"))
            .map { $0 ?? UIImage(named: "User-Unknown") }
    }

    private var imageCache = NSCache<NSString, UIImage>()

}
