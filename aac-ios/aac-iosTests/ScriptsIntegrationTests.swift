//
//  ScriptsIntegrationTests.swift
//  aac-iosTests
//
//  Integration tests to ensure async script generation features work with the app
//

import XCTest
@testable import aac_ios

final class ScriptsIntegrationTests: XCTestCase {
    var viewModel: ScriptsViewModel!
    
    override func setUpWithError() throws {
        viewModel = ScriptsViewModel()
        
        // Clear all data for clean test state
        UserDefaults.standard.removeObject(forKey: "scripts")
        UserDefaults.standard.removeObject(forKey: "scriptOrder")
        UserDefaults.standard.removeObject(forKey: "scriptsImages")
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        
        // Clean up
        UserDefaults.standard.removeObject(forKey: "scripts")
        UserDefaults.standard.removeObject(forKey: "scriptOrder")
        UserDefaults.standard.removeObject(forKey: "scriptsImages")
    }
    
    // MARK: - Full Workflow Tests
    
    func testCompleteScriptWorkflow_CreateCategoryAndScripts() throws {
        // This test simulates the complete workflow of creating a category and adding scripts
        
        // Step 1: Create a new category
        let categoryName = "TestCategory"
        var categoryTexts: [String: [String]] = [:]
        categoryTexts[categoryName] = Array(repeating: "", count: 6)
        
        var categoryOrder: [Int: String] = [:]
        categoryOrder[1] = categoryName
        
        var categoryImages: [String: String] = [:]
        categoryImages[categoryName] = "test_image.png"
        
        // Step 2: Save all data
        viewModel.saveScripts(categoryTexts)
        viewModel.saveOrder(categoryOrder)
        viewModel.saveImages(categoryImages)
        
        // Step 3: Add scripts to the category
        categoryTexts[categoryName] = ["Script 1", "Script 2", "Script 3", "", "", ""]
        viewModel.saveScripts(categoryTexts)
        
        // Step 4: Verify everything persisted
        let loadedScripts = viewModel.loadScripts()
        let loadedOrder = viewModel.loadOrder()
        let loadedImages = viewModel.loadImages()
        
        XCTAssertNotNil(loadedScripts?[categoryName], "Category should exist")
        XCTAssertEqual(loadedScripts?[categoryName]?.count, 6, "Should have 6 script slots")
        XCTAssertEqual(loadedScripts?[categoryName]?[0], "Script 1", "First script should be saved")
        XCTAssertEqual(loadedOrder?[1], categoryName, "Order should be preserved")
        XCTAssertEqual(loadedImages[categoryName], "test_image.png", "Image path should be saved")
    }
    
    func testMultipleCategories_AllPersistCorrectly() throws {
        // Test that multiple categories can coexist
        
        // Arrange
        let categories = ["Health", "Food", "Activities"]
        var categoryTexts: [String: [String]] = [:]
        var categoryOrder: [Int: String] = [:]
        var categoryImages: [String: String] = [:]
        
        // Act - Create multiple categories
        for (index, category) in categories.enumerated() {
            categoryTexts[category] = Array(repeating: "", count: 6)
            categoryOrder[index + 1] = category
            categoryImages[category] = "\(category.lowercased())_image.png"
        }
        
        viewModel.saveScripts(categoryTexts)
        viewModel.saveOrder(categoryOrder)
        viewModel.saveImages(categoryImages)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        let loadedOrder = viewModel.loadOrder()
        let loadedImages = viewModel.loadImages()
        
        XCTAssertEqual(loadedScripts?.count, 3, "Should have 3 categories")
        XCTAssertEqual(loadedOrder?.count, 3, "Should have 3 order entries")
        XCTAssertEqual(loadedImages.count, 3, "Should have 3 images")
        
        for category in categories {
            XCTAssertNotNil(loadedScripts?[category], "\(category) should exist")
            XCTAssertNotNil(loadedOrder?.values.first(where: { $0 == category }), "\(category) should be in order")
            XCTAssertNotNil(loadedImages[category], "\(category) image should exist")
        }
    }
    
    func testScriptUpdate_ModifiesExistingCategory() throws {
        // Test updating scripts in an existing category
        
        // Arrange - Create initial category
        let categoryName = "Health"
        var categoryTexts: [String: [String]] = [:]
        categoryTexts[categoryName] = ["Old Script 1", "Old Script 2", "", "", "", ""]
        viewModel.saveScripts(categoryTexts)
        
        // Act - Update scripts
        categoryTexts[categoryName] = ["New Script 1", "New Script 2", "New Script 3", "", "", ""]
        viewModel.saveScripts(categoryTexts)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertEqual(loadedScripts?[categoryName]?[0], "New Script 1", "First script should be updated")
        XCTAssertEqual(loadedScripts?[categoryName]?[1], "New Script 2", "Second script should be updated")
        XCTAssertEqual(loadedScripts?[categoryName]?[2], "New Script 3", "Third script should be new")
    }
    
    // MARK: - Data Persistence Tests
    
    func testDataPersistence_AcrossViewModelInstances() throws {
        // Test that data persists when creating new ViewModel instances
        
        // Arrange - Save data with first instance
        let firstViewModel = ScriptsViewModel()
        let testScripts: [String: [String]] = ["Health": ["Script1", "Script2", "", "", "", ""]]
        firstViewModel.saveScripts(testScripts)
        
        // Act - Load with new instance
        let secondViewModel = ScriptsViewModel()
        let loadedScripts = secondViewModel.loadScripts()
        
        // Assert
        XCTAssertNotNil(loadedScripts, "Data should persist across instances")
        XCTAssertEqual(loadedScripts?["Health"], testScripts["Health"], "Scripts should match")
    }
    
    func testDataIntegrity_AfterMultipleSaves() throws {
        // Test that data integrity is maintained after multiple save operations
        
        // Arrange
        var categoryTexts: [String: [String]] = [:]
        var categoryOrder: [Int: String] = [:]
        
        // Act - Save multiple times with updates
        categoryTexts["Health"] = ["Script1"]
        viewModel.saveScripts(categoryTexts)
        categoryOrder[1] = "Health"
        viewModel.saveOrder(categoryOrder)
        
        categoryTexts["Food"] = ["Script2"]
        viewModel.saveScripts(categoryTexts)
        categoryOrder[2] = "Food"
        viewModel.saveOrder(categoryOrder)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        let loadedOrder = viewModel.loadOrder()
        
        XCTAssertEqual(loadedScripts?.count, 2, "Should have both categories")
        XCTAssertEqual(loadedOrder?.count, 2, "Should have both order entries")
        XCTAssertNotNil(loadedScripts?["Health"], "Health should still exist")
        XCTAssertNotNil(loadedScripts?["Food"], "Food should exist")
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyScripts_HandlesCorrectly() throws {
        // Test handling of empty script arrays
        
        // Arrange
        let categoryName = "EmptyCategory"
        var categoryTexts: [String: [String]] = [:]
        categoryTexts[categoryName] = Array(repeating: "", count: 6)
        
        // Act
        viewModel.saveScripts(categoryTexts)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertNotNil(loadedScripts?[categoryName], "Empty category should be saved")
        XCTAssertEqual(loadedScripts?[categoryName]?.count, 6, "Should have 6 empty slots")
        XCTAssertTrue(loadedScripts?[categoryName]?.allSatisfy { $0.isEmpty } ?? false, "All slots should be empty")
    }
    
    func testLargeScriptArrays_HandlesCorrectly() throws {
        // Test that the system can handle categories with many scripts
        
        // Arrange
        let categoryName = "LargeCategory"
        var categoryTexts: [String: [String]] = [:]
        let largeScriptArray = (0..<20).map { "Script \($0)" }
        categoryTexts[categoryName] = largeScriptArray
        
        // Act
        viewModel.saveScripts(categoryTexts)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertEqual(loadedScripts?[categoryName]?.count, 20, "Should handle large arrays")
        XCTAssertEqual(loadedScripts?[categoryName]?[0], "Script 0", "First script should match")
        XCTAssertEqual(loadedScripts?[categoryName]?[19], "Script 19", "Last script should match")
    }
}

