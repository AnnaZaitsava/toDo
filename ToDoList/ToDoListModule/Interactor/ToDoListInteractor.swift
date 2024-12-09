import UIKit

protocol ToDoListInteractorInputProtocol: AnyObject {
    func fetchTasks()
    func loadTasksFromAPI()
    func createTask(_ task: TaskModel)
    func updateTask(_ task: TaskModel)
    func deleteTask(_ task: TaskModel)
}

final class ToDoListInteractor: ToDoListInteractorInputProtocol {
    weak var output: ToDoListOutputProtocol?
    private let storageManager: CoreDataManagerProtocol
    private let backgroundQueue = DispatchQueue(label: "todolistCoredata", qos: .userInitiated)
    
    init(coreDataManager: CoreDataManagerProtocol) {
        storageManager = coreDataManager
    }
    
    func fetchTasks() {
        backgroundQueue.async { [weak self] in
            let tasks = self?.storageManager.fetchTasks() ?? []
            DispatchQueue.main.async {
                self?.output?.didFetchTasks(tasks)
            }
        }
    }
    
    func loadTasksFromAPI() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "loadedTasks")
        if !isFirstLaunch {
            ToDoService().fetchTasks { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.backgroundQueue.async {
                        tasks.forEach({ self?.storageManager.createTask($0)})
                        UserDefaults.standard.setValue(true, forKey: "loadedTasks")
                    }
                    DispatchQueue.main.async {
                        self?.output?.didFetchTasks(tasks)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.output?.didFailToFetchTasks(error)
                    }
                }
            }
        }
    }
    
    func createTask(_ task: TaskModel) {
        backgroundQueue.async { [weak self] in
            self?.storageManager.createTask(task)
        }
    }
    
    func updateTask(_ task: TaskModel) {
        backgroundQueue.async { [weak self] in
            self?.storageManager.updateTask(task)
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        backgroundQueue.async { [weak self] in
            self?.storageManager.deleteTask(task)
        }
    }
}
