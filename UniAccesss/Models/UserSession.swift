import Foundation
import SwiftUI

@MainActor
class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var currentUser: UserAccount? = nil
    @Published var isLoggedIn: Bool = false

    var rol: Rol? { currentUser?.rolEnum }
    var nombre: String { currentUser?.nombre ?? "Usuario" }
    var entityId: Int { currentUser?.entityId ?? 0 }

    func login(user: UserAccount) {
        currentUser = user
        isLoggedIn  = true
    }

    func logout() {
        currentUser = nil
        isLoggedIn  = false
    }
}
