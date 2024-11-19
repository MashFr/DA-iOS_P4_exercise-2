import Foundation

struct UserListRepository {
    
    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)
    private let scheme: String = "https"
    private let host: String = "randomuser.me"
    private let path: String = "/api"
    
    init(
        executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
    ) {
        self.executeDataRequest = executeDataRequest
    }
    
    func fetchUsers(quantity: Int) async throws -> [User] {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = try URLRequest(
            url: url,
            method: .GET,
            parameters: [
                "results": quantity
            ]
        )
        
        let (data, _) = try await executeDataRequest(request)
        
        let response = try JSONDecoder().decode(UserListResponse.self, from: data)
        
        return response.results.map(User.init)
    }
}
