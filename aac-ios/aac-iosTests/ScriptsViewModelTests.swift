//
//  ScriptsViewModelTests.swift
//  aac-iosTests
//
//  Created for testing async script generation and prompt engineering features
//

import XCTest
@testable import aac_ios

final class ScriptsViewModelTests: XCTestCase {
    var viewModel: ScriptsViewModel!
    
    override func setUpWithError() throws {
        // Create a fresh instance for each test
        viewModel = ScriptsViewModel()
        
        // Clear UserDefaults for clean test state
        UserDefaults.standard.removeObject(forKey: "scripts")
        UserDefaults.standard.removeObject(forKey: "scriptOrder")
        UserDefaults.standard.removeObject(forKey: "scriptsImages")
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        
        // Clean up UserDefaults after each test
        UserDefaults.standard.removeObject(forKey: "scripts")
        UserDefaults.standard.removeObject(forKey: "scriptOrder")
        UserDefaults.standard.removeObject(forKey: "scriptsImages")
    }
    
    // MARK: - Script Saving and Loading Tests
    
    func testSaveScripts_SavesCorrectly() throws {
        // Arrange
        let testScripts: [String: [String]] = [
            "Health": ["I need help", "I'm in pain", "Call doctor"],
            "Food": ["I'm hungry", "I want water", "I'm full"]
        ]
        
        // Act
        viewModel.saveScripts(testScripts)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertNotNil(loadedScripts, "Scripts should be saved and loadable")
        XCTAssertEqual(loadedScripts?["Health"], testScripts["Health"], "Health scripts should match")
        XCTAssertEqual(loadedScripts?["Food"], testScripts["Food"], "Food scripts should match")
    }
    
    func testLoadScripts_ReturnsNilWhenNoScriptsExist() throws {
        // Act
        let loadedScripts = viewModel.loadScripts()
        
        // Assert
        XCTAssertNil(loadedScripts, "Should return nil when no scripts are saved")
    }
    
    func testSaveScripts_HandlesNilValue() throws {
        // Act - Should not crash
        viewModel.saveScripts(nil)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertNil(loadedScripts, "Saving nil should result in nil when loaded")
    }
    
    func testSaveScripts_OverwritesPreviousData() throws {
        // Arrange
        let firstScripts: [String: [String]] = ["Category1": ["Script1"]]
        let secondScripts: [String: [String]] = ["Category2": ["Script2"]]
        
        // Act
        viewModel.saveScripts(firstScripts)
        viewModel.saveScripts(secondScripts)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertEqual(loadedScripts?.keys.count, 1, "Should only have one category after overwrite")
        XCTAssertNil(loadedScripts?["Category1"], "First category should be gone")
        XCTAssertNotNil(loadedScripts?["Category2"], "Second category should exist")
    }
    
    // MARK: - Script Order Tests
    
    func testSaveOrder_SavesCorrectly() throws {
        // Arrange
        let testOrder: [Int: String] = [
            1: "Health",
            2: "Food",
            3: "Activities"
        ]
        
        // Act
        viewModel.saveOrder(testOrder)
        
        // Assert
        let loadedOrder = viewModel.loadOrder()
        XCTAssertNotNil(loadedOrder, "Order should be saved and loadable")
        XCTAssertEqual(loadedOrder?[1], "Health", "First item should be Health")
        XCTAssertEqual(loadedOrder?[2], "Food", "Second item should be Food")
        XCTAssertEqual(loadedOrder?[3], "Activities", "Third item should be Activities")
    }
    
    func testLoadOrder_ReturnsNilWhenNoOrderExists() throws {
        // Act
        let loadedOrder = viewModel.loadOrder()
        
        // Assert
        XCTAssertNil(loadedOrder, "Should return nil when no order is saved")
    }
    
    func testSaveOrder_HandlesNilValue() throws {
        // Act - Should not crash
        viewModel.saveOrder(nil)
        
        // Assert
        let loadedOrder = viewModel.loadOrder()
        XCTAssertNil(loadedOrder, "Saving nil should result in nil when loaded")
    }
    
    // MARK: - Image Saving and Loading Tests
    
    func testSaveImages_SavesCorrectly() throws {
        // Arrange
        let testImages: [String: String] = [
            "Health": "health_image.png",
            "Food": "food_image.png"
        ]
        
        // Act
        viewModel.saveImages(testImages)
        
        // Assert
        let loadedImages = viewModel.loadImages()
        XCTAssertEqual(loadedImages["Health"], "health_image.png", "Health image path should match")
        XCTAssertEqual(loadedImages["Food"], "food_image.png", "Food image path should match")
    }
    
    func testLoadImages_ReturnsEmptyDictionaryWhenNoImagesExist() throws {
        // Act
        let loadedImages = viewModel.loadImages()
        
        // Assert
        XCTAssertTrue(loadedImages.isEmpty, "Should return empty dictionary when no images are saved")
    }
    
    func testSaveImages_OverwritesPreviousData() throws {
        // Arrange
        let firstImages: [String: String] = ["Category1": "image1.png"]
        let secondImages: [String: String] = ["Category2": "image2.png"]
        
        // Act
        viewModel.saveImages(firstImages)
        viewModel.saveImages(secondImages)
        
        // Assert
        let loadedImages = viewModel.loadImages()
        XCTAssertEqual(loadedImages.keys.count, 1, "Should only have one image after overwrite")
        XCTAssertNil(loadedImages["Category1"], "First image should be gone")
        XCTAssertEqual(loadedImages["Category2"], "image2.png", "Second image should exist")
    }
    
    // MARK: - Integration Tests
    
    func testSaveAndLoadAllData_WorksTogether() throws {
        // Arrange
        let testScripts: [String: [String]] = ["Health": ["Script1", "Script2"]]
        let testOrder: [Int: String] = [1: "Health"]
        let testImages: [String: String] = ["Health": "health.png"]
        
        // Act
        viewModel.saveScripts(testScripts)
        viewModel.saveOrder(testOrder)
        viewModel.saveImages(testImages)
        
        // Assert - All should work together
        XCTAssertNotNil(viewModel.loadScripts(), "Scripts should load")
        XCTAssertNotNil(viewModel.loadOrder(), "Order should load")
        XCTAssertFalse(viewModel.loadImages().isEmpty, "Images should load")
    }
    
    func testMultipleCategories_PersistCorrectly() throws {
        // Arrange
        let testScripts: [String: [String]] = [
            "Health": ["H1", "H2"],
            "Food": ["F1", "F2"],
            "Activities": ["A1", "A2"]
        ]
        let testOrder: [Int: String] = [1: "Health", 2: "Food", 3: "Activities"]
        
        // Act
        viewModel.saveScripts(testScripts)
        viewModel.saveOrder(testOrder)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        let loadedOrder = viewModel.loadOrder()
        
        XCTAssertEqual(loadedScripts?.count, 3, "Should have 3 categories")
        XCTAssertEqual(loadedOrder?.count, 3, "Should have 3 order entries")
        XCTAssertEqual(loadedOrder?[1], "Health", "First should be Health")
    }
}

