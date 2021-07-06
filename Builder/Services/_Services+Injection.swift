//
//  Services+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerServices() {
        register {
            return RandomUserSessionManager()
                .wrap(ErrorMappingWrapper())
                .wrap(StandardHeadersWrapper())
                .wrap(SSOAuthenticationWrapper())
                .wrap(SessionLoggingWrapper())
        }

        register { UserImageCache() }.scope(.shared)
        register { UserService() as UserServiceType }

        #if MOCK
        mock.register { MockUserService() as UserServiceType }
        #endif
    }
}
