//
//  Builder+Variable.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/23/21.
//

import Foundation
import RxSwift
import RxCocoa


@propertyWrapper public struct Variable<T> {
    
    public var relay: BehaviorRelay<T>
    
    public init(_ relay: BehaviorRelay<T>) {
        self.relay = relay
    }
    
    public var wrappedValue: T {
        get { return relay.value }
        nonmutating set { relay.accept(newValue) }
    }
    
    public var projectedValue: Variable<T> {
        get { return self }
    }
    
    public mutating func reset() {
        relay = BehaviorRelay(value: relay.value)
    }
    
}

extension Variable {
    
    init(wrappedValue: T) {
        self.relay = BehaviorRelay<T>(value: wrappedValue)
    }
    
}

extension Variable where T:Equatable {
    
    public func onChange(_ observer: @escaping (_ value: T) -> ()) -> Disposable {
        relay
//            .debug()
            .skip(1)
            .distinctUntilChanged()
            .subscribe { observer($0) }
    }

//    public func onChange(_ bag: DisposeBag, _ observer: @escaping (_ value: T) -> ()) {
//        onChange(observer)
//            .disposed(by: bag)
//    }

}

extension Variable: RxBinding {
    
    public func asObservable() -> Observable<T> {
        return relay.asObservable()
    }
    
    public func bind(_ observable: Observable<T>) -> Disposable {
        return observable.bind(to: relay)
    }
        
}

extension Variable: RxBidirectionalBinding {
    // previously defined
}


//struct A: ViewBuilder {
//    @Variable var name = "Michael"
//    func build() -> View {
//        B(name: $name)
//    }
//}
//
//struct B: ViewBuilder  {
//    @Variable var name: String
//    func build() -> View {
//         LabelView(name)
//    }
//}
