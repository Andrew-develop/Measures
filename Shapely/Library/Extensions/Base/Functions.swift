//
//  Functions.swift
//
//  Created by Anton Selyanin on 6/4/16.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public func with<T>(_ object: T, _ initializer: (T) -> Void) -> T {
    initializer(object)
    return object
}

public func configure<T>(_ object: T, _ configurator: (T) -> Void) {
    configurator(object)
}

public protocol Applicative {}

public extension Applicative where Self: AnyObject {
    @inline(__always) func apply(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

extension NSObject: Applicative {}

public extension Optional {
    @inline(__always) func `let`(_ configuration: (Wrapped) -> Void) {
        guard let unwrapped = self else { return }
        configuration(unwrapped)
    }
}

public protocol Mutable {}

public extension Mutable {
    func mutate(mutation: (inout Self) -> Void) -> Self {
        var val = self
        mutation(&val)
        return val
    }
}

public extension Observable where Element: Mutable {
    func mutate(mutation: @escaping (inout Element) -> Void) -> Observable<Element> {
        return map { element -> Element in
            element.mutate(mutation: mutation)
        }
    }
}

public extension Array where Element: Mutable {
    func mutate(mutation: (inout Element) -> Void) -> [Element] {
        return map { element -> Element in
            element.mutate(mutation: mutation)
        }
    }
}

public extension BehaviorRelay where Element: Mutable {
    func mutate(mutation: (inout Element) -> Void) {
        accept(value.mutate(mutation: mutation))
    }
}

public extension BehaviorSubject where Element: Mutable {
    func mutate(mutation: (inout Element) -> Void) {
        guard let value = try? value() else {
            assertionFailure("Can't mutate element in behavior subject")
            return
        }

        onNext(value.mutate(mutation: mutation))
    }
}
