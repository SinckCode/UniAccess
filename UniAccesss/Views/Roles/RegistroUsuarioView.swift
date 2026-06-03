import SwiftUI
import SwiftData

struct RegistroUsuarioView: View {
    @Environment(\.modelContext) private var context
    @Query private var cuentas: [UserAccount]

    @State private var showForm = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showDeleteAlert = false
    @State private var cuentaAEliminar: UserAccount?

    var body: some View {
        Group {
            if cuentas.isEmpty {
                ContentUnavailableView("Sin cuentas", systemImage: "person.badge.plus", description: Text("Registra usuarios para que puedan iniciar sesion"))
            } else {
                List {
                    ForEach(cuentas) { cuenta in
                        CardView {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle().fill(colorParaRol(cuenta.rolEnum).opacity(0.12)).frame(width: 44, height: 44)
                                    Image(systemName: cuenta.rolEnum.icon).foregroundColor(colorParaRol(cuenta.rolEnum))
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(cuenta.nombre).font(.headline)
                                    Text(cuenta.correo).font(.caption).foregroundColor(Color(hex: "#6B7280"))
                                }
                                Spacer()
                                Text(cuenta.rolEnum.label)
                                    .font(.caption).fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(colorParaRol(cuenta.rolEnum))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal).padding(.vertical, 4)
                        .listRowBackground(Color.clear).listRowSeparator(.hidden)
                        .swipeActions {
                            Button(role: .destructive) {
                                cuentaAEliminar = cuenta
                                showDeleteAlert = true
                            } label: { Label("Eliminar", systemImage: "trash") }
                        }
                    }
                }
                .listStyle(.plain).background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Cuentas de Usuario")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showForm = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showForm) { NuevaCuentaFormView() }
        .alert("Eliminar Cuenta", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                if let c = cuentaAEliminar { context.delete(c); try? context.save() }
            }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Esta accion no se puede deshacer.") }
        .background(Color(hex: "#F5F5F7"))
    }

    private func colorParaRol(_ rol: Rol) -> Color {
        switch rol {
        case .alumno:    return Color(hex: "#00897B")
        case .profesor:  return Color(hex: "#2E7D32")
        case .directivo: return Color(hex: "#D32F2F")
        case .staff:     return Color(hex: "#1B2A4A")
        }
    }
}

struct NuevaCuentaFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var nombre    = ""
    @State private var correo    = ""
    @State private var password  = ""
    @State private var rolSelec  = Rol.alumno
    @State private var entityId  = ""
    @State private var errorMsg: String?
    @State private var showError = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos de la Cuenta") {
                    StyledTextField(label: "Nombre completo", placeholder: "Juan Perez", icon: "person", text: $nombre)
                    StyledTextField(label: "Correo", placeholder: "correo@uniaccess.edu", icon: "envelope", text: $correo, keyboardType: .emailAddress)
                    StyledTextField(label: "Contrasena", placeholder: "Minimo 6 caracteres", icon: "lock", text: $password, isSecure: true)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section("Rol y Vinculacion") {
                    Picker("Rol", selection: $rolSelec) {
                        ForEach([Rol.alumno, .profesor, .directivo, .staff], id: \.self) {
                            Text($0.label).tag($0)
                        }
                    }
                    StyledTextField(label: "ID en la API", placeholder: "ID del registro en la API", icon: "number", text: $entityId, keyboardType: .numberPad)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section {
                    PrimaryButton(title: "Crear Cuenta", action: crearCuenta)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)
            }
            .navigationTitle("Nueva Cuenta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } } }
            .alert("Error", isPresented: $showError) { Button("OK", role: .cancel) {} } message: { Text(errorMsg ?? "") }
        }
    }

    private func crearCuenta() {
        guard !nombre.isEmpty, !correo.isEmpty, !password.isEmpty, let id = Int(entityId) else {
            errorMsg = "Completa todos los campos correctamente"
            showError = true
            return
        }
        do {
            try AuthService.shared.registrar(correo: correo.lowercased().trimmingCharacters(in: .whitespaces), password: password, rol: rolSelec, entityId: id, nombre: nombre, context: context)
            dismiss()
        } catch {
            errorMsg = error.localizedDescription
            showError = true
        }
    }
}
