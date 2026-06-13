import Foundation
import Combine
import SwiftData

class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var currentUser: UserAccount? = nil
    @Published var isLoggedIn: Bool = false

    var rol: Rol? { currentUser?.rolEnum }
    var nombre: String { currentUser?.nombre ?? "Usuario" }
    var entityId: Int { currentUser?.entityId ?? 0 }

    private static let savedEmailKey = "savedSessionEmail"

    var savedEmail: String? {
        UserDefaults.standard.string(forKey: Self.savedEmailKey)
    }

    func login(user: UserAccount) {
        currentUser = user
        isLoggedIn  = true
        UserDefaults.standard.set(user.correo, forKey: Self.savedEmailKey)
    }

    func logout() {
        currentUser = nil
        isLoggedIn  = false
        UserDefaults.standard.removeObject(forKey: Self.savedEmailKey)
    }
}
