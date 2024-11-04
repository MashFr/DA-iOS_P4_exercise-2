//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Tony Stark on 17/10/2024.
//

import XCTest
@testable import UserList

@MainActor
final class UserListViewModelTests: XCTestCase {
    
    var viewModel: UserListViewModel!
    let dataRequestMock = DataRequestMock()
    var repository: UserListRepository!
    
    override func setUp() {
        super.setUp()
        dataRequestMock.shouldReturnValidResponse = true
        repository = UserListRepository(executeDataRequest: dataRequestMock.executeDataRequest)
        viewModel = UserListViewModel(repository: repository)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGivenUsersListIsEmpty_WhenReloadUsers_ThenUsersListIsNoLongerEmptyAndNoProblemsOccur() async throws {
        let expectation = XCTestExpectation(description: "reloadUsers completes")
        
        Task {
            await viewModel.reloadUsers() // une tâche asynchrone
            XCTAssertFalse(viewModel.users.isEmpty) // validation une fois la tâche terminée

            let user0 = dataRequestMock.mockUser1
            XCTAssertEqual(viewModel.users[0].name.first, user0.name.first)
            XCTAssertEqual(viewModel.users[0].name.last, user0.name.last)
            XCTAssertEqual(viewModel.users[0].dob.age, user0.dob.age)
            XCTAssertEqual(viewModel.users[0].picture.large, user0.picture.large)
            
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.showAlert)
            
            expectation.fulfill() // Marque l'expectation comme remplie
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testGivenUsersListIsNotEmpty_WhenFetchUsers_ThenUsersListHasNewUsersAndNoProblemsOccur() async throws {
        let expectation = XCTestExpectation(description: "fetchUsers completes")
        
        Task {
            await viewModel.fetchUsers()
            
            XCTAssertFalse(viewModel.users.isEmpty)
            let user0 = dataRequestMock.mockUser1
            XCTAssertEqual(viewModel.users[0].name.first, user0.name.first)
            XCTAssertEqual(viewModel.users[0].name.last, user0.name.last)
            XCTAssertEqual(viewModel.users[0].dob.age, user0.dob.age)
            XCTAssertEqual(viewModel.users[0].picture.large, user0.picture.large)
            
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.showAlert)
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testGivenUsersIsEmpty_WhenFetchUsersAndErrorOccurs_ThenUsersListIsEmptyAndErrorMessageOccur() async throws {
        dataRequestMock.shouldReturnValidResponse = false
        let expectation = XCTestExpectation(description: "fetchUsers with error completes")
        
        Task {
            await viewModel.fetchUsers()
            
            XCTAssertTrue(viewModel.users.isEmpty)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertTrue(viewModel.showAlert)
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testGivenUserIsLastOfUserList_WhenShouldLoadMoreData_ThenTrue() async throws {
        let expectation = XCTestExpectation(description: "fetchUsers for last user completes")
        
        Task {
            await viewModel.fetchUsers()
            
            let lastUser = viewModel.users.last!
            XCTAssertTrue(viewModel.shouldLoadMoreData(currentItem: lastUser))
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testGivenUserIsNotLastOfUserList_WhenShouldLoadMoreData_ThenFalse() async throws {
        let expectation = XCTestExpectation(description: "fetchUsers for first user completes")
        
        Task {
            await viewModel.fetchUsers()
            
            let firstUser = viewModel.users.first!
            XCTAssertFalse(viewModel.shouldLoadMoreData(currentItem: firstUser))
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testGivenGridViewIsFalseWhenToggleGridView_ThenTrue() {
        XCTAssertFalse(viewModel.isGridView)
        viewModel.toggleGridView()
        XCTAssertTrue(viewModel.isGridView)
    }
    
    func testGivenShowAlertIsFalseWhenToggleshowAlert_ThenTrue() {
        XCTAssertFalse(viewModel.showAlert)
        viewModel.toggleAlert()
        XCTAssertTrue(viewModel.showAlert)
    }
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
