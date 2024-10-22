import SwiftUI

struct UserListView: View {

    @StateObject private var viewModel = UserListViewModel()

    var body: some View {
        NavigationView {
            if !viewModel.output.isGridView {
                List(viewModel.output.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        UserRowView(user: user)
                    }
                    .onAppear {
                        if viewModel.output.shouldLoadMoreData(currentItem: user) {
                            Task {
                                await viewModel.input.fetchUsers()
                            }
                        }
                    }
                }
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        UserListToolbarView(viewModel: viewModel)
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(viewModel.output.users) { user in
                            NavigationLink(destination: UserDetailView(user: user)) {
                                UserGridView(user: user)
                            }
                            .onAppear {
                                if viewModel.output.shouldLoadMoreData(currentItem: user) {
                                    Task {
                                        await viewModel.input.fetchUsers()
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        UserListToolbarView(viewModel: viewModel)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.input.fetchUsers()
            }
        }
        .alert(
            Text("Error"),
            isPresented: $viewModel.showAlert
        ) {
            Button("OK") {}
        } message: {
            Text(viewModel.output.errorMessage ?? "Unknown error")
        }

    }

}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
