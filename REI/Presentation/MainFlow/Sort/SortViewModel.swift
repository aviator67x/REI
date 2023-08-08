//
//  SortViewModel.swift
//  REI
//
//  Created by User on 03.08.2023.
//

import Combine

final class SortViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SortTransition, Never>()
    
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[SortTable], Never>([])
    
   override init() {
        super.init()
    }
    
    override func onViewDidLoad() {
        createDataSource()
    }
    
    private func  createDataSource() {
        let items = [
            SortItem.title(model: TitleCellModel(title: "Address", isCheckmarkHidden: false)),
            SortItem.address(model: SortCellModel(name: "a - z", isHidden: false, isSelected: false, arrowImageName: "arrow.up")),
            SortItem.address(model: SortCellModel(name: "z - a", isHidden: false, isSelected: true, arrowImageName: "arrow.down"))]
        let section = SortTable(section: .button, items: items)
        
        sectionsSubject.value = [section]
    }
}
