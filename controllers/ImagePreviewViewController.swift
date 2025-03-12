//
//  imagepreviewviewcontroller.swift
//  insectiscan
//
//  Created by Jason Grife on 3/9/25.
//

// ImagePreviewViewController.swift
import UIKit

class ImagePreviewViewController: UIViewController {
    // MARK: - Properties
    private let image: UIImage
    private let notes: String
    
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var riskAssessmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Assess Risk", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(assessRisk), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(image: UIImage, notes: String) {
        self.image = image
        self.notes = notes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Image Preview"
        view.backgroundColor = .white
        
        imageView.image = image
        
        if notes == "Add notes about the bite or sting..." {
            notesLabel.text = "No notes added"
        } else {
            notesLabel.text = notes
        }
        
        view.addSubview(imageView)
        view.addSubview(notesLabel)
        view.addSubview(riskAssessmentButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            notesLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            notesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            riskAssessmentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            riskAssessmentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            riskAssessmentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            riskAssessmentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func assessRisk() {
        let riskVC = RiskAssessmentViewController()
        navigationController?.pushViewController(riskVC, animated: true)
    }
}
