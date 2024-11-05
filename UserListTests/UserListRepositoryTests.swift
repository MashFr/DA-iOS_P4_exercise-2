import XCTest
@testable import UserList




final class UserListRepositoryTests: XCTestCase {
    
    let dataRequestMock = DataRequestMock()
    var repository: UserListRepository!
    var user1: UserListResponse.User!
    var user2: UserListResponse.User!
    
    override func setUp() {
        super.setUp()
        dataRequestMock.shouldReturnValidResponse = true
        repository = UserListRepository(executeDataRequest: dataRequestMock.executeDataRequest)
    }
    
    func testFetchUsersSuccess() async throws {
        // Given
        let quantity = 2

        // When
        let users = try await repository.fetchUsers(quantity: quantity)

        // Then
        let user0 = dataRequestMock.mockUser1
        XCTAssertEqual(users.count, quantity)
        XCTAssertEqual(users[0].name.first, user0.name.first)
        XCTAssertEqual(users[0].name.last, user0.name.last)
        XCTAssertEqual(users[0].dob.age, user0.dob.age)
        XCTAssertEqual(users[0].picture.large, user0.picture.large)

        let user1 = dataRequestMock.mockUser2
        XCTAssertEqual(users[1].name.first, user1.name.first)
        XCTAssertEqual(users[1].name.last, user1.name.last)
        XCTAssertEqual(users[1].dob.age, user1.dob.age)
        XCTAssertEqual(users[1].picture.medium, user1.picture.medium)
    }

    func testFetchUsersInvalidJSONResponse() async throws {
        // Given
        dataRequestMock.shouldReturnValidResponse = false

        // When
        do {
            _ = try await repository.fetchUsers(quantity: 2)
            XCTFail("Response should fail")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
}
