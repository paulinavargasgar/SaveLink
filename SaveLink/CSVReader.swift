//
//  CSVReader.swift
//  SaveLink
//
//  Created by Adrián Reyes on 15/11/24.
//

import Foundation

struct CSVReader {
    static func parseCSV(fileName: String) -> [String] {
        var addresses = [String]()
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let content = try String(contentsOfFile: path)
                let rows = content.components(separatedBy: "\n")
                
                for row in rows.dropFirst() { // Omitir encabezado
                    let columns = row.components(separatedBy: ",")
                    if columns.count > 2 { // Ajustar índice según la columna de Dirección
                        addresses.append(columns[2].trimmingCharacters(in: .whitespaces)) // Columna de dirección
                        print("Direcciones: \(addresses)")
                    }
                }
            } catch {
                print("Error al leer el archivo CSV: \(error)")
            }
        }
        
        return addresses
    }
}
