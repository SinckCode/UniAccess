import Foundation
import SwiftUI
import Combine

@MainActor
class AlumnoViewModel: ObservableObject {
    @Published var alumnos: [Alumno] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let service = AlumnoService()

    func fetchAll() async {
        isLoading = true
        defer { isLoading = false }
        do {
            alumnos = try await service.getAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func save(_ item: Alumno) async {
        do {
            try await service.save(item)
            await fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func update(_ item: Alumno) async {
        do {
            try await service.update(item)
            await fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func delete(id: Int) async {
        do {
            try await service.delete(id: id)
            alumnos.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
