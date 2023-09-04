//
//  ThemeManager.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 04.09.2023.
//

import Foundation

class ThemeManager {
    // MARK: - Variables

    static let shared = ThemeManager()

    var currentThemeIndex = 0

    var themes: [Theme] = [
        Theme(title: "Default",
              cardColor: nil,
              cardSymbol: "⬛️",
              symbols: ["🌻", "🐍", "🐝", "🌹"]),
    ]

    private init() {
        // check if there are any themes stored in UserDefaults and retreive them as well
        retrieveThemes()
    }

    // MARK: - Public

    func getCurrentTheme() -> Theme {
        return themes[currentThemeIndex]
    }

    func incrementToNextTheme() {
        currentThemeIndex += 1
        if currentThemeIndex == themes.count {
            currentThemeIndex = 0
        }
    }

    // MARK: - Private

    private func storeThemesInUserDefaults(themes: [Theme]?) {
        guard themes != nil else { return }

        // encode the themes and save them to user defaults
        do {
            let encodedThemes = try JSONEncoder().encode(themes)
            UserDefaults.standard.set(encodedThemes, forKey: "themesKey")
        } catch {
            print("Error encoding themes: \(error)")
        }
    }

    private func retrieveThemes() {
        // if there are any themes stored on UserDefaults, retrieve them
        if let storedThemesData = UserDefaults.standard.data(forKey: "themesKey") {
            do {
                let themes = try JSONDecoder().decode([Theme].self, from: storedThemesData)

                self.themes.append(contentsOf: themes)
                return
            } catch {
                print("Error decoding stored themes: \(error)")
            }
        }

        // If themes are not in UserDefaults, fetch them from the API
        let api = API()
        api.fetchThemes { themes in
            // Store the fetched themes in UserDefaults for future use
            guard themes != nil else { return }

            self.storeThemesInUserDefaults(themes: themes ?? [])
            self.themes.append(contentsOf: themes ?? [])
        }
    }
}
