import UIKit
import SnapKit

protocol DetailedTaskViewInputProtocol: AnyObject {
    func setupWithTaskData(_ task: TaskModel)
    func updateDate(date: String)
}

final class DetailedTaskViewController: UIViewController, DetailedTaskViewInputProtocol {
    var output: DetailedTaskOutputProtocol?
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 34)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = 3
        textView.keyboardAppearance = .dark
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .faidedWhite
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        label.addGestureRecognizer(dateTapGesture)

        return label
    }()
    
    private lazy var calendarView: UICalendarView = {
        let view = UICalendarView()
        view.overrideUserInterfaceStyle = .dark
        view.tintColor = .customYellow
        view.isUserInteractionEnabled = true
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        view.selectionBehavior = dateSelection
        return view
    }()
    
    private lazy var calendarContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isHidden = true
        view.backgroundColor = .customDarkGray
        
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        return view
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.autocorrectionType = .yes
        textView.keyboardAppearance = .dark
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        calendarView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let title = titleTextView.text,
              let desc = descriptionTextView.text,
              let dateString = dateLabel.text else { return }
        output?.didFinishEditingTask(title, desc, dateString)
    }
    
    func setupWithTaskData(_ task: TaskModel) {
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .customYellow
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        addSubviews()
        setupConstraints()
        loadTaskData(task)
    }
    private func loadTaskData(_ task: TaskModel) {
        titleTextView.text = task.todo
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat
        let formattedDate = dateFormatter.string(from: task.date ?? Date())
        dateLabel.text = formattedDate
        descriptionTextView.text = task.desc
    }
    
    func updateDate(date: String) {
        dateLabel.text = date        
    }
    
    @objc private func dateLabelTapped() {
        if let dateString = dateLabel.text, !dateString.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = K.dateFormat
            
            if let savedDate = dateFormatter.date(from: dateString) {
                if let selection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate {
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: savedDate)
                    selection.setSelected(dateComponents, animated: true)
                }
            }
        }
        calendarContainerView.isHidden.toggle()
    }


    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UI

private extension DetailedTaskViewController {
    
    func addSubviews() {
        
        [titleTextView, dateLabel, descriptionTextView, calendarContainerView].forEach(view.addSubview)
    }
    
    func setupConstraints() {
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.left.right.equalToSuperview().inset(15)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.left.right.equalTo(titleTextView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        calendarContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(350)
        }

    }
}

extension DetailedTaskViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else { return }
        
        output?.didChooseDate(date: date)
        calendarContainerView.isHidden = true
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = K.dateFormat
//        let formattedDate = dateFormatter.string(from: date)
//
//        dateLabel.text = formattedDate
        
    }
}


