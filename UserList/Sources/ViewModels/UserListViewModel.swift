//
//  ViewModel.swift
//  UserList
//
//  Created by Tony Stark on 05/10/2024.
//
import SwiftUI

class UserListViewModel: ObservableObject {

    // Utilité du singleton pattern / explication ???
    private let repository = UserListRepository()

    // MARK: OUTPUT

    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false

    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    // MARK: INPUT

    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                DispatchQueue.main.async {
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
            } catch {
                // TODO: show error in view
                // isLoadind false
                // add a published var errorMessage and handle it in the view
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }

    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}
