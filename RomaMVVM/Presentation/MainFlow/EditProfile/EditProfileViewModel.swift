//
//  EditProfileViewModel.swift
//  RomaMVVM
//
//  Created by User on 22.03.2023.
//

import Combine

final class EditProfileViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<EditProfileTransition, Never>()
    
   override init() {

        super.init()
    }
    
}
