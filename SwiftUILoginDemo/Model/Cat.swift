//
//  Cat.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/20.
//

import Foundation
import Combine

struct Cat: Identifiable {
    var id: String
    let imageURL: String
}

class RemoteImage: ObservableObject {
    
    @Published var data = Data()
    init(url: String) {
        let token = SubscriptionToken()
        URLSession.shared
            .dataTaskPublisher(for: URL(string: url)!).map { $0.data }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink(receiveCompletion: { (complete) in
                token.remove()
            }, receiveValue: { [weak self](data) in
                guard let self = self else { return }
                guard let data = data else { return }
                self.data = data
            })
            .store(in: token)
    }
}
