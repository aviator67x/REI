//
//  ProfileViewModel.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import Combine
import Foundation
import Kingfisher

final class ProfileViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<ProfileTransition, Never>()

    private(set) lazy var openGalleryPublisher = openGallerySubject.eraseToAnyPublisher()
    private let openGallerySubject = CurrentValueSubject<Bool, Never>(false)

    private(set) lazy var universalImagePublisher = universalImageSubject.eraseToAnyPublisher()
    private let universalImageSubject = CurrentValueSubject<ImageResource?, Never>(nil)

    private(set) lazy var userPublisher = userActionSubject.eraseToAnyPublisher()
    private lazy var userActionSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)

    private let userService: UserService

    @Published private(set) var sections: [ProfileCollection] = []
    
    private var uploadingImageData: Data?

    init(userService: UserService) {
        self.userService = userService
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
    }
        
    private func setupBinding() {
        userService.userPublisher
            .receive(on: DispatchQueue.main)
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, user) in
                self.updateDataSource(user: user)
            })
            .store(in: &cancellables)
    }

    private func updateDataSource(user: UserDomainModel) {
                let userDataSection: ProfileCollection = {
                    let userDataCellModel: UserDataCellModel
                    if let uploadingImageData = uploadingImageData {
                        userDataCellModel = UserDataCellModel(
                            name: user.name,
                            email: user.email,
                            image: .imageData(uploadingImageData)
                        )
                    } else {
                        userDataCellModel = UserDataCellModel(
                            name: user.name,
                            email: user.email,
                            image: .imageURL(user.imageURL)
                        )
                    }
                    return ProfileCollection(section: .userData, items: [.userData(userDataCellModel)])
                }()

                let detailsSection: ProfileCollection = {
                    ProfileCollection(section: .details, items: [
                        .plain(.name),
                        .plain(.email),
                        .plain(.dateOfBirth),
                        .plain(.password),
                    ])
                }()

                let buttonSection: ProfileCollection = {
                    ProfileCollection(section: .button, items: [
                        .button,
                    ])
                }()
                sections = [userDataSection, detailsSection, buttonSection]
            }
    
    func saveAvatar(avatar: Data) {
        userService.saveAvatar(image: avatar)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: {value in})
            .store(in: &cancellables)
    }

    private func update(user: UpdateUserRequestModel) {
        isLoadingSubject.send(true)
        userService.update(user: user)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    print("User has been updated")
                case let .failure(error):
                    errorSubject.send(error)
                }
            } receiveValue: { [unowned self] user in
                let userModel = UserDomainModel(networkModel: user)
                self.userService.save(user: userModel)
                setupBinding()
            }
            .store(in: &cancellables)
    }

    func logout() {
        isLoadingSubject.send(true)
        userService.logout()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                self.isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    self.transitionSubject.send(.logout)
                    self.transitionSubject.send(completion: .finished)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.errorSubject.send(error)
                }
                
            }, receiveValue: { value in})
            .store(in: &cancellables)
    }

    func openGallery() {
        isLoadingSubject.send(true)
        openGallerySubject.value = true
        isLoadingSubject.send(false)
    }

    func showEditPrifile(configuration: EditProfileConfiguration) {
        transitionSubject.send(.showEditProfile(configuration))
    }

    func showPassword() {
        transitionSubject.send(.showPassword)
    }
}
