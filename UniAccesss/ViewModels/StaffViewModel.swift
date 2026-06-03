import Foundation
import SwiftUI
import Combine

@MainActor
class StaffViewModel: ObservableObject {
    @Published var staffList: [Staff] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let service = StaffService()

    func fetchAll() async {
        isLoading = true
        defer { isLoading = false }
        do {
            staffList = try await service.getAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func save(_ item: Staff) async {
        do {
            try await service.save(item)
            await fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func update(_ item: Staff) async {
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
            staffList.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
