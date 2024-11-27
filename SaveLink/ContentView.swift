//
//  ContentView.swift
//  SaveLink
//
//  Created by Paulina on 13/11/24.
//

// ContentView = Nuestra pantalla Main (es la que se muestra al autenticarse cómo usuario).


//
//  ContentView.swift
//  SaveLink
//
//  Created by Paulina on 13/11/24.
//

import SwiftUI
import FirebaseAuth
import MapKit

struct GasStationAnnotation: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var gasStationCoordinates: [GasStationAnnotation] = []
    @State private var showUserInfo = false

    // Color personalizado usando RGB
    let Color_Verde_Fuerte = Color(red: 0 / 255, green: 92 / 255, blue: 83 / 255)
    
    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            ZStack {
                // Mapa con los pines
                Map(coordinateRegion: $region, annotationItems: gasStationCoordinates) { pin in
                    MapPin(coordinate: pin.coordinate, tint: .red)
                    
                }
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
                            Image(systemName: "map")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: {
                            showUserInfo = true
                        }) {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        .sheet(isPresented: $showUserInfo) {
                            UserInfoView(userID: userID, showUserInfo: $showUserInfo)
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
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color_Verde_Fuerte)
                    .edgesIgnoringSafeArea(.bottom)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onAppear {
                loadGasStations()
            }
        }
    }
    
    // Función para cargar las direcciones de las gasolineras y geocodificarlas
    func loadGasStations() {
        let addresses = CSVReader.parseCSV(fileName: "direcciones_limpias") // Asegúrate de usar el nombre correcto del archivo CSV

        //print("Direcciones cargadas del CSV:")
        //print(addresses)

        // Conjunto para evitar duplicados (almacena direcciones únicas)
        var uniqueCoordinates = Set<String>() // Usaremos un hash basado en la latitud y longitud como clave
        
        // Contador para saber cuántas direcciones han sido procesadas
        var processedCount = 0
        let totalAddresses = addresses.count

        for address in addresses {
            GeocoderHelper.geocodeAddress(address: address) { coordinate in
                if let coordinate = coordinate {
                    let coordinateKey = "\(coordinate.latitude),\(coordinate.longitude)"
                    
                    // Verificar si la coordenada ya está en el conjunto
                    if !uniqueCoordinates.contains(coordinateKey) {
                        uniqueCoordinates.insert(coordinateKey)
                        
                        //print("Dirección geocodificada: \(address) -> \(coordinate)")
                        let annotation = GasStationAnnotation(title: address, coordinate: coordinate)
                        //print("ID del pin generado: \(annotation.id)")


                        DispatchQueue.main.async {
                            gasStationCoordinates.append(annotation)
                        }
                    } else {
                        //print("Dirección duplicada ignorada: \(address)")
                    }
                } else {
                    print("No se pudo geocodificar la dirección: \(address)")
                }

                // Incrementar el contador de procesados
                processedCount += 1
                if processedCount == totalAddresses {
                    DispatchQueue.main.async {
                        print("Número total de pines únicos cargados: \(gasStationCoordinates.count)")
                    }
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


