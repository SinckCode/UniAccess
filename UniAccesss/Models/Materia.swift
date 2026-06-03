import Foundation

struct Materia: Codable, Identifiable, Hashable {
    var idMateria: Int?
    var nombre: String
    var clave: String
    var creditos: Int
    var semestre: Int
    var idCarrera: Int
    var idProfesor: Int

    var id: Int { idMateria ?? 0 }
}
