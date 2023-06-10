//
//  AdDetailsViewController.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import UIKit

final class AdDetailsViewController: BaseViewController<AdDetailsViewModel> {
    // MARK: - Views
    private let contentView = AdDetailsView()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .onBackTap:
                    viewModel.popScreen()
                case .onForwardTap:
                    viewModel.moveToAdPhoto()
                case .crossDidTap:
                    viewModel.moveToMyHouse()
                case let .typeTextField(text):
                    viewModel.updateAdCreatingRequestModel(propertyType: text)
                case let .numberTextField(text):
                    viewModel.updateAdCreatingRequestModel(numbeOfRoooms: text)
                case let .yearTextField(text):
                    viewModel.updateAdCreatingRequestModel(constructionYear: text)
                case let .garageTextField(text):
                    viewModel.updateAdCreatingRequestModel(parkingType: text)
                case let .livingAreaTextField(text):
                    viewModel.updateAdCreatingRequestModel(livingArea: text)
                case let .squareTextField(text):
                    viewModel.updateAdCreatingRequestModel(square: text)
                case let .priceTextField(text):
                    viewModel.updateAdCreatingRequestModel(price: text)
                }
            }
            .store(in: &cancellables)

        viewModel.adModelPublisher
            .sinkWeakly(self, receiveValue: { (self, adModel) in
                self.contentView.setupView(adModel)
            })
            .store(in: &cancellables)
    }
}
