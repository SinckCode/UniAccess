import Foundation

struct Directivo: Codable, Identifiable, Hashable {
    var idDirectivo: Int?
    var nombre: String
    var apellidoPaterno: String
    var apellidoMaterno: String?
    var puesto: String
    var correo: String
    var telefono: String?

    var id: Int { idDirectivo ?? 0 }

    var nombreCompleto: String {
        [nombre, apellidoPaterno, apellidoMaterno].compactMap { $0 }.joined(separator: " ")
    }
}
