//
//  countrydetailviewcontroller.swift
//  insectiscan
//
//  Created by Jason Grife on 3/9/25.
//
// CountryDetailViewController.swift
import UIKit

class CountryDetailViewController: UIViewController {
    // MARK: - Properties
    private let country: Country
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var insectsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Dangerous Insects & Bugs"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var insectsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var safetyTipsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Safety Precautions"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var safetyTipsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureWithCountry()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = country.name
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(insectsHeaderLabel)
        contentView.addSubview(insectsStackView)
        contentView.addSubview(safetyTipsHeaderLabel)
        contentView.addSubview(safetyTipsStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            insectsHeaderLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            insectsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            insectsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            insectsStackView.topAnchor.constraint(equalTo: insectsHeaderLabel.bottomAnchor, constant: 8),
            insectsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            insectsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            safetyTipsHeaderLabel.topAnchor.constraint(equalTo: insectsStackView.bottomAnchor, constant: 24),
            safetyTipsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            safetyTipsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            safetyTipsStackView.topAnchor.constraint(equalTo: safetyTipsHeaderLabel.bottomAnchor, constant: 8),
            safetyTipsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            safetyTipsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            safetyTipsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureWithCountry() {
        titleLabel.text = country.name
        
        // Add insect labels
        for (index, insect) in country.insects.enumerated() {
            let insectLabel = createBulletLabel(text: insect, number: index + 1)
            insectsStackView.addArrangedSubview(insectLabel)
        }
        
        // Add safety tip labels
        for (index, tip) in country.safetyTips.enumerated() {
            let tipLabel = createBulletLabel(text: tip, number: index + 1)
            safetyTipsStackView.addArrangedSubview(tipLabel)
        }
    }
    
    private func createBulletLabel(text: String, number: Int) -> UILabel {
        let label = UILabel()
        label.text = "\(number). \(text)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }
}
