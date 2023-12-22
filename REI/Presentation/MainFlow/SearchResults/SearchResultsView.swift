//
//  FindView.swift
//  REI
//
//  Created by User on 05.04.2023.
//

import GoogleMobileAds
import Combine
import CoreLocation
import MapKit
import UIKit

enum SearchResultsViewAction {
    case refreshCollection
    case collectionBottomDidReach
    case fromSelectViewTransition(SelectViewAction)
    case onCellHeartButtonPublisher(selectedItem: SearchResultsItem)
    case selectedItem(SearchResultsItem)
    case showAlert(UIAlertController)
    case visiblePoligon(coordinates: String)
}

final class SearchResultsView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchResultsSection, SearchResultsItem>?
    private let locationManager = CLLocationManager()

    // MARK: - Subviews
    private lazy var stackView = UIStackView()
    private lazy var selectView = SelectView()
    private lazy var resultView = ResultView()
    private lazy var collectionView: UICollectionView = createCollectionView()
    private lazy var mapView = MKMapView()
    private lazy var availableHousesButton = UIButton()
    private let bannerView = GADBannerView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchResultsViewAction, Never>()

    private lazy var stackViewTopConstraint = stackView.topAnchor.constraint(
        equalTo: self.safeAreaLayoutGuide.topAnchor,
        constant: 0
    )
    
   private let refreshControl = UIRefreshControl()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
           refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
           collectionView.refreshControl = refreshControl
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func refreshCollection() {
        actionSubject.send(.refreshCollection)
        refreshControl.endRefreshing()
    }

    // MARK: - Private methods
    private func createCollectionView() -> UICollectionView {
        let sectionProvider =
            { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
                listConfiguration.showsSeparators = true
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)

                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }

    private func setupCollectionView() {
        collectionView.register(PhotoCell.self)
        collectionView.register(MainCell.self)
        collectionView.register(ListCell.self)
        collectionView.register(MapCell.self)

        setupDataSource()
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollectionView()
        bindActions()
    }
    
    private func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { SearchResultsViewAction.selectedItem($0) }
            .sink { [unowned self] in
                self.actionSubject.send($0)
            }
            .store(in: &cancellables)

        collectionView.reachedBottomPublisher()
            .sink { [unowned self] in
                self.actionSubject.send(.collectionBottomDidReach)
            }
            .store(in: &cancellables)

        collectionView.contentOffsetPublisher
            .sink { [unowned self] offset in
                let yOffset = offset.y
                let selectViewHeight = selectView.bounds.height
                if yOffset >= selectViewHeight {
                    stackViewTopConstraint.constant = -selectViewHeight
                } else {
                    stackViewTopConstraint.constant = -yOffset
                }
            }
            .store(in: &cancellables)

        selectView.actionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                self.actionSubject.send(.fromSelectViewTransition(transition))
            })
            .store(in: &cancellables)
        
        availableHousesButton.tapPublisher
            .sinkWeakly(self, receiveValue: {(self, _) in
                let region = self.mapView.region
                let regionCenter = region.center
                let spanLatitude = region.span.latitudeDelta
                let spanLongitude = region.span.longitudeDelta
                let nwLatitude = regionCenter.latitude + spanLatitude/2
                let nwLongitude = regionCenter.longitude - spanLongitude/2
                let swLatitude = regionCenter.latitude - spanLatitude/2
                let swLongitude = nwLongitude
                let seLatitude = swLatitude
                let seLongitude = regionCenter.longitude + spanLongitude/2
                let neLatitude = nwLatitude 
                let neLongitude = seLongitude
                let poligon = "POLYGON((\(nwLatitude) \(nwLongitude), \(swLatitude) \(swLongitude), \(seLatitude) \(seLongitude), \(neLatitude) \(neLongitude), \(nwLatitude) \(nwLongitude)))"
            
                self.actionSubject.send(.visiblePoligon(coordinates: poligon))
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fill

        mapView.userTrackingMode = .follow
        mapView.isHidden = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        availableHousesButton.rounded(3)
        availableHousesButton.bordered(width: 2, color: .gray)
        availableHousesButton.backgroundColor = .orange
        availableHousesButton.tintColor = .white
        availableHousesButton.setTitle("Get suggestions in this area", for: .normal)
        availableHousesButton.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.bannerView.isHidden = true
        }
    }

    private func setupLayout() {
        stackView.addArrangedSubview(selectView)
        stackView.addArrangedSubview(resultView)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(mapView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackViewTopConstraint,
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        addSubview(availableHousesButton) {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-100)
            $0.height.equalTo(50)
        }
        
        addSubview(bannerView) {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - View constants
private enum Constant {}

// MARK: - extension
extension SearchResultsView {
    func showCollection(sections: [SearchResultsCollection]) {
        collectionView.isHidden = false
        mapView.isHidden = true
        availableHousesButton.isHidden = true
        setupSnapShot(sections: sections)
        
        if sections.last?.section != .main  {
            let section = sections.count - 1
            if self.collectionView.numberOfItems(inSection: section) > 10 {
                let item = self.collectionView.numberOfItems(inSection: section) - 1
                let lastItemIndex = IndexPath(item: item, section: section)
                self.collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
            }
        }
    }

    func showMapView(model: MapCellModel) {
        locationManager.delegate = self
        locationManagerDidChangeAuthorization(locationManager)
    }

    func makeSelectView(isVisible: Bool) {
        selectView.isHidden = !isVisible
    }

    func updateResultView(with data: ResultViewModel) {
        resultView.setup(with: data)
    }
    
    func setupBanner(_ viewController: UIViewController) {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
        bannerView.rootViewController = viewController
    }

    func setupSnapShot(sections: [SearchResultsCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultsSection, SearchResultsItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchResultsSection, SearchResultsItem>(
            collectionView: collectionView,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .photo(model):
                    let cell: PhotoCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(model)
                    cell.heartButtonDidTap = { [weak self] in
                        self?.actionSubject.send(.onCellHeartButtonPublisher(selectedItem: item))
                    }
                    return cell

                case let .main(model):
                    let cell: MainCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(model)
                    return cell

                case let .list(model):
                    let cell: ListCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.heartButtonDidTap = { [weak self] in
                        self?.actionSubject.send(.onCellHeartButtonPublisher(selectedItem: item))
                    }
                    cell.setupCell(model)
                    return cell
                }
            }
        )
    }
}

// MARK: - extension CLLocationManagerDelegate
extension SearchResultsView: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            collectionView.isHidden = true
            mapView.isHidden = false
            availableHousesButton.isHidden = false
            manager.startUpdatingLocation()
        case .restricted, .denied:
            // TODO: from this state requestWhenInUseAuthorization() isn't being called
            let alert = UIAlertController(
                title: "Access to user location is restricted",
                message: "Change your setting in General",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "User location", style: .default) { _ in
                manager.requestWhenInUseAuthorization()
                print(String(describing: manager.authorizationStatus))
            })
            actionSubject.send(.showAlert(alert))
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
//        mapView.setRegion(region, animated: true)


        let ditzingenCenter = CLLocationCoordinate2D(
            latitude: 48.8372486549913,
            longitude: 9.00023878679861
        )
        mapView.setCenter(ditzingenCenter, animated: true)
    }
    
    func showOnMap(location: Point, address: String) {
            let houseLocation = CLLocationCoordinate2D(
                latitude: location.coordinates[0],
                longitude: location.coordinates[1]
            )

            let annotation = MKPointAnnotation()
            annotation.coordinate = houseLocation
            annotation.title = address

            self.mapView.addAnnotation(annotation)
        }
}

#if DEBUG
    import SwiftUI
    struct FindPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(SearchResultsView())
        }
    }
#endif
