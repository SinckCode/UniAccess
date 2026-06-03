import Foundation

struct Staff: Codable, Identifiable, Hashable {
    var idStaff: Int?
    var nombre: String
    var apellidoPaterno: String
    var apellidoMaterno: String?
    var area: String
    var puesto: String
    var correo: String
    var telefono: String?

    var id: Int { idStaff ?? 0 }

    var nombreCompleto: String {
        [nombre, apellidoPaterno, apellidoMaterno].compactMap { $0 }.joined(separator: " ")
    }
}
