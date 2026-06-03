import Foundation

struct Alumno: Codable, Identifiable, Hashable {
    var idAlumno: Int?
    var nombre: String
    var apellidoPaterno: String
    var apellidoMaterno: String?
    var matricula: String
    var correo: String
    var telefono: String?
    var semestre: Int
    var idCarrera: Int
    var fechaIngreso: String
    var estatus: String?

    var id: Int { idAlumno ?? 0 }

    var nombreCompleto: String {
        [nombre, apellidoPaterno, apellidoMaterno].compactMap { $0 }.joined(separator: " ")
    }
}
