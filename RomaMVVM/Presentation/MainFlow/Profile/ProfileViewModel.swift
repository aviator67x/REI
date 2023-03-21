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
        userService.userPublisher
            .sink { [unowned self] user in
                userActionSubject.value = user
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
                        .button
                    ])
                }()
                self.sections = [detailsSection, buttonSection]
            }
            .store(in: &cancellables)
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
