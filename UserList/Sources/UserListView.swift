import SwiftUI

struct UserListView: View {
    // TODO: - Those properties should be viewModel's OutPuts
    @State private var users: [User] = []
    @State private var isLoading = false
    // Toolbar viewModel
    @State private var isGridView = false

    // TODO: - The property should be declared in the viewModel
    private let repository = UserListRepository()
    
    var body: some View {
        NavigationView {
            if !isGridView {
                List(users) { user in
                    // TODO: - Separate the ui for the list and the listRow
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
                    // TODO: - Move the onAppear in a viewModel
                    .onAppear {
                        if self.shouldLoadMoreData(currentItem: user) {
                            self.fetchUsers()
                        }
                    }
                }
                .navigationTitle("Users")
                // TODO: - Move the toolbar in a dedicated view file and with 2 toolbar view Item
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
                            // TODO: - Separate the ui for the scroolView and the userVstackView
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
                            // TODO: - Move the onAppear in a viewModel
                            .onAppear {
                                if self.shouldLoadMoreData(currentItem: user) {
                                    self.fetchUsers()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Users")
                // TODO: - Move the toolbar in a dedicated view file and with 2 toolbar view Item
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

    // TODO: - Should be a viewModel's input
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

    // TODO: - Should be an OutPut
    private func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    // TODO: - Should be a viewModel's input
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
