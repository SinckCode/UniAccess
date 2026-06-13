import Foundation

struct Calificacion: Codable, Identifiable, Hashable {
    var idCalificacion: Int?
    var idAlumno: Int
    var idMateria: Int
    var calificacion: Double
    var periodo: String

    var id: Int { idCalificacion ?? 0 }

    var aprobado: Bool { calificacion >= 6.0 }
}
