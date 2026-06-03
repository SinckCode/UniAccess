import Foundation
import SwiftUI
import Combine

@MainActor
class DirectivoViewModel: ObservableObject {
    @Published var directivos: [Directivo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let service = DirectivoService()

    func fetchAll() async {
        isLoading = true
        defer { isLoading = false }
        do {
            directivos = try await service.getAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func save(_ item: Directivo) async {
        do {
            try await service.save(item)
            await fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func update(_ item: Directivo) async {
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
            directivos.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
