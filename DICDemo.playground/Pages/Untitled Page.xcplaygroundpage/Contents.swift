import UIKit

protocol AwesomeDICProtocol {
    func register<Service>(type: Service.Type, service: Any)
    func resolve<Service>(type: Service.Type) -> Service?
}

final class AwsomeDIContainer: AwesomeDICProtocol {

    static let shared = AwsomeDIContainer()

    private init() { }

    var services: [String: Any] = [:]

    func register<Service>(type: Service.Type, service: Any) {
        services["\(type)"] = service
    }

    func resolve<Service>(type: Service.Type) -> Service? {
        return services["\(type)"] as? Service
    }
}

protocol UserServiceProtocol {
    func fetchUsers()
}

protocol RewardServiceProtocol {
    func fetchRewrds()
}

final class UserService: UserServiceProtocol {

    func fetchUsers() {
        print("Users fetching...")
    }
}

final class RewardService: RewardServiceProtocol {

    func fetchRewrds() {
        print("Reward fetching...")
    }
}

final class fruitsViewModel {

    private let userService: UserServiceProtocol
    private let rewardService: RewardServiceProtocol


    init(userService: UserServiceProtocol = AwsomeDIContainer.shared.resolve(type: UserServiceProtocol.self)!, rewardService: RewardServiceProtocol = AwsomeDIContainer.shared.resolve(type: RewardService.self)!) {
        self.userService = userService
        self.rewardService = rewardService
    }

    func fetchUsers() {
        userService.fetchUsers()
    }

    func fetchRewards() {
        rewardService.fetchRewrds()
    }
}

let container = AwsomeDIContainer.shared
container.register(type: UserServiceProtocol.self, service: UserService())
container.register(type: RewardService.self, service: RewardService())

let viewModel = fruitsViewModel()
viewModel.fetchUsers()
viewModel.fetchRewards()
