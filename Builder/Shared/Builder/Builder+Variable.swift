//
//  Builder+Variable.swift
//  Builder
//
//  Created by Michael Long on 10/23/21.
//

import Foundation
import RxSwift
import RxCocoa


@propertyWrapper public struct Variable<T> {
    
    public var relay: BehaviorRelay<T>
    
    public init(wrappedValue: T) {
        self.relay = BehaviorRelay<T>(value: wrappedValue)
    }
    
    public var wrappedValue: T {
        get { return relay.value }
        set { relay.accept(newValue) }
    }
    
    public var projectedValue: Variable<T> {
        get { return self }
        mutating set { self = newValue }
    }
    
    public func asObservable() -> Observable<T> {
        return relay.asObservable()
    }

    public func bind(_ observable: Observable<T>) -> Disposable {
        return observable.bind(to: relay)
    }

}

public protocol RxBinding {
    associatedtype T
    func asObservable() -> Observable<T>
}

extension Observable: RxBinding {
    // previously defined
}

extension Variable: RxBinding {
    // previously defined
}


public protocol RxBidirectionalBinding: RxBinding {
    associatedtype T
    var relay: BehaviorRelay<T> { get }
}

extension BehaviorRelay: RxBidirectionalBinding {
    public var relay: BehaviorRelay<Element> { self }
}

extension Variable: RxBidirectionalBinding {
    // previously defined
}


