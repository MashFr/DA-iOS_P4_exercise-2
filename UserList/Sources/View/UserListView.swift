import SwiftUI

struct UserListView: View {

    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationView {
            if !viewModel.isGridView {
                List(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        UserRowView(user: user)
                    }
                    .onAppear {
                        if viewModel.shouldLoadMoreData(currentItem: user) {
                            viewModel.fetchUsers()
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
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: UserDetailView(user: user)) {
                                UserGridView(user: user)
                            }
                            .onAppear {
                                if viewModel.shouldLoadMoreData(currentItem: user) {
                                    viewModel.fetchUsers()
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
            viewModel.fetchUsers()
        }
    }

}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
