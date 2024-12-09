
import UIKit

enum ToDoServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return K.invalidURL
        case .noData:
            return K.noData
        case .decodingError(let error):
            return "\(K.decodingError) \(error)"
        case .networkError(let error):
            return "\(K.networkError) \(error)"
        case .serverError:
            return K.serverError
        }
    }
}

final class ToDoService {
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        guard let url = URL(string: K.urlAPI) else {
            completion(.failure(ToDoServiceError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ToDoServiceError.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(ToDoServiceError.serverError))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TaskResponse.self, from: data)
                let tasks = result.todos ?? []
                completion(.success(tasks))
            }
            catch {
                completion(.failure(ToDoServiceError.decodingError(error)))
            }
        }
        task.resume()
    }
}
