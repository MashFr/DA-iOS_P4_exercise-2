import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        VStack {
            // TODO: - move the image in a view UserPicture
            AsyncImage(url: URL(string: user.picture.large)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text("\(user.dob.date)")
                    .font(.subheadline)
            }
            .padding()

            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}
