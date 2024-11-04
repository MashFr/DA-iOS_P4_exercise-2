//
//  DataRequestMock.swift
//  UserListTests
//
//  Created by Tony Stark on 23/10/2024.
//

import Foundation
@testable import UserList

class DataRequestMock {
    
    // MARK: - Properties
    
    var shouldReturnValidResponse: Bool = true
    let mockUser1: UserListResponse.User
    let mockUser2: UserListResponse.User
    private let mockUserListResponse: UserListResponse
    
    // MARK: - Initializer
    
    init() {
        mockUser1 = UserListResponse.User(
            name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01", age: 31),
            picture: UserListResponse.User.Picture(
                large: "https://example.com/large.jpg",
                medium: "https://example.com/medium.jpg",
                thumbnail: "https://example.com/thumbnail.jpg"
            )
        )
        
        mockUser2 = UserListResponse.User(
            name: UserListResponse.User.Name(title: "Mr", first: "Jane", last: "Smith"),
            dob: UserListResponse.User.Dob(date: "1995-02-15", age: 26),
            picture: UserListResponse.User.Picture(
                large: "https://example.com/large.jpg",
                medium: "https://example.com/medium.jpg",
                thumbnail: "https://example.com/thumbnail.jpg"
            )
        )
        
        mockUserListResponse = UserListResponse(results: [mockUser1, mockUser2])
    }
    
    // MARK: - Public Methods
    
    func executeDataRequest(for request: URLRequest) async throws -> (Data, URLResponse) {
        if shouldReturnValidResponse {
            return try await createValidMockResponse(for: request)
        } else {
            return try await createInvalidMockResponse(for: request)
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func encodedUserData() throws -> Data {
        try JSONEncoder().encode(mockUserListResponse)
    }
     
    private func createValidMockResponse(for request: URLRequest) async throws -> (Data, URLResponse) {
        let data = try encodedUserData()
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
    
    private func createInvalidMockResponse(for request: URLRequest) async throws -> (Data, URLResponse) {
        let invalidJSONData = "invalid JSON".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (invalidJSONData, response)
    }
}
