import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: UserSession

    var body: some View {
        switch session.rol {
        case .alumno:    AlumnoTabView()
        case .profesor:  ProfesorTabView()
        case .directivo: DirectivoTabView()
        case .staff:     StaffTabView()
        case nil:        LoginView()
        }
    }
}
