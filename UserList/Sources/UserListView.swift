import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    @State private var isLoading = false
    @State private var isGridView = false
    
    private let repository = UserListRepository()
    
    var body: some View {
        NavigationView {
            if !isGridView {
                List(users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        HStack {
                            AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            
                            VStack(alignment: .leading) {
                                Text("\(user.name.first) \(user.name.last)")
                                    .font(.headline)
                                Text("\(user.dob.date)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onAppear {
                        if self.shouldLoadMoreData(currentItem: user) {
                            self.fetchUsers()
                        }
                    }
                }
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Picker(selection: $isGridView, label: Text("Display")) {
                            Image(systemName: "rectangle.grid.1x2.fill")
                                .tag(true)
                                .accessibilityLabel(Text("Grid view"))
                            Image(systemName: "list.bullet")
                                .tag(false)
                                .accessibilityLabel(Text("List view"))
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.reloadUsers()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.large)
                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(users) { user in
                            NavigationLink(destination: UserDetailView(user: user)) {
                                VStack {
                                    AsyncImage(url: URL(string: user.picture.medium)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                    }
                                    
                                    Text("\(user.name.first) \(user.name.last)")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .onAppear {
                                if self.shouldLoadMoreData(currentItem: user) {
                                    self.fetchUsers()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Picker(selection: $isGridView, label: Text("Display")) {
                            Image(systemName: "rectangle.grid.1x2.fill")
                                .tag(true)
                                .accessibilityLabel(Text("Grid view"))
                            Image(systemName: "list.bullet")
                                .tag(false)
                                .accessibilityLabel(Text("List view"))
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.reloadUsers()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.large)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.fetchUsers()
        }
    }
    
    private func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                self.users.append(contentsOf: users)
                isLoading = false
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    private func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    private func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
