import SwiftUI

struct DirectivoFormView: View {
    @ObservedObject var vm: DirectivoViewModel
    var directivo: Directivo? = nil
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var apellidoPaterno = ""
    @State private var apellidoMaterno = ""
    @State private var puesto = ""
    @State private var correo = ""
    @State private var telefono = ""

    private var isEditing: Bool { directivo != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Nombre") {
                    StyledTextField(label: "Nombre", placeholder: "Carlos", icon: "person", text: $nombre)
                    StyledTextField(label: "Apellido Paterno", placeholder: "Lopez", icon: "person", text: $apellidoPaterno)
                    StyledTextField(label: "Apellido Materno (opcional)", placeholder: "Fernandez", icon: "person", text: $apellidoMaterno)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section("Cargo y Contacto") {
                    StyledTextField(label: "Puesto", placeholder: "Director de Facultad", icon: "briefcase", text: $puesto)
                    StyledTextField(label: "Correo", placeholder: "c.lopez@uniaccess.edu", icon: "envelope", text: $correo, keyboardType: .emailAddress)
                    StyledTextField(label: "Telefono (opcional)", placeholder: "5555004321", icon: "phone", text: $telefono, keyboardType: .phonePad)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section {
                    PrimaryButton(title: isEditing ? "Actualizar" : "Guardar", action: guardar, isLoading: vm.isLoading)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)
            }
            .navigationTitle(isEditing ? "Editar Directivo" : "Nuevo Directivo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } } }
            .onAppear(perform: cargarDatos)
            .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        }
    }

    private func cargarDatos() {
        guard let d = directivo else { return }
        nombre = d.nombre; apellidoPaterno = d.apellidoPaterno
        apellidoMaterno = d.apellidoMaterno ?? ""; puesto = d.puesto
        correo = d.correo; telefono = d.telefono ?? ""
    }

    private func guardar() {
        guard !nombre.isEmpty, !apellidoPaterno.isEmpty, !puesto.isEmpty, !correo.isEmpty else { return }
        let item = Directivo(
            idDirectivo: directivo?.idDirectivo, nombre: nombre, apellidoPaterno: apellidoPaterno,
            apellidoMaterno: apellidoMaterno.isEmpty ? nil : apellidoMaterno,
            puesto: puesto, correo: correo, telefono: telefono.isEmpty ? nil : telefono
        )
        Task {
            if isEditing { await vm.update(item) } else { await vm.save(item) }
            if !vm.showError { dismiss() }
        }
    }
}
