//
//  ListViewModel.swift
//  MusicPlayerSwiftUI
//
//  Created by Talor Levy on 3/25/23.
//

import Foundation


class ListViewModel: ObservableObject {
    
    @Published var results: [ResultModel] = []
    
    func fetchResults() {
        NetworkManager.shared.fetchData(urlString: Constants.urls.jsonDocumentUrl.rawValue) { [weak self] (result: Result<JSONModel, Error>) in
            switch result {
            case .success(let jsonDoc):
                self?.results = jsonDoc.results
            case .failure(let error):
                print("Error fetching results at ListViewModel: \(error)")
            }
        }
    }
}
