import Foundation

struct Carrera: Codable, Identifiable, Hashable {
    var idCarrera: Int?
    var nombre: String
    var descripcion: String
    var duracionSemestres: Int
    var facultad: String

    var id: Int { idCarrera ?? 0 }
}
