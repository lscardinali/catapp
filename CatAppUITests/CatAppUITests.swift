//
//  CatAppUITests.swift
//  CatAppUITests
//
//  Created by Lucas Cardinali on 7/10/24.
//

import XCTest

final class CatAppUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testLoadInitialData() throws {

        let app = XCUIApplication()
        app.launchArguments += ["--uitesting"]
        app.launch()

        XCTAssertTrue(app.scrollViews["BreedList"].exists)

        app.staticTexts["BreedTileName"].waitForExistence(timeout: 10)

        let favoriteTab = app.buttons["FavoritesTab"]
        let breedsTab = app.buttons["BreedsTab"]

        favoriteTab.tap()

        let noFavoritesText = app.staticTexts["noFavoritesText"]
        XCTAssertTrue(noFavoritesText.exists)

        breedsTab.tap()

        let favoriteButtons = app.buttons["FavoriteButton"]
        XCTAssertTrue(favoriteButtons.exists)
        favoriteButtons.firstMatch.tap()

        favoriteTab.tap()

        XCTAssertFalse(noFavoritesText.exists)

        breedsTab.tap()

        let searchField = app.searchFields.firstMatch

        searchField.tap()
        searchField.typeText("aegean")

        let tiles = app.staticTexts.matching(identifier: "BreedTileName")
        XCTAssertEqual(tiles.count, 1)

        tiles.firstMatch.tap()

        XCTAssertTrue(app.images["BreedDetailImage"].exists)

    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
