import Foundation
import SwiftUI
import Combine

@MainActor
class ProfesorViewModel: ObservableObject {
    @Published var profesores: [Profesor] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let service = ProfesorService()

    func fetchAll() async {
        isLoading = true
        defer { isLoading = false }
        do {
            profesores = try await service.getAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func save(_ item: Profesor) async {
        do {
            try await service.save(item)
            await fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func update(_ item: Profesor) async {
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
            profesores.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
