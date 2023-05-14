//
//  CategoryViewModel.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 14.05.2023.
//

import Foundation


import Foundation

class CategoryViewModel {
    var genres = [Genre]()
    var updateUI: (() -> Void)?

    func getGenres() {
        APIManager.shared.getGenres { [weak self] data in
            switch(data)
            {
            case .success(let genres):
                self?.genres = genres.data ?? [Genre]()
                self?.updateUI?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
