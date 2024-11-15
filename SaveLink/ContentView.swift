//
//  ContentView.swift
//  SaveLink
//
//  Created by Paulina on 13/11/24.
//

// ContentView = Nuestra pantalla Main (es la que se muestra al autenticarse cómo usuario).


import SwiftUI
import FirebaseAuth
import MapKit

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Color personalizado usando RGB
    let Color_Verde_Fuerte = Color(red: 0 / 255, green: 92 / 255, blue: 83 / 255)
    
    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            ZStack {
                Map(coordinateRegion: $region)
                    .edgesIgnoringSafeArea(.all)
                
                // Bienvenida en la esquina superior derecha
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Bienvenido, \(userID)")
                                .padding(10)
                                .background(Color_Verde_Fuerte)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                                .padding([.top, .trailing], 16)
                        }
                    }
                    Spacer()
                    
                    // Barra inferior con tres botones
                    HStack {
                        Spacer()
                        Button(action: {
                            // Acción para botón de inicio
                        }) {
                            Image(systemName: "house")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: {
                            // Acción para botón de mapa
                        }) {
                            Image(systemName: "map")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: {
                            // Acción para botón de menú
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    //.padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60) // Ajusta la altura de la barra inferior
                    .background(Color_Verde_Fuerte)
                    .edgesIgnoringSafeArea(.bottom)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
