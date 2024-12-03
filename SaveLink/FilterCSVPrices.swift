//
//  FilterCSVPrices.swift
//  SaveLink
//
//  Created by Adrián Reyes on 02/12/24.
//

import SwiftUI
import Foundation

struct GasStation: Identifiable {
    let id = UUID()
    let permitNumber: String
    let name: String
    let address: String
    let product: String
    let subproduct: String
    let price: Double
}

class CSVReaderPrices {
    static func parseCSV(fileName: String, productFilter: String = "Premium") -> [GasStation] {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            print("El archivo CSV no fue encontrado.")
            return []
        }

        do {
            let content = try String(contentsOfFile: filePath)
            let lines = content.components(separatedBy: "\n").dropFirst()
            var gasStations: [GasStation] = []

            for line in lines {
                let columns = line.components(separatedBy: "\t") // Separador: Tabulador
                if columns.count == 6 {
                    let permitNumber = columns[0]
                    let name = columns[1]
                    let address = columns[2]
                    let product = columns[3]
                    let subproduct = columns[4]
                    let priceString = columns[5].replacingOccurrences(of: "$", with: "")

                    if let price = Double(priceString), product.contains(productFilter) {
                        let gasStation = GasStation(
                            permitNumber: permitNumber,
                            name: name,
                            address: address,
                            product: product,
                            subproduct: subproduct,
                            price: price
                        )
                        gasStations.append(gasStation)
                    }
                }
            }

            return gasStations
        } catch {
            print("Error al leer el archivo CSV: \(error)")
            return []
        }
    }
}


