
import UIKit
import SnapKit

protocol ToDoListViewInputProtocol: AnyObject {
    func setupUI()
    func showTasks(_ tasks: [TaskModel], totalCount: Int)
    func showError(_ message: String)
}

final class ToDoListViewController: UIViewController, ToDoListViewInputProtocol {
    var output: ToDoListOutputProtocol?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .customDarkGray
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .customYellow
        searchBar.keyboardAppearance = .dark
        
        if let textField = searchBar.value(forKey: K.searchField) as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: LocalizedData.search,
                attributes: [.foregroundColor: UIColor.faidedWhite]
            )
            if let iconView = textField.leftView as? UIImageView {
                iconView.tintColor = UIColor.gray
            }
        }
        
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: K.taskCell)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
        
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customDarkGray
        return view
    }()
    
    private let bottomBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .customDarkGray
        return view
    }()
    
    private lazy var newTaskButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .customYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return button
        
    }()
    
    private let taskCounterLabel: UILabel = {
        let taskCounterLabel = UILabel()
        taskCounterLabel.textColor = .white
        taskCounterLabel.font = UIFont.systemFont(ofSize: 12)
        return taskCounterLabel
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedData.tasks
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .white
        return label
        
    }()
    
    
    private var tasks: [TaskModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI() {
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        title = LocalizedData.tasks
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        setupSearchBar()
        addSubviews()
        setupConstraints()
    }
    
    private func setupSearchBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
    }
    
    func showTasks(_ tasks: [TaskModel], totalCount: Int) {
        self.tasks = tasks
        tableView.reloadData()
        taskCounterLabel.text = "\(totalCount) Задач"
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: LocalizedData.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedData.ok, style: .default))
        present(alert, animated: true)
        print(message)
    }
    
    @objc private func didTapAddButton() {
        output?.navigateToCreateTask()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.taskCell, for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let editAction = UIAction(title: LocalizedData.editAction, image: UIImage(resource: .edit)) { action in
                self.output?.navigateToEditTask(task)
            }
            let shareAction = UIAction(title: LocalizedData.shareAction, image: UIImage(resource: .export)) { action in
                self.output?.navigateToShareSheet(task)
            }
            let deleteAction = UIAction(title: LocalizedData.deleteAction, image: UIImage(resource: .trash), attributes: .destructive) { action in
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    self.output?.deleteTask(task)
                })
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        output?.navigateToEditTask(tasks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: LocalizedData.deleteAction) { [weak self] _, _, complete in
            guard let self = self else { return }
            let taskForDelete = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.output?.deleteTask(taskForDelete)
            })
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ToDoListViewController: TaskTableViewCellDelegate {
    func didToggleTaskCompletion(at cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tasks[indexPath.row].completed.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        output?.toggleTaskCompletion(at: indexPath.row)
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output?.didSearchTextChange(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - UI

private extension ToDoListViewController {
    
    func addSubviews() {
        
        [searchBar, tableView, bottomBgView, footerView].forEach(view.addSubview)
        [taskCounterLabel,newTaskButton ].forEach(footerView.addSubview)
    }
    
    func setupConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(10)
        }
        
        footerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        bottomBgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(footerView)
            make.left.right.equalToSuperview()
        }
        
        taskCounterLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        newTaskButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
    }
}
