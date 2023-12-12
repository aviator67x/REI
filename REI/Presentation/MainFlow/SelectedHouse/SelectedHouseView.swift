//
//  SelectedHouseView.swift
//  REI
//
//  Created by User on 31.05.2023.
//

import Combine
import CoreLocation
import MapKit
import SnapKit
import UIKit
import Kingfisher

enum SelectedHouseViewAction {
    case onHeartButtonTap(itemId: String)
    case imageDidTap
    case call
    case sendEmail
    case onBlueprintTap
    case onAllaroundTap
    case onVideoTap
}

final class SelectedHouseView: BaseView {
    // MARK: - Subviews
    let scrollView = UIScrollView()
    let contentView = UIView()
    let imageView = UIImageView()
    let upperButtonStack = UIStackView()
    let allaroundButton = UIButton()
    let videoButton = UIButton()
    let blueprintButton = UIButton()
    let streetLabel = UILabel()
    let ortLabel = UILabel()
    let sqmLabel = UILabel()
    let descTitleLabel = UILabel()
    let spacer = UIView()
    let priceValueLabel = UILabel()
    let stackView = UIStackView()
    let heartButton = UIButton()
    let descriptionLabel = UILabel()
    let moreButton = UIButton()
    let buttonStack = UIStackView()
    let callButton = UIButton()
    let writeButton = UIButton()
    let separator = UIView()
    let mapView = MKMapView()
    let downSpacer = UIView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SelectedHouseViewAction, Never>()

    private var currentItemId: String?

    private var isMore = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        heartButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                guard let currentItemId = self.currentItemId else {
                    return
                }
                self.actionSubject.send(.onHeartButtonTap(itemId: currentItemId))
            })
            .store(in: &cancellables)

        moreButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.isMore.toggle()
                let nsString = Constant.text.rawValue as NSString
                self.descriptionLabel.text = self.isMore ? nsString
                    .substring(with: NSRange(location: 0, length: nsString.length > 300 ? 300 : nsString.length)) :
                    Constant.text.rawValue
                self.moreButton.setTitle(self.isMore ? "Show More" : "Show Less", for: .normal)
                self.layoutIfNeeded()

            })
            .store(in: &cancellables)
        
        callButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.call)
            })
            .store(in: &cancellables)
        
        writeButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                        self.actionSubject.send(.sendEmail)
            })
            .store(in: &cancellables)
        
        blueprintButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                        self.actionSubject.send(.onBlueprintTap)
            })
            .store(in: &cancellables)
        
        allaroundButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                        self.actionSubject.send(.onAllaroundTap)
            })
            .store(in: &cancellables)
        
        videoButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                        self.actionSubject.send(.onVideoTap)
            })
            .store(in: &cancellables)
    }

    @objc
    func imageDidTap() {
        actionSubject.send(.imageDidTap)
    }

    private func setupUI() {
        backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never

        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageDidTap))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true

        stackView.axis = .vertical
        stackView.spacing = 1

        upperButtonStack.axis = .horizontal
        upperButtonStack.distribution = .fillEqually

        [allaroundButton, blueprintButton, videoButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.cornerRadius = 3
            button.bordered(width: 1, color: .lightGray)
        }
        blueprintButton.setTitle("Blueprint", for: .normal)
        allaroundButton.setTitle("360", for: .normal)
        videoButton.setTitle("Video", for: .normal)

        streetLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        ortLabel.font = UIFont.systemFont(ofSize: 16)
        sqmLabel.font = UIFont.systemFont(ofSize: 16)
        priceValueLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        descTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        descTitleLabel.text = "Description"

        let nsString = Constant.text.rawValue as NSString
        descriptionLabel.text = nsString
            .substring(with: NSRange(location: 0, length: nsString.length > 300 ? 300 : nsString.length))
        descriptionLabel.numberOfLines = 0

        moreButton.setTitleColor(.gray, for: .normal)
        moreButton.titleLabel?.textAlignment = .center
        moreButton.layer.cornerRadius = 3
        moreButton.bordered(width: 1, color: .lightGray)
        moreButton.setTitle("Show more", for: .normal)

        buttonStack.backgroundColor = .white
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 16
        buttonStack.bordered(width: 0.5, color: .lightGray)
        buttonStack.layoutMargins = UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16)
        buttonStack.isLayoutMarginsRelativeArrangement = true

        separator.backgroundColor = .gray
        separator.layer.shadowColor = UIColor.black.cgColor
        separator.layer.shadowOpacity = 1
        separator.layer.shadowOffset = CGSize(width: 10, height: 0)
        separator.layer.shadowRadius = 3

        [callButton, writeButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.cornerRadius = 3
        }
        callButton.setTitle("+ 31 890 2345678", for: .normal)
        callButton.backgroundColor = .white
        callButton.layer.cornerRadius = 3
        callButton.bordered(width: 1, color: .lightGray)

        writeButton.backgroundColor = .orange
        writeButton.setTitle("Apply for the listing", for: .normal)
    }

    private func setupLayout() {
        addSubview(scrollView) {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView) {
            $0.leading.trailing.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }

        contentView.addSubview(imageView) {
            $0.leading.top.trailing.equalTo(contentView)
            $0.height.equalTo(250)
        }

        contentView.addSubview(upperButtonStack) {
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }

        upperButtonStack.addArrangedSubviews([blueprintButton, allaroundButton, videoButton])

        contentView.addSubview(stackView) {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(upperButtonStack.snp.bottom).offset(20)
        }

        spacer.snp.makeConstraints {
            $0.height.equalTo(10)
        }

        stackView.addArrangedSubviews([streetLabel, ortLabel, sqmLabel, spacer, priceValueLabel])

        addSubview(descTitleLabel) {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(stackView.snp.bottom).offset(20)
        }

        contentView.addSubview(descriptionLabel) {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(descTitleLabel.snp.bottom)
        }

        contentView.addSubview(moreButton) {
            $0.top.equalTo(descriptionLabel.snp.bottom)
            $0.centerX.equalTo(descriptionLabel.snp.centerX).offset(100)
            $0.height.equalTo(20)
            $0.width.equalTo(100)
        }

        contentView.addSubview(mapView) {
            $0.top.equalTo(moreButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(250)
        }

        contentView.addSubview(downSpacer) {
            $0.top.equalTo(mapView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
            $0.bottom.equalToSuperview()
        }

        contentView.addSubview(heartButton) {
            $0.size.equalTo(40)
            $0.trailing.top.equalToSuperview().inset(20)
        }

        addSubview(buttonStack) {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(50)
        }

        callButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        writeButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        buttonStack.addArrangedSubviews([callButton, writeButton])

        addSubview(separator) {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonStack.snp.top)
            $0.height.equalTo(0.5)
        }
    }

    func setupView(_ model: SelectedHouseModel) {
        currentItemId = model.id
        let url = model.image
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "house"))
        
        streetLabel.text = [model.street, String(model.house)].joined(separator: " ")
        ortLabel.text = model.ort
        sqmLabel.text = "\(model.livingArea) sqm / \(model.square) sqm \u{00B7} \(model.numberOfRooms) rooms"
        priceValueLabel.text = "\u{20AC} \(String(model.price)) k.k."

        let mediumConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let mediumBoldHeartEmpty = UIImage(systemName: "heart", withConfiguration: mediumConfig)
        let mediumBoldHeartFill = UIImage(systemName: "heart.fill", withConfiguration: mediumConfig)
        heartButton.setImage(model.isFavourite ? mediumBoldHeartFill : mediumBoldHeartEmpty, for: .normal)
        heartButton.tintColor = model.isFavourite ? .red : .white

        let address = [model.ort, model.street, String(model.house)].joined(separator: ",")
        guard let location = model.location else {
            return
        }
        showOnMap(location: location, address: address)
    }

    func showOnMap(location: Point, address: String) {
            let houseLocation = CLLocationCoordinate2D(
                latitude: location.coordinates[0],
                longitude: location.coordinates[1]
            )

            let annotation = MKPointAnnotation()
            annotation.coordinate = houseLocation
            annotation.title = address
            let coordinateRegion = MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
            self.mapView.setRegion(coordinateRegion, animated: true)
            self.mapView.addAnnotation(annotation)
        }
    }
//}

// MARK: - View constants
private enum Constant: String {
    case text = """
        What a wonderful view!
        This neatly finished family home is located in a particularly beautiful location in the popular new housing estate De Draai. At the front of the house you can dream away with the idyllic view of a thatched farm with grassland, trees and ditch in front. You don't have the feeling that you live in a new residential area at all!
        At the rear you have a nice view into your own backyard. This garden is neatly laid out, located on the sunny southwest and has a gate to get to the public road. In addition, here is the detached wooden shed for storing your bicycles and garden equipment.
        De Draai is a child-friendly neighborhood with a relatively large number of families. Facilities such as primary and secondary education, a supermarket, public transport (bus/train), the old center of Heerhugowaard and the Middenwaard shopping center are within walking and/or cycling distance.
        Layout of the house:
        Ground floor:
        Entrance, hall, modern meter cupboard and light toilet with fountain. The garden-oriented living room has a door to the backyard and the floor is finished with a beautiful PVC floor with underfloor heating. The contemporary open kitchen consists of 2 parallel kitchen blocks that are equipped with a 5-burner gas stove, oven, extractor hood, dishwasher and fridge freezer. The first floor can be reached via the partly open staircase.
        First floor:
        Landing with stairs to the second floor and access to all areas on this floor. At the front of the house is the largest bedroom with 2 large skylights that let in a lot of light. Then there is a modern bathroom with shower, sink and toilet. The two smaller bedrooms can be found at the rear. The first floor is heated by radiators.
        Second floor:
        Via a staircase you reach the spacious attic with skylight. You can use this space as a bedroom, study / office or hobby room. Here you will find the washing machine and dryer connection. The central heating boiler and heat recovery unit are located in a closed cabinet. There is also storage space behind the knee bulkheads.
        Garden:
        Both the front and backyard are neatly landscaped and offer opportunities to enjoy the outdoors. The backyard is located on the southwest, so you can grab quite a few hours of sunshine. There is also a detached wooden shed here.
        Details:
        - Beautiful view of farm with grassland in front;
        - Underfloor heating on the ground floor;
        - Possibility to create an extra bedroom on the second floor;
        - Energy label A;
        - Very low energy and gas costs;
        - 3 solar panels on the roof;
        - Acceptance in consultation.
        Fished behind the net again? Call in your own Heerhugowaard NVM purchase broker immediately. Your Heerhugowaard NVM purchase broker will stand up for your interests and save you time, money and worries!
    """
}

#if DEBUG
    import SnapKit
    import SwiftUI
    struct SelectedHousePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(SelectedHouseView())
        }
    }
#endif
