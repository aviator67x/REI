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

    func logout() {
        guard let token = userService.token else { return }
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
                self.transitionSubject.send(.logout)
                self.transitionSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
    }

    func updateDataSource() {
        guard let user = userService.getUser() else { return }
        let userProfileSection: SettingsCollection = {
            let userModel = UserProfileCellModel(
                name: user.name,
                email: user.email
//                image: user.image
            )
            return SettingsCollection(section: .userProfile, items: [.userProfile(userModel: userModel)])
        }()
        
        let profileSection: SettingsCollection = {
           
            return SettingsCollection(section: .profile, items: [.plain(title: "Profile")])
        }()
        
        let termsSection: SettingsCollection = {
          
            return SettingsCollection(section: .terms, items: [.plain(title: "Terms and Conditions"), .plain(title: "Privacy policy")])
        }()
        
        let companySection: SettingsCollection = {
            
            return SettingsCollection(section: .company, items: [.plain(title: "About us"), .plain(title: "F.A.Q."), .plain(title: "Contact us")])
        }()
        
        self.sections = [userProfileSection, profileSection, termsSection, companySection]
    }
}
