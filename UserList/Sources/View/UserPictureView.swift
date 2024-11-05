//
//  UserPictureView.swift
//  UserList
//
//  Created by Tony Stark on 23/10/2024.
//

import SwiftUI

struct UserPictureView: View {
    let imageUrl: String
    let size: CGFloat

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}
