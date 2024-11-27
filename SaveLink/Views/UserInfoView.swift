//
//  UserInfoView.swift
//  SaveLink
//
//  Created by Adrián Reyes on 26/11/24.
//

import SwiftUI
import FirebaseAuth

struct UserInfoView: View {
    let userID: String
    @Binding var showUserInfo: Bool

    var body: some View {
        VStack {
            Text("Información del Usuario")
                .font(.title)
                .padding()

            Text("Usuario: \(userID)")
                .padding()

            Spacer()

            Button(action: {
                // Cerrar sesión
                @AppStorage("uid") var userID: String = ""
                userID = ""
                showUserInfo = false
            }) {
                Text("Cerrar Sesión")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

struct UserInfoView_Previews: PreviewProvider {
    @State static var showUserInfo = true

    static var previews: some View {
        UserInfoView(userID: "EjemploUsuario", showUserInfo: $showUserInfo)
    }
}
