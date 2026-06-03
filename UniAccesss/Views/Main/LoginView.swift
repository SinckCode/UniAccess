import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var session: UserSession

    @State private var correo = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 12) {
                        Image(systemName: "graduationcap.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(Color(hex: "#1B2A4A"))

                        Text("UniAccess")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#1B2A4A"))

                        Text("Portal Academico Institucional")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                    .padding(.top, 40)

                    VStack(spacing: 16) {
                        StyledTextField(
                            label: "Correo institucional",
                            placeholder: "correo@uniaccess.edu",
                            icon: "envelope.fill",
                            text: $correo,
                            keyboardType: .emailAddress
                        )

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Contrasena")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "#6B7280"))

                            HStack(spacing: 10) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(hex: "#00897B"))
                                    .frame(width: 20)

                                if showPassword {
                                    TextField("Contrasena", text: $password)
                                } else {
                                    SecureField("Contrasena", text: $password)
                                }

                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color(hex: "#6B7280"))
                                }
                            }
                            .padding(12)
                            .background(Color(hex: "#F5F5F7"))
                            .cornerRadius(10)
                        }
                    }

                    PrimaryButton(title: "Iniciar Sesion", action: iniciarSesion, isLoading: isLoading)

                    HStack {
                        Rectangle().frame(height: 1).foregroundColor(Color(hex: "#6B7280").opacity(0.3))
                        Text("O ingresa con")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#6B7280"))
                            .fixedSize()
                        Rectangle().frame(height: 1).foregroundColor(Color(hex: "#6B7280").opacity(0.3))
                    }

                    Button {
                        iniciarSesion()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "faceid").font(.title3)
                            Text("Biometria / Face ID").fontWeight(.semibold)
                        }
                        .foregroundColor(Color(hex: "#1B2A4A"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#1B2A4A"), lineWidth: 1.5))
                    }

                    Text("v2.4.1")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#6B7280"))
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
            }
        }
        .alert("Error al iniciar sesion", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .task {
            AuthService.shared.seedCuentasDemo(context: context)
        }
    }

    private func iniciarSesion() {
        guard !correo.isEmpty, !password.isEmpty else {
            errorMessage = "Ingresa tu correo y contrasena"
            showError = true
            return
        }
        isLoading = true
        do {
            let correoLimpio = correo.lowercased().trimmingCharacters(in: .whitespaces)
            let user = try AuthService.shared.login(correo: correoLimpio, password: password, context: context)
            session.login(user: user)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isLoading = false
    }
}
