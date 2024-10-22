//
//  UserListToolbarView.swift
//  UserList
//
//  Created by Tony Stark on 14/10/2024.
//

import SwiftUI

struct UserListToolbarView: View {
    @ObservedObject var viewModel: UserListViewModel

    var body: some View {
        HStack {
            Picker(selection: $viewModel.isGridView, label: Text("Display")) {
                Image(systemName: "rectangle.grid.1x2.fill")
                    .tag(true)
                    .accessibilityLabel(Text("Grid view"))
                Image(systemName: "list.bullet")
                    .tag(false)
                    .accessibilityLabel(Text("List view"))
            }
            .pickerStyle(SegmentedPickerStyle())
            Button(action: {
                Task {
                    await viewModel.input.reloadUsers()
                }
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        }
    }
}

// #Preview {
//    UserListToolbarView()
// }
