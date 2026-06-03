import Foundation

class DirectivoService {
    private let endpoint = "directivos"
    private let api = APIService.shared

    func getAll() async throws -> [Directivo] { try await api.getAll(endpoint: endpoint) }
    func getById(id: Int) async throws -> Directivo { try await api.getById(endpoint: endpoint, id: id) }
    func save(_ item: Directivo) async throws { try await api.save(endpoint: endpoint, body: item) }
    func update(_ item: Directivo) async throws { try await api.update(endpoint: endpoint, body: item) }
    func delete(id: Int) async throws { try await api.delete(endpoint: endpoint, id: id) }
}
