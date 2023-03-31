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
        updateDataSource()
    }

    private func updateDataSource() {
        userService.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] user in
                guard let user = user else {
                    return
                }
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
            }
            .store(in: &cancellables)
    }

    func saveAvatar(avatar: Data) {
        uploadingImageData = avatar
        updateDataSource()
        isLoadingSubject.send(true)
        userService.saveAvatar(image: avatar)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    print("Avatar has been saved")
                case let .failure(error):
                    print(error.errorDescription ?? "")
                }
            } receiveValue: { [unowned self] avatarUrl in
                let imageURL = avatarUrl.imageURL
                let userId = userService.getUser()?.id ?? ""
                let updateUserRequestModel = UpdateUserRequestModel(
                    firstName: nil,
                    lastName: nil,
                    nickName: nil,
                    imageURL: imageURL,
                    id: userId
                )
                KingfisherManager.shared.retrieveImage(
                    with: Kingfisher.ImageResource(downloadURL: URL(string: imageURL)!),
                    options: [.cacheOriginalImage],
                    completionHandler: nil)
                update(user: updateUserRequestModel)
            }
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
                updateDataSource()
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
