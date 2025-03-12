//
//  AccountViewController.swift
//  insectiscan
//
//  Created by Jason Grife on 3/10/25.
//
// AccountViewController.swift
import UIKit

class AccountViewController: UIViewController {
    
    // MARK: - UI Components
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
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var agePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderSegmentedControl: UISegmentedControl = {
        let items = ["Male", "Female", "Other"]
        let control = UISegmentedControl(items: items)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var skinToneLabel: UILabel = {
        let label = UILabel()
        label.text = "Skin Tone"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var skinTonePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var locationSharingLabel: UILabel = {
        let label = UILabel()
        label.text = "Location Sharing"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationSharingSwitch: UISwitch = {
        let locationSwitch = UISwitch()
        locationSwitch.translatesAutoresizingMaskIntoConstraints = false
        return locationSwitch
    }()
    
    private lazy var emergencyContactsLabel: UILabel = {
        let label = UILabel()
        label.text = "Emergency Contacts"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addContactButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add Contact", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addContactTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Profile", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private let ageOptions = Array(1...120)
    private let skinToneOptions = ["Very Fair", "Fair", "Medium", "Olive", "Brown", "Dark Brown", "Very Dark"]
    private var emergencyContacts: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPickerViews()
        setupTableView()
        setupGestureRecognizers()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "My Profile"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(changePhotoButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(ageLabel)
        contentView.addSubview(agePicker)
        contentView.addSubview(genderLabel)
        contentView.addSubview(genderSegmentedControl)
        contentView.addSubview(skinToneLabel)
        contentView.addSubview(skinTonePicker)
        contentView.addSubview(locationSharingLabel)
        contentView.addSubview(locationSharingSwitch)
        contentView.addSubview(emergencyContactsLabel)
        contentView.addSubview(addContactButton)
        contentView.addSubview(contactsTableView)
        contentView.addSubview(saveButton)
        
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
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            changePhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ageLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            ageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            agePicker.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 8),
            agePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            agePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            agePicker.heightAnchor.constraint(equalToConstant: 120),
            
            genderLabel.topAnchor.constraint(equalTo: agePicker.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            genderSegmentedControl.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            skinToneLabel.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 20),
            skinToneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            skinTonePicker.topAnchor.constraint(equalTo: skinToneLabel.bottomAnchor, constant: 8),
            skinTonePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skinTonePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            skinTonePicker.heightAnchor.constraint(equalToConstant: 120),
            
            locationSharingLabel.topAnchor.constraint(equalTo: skinTonePicker.bottomAnchor, constant: 20),
            locationSharingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            locationSharingSwitch.centerYAnchor.constraint(equalTo: locationSharingLabel.centerYAnchor),
            locationSharingSwitch.leadingAnchor.constraint(equalTo: locationSharingLabel.trailingAnchor, constant: 20),
            
            emergencyContactsLabel.topAnchor.constraint(equalTo: locationSharingLabel.bottomAnchor, constant: 20),
            emergencyContactsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            addContactButton.centerYAnchor.constraint(equalTo: emergencyContactsLabel.centerYAnchor),
            addContactButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactsTableView.topAnchor.constraint(equalTo: emergencyContactsLabel.bottomAnchor, constant: 8),
            contactsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactsTableView.heightAnchor.constraint(equalToConstant: 100),
            
            saveButton.topAnchor.constraint(equalTo: contactsTableView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Make profile image view circular
        profileImageView.layer.cornerRadius = 60
    }
    
    private func setupPickerViews() {
        agePicker.delegate = self
        agePicker.dataSource = self
        
        skinTonePicker.delegate = self
        skinTonePicker.dataSource = self
        
        // Set default selections
        genderSegmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(changePhotoTapped))
        profileImageView.addGestureRecognizer(profileTapGesture)
    }
    
    // MARK: - Actions
    @objc private func changePhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Select Photo Source", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
    @objc private func addContactTapped() {
        let alert = UIAlertController(title: "Add Emergency Contact", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Contact Name"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Phone Number"
            textField.keyboardType = .phonePad
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let name = alert.textFields?[0].text, !name.isEmpty,
                  let phone = alert.textFields?[1].text, !phone.isEmpty else {
                return
            }
            
            self.emergencyContacts.append("\(name): \(phone)")
            self.contactsTableView.reloadData()
            
            // Adjust table height based on content
            self.updateTableViewHeight()
        }))
        
        present(alert, animated: true)
    }
    
    @objc private func saveProfile() {
        // Save profile data (to UserDefaults or your preferred storage)
        let profile = UserProfile(
            name: nameTextField.text ?? "",
            age: ageOptions[agePicker.selectedRow(inComponent: 0)],
            gender: genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) ?? "",
            skinTone: skinToneOptions[skinTonePicker.selectedRow(inComponent: 0)],
            locationSharingEnabled: locationSharingSwitch.isOn,
            emergencyContacts: emergencyContacts
        )
        
        saveProfileToStorage(profile)
        
        // Show success message
        let alert = UIAlertController(title: "Success", message: "Your profile has been saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateTableViewHeight() {
        let rowHeight: CGFloat = 44
        let newHeight = CGFloat(emergencyContacts.count) * rowHeight
        
        let heightConstraint = contactsTableView.constraints.first(where: { $0.firstAttribute == .height })
        heightConstraint?.constant = max(100, newHeight)
    }
    
    private func saveProfileToStorage(_ profile: UserProfile) {
        // Save to UserDefaults for simplicity
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "userProfile")
        }
    }
}

// MARK: - UIPickerViewDelegate & DataSource
extension AccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == agePicker {
            return ageOptions.count
        } else {
            return skinToneOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == agePicker {
            return String(ageOptions[row])
        } else {
            return skinToneOptions[row]
        }
    }
}

// MARK: - UITableViewDelegate & DataSource
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, emergencyContacts.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        if emergencyContacts.isEmpty {
            cell.textLabel?.text = "No emergency contacts added"
            cell.textLabel?.textColor = .lightGray
        } else {
            cell.textLabel?.text = emergencyContacts[indexPath.row]
            cell.textLabel?.textColor = .black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && !emergencyContacts.isEmpty {
            emergencyContacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateTableViewHeight()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        
        dismiss(animated: true)
    }
}

// MARK: - UserProfile Model
struct UserProfile: Codable {
    let name: String
    let age: Int
    let gender: String
    let skinTone: String
    let locationSharingEnabled: Bool
    let emergencyContacts: [String]
}
