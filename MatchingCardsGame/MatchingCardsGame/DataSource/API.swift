//
//  API.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 04.09.2023.
//

import Foundation

struct API {
    func fetchThemes(completion: @escaping ([Theme]?) -> Void) {
        guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/concentrationgame-20753.appspot.com/o/themes.json?alt=media&token=6898245a-0586-4fed-b30e-5078faeba078") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching themes: \(error)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let themes = try JSONDecoder().decode([Theme].self, from: data)
                    completion(themes)
                } catch {
                    print("Error decoding themes: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
}
