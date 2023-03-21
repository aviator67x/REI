//
//  ProfileViewModel.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import Combine
import Foundation

struct ProfileCollection {
    var section: ProfileSection
    var items: [ProfileItem]
}

final class ProfileViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<ProfileTransition, Never>()

    private(set) lazy var userPublisher = userActionSubject.eraseToAnyPublisher()
    private lazy var userActionSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)

    private let userService: UserService

    @Published private(set) var sections: [ProfileCollection] = []

    init(userService: UserService) {
        self.userService = userService
        super.init()
    }

    override func onViewDidLoad() {
        updateDataSource()
    }

    func updateDataSource() {
//        userService.userPublisher
//            .sink { [unowned self] user in
        guard let user = userService.getUser(),
               let url =
                  URL(
                      string: "https://backendlessappcontent.com/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/files/images/30D6D6CC-899C-4A68-9FE4-B1B61AF84174.png"
                  ) else {
            return
        }
        let userDataSection: ProfileCollection = {
            let userDataModel = UserDataCellModel(
                name: user.name,
                email: user.email,
                image: .imageURL(url)
            )

            return ProfileCollection(section: .userData, items: [.userData(userDataModel)])
        }()

        let detailsSection: ProfileCollection = {
            ProfileCollection(section: .details, items: [
                .plain("Name"),
                .plain("Email"),
                .plain("Date of birth"),
                .plain("Password"),
            ])
        }()

        let buttonSection: ProfileCollection = {
            ProfileCollection(section: .button, items: [
                .button,
            ])
        }()
        sections = [userDataSection, detailsSection, buttonSection]
//            }
//            .store(in: &cancellables)
    }

    func logout() {
        guard let token = userService.token else {
            return
        }
        userService.logOut(token: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.transitionSubject.send(.logout)
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    self?.errorSubject.send(error)
                }
            } receiveValue: { _ in
                self.userService.logOut()
                self.transitionSubject.send(.logout)
                self.transitionSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
    }

    func showName() {
        transitionSubject.send(.showName)
    }

    func showEmail() {
        transitionSubject.send(.showEmail)
    }

    func showBirth() {
        transitionSubject.send(.showBirth)
    }

    func showPassword() {
        transitionSubject.send(.showPassword)
    }
}
