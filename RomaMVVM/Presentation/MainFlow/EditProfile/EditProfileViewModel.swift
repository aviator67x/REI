//
//  EditProfileViewModel.swift
//  RomaMVVM
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
    
    private var firstName = ""
    private var lastName = ""
    private var nickName = ""
    
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }
    
    override func onViewDidLoad() {
        userService.userPublisher
            .sinkWeakly(self, receiveValue: {(self, user) in
                self.userSubject.value = user
            })
            .store(in: &cancellables)
    }
    
    func updateUser() {
        let userId = userService.getUser()?.id ?? ""
        let userModel = UpdateUserRequestModel(
            firstName: firstName == "" ? nil : firstName,
            lastName: lastName == "" ? nil : lastName,
            nickName: nickName == "" ? nil : nickName,
            imageURL: nil,
            id: userId)
        userService.update(user: userModel)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self]completion in
                switch completion {
                case .finished:
                    print("User has been update with new value")
                case .failure(let error):
                    self.errorSubject.send(error)
                }
            }, receiveValue: { [unowned self] updatedUser in
                let model = UserDomainModel(networkModel: updatedUser)
                self.userService.save(user: model)
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
}
