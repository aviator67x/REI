//
//  SettingsViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import Foundation

struct SettingsCollection {
    var section: SettingsSection
    var items: [SettingsItem]
}

final class SettingsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SettingsTransition, Never>()

    private let userService: UserService
    private let userNetworkService: UserNetworkService

    @Published private(set) var sections: [SettingsCollection] = []

    init(userService: UserService, userNerworkService: UserNetworkService) {
        self.userService = userService
        self.userNetworkService = userNerworkService
        super.init()
    }

    override func onViewDidLoad() {
        updateDataSource()
    }

    override func onViewWillAppear() {
        updateDataSource()
    }

    func updateDataSource() {
        userService.userPublisher
            .sink { [unowned self] user in
            guard let user = user else { return }
            let userProfileSection: SettingsCollection = {
                let userModel = UserProfileCellModel(
                    name: user.name,
                    email: user.email,
                    image: .imageURL(user.imageURL)
                )
                return SettingsCollection(section: .userProfile, items: [.userProfile(userModel: userModel)])
            }()
            let profileSection: SettingsCollection = {
                SettingsCollection(section: .profile, items: [.plain(title: "Profile")])
            }()
            let termsSection: SettingsCollection = {
                SettingsCollection(section: .terms, items: [
                    .plain(title: "Terms and Conditions"), .plain(title: "Privacy policy"),
                ])
            }()
            let companySection: SettingsCollection = {
                SettingsCollection(
                    section: .company,
                    items: [.plain(title: "About us"), .plain(title: "F.A.Q."), .plain(title: "Contact us")]
                )
            }()
            sections = [userProfileSection, profileSection, termsSection, companySection]
        }
        .store(in: &cancellables)
    }
        

    func showProfile() {
        transitionSubject.send(.profile)
    }

    func showTerms() {
        transitionSubject.send(.terms)
    }
}
