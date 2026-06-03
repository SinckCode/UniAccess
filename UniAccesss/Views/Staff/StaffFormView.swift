import SwiftUI

struct StaffFormView: View {
    @ObservedObject var vm: StaffViewModel
    var staff: Staff? = nil
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var apellidoPaterno = ""
    @State private var apellidoMaterno = ""
    @State private var area = ""
    @State private var puesto = ""
    @State private var correo = ""
    @State private var telefono = ""

    private var isEditing: Bool { staff != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Nombre") {
                    StyledTextField(label: "Nombre", placeholder: "Maria", icon: "person", text: $nombre)
                    StyledTextField(label: "Apellido Paterno", placeholder: "Gonzalez", icon: "person", text: $apellidoPaterno)
                    StyledTextField(label: "Apellido Materno (opcional)", placeholder: "Perez", icon: "person", text: $apellidoMaterno)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section("Cargo y Contacto") {
                    StyledTextField(label: "Area", placeholder: "Servicios Escolares", icon: "building.2", text: $area)
                    StyledTextField(label: "Puesto", placeholder: "Coordinadora", icon: "briefcase", text: $puesto)
                    StyledTextField(label: "Correo", placeholder: "m.gonzalez@uniaccess.edu", icon: "envelope", text: $correo, keyboardType: .emailAddress)
                    StyledTextField(label: "Telefono (opcional)", placeholder: "5555009876", icon: "phone", text: $telefono, keyboardType: .phonePad)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section {
                    PrimaryButton(title: isEditing ? "Actualizar" : "Guardar", action: guardar, isLoading: vm.isLoading)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)
            }
            .navigationTitle(isEditing ? "Editar Staff" : "Nuevo Staff")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } } }
            .onAppear(perform: cargarDatos)
            .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        }
    }

    private func cargarDatos() {
        guard let s = staff else { return }
        nombre = s.nombre; apellidoPaterno = s.apellidoPaterno
        apellidoMaterno = s.apellidoMaterno ?? ""; area = s.area
        puesto = s.puesto; correo = s.correo; telefono = s.telefono ?? ""
    }

    private func guardar() {
        guard !nombre.isEmpty, !apellidoPaterno.isEmpty, !area.isEmpty, !puesto.isEmpty, !correo.isEmpty else { return }
        let item = Staff(
            idStaff: staff?.idStaff, nombre: nombre, apellidoPaterno: apellidoPaterno,
            apellidoMaterno: apellidoMaterno.isEmpty ? nil : apellidoMaterno,
            area: area, puesto: puesto, correo: correo,
            telefono: telefono.isEmpty ? nil : telefono
        )
        Task {
            if isEditing { await vm.update(item) } else { await vm.save(item) }
            if !vm.showError { dismiss() }
        }
    }
}
