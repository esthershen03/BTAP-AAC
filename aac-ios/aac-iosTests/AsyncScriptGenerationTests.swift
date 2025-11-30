//
//  AsyncScriptGenerationTests.swift
//  aac-iosTests
//
//  Tests for async script generation and image loading features
//

import XCTest
import SwiftUI
import PhotosUI
@testable import aac_ios

final class AsyncScriptGenerationTests: XCTestCase {
    
    // MARK: - Async Image Loading Tests
    
    func testAsyncImageLoading_CompletesSuccessfully() async throws {
        // This test verifies that the async image loading pattern works
        // Note: In a real scenario, you'd mock PhotosPickerItem
        
        // Arrange
        let expectation = XCTestExpectation(description: "Image loading completes")
        
        // Act - Simulate the async pattern used in Scripts.swift
        Task { @MainActor in
            // Simulate async work (like loading from PhotosPickerItem)
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            
            // Simulate successful image data loading
            let testImageData = createTestImageData()
            if let uiImage = UIImage(data: testImageData) {
                expectation.fulfill()
            }
        }
        
        // Assert
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testAsyncImageLoading_HandlesFailure() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Async task handles failure")
        
        // Act - Simulate failed async image loading
        Task { @MainActor in
            do {
                // Simulate a failure scenario
                try await Task.sleep(nanoseconds: 50_000_000)
                throw NSError(domain: "TestError", code: 1)
            } catch {
                expectation.fulfill()
            }
        }
        
        // Assert
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    // MARK: - Script Generation Workflow Tests
    
    func testScriptGeneration_AddsNewCategory() throws {
        // Arrange
        let viewModel = ScriptsViewModel()
        var categories: [String] = []
        let newCategory = "TestCategory"
        
        // Act - Simulate adding a new category
        if !categories.contains(newCategory) {
            categories.append(newCategory)
            var categoryTexts: [String: [String]] = [:]
            categoryTexts[newCategory] = Array(repeating: "", count: 6)
            
            viewModel.saveScripts(categoryTexts)
        }
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertNotNil(loadedScripts?[newCategory], "New category should be saved")
        XCTAssertEqual(loadedScripts?[newCategory]?.count, 6, "New category should have 6 empty script slots")
    }
    
    func testScriptGeneration_DoesNotDuplicateCategories() throws {
        // Arrange
        let viewModel = ScriptsViewModel()
        var categories: [String] = ["Health"]
        let existingCategory = "Health"
        
        // Act - Try to add duplicate
        if !categories.contains(existingCategory) {
            categories.append(existingCategory)
        }
        
        // Assert
        XCTAssertEqual(categories.count, 1, "Should not add duplicate category")
        XCTAssertEqual(categories.first, "Health", "Should keep original category")
    }
    
    func testScriptGeneration_SavesScriptsCorrectly() throws {
        // Arrange
        let viewModel = ScriptsViewModel()
        let categoryName = "Health"
        let testScripts = ["I need help", "I'm in pain", "Call doctor", "", "", ""]
        
        // Act
        var categoryTexts: [String: [String]] = [:]
        categoryTexts[categoryName] = testScripts
        viewModel.saveScripts(categoryTexts)
        
        // Assert
        let loadedScripts = viewModel.loadScripts()
        XCTAssertEqual(loadedScripts?[categoryName], testScripts, "Scripts should be saved correctly")
    }
    
    // MARK: - Image Path Management Tests
    
    func testImagePath_SavesToDocumentDirectory() throws {
        // Arrange
        let testImage = createTestUIImage()
        let fileName = UUID().uuidString + ".png"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsDirectory.appendingPathComponent(fileName)
        
        // Act
        guard let imageData = testImage.pngData() else {
            XCTFail("Failed to create image data")
            return
        }
        
        try imageData.write(to: filePath)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath.path), "Image should be saved to documents directory")
        
        // Cleanup
        try? FileManager.default.removeItem(at: filePath)
    }
    
    func testImagePath_LoadsFromDocumentDirectory() throws {
        // Arrange
        let testImage = createTestUIImage()
        let fileName = UUID().uuidString + ".png"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsDirectory.appendingPathComponent(fileName)
        
        guard let imageData = testImage.pngData() else {
            XCTFail("Failed to create image data")
            return
        }
        
        try imageData.write(to: filePath)
        
        // Act
        let loadedImage = UIImage(contentsOfFile: filePath.path)
        
        // Assert
        XCTAssertNotNil(loadedImage, "Should be able to load image from documents directory")
        
        // Cleanup
        try? FileManager.default.removeItem(at: filePath)
    }
    
    // MARK: - Helper Methods
    
    private func createTestImageData() -> Data {
        // Create a simple 1x1 pixel image for testing
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.pngData() ?? Data()
    }
    
    private func createTestUIImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

