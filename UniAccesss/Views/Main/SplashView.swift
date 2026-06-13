import SwiftUI
import SwiftData

struct SplashView: View {
    @EnvironmentObject private var session: UserSession
    @Environment(\.modelContext) private var context
    @State private var isActive = false

    var body: some View {
        if isActive {
            if session.isLoggedIn {
                RootView()
            } else {
                LoginView()
            }
        } else {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#1B2A4A").opacity(0.08))
                            .frame(width: 120, height: 120)
                        Image(systemName: "graduationcap.circle.fill")
                            .font(.system(size: 72))
                            .foregroundColor(Color(hex: "#1B2A4A"))
                    }
                    VStack(spacing: 6) {
                        Text("UniAccess")
                            .font(.largeTitle).fontWeight(.bold)
                            .foregroundColor(Color(hex: "#1B2A4A"))
                        Text("Portal de Servicios Academicos")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                    Spacer()
                    Text("v2.4.1")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#6B7280"))
                        .padding(.bottom, 30)
                }
            }
            .task {
                AuthService.shared.seedCuentasDemo(context: context)
                autoLogin()
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation { isActive = true }
            }
        }
    }

    @MainActor
    private func autoLogin() {
        guard let correo = session.savedEmail else { return }
        if let user = AuthService.shared.loginBySavedSession(correo: correo, context: context) {
            session.login(user: user)
        }
    }
}
