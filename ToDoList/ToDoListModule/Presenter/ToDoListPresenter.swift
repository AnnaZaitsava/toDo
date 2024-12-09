import UIKit

protocol ToDoListOutputProtocol: AnyObject {
    func viewDidLoad()
    func didFetchTasks(_ tasks: [TaskModel])
    func didFailToFetchTasks(_ error: Error)
    func didSearchTextChange(_ text: String)
    func toggleTaskCompletion(at index: Int)
    func navigateToEditTask(_ task: TaskModel)
    func deleteTask(_ task: TaskModel)
    func navigateToCreateTask()
    func navigateToShareSheet(_ task: TaskModel)
}

final class ToDoListPresenter: ToDoListOutputProtocol, EditTaskDelegate {
    weak var view: ToDoListViewInputProtocol?
    var interactor: ToDoListInteractorInputProtocol?
    var router: ToDoListRouterInputProtocol?
    
    private var tasks: [TaskModel] = [] {
        didSet {
            updateView()
        }
    }
    private var filteredTasks: [TaskModel] = []
    private var isSearchActive: Bool = false
    
    func viewDidLoad() {
        view?.setupUI()
        interactor?.loadTasksFromAPI()
        interactor?.fetchTasks()
    }
    
    func didFetchTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks.reversed()
    }
    
    func didFailToFetchTasks(_ error: Error) {
        if let tasksFetchError = error as? ToDoServiceError {
            view?.showError("Failed to load tasks: \(tasksFetchError.errorDescription)")
        } else {
            view?.showError("Failed to load tasks: \(error.localizedDescription)")
        }
    }
    
    func didSearchTextChange(_ text: String) {
        isSearchActive = !text.isEmpty
        filteredTasks = isSearchActive ? tasks.filter { $0.todo.lowercased().contains(text.lowercased()) } : []
        updateView()
    }
    
    private func updateView() {
        let tasksForDisplay = isSearchActive ? filteredTasks : tasks
        view?.showTasks(tasksForDisplay, totalCount: tasks.count)
    }
    
    func toggleTaskCompletion(at index: Int) {
        if isSearchActive {
            let taskId = filteredTasks[index].id
            guard let originalIndex = tasks.firstIndex(where: { $0.id == taskId }) else { return }
            tasks[originalIndex].completed.toggle()
            filteredTasks[index].completed.toggle()
        } else {
            tasks[index].completed.toggle()
        }
        interactor?.updateTask(tasks[index])
        updateView()
    }
    
    func navigateToEditTask(_ task: TaskModel) {
        router?.presentTaskDetail(task, self)
    }
    
    func navigateToCreateTask() {
        let id = Int(UUID().uuidString.prefix(8), radix: 16) ?? 0
        let newTask = TaskModel(id: id, todo: LocalizedData.title, desc: LocalizedData.description, completed: false, userId: id)
        tasks.insert(newTask, at: 0)
        interactor?.createTask(newTask)
        router?.presentTaskDetail(newTask, self)
    }
    
    func didEditTask(_ task: TaskModel) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index] = task
        interactor?.updateTask(tasks[index])
        updateView()
    }
    
    func deleteTask(_ task: TaskModel) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks.remove(at: index)
        if isSearchActive {
            guard let filteredIndex = filteredTasks.firstIndex(where: { $0.id == task.id }) else { return }
            filteredTasks.remove(at: filteredIndex)
            updateView()
        }
        interactor?.deleteTask(task)
    }
    
    func navigateToShareSheet(_ task: TaskModel) {
        let itemsToShare = [task.todo]
        router?.presentShareSheet(items: itemsToShare)
    }
}
