//
//  UserRowView.swift
//  UserList
//
//  Created by Tony Stark on 14/10/2024.
//

import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack {
            UserPictureView(imageUrl: user.picture.thumbnail, size: 50)

            VStack(alignment: .leading) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text("\(user.dob.date)")
                    .font(.subheadline)
            }
        }
    }
}
