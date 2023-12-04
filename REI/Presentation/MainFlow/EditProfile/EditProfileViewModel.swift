//
//  EditProfileViewModel.swift
//  REI
//
//  Created by User on 22.03.2023.
//

import Combine
import Foundation

final class EditProfileViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<EditProfileTransition, Never>()
    
    private let userService: UserService
    
    private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
    private lazy var userSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)
    
    private(set) lazy var popEditPublisher = popEditSubject.eraseToAnyPublisher()
    private lazy var popEditSubject = PassthroughSubject<Bool, Never>()
    
    private var firstName = ""
    private var lastName = ""
    private var nickName = ""
    private var email = ""
    
    // MARK: - Life cycle
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }
    
    override func onViewWillAppear() {
        userService.userPublisher
            .sink { [unowned self] user in
                userSubject.value = user
            }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension EditProfileViewModel {
    func updateUser() {
        let userId = userService.getUser()?.id ?? ""
        let userModel = UpdateUserRequestModel(
            firstName: self.firstName == "" ? nil : self.firstName,
            lastName: self.lastName == "" ? nil : self.lastName,
            nickName: self.nickName == "" ? nil : self.nickName,
            email: self.email == "" ? nil : self.email,
            imageURL: nil,
            id: userId)
        isLoadingSubject.send(true)
        userService.update(user: userModel)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self]completion in
                isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    print("User has been updated with a new value")
                case .failure(let error):
                    self.errorSubject.send(error)
                }
            }, receiveValue: { [unowned self] updatedUser in
                let model = UserDomainModel(networkModel: updatedUser)
                self.userService.save(user: model)
                popEditSubject.send(true)
            })
            .store(in: &cancellables)
    }
    
    func update(firstName: String) {
        self.firstName = firstName
    }
    
    func update(lastName: String) {
        self.lastName = lastName
    }
    
    func update(nickName: String) {
        self.nickName = nickName
    }
    
    func update(email: String) {
        self.email = email
    }
}
