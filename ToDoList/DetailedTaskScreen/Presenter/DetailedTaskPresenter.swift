import UIKit

protocol DetailedTaskOutputProtocol {
    func viewDidLoad()
    func didFinishEditingTask(_ title: String, _ desc: String, _ dateString: String)
}

final class DetailedTaskPresenter: DetailedTaskOutputProtocol {
    weak var view: DetailedTaskViewInputProtocol?
    weak var delegate: DetailedTaskDelegate?
    
    private var task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
    }
    
    func viewDidLoad() {
        view?.setupWithTaskData(task)
    }
    
    func didFinishEditingTask(_ title: String, _ desc: String, _ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat
        guard let date = dateFormatter.date(from: dateString) else { return }
        
        task.todo = title
        task.desc = desc
        task.date = date
        delegate?.didEditTask(task)
    }
}
