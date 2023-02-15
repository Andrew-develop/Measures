//
//  SwinjectExtensions.swift
//
//  Created by Anisov Aleksey on 3/15/17.
//  Copyright © 2017 Anisov Aleksey. All rights reserved.
//

import Swinject

extension Container {
    // swiftlint:disable force_cast

    @discardableResult
    func register<Service, ServiceProto>(_ serviceType: Service.Type, as type: ServiceProto.Type)
        -> ServiceEntry<ServiceProto> {
        return register(type) { $0.resolve(serviceType)! as! ServiceProto }
    }

    @discardableResult
    func register<Service, ServiceProto, Argument>(_ serviceType: Service.Type, as type: ServiceProto.Type,
                                                   with _: Argument.Type) -> ServiceEntry<ServiceProto> {
        return register(type) { (resolver, argument: Argument) in
            resolver.resolve(serviceType, argument: argument)! as! ServiceProto
        }
    }

    @discardableResult
    func register<Service, ServiceType>(_ service: Service, as type: ServiceType.Type)
        -> ServiceEntry<ServiceType> {
        return register(type) { _ in
            service as! ServiceType
        }
    }
}

extension Resolver {
    func resolve<Service>() -> Service {
        return resolve(Service.self)!
    }

    func resolve<Service, Arg1>(argument: Arg1) -> Service {
        return resolve(Service.self, argument: argument)!
    }
}
