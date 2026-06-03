import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var session: UserSession
    @AppStorage("textSize") private var textSize = "Normal"
    @AppStorage("contrast") private var contrast = "Estandar"
    @State private var notifications = true
    @State private var privacy = false
    @State private var showLogoutAlert = false

    private let textSizes = ["Pequeno", "Normal", "Grande", "Muy Grande"]
    private let contrasts = ["Estandar", "Alto Contraste"]

    var body: some View {
        List {
            Section("Cuenta") {
                HStack(spacing: 14) {
                    ZStack {
                        Circle().fill(Color(hex: "#1B2A4A").opacity(0.1)).frame(width: 44, height: 44)
                        Image(systemName: "person.fill").foregroundColor(Color(hex: "#1B2A4A"))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.nombre).font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                        Text(session.rol?.label ?? "Cuenta institucional")
                            .font(.caption).foregroundColor(Color(hex: "#6B7280"))
                    }
                }
                .padding(.vertical, 4)
            }

            Section("Notificaciones") {
                Toggle("Recibir notificaciones", isOn: $notifications).tint(Color(hex: "#2E7D32"))
            }

            Section("Privacidad") {
                Toggle("Datos de uso anonimos", isOn: $privacy).tint(Color(hex: "#2E7D32"))
            }

            Section("Accesibilidad") {
                Picker("Tamano de texto", selection: $textSize) {
                    ForEach(textSizes, id: \.self) { Text($0) }
                }
                Picker("Contraste", selection: $contrast) {
                    ForEach(contrasts, id: \.self) { Text($0) }
                }
            }

            Section("Idioma") {
                Picker("Idioma", selection: .constant("Espanol")) {
                    Text("Espanol").tag("Espanol")
                }
            }

            Section {
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Cerrar Sesion")
                    }
                }
            }

            Section {
                HStack {
                    Spacer()
                    Text("UniAccess v1.0.0")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#6B7280"))
                    Spacer()
                }
            }
        }
        .navigationTitle("Perfil y Ajustes")
        .alert("Cerrar Sesion", isPresented: $showLogoutAlert) {
            Button("Cerrar Sesion", role: .destructive) { session.logout() }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Tu sesion sera cerrada.") }
    }
}
