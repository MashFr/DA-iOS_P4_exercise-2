//
//  ViewModel.swift
//  UserList
//
//  Created by Tony Stark on 05/10/2024.
//
import SwiftUI

class UserListViewModel: ObservableObject, UserListViewModelInput, UserListViewModelOutput {
    
    // MARK: Properties
    private let repository: UserListRepository
    private var pageSize: Int = 20
    
    // MARK: Initialization
    init(repository: UserListRepository = UserListRepository()) {
        self.repository = repository
    }
    
    // MARK: - OUTPUT
    var output: UserListViewModelOutput { get { self } }
    
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String? = nil
    
    // Faut il definir une méthode pour changer la valeur de isGridView dans le View Model et ainsi passer par output/input
    // cf : Voir la vue
    // De meme pour showAlert quand on utilise le binding avec $
    @Published var isGridView = false
    @Published var showAlert = false
    
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    // MARK: - INPUT
    // Faut il créer une extention ?
    var input: UserListViewModelInput { get { self } }
    
    @MainActor
    func fetchUsers() async {
        self.isLoading = true

        do {
            let users = try await repository.fetchUsers(quantity: pageSize)
            self.users.append(contentsOf: users)
        } catch {
            self.errorMessage = "Error fetching users: \(error.localizedDescription)"
            self.showAlert = true
            print("Error fetching users: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    
    func reloadUsers() async {
        DispatchQueue.main.async {
            self.users.removeAll()
        }
        
        await fetchUsers()
    }
}

protocol UserListViewModelInput {
    func fetchUsers() async
    func reloadUsers() async
}

protocol UserListViewModelOutput {
    var users: [User] { get }
    var isLoading: Bool { get }
    var isGridView: Bool { get set }
    var errorMessage: String? { get }
    
    func shouldLoadMoreData(currentItem item: User) -> Bool
}
