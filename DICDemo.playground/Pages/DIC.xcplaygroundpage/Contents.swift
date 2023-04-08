//: [Previous](@previous)

import Foundation

typealias FactoryClosure = (DIC) -> AnyObject

protocol DICProtocol {

    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure)
    func resolve<Service>(type: Service.Type) -> Service?
}

class DIC: DICProtocol {

    var services = Dictionary<String, FactoryClosure>()

    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure) {

        services["\(type)"] = factoryClosure
    }

    func resolve<Service>(type: Service.Type) -> Service? {
        return services["\(type)"]?(self) as? Service

    }
}

protocol ServiceOneProtocol {
 func doSomeThingCool()
}

protocol ServiceTwoProtocol {
 func doSomeThingAsWell()
}

final class ServiceOne: ServiceOneProtocol {

    func doSomeThingCool() {
        print("Users fetching...")
    }
}

final class ServiceTwo: ServiceTwoProtocol {

    func doSomeThingAsWell() {
        print("Reward fetching...")
    }
}

class ParentClass {
    let serviceOne: ServiceOneProtocol
     let serviceTwo: ServiceTwoProtocol

    init(serviceOne: ServiceOneProtocol, serviceTwo: ServiceTwoProtocol) {
        self.serviceOne = serviceOne
        self.serviceTwo = serviceTwo
    }

    convenience init(container: DICProtocol) {
        self.init(serviceOne: container.resolve(type: ServiceOneProtocol.self)!, serviceTwo: ServiceTwoProtocol.self as! ServiceTwoProtocol)
    }

    func btnTapped() {
        serviceOne.doSomeThingCool()
    }
    func TappMeTwo() {
        serviceTwo.doSomeThingAsWell()
    }
}

let container = DIC() // 1
container.register(type: ServiceTwoProtocol.self) { _ in // 2
    return ServiceTwo()
}
container.register(type: ServiceOneProtocol.self) { container in // 3
    return ServiceOne()
}
let parent  = ParentClass(serviceOne: ServiceOne(), serviceTwo: ServiceTwo())
parent.btnTapped()
parent.TappMeTwo()


