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
  
    func updateDataSource() {
        guard let user = userService.getUser() else { return }
        guard let url = URL(string: "https://backendlessappcontent.com/DD1C6C3C-1432-CEA8-FF78-F071F66BF000/04FFE4D5-65A2-4F62-AA9F-A51D1BF8550B/files/images/30D6D6CC-899C-4A68-9FE4-B1B61AF84174.png") else {
            return
        }
        let userProfileSection: SettingsCollection = {
            let userModel = UserProfileCellModel(
                name: user.name,
                email: user.email,
                image: .imageURL(url)
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
    
    func showProfile() {
        transitionSubject.send(.profile)
    }
    
    func showTerms() {
        transitionSubject.send(.terms)
    }
}
