//
//  riskassessmentviewcontroller.swift
//  insectiscan
//
//  Created by Jason Grife on 3/9/25.
//

// RiskAssessmentViewController.swift
import UIKit

class RiskAssessmentViewController: UIViewController {
    // MARK: - UI Components
    private lazy var painLevelSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 1
        slider.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var painLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Pain Level: 1"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var swellingLevelSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 1
        slider.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var swellingLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Swelling Level: 1"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate Risk", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculateRisk), for: .touchUpInside)
        return button
    }()
    
    private lazy var riskMeterView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var riskMeterFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var riskLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Risk Level: 1/10"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var riskDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Low Risk - Monitor for changes"
        label.textColor = .green
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var riskMeterFillViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSliderActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Risk Assessment"
        view.backgroundColor = .white
        
        view.addSubview(painLevelLabel)
        view.addSubview(painLevelSlider)
        view.addSubview(swellingLevelLabel)
        view.addSubview(swellingLevelSlider)
        view.addSubview(calculateButton)
        view.addSubview(riskMeterView)
        riskMeterView.addSubview(riskMeterFillView)
        view.addSubview(riskLevelLabel)
        view.addSubview(riskDescriptionLabel)
        
        riskMeterFillViewWidthConstraint = riskMeterFillView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            painLevelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            painLevelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            painLevelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            painLevelSlider.topAnchor.constraint(equalTo: painLevelLabel.bottomAnchor, constant: 8),
            painLevelSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            painLevelSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            swellingLevelLabel.topAnchor.constraint(equalTo: painLevelSlider.bottomAnchor, constant: 24),
            swellingLevelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            swellingLevelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            swellingLevelSlider.topAnchor.constraint(equalTo: swellingLevelLabel.bottomAnchor, constant: 8),
            swellingLevelSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            swellingLevelSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            calculateButton.topAnchor.constraint(equalTo: swellingLevelSlider.bottomAnchor, constant: 32),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calculateButton.heightAnchor.constraint(equalToConstant: 50),
            
            riskMeterView.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 32),
            riskMeterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            riskMeterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            riskMeterView.heightAnchor.constraint(equalToConstant: 24),
            
            riskMeterFillView.topAnchor.constraint(equalTo: riskMeterView.topAnchor),
            riskMeterFillView.leadingAnchor.constraint(equalTo: riskMeterView.leadingAnchor),
            riskMeterFillView.heightAnchor.constraint(equalTo: riskMeterView.heightAnchor),
            riskMeterFillViewWidthConstraint,
            
            riskLevelLabel.topAnchor.constraint(equalTo: riskMeterView.bottomAnchor, constant: 16),
            riskLevelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            riskDescriptionLabel.topAnchor.constraint(equalTo: riskLevelLabel.bottomAnchor, constant: 8),
            riskDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupSliderActions() {
        painLevelSlider.addTarget(self, action: #selector(painSliderChanged), for: .valueChanged)
        swellingLevelSlider.addTarget(self, action: #selector(swellingSliderChanged), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc private func painSliderChanged() {
        let value = Int(painLevelSlider.value)
        painLevelLabel.text = "Pain Level: \(value)"
    }
    
    @objc private func swellingSliderChanged() {
        let value = Int(swellingLevelSlider.value)
        swellingLevelLabel.text = "Swelling Level: \(value)"
    }
    
    @objc private func calculateRisk() {
        let painLevel = Int(painLevelSlider.value)
        let swellingLevel = Int(swellingLevelSlider.value)
        
        // Simple risk calculation - customize as needed
        let riskScore = min((painLevel + swellingLevel) / 2, 10)
        
        // Update risk meter
        updateRiskMeter(with: riskScore)
    }
    
    private func updateRiskMeter(with score: Int) {
        // Update the risk meter fill width
        let fillPercentage = CGFloat(score) / 10.0
        riskMeterFillViewWidthConstraint.constant = riskMeterView.bounds.width * fillPercentage
        
        // Update risk color
        switch score {
        case 1...3:
            riskMeterFillView.backgroundColor = .green
            riskDescriptionLabel.textColor = .green
            riskDescriptionLabel.text = "Low Risk - Monitor for changes"
        case 4...6:
            riskMeterFillView.backgroundColor = .orange
            riskDescriptionLabel.textColor = .orange
            riskDescriptionLabel.text = "Medium Risk - Consider medical attention"
        case 7...10:
            riskMeterFillView.backgroundColor = .red
            riskDescriptionLabel.textColor = .red
            riskDescriptionLabel.text = "High Risk - Seek immediate medical attention"
        default:
            break
        }
        
        riskLevelLabel.text = "Risk Level: \(score)/10"
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
