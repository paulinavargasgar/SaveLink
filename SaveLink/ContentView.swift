import SwiftUI
import FirebaseAuth
import MapKit

struct UserReview: Identifiable {
    let id = UUID()
    let username: String
    let comment: String
    let rating: Int
}

struct GasStationAnnotation: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let pricePerLiter: Double // Precio por litro agregado
}

struct GasStationDetailView: View {
    let gasStation: GasStationAnnotation
    let globalRating: Double
    let reviews: [UserReview]

    var body: some View {
        VStack(alignment: .leading) {
            Text(gasStation.title)
                .font(.title)
                .padding(.bottom, 10)

            HStack {
                Text("Calificación global:")
                    .font(.headline)
                Spacer()
                Text(String(format: "%.1f", globalRating))
                    .font(.title)
                    .bold()
            }
            .padding()

            HStack {
                Text("Precio por litro:")
                    .font(.headline)
                Spacer()
                Text(String(format: "$%.2f MXN", gasStation.pricePerLiter))
                    .font(.title)
                    .bold()
            }
            .padding()

            Divider()

            Text("Opiniones:")
                .font(.headline)
                .padding(.bottom, 5)

            ScrollView {
                ForEach(reviews) { review in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(review.username)
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\(review.rating)/5 ⭐️")
                                .font(.subheadline)
                        }
                        Text(review.comment)
                            .font(.body)
                            .foregroundColor(.gray)
                        Divider()
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .padding()
        .navigationTitle("Detalles")
    }
}

struct ContentView: View {

    @AppStorage("uid") var userID: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var gasStationCoordinates: [GasStationAnnotation] = []
    @State private var showUserInfo = false
    @State private var showMenu = false
    @State private var selectedFuelType: String = "Premium" // Premium por defecto
    
    let Color_Verde_Fuerte = Color(red: 0 / 255, green: 92 / 255, blue: 83 / 255)

    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            NavigationView {
                ZStack {
                    Map(coordinateRegion: $region, annotationItems: gasStationCoordinates) { pin in
                        MapAnnotation(coordinate: pin.coordinate) {
                            NavigationLink(destination: GasStationDetailView(
                                gasStation: pin,
                                globalRating: Double.random(in: 3.0...5.0),
                                reviews: [
                                    UserReview(username: "Juan Pérez", comment: "Buena atención y gasolina de calidad.", rating: 5),
                                    UserReview(username: "Ana López", comment: "Un poco caro, pero rápido servicio.", rating: 4),
                                    UserReview(username: "Carlos Gómez", comment: "Las bombas no funcionaban bien.", rating: 3)
                                ]
                            )) {
                                VStack {
                                    Image("gas_station_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .shadow(radius: 4)
                                    Text(pin.title)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .background(Color.white.opacity(0.7))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)

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
                        HStack {
                            Spacer()
                            Button(action: {
                                showMenu = false
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
                                withAnimation {
                                    showMenu.toggle()
                                }
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

                    if showMenu {
                        VStack {
                            HStack {
                                Button(action: {
                                    selectedFuelType = "Premium"
                                }) {
                                    Text("Premium")
                                        .padding()
                                        .background(selectedFuelType == "Premium" ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                Button(action: {
                                    selectedFuelType = "Magna"
                                }) {
                                    Text("Magna")
                                        .padding()
                                        .background(selectedFuelType == "Magna" ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                Button(action: {
                                    selectedFuelType = "Diesel"
                                }) {
                                    Text("Diesel")
                                        .padding()
                                        .background(selectedFuelType == "Diesel" ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding()

                            List(gasStationCoordinates) { station in
                                HStack {
                                    Text(station.title)
                                    Spacer()
                                    Text(String(format: "$%.2f", station.pricePerLiter)) // Usar precio por tipo
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding()
                            .shadow(radius: 5)

                            Button(action: {
                                withAnimation {
                                    showMenu = false
                                }
                            }) {
                                Text("Regresar")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                        }
                        .transition(.move(edge: .trailing))
                    }
                }
                .onAppear {
                    loadGasStations()
                }
            }
        }
    }

    func loadGasStations() {
        let addresses = CSVReader.parseCSV(fileName: "direcciones_limpias")

        var uniqueCoordinates = Set<String>()
        var processedCount = 0
        let totalAddresses = addresses.count

        for address in addresses {
            GeocoderHelper.geocodeAddress(address: address) { coordinate in
                if let coordinate = coordinate {
                    let coordinateKey = "\(coordinate.latitude),\(coordinate.longitude)"

                    if !uniqueCoordinates.contains(coordinateKey) {
                        uniqueCoordinates.insert(coordinateKey)

                        let annotation = GasStationAnnotation(title: address, coordinate: coordinate, pricePerLiter: Double.random(in: 18.0...24.0))

                        DispatchQueue.main.async {
                            gasStationCoordinates.append(annotation)
                        }
                    }
                } else {
                    print("No se pudo geocodificar la dirección: \(address)")
                }

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
