//
//  SelectRegionViewModel.swift
//  FindCovidVaccineCenter
//
//  Created by UAPMobile on 2022/02/11.
//

import Foundation
import Combine

// data change => emit event
class SelectRegionViewModel: ObservableObject {
    @Published var centers = [Center.Sido: [Center]]()
    private var cancellables = Set<AnyCancellable>()  // DisposeBag
    
    init(centerNetwork: CenterNetwork = CenterNetwork()){
        // view로 작성되어야 하는 모델이기 때문에 main에서 receive
        // AnyPublisher<[Sido],UrlError> 를 return 하는 메소드
        // .sink 는 subscriber 역할로서 작업 처리
        centerNetwork.getCenterList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                [weak self] in
                guard case .failure(let error) = $0 else { return }
                print(error.localizedDescription)
                self?.centers = [Center.Sido: [Center]]()
            },
                  receiveValue: {
                    [weak self] centers in
                    self?.centers = Dictionary(grouping: centers) { $0.sido }
                  }
            )
            .store(in: &cancellables)  //disposed(by:disposeBag)
    }
}
