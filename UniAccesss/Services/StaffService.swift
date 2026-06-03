import Foundation

class StaffService {
    private let endpoint = "staff"
    private let api = APIService.shared

    func getAll() async throws -> [Staff] { try await api.getAll(endpoint: endpoint) }
    func getById(id: Int) async throws -> Staff { try await api.getById(endpoint: endpoint, id: id) }
    func save(_ item: Staff) async throws { try await api.save(endpoint: endpoint, body: item) }
    func update(_ item: Staff) async throws { try await api.update(endpoint: endpoint, body: item) }
    func delete(id: Int) async throws { try await api.delete(endpoint: endpoint, id: id) }
}
