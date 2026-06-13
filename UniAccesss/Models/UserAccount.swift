import Foundation
import Combine
import SwiftData

enum Rol: String, Codable {
    case alumno     = "alumno"
    case profesor   = "profesor"
    case directivo  = "directivo"
    case staff      = "staff"

    var label: String {
        switch self {
        case .alumno:    return "Alumno"
        case .profesor:  return "Profesor"
        case .directivo: return "Directivo"
        case .staff:     return "Staff"
        }
    }

    var icon: String {
        switch self {
        case .alumno:    return "person.fill"
        case .profesor:  return "person.text.rectangle"
        case .directivo: return "briefcase.fill"
        case .staff:     return "wrench.and.screwdriver.fill"
        }
    }
}

@Model
class UserAccount {
    var correo: String
    var password: String
    var rol: String
    var entityId: Int
    var nombre: String

    init(correo: String, password: String, rol: Rol, entityId: Int, nombre: String) {
        self.correo   = correo
        self.password = password
        self.rol      = rol.rawValue
        self.entityId = entityId
        self.nombre   = nombre
    }

    var rolEnum: Rol { Rol(rawValue: rol) ?? .alumno }
}
