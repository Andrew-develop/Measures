//
//  Weakify.swift
//  Vladlink
//
//  Created by Pavel Zorin on 27.02.2021.
//

public func weakify<T: AnyObject, U>(_ owner: T, _ comp: @escaping (T) -> () throws -> Void) -> (U) throws -> Void {
    return { [weak owner] _ in
        if let this = owner {
            try comp(this)()
        }
    }
}

public func weakify<T: AnyObject, U>(_ owner: T, _ comp: @escaping (T) -> (U) -> Void) -> (U) -> Void {
    return { [weak owner] obj in
        if let this = owner {
            comp(this)(obj)
        }
    }
}

public func weakify<T: AnyObject, U>(_ owner: T, _ comp: @escaping (T) -> (U) throws -> Void) -> (U) throws -> Void {
    return { [weak owner] obj in
        if let this = owner {
            try comp(this)(obj)
        }
    }
}

public func weakify<T: AnyObject, U>(_ owner: T, _ comp: @escaping (T) -> () -> U) -> () -> U? {
    return { [weak owner] in
        if let this = owner {
            return comp(this)()
        } else {
            return nil
        }
    }
}

public func weakify<T: AnyObject, U>(_ owner: T, _ comp: @escaping (T) -> () throws -> U) -> () throws -> U? {
    return { [weak owner] in
        if let this = owner {
            return try comp(this)()
        } else {
            return nil
        }
    }
}

public func weakify<T: AnyObject, U, V>(_ owner: T, _ comp: @escaping (T) -> (U) -> V) -> (U) -> V? {
    return { [weak owner] obj in
        if let this = owner {
            return comp(this)(obj)
        } else {
            return nil
        }
    }
}

public func weakify<T: AnyObject, U, V>(_ owner: T, _ comp: @escaping (T) -> (U) throws -> V) -> (U) throws -> V? {
    return { [weak owner] obj in
        if let this = owner {
            return try comp(this)(obj)
        } else {
            return nil
        }
    }
}

public func weakify<T: AnyObject, A, B>(_ owner: T, _ comp: @escaping (T) -> (A, B) -> Void) -> (A, B) -> Void {
    return { [weak owner] one, two in
        if let this = owner {
            comp(this)(one, two)
        }
    }
}

public func weakify<T: AnyObject, A, B, C>(_ owner: T, _ comp: @escaping (T) -> (A, B, C) -> Void) -> (A, B, C) -> Void {
    return { [weak owner] one, two, three in
        if let this = owner {
            comp(this)(one, two, three)
        }
    }
}

public func weakify<T: AnyObject>(_ owner: T, _ comp: @escaping (T) -> () -> Void) -> () -> Void {
    return { [weak owner] in
        if let this = owner {
            comp(this)()
        }
    }
}
