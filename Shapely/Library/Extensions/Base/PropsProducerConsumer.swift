//
//  PropsProducerConsumer.swift
//  Vladlink
//
//  Created by Pavel Zorin on 27.02.2022.
//

import RxCocoa

protocol PropsProducer {
    associatedtype Props

    var rx_props: Driver<Props> { get }
}

protocol PropsConsumer {
    associatedtype Props

    var props: Props { get set }
}

extension PropsConsumer where Self: NSObject {
    func bind<Producer: PropsProducer>(to propsProducer: Producer) where Producer.Props == Props {
        holdRef(propsProducer, by: "props_producer")

        _ = propsProducer.rx_props
            .drive(onNext: { [weak self] props in
                self?.props = props
            })
    }
}

extension NSObject {
    func holdRef(_ object: Any, by key: String) {
        var mutableKey = key
        objc_setAssociatedObject(self, &mutableKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
