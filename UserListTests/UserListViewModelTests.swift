//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Tony Stark on 17/10/2024.
//

import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {
    // TODO: Try to mock the network
    
    var viewModel: UserListViewModel!
    
    override func setUp() {
        super.setUp()
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        viewModel = UserListViewModel(repository: repository)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func testGivenUsersListIsEmpty_WhenReloadUsers_ThenUsersListIsNoLongerEmptyAndNoProblemsOccur() async throws {
        // Given
        // When
        await viewModel.reloadUsers()

        // Then
        XCTAssertFalse(viewModel.users.isEmpty)
        // And
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showAlert)
    }

//    @MainActor
//    func testGivenUsersListIsEmpty_WhenReloadUsers_ThenUsersListIsNoLongerEmpty() async throws {
//        let expectation = XCTestExpectation(description: "fetchUsers asynchronously.")
//
//        Task {
//            await viewModel.reloadUsers()
//            XCTAssertFalse(viewModel.users.isEmpty)
//            expectation.fulfill()
//        }
//        
//        await fulfillment(of: [expectation], timeout: 10) 
//    }
}


private extension UserListViewModelTests {
    // Define a mock for executeDataRequest that returns predefined data
    func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Create mock data with a sample JSON response
        let sampleJSON = """
            {
                "results": [
                    {
                        "name": {
                            "title": "Mr",
                            "first": "John",
                            "last": "Doe"
                        },
                        "dob": {
                            "date": "1990-01-01",
                            "age": 31
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    },
                    {
                        "name": {
                            "title": "Ms",
                            "first": "Jane",
                            "last": "Smith"
                        },
                        "dob": {
                            "date": "1995-02-15",
                            "age": 26
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    }
                ]
            }
        """

        let data = sampleJSON.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
}
