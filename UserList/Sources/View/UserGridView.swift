//
//  UserGridView.swift
//  UserList
//
//  Created by Tony Stark on 14/10/2024.
//

import SwiftUI

struct UserGridView: View {
    let user: User

    var body: some View {
        VStack {
            UserPictureView(imageUrl: user.picture.medium, size: 150)

            Text("\(user.name.first) \(user.name.last)")
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }
}
