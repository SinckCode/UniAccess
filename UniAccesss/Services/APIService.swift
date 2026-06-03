import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL invalida"
        case .networkError(let e): return "Error de red: \(e.localizedDescription)"
        case .decodingError(let e): return "Error al procesar datos: \(e.localizedDescription)"
        case .serverError(let code): return "Error del servidor: \(code)"
        case .noData: return "Sin datos del servidor"
        }
    }
}

class APIService {
    static let shared = APIService()
    private init() {}

    private func makeURL(_ path: String) throws -> URL {
        guard let url = URL(string: "\(APIConfig.baseURL)/\(path)") else {
            throw APIError.invalidURL
        }
        return url
    }

    func getAll<T: Decodable>(endpoint: String) async throws -> [T] {
        let url = try makeURL("\(endpoint)/getAll")
        let (data, response) = try await URLSession.shared.data(from: url)
        try validateResponse(response)
        return try decode([T].self, from: data)
    }

    func getById<T: Decodable>(endpoint: String, id: Int) async throws -> T {
        let url = try makeURL("\(endpoint)/get/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        try validateResponse(response)
        return try decode(T.self, from: data)
    }

    func save<T: Encodable>(endpoint: String, body: T) async throws {
        let url = try makeURL("\(endpoint)/save")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }

    func update<T: Encodable>(endpoint: String, body: T) async throws {
        let url = try makeURL("\(endpoint)/update")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }

    func delete(endpoint: String, id: Int) async throws {
        let url = try makeURL("\(endpoint)/delete/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.serverError(http.statusCode)
        }
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
