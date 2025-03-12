//
//  countrycell.swift
//  insectiscan
//
//  Created by Jason Grife on 3/9/25.
//
// CountryCell.swift
import UIKit

class CountryCell: UITableViewCell {
    // MARK: - UI Components
    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var insectCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(countryNameLabel)
        contentView.addSubview(insectCountLabel)
        contentView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            countryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countryNameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            
            insectCountLabel.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 4),
            insectCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            insectCountLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            insectCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configure
    func configure(with country: Country) {
        countryNameLabel.text = country.name
        insectCountLabel.text = "\(country.insects.count) species of dangerous insects/bugs"
    }
}
