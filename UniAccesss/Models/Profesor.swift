import Foundation

struct Profesor: Codable, Identifiable, Hashable {
    var idProfesor: Int?
    var nombre: String
    var apellidoPaterno: String
    var apellidoMaterno: String?
    var correo: String
    var telefono: String?
    var especialidad: String?
    var estatus: String?

    var id: Int { idProfesor ?? 0 }

    var nombreCompleto: String {
        [nombre, apellidoPaterno, apellidoMaterno].compactMap { $0 }.joined(separator: " ")
    }
}
