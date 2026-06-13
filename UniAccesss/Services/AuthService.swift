import Foundation
import SwiftData

@MainActor
class AuthService {
    static let shared = AuthService()

    func loginBySavedSession(correo: String, context: ModelContext) -> UserAccount? {
        let descriptor = FetchDescriptor<UserAccount>(
            predicate: #Predicate { $0.correo == correo }
        )
        return try? context.fetch(descriptor).first
    }

    func login(correo: String, password: String, context: ModelContext) throws -> UserAccount {
        let descriptor = FetchDescriptor<UserAccount>(
            predicate: #Predicate { $0.correo == correo && $0.password == password }
        )
        let results = try context.fetch(descriptor)
        guard let user = results.first else {
            throw AuthError.invalidCredentials
        }
        return user
    }

    func registrar(correo: String, password: String, rol: Rol, entityId: Int, nombre: String, context: ModelContext) throws {
        let descriptor = FetchDescriptor<UserAccount>(
            predicate: #Predicate { $0.correo == correo }
        )
        let existing = try context.fetch(descriptor)
        guard existing.isEmpty else { throw AuthError.correoYaRegistrado }

        let account = UserAccount(correo: correo, password: password, rol: rol, entityId: entityId, nombre: nombre)
        context.insert(account)
        try context.save()
    }

    func seedCuentasDemo(context: ModelContext) {
        let descriptor = FetchDescriptor<UserAccount>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let demos: [(String, String, Rol, Int, String)] = [
            ("staff@uniaccess.edu",      "staff123",      .staff,      1, "Admin Staff"),
            ("director@uniaccess.edu",   "director123",   .directivo,  1, "Carlos Lopez"),
            ("profesor@uniaccess.edu",   "profesor123",   .profesor,   1, "Roberto Almanza"),
            ("alumno@uniaccess.edu",     "alumno123",     .alumno,     1, "Alejandro Mendoza")
        ]

        for (correo, pass, rol, id, nombre) in demos {
            let account = UserAccount(correo: correo, password: pass, rol: rol, entityId: id, nombre: nombre)
            context.insert(account)
        }
        try? context.save()
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case correoYaRegistrado

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:  return "Correo o contrasena incorrectos"
        case .correoYaRegistrado:  return "Este correo ya tiene una cuenta registrada"
        }
    }
}
