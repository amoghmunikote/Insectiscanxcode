/// CameraViewController.swift
import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - UI Components
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shouldRasterize = false // Don't rasterize camera view for better quality
        return view
    }()
    
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        // Add haptic feedback for better user experience
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()
    
    private lazy var galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.on.rectangle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        // Add haptic feedback for better user experience
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()
    
    private lazy var notesTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Add notes about the bite or sting..."
        textView.textColor = .lightGray
        textView.delegate = self
        // Improve scrolling performance
        textView.isScrollEnabled = true
        textView.scrollsToTop = true
        textView.bounces = true
        textView.showsVerticalScrollIndicator = true
        return textView
    }()
    
    private var notesTextViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Performance optimizations
        view.isOpaque = true
        
        setupUI()
        setupCamera()
        optimizeForPerformance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start camera when view appears with smooth fade in
        captureSession?.startRunning()
        
        // Add a subtle animation when the view appears
        UIView.animate(withDuration: 0.3) {
            self.cameraView.alpha = 1.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Prepare view for appearance
        cameraView.alpha = 0.8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop camera when view disappears
        captureSession?.stopRunning()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Camera"
        view.backgroundColor = .white
        
        view.addSubview(cameraView)
        view.addSubview(notesTextView)
        view.addSubview(captureButton)
        view.addSubview(galleryButton)
        
        // Dynamic constraint that can be updated when keyboard appears
        notesTextViewBottomConstraint = notesTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            notesTextView.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 16),
            notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notesTextViewBottomConstraint!,
            
            captureButton.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: -20),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            galleryButton.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor, constant: -20),
            galleryButton.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: -20),
            galleryButton.widthAnchor.constraint(equalToConstant: 44),
            galleryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            presentAlert(title: "Camera Error", message: "Unable to access the camera.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if let captureSession = captureSession,
               captureSession.canAddInput(input),
               let stillImageOutput = stillImageOutput,
               captureSession.canAddOutput(stillImageOutput) {
                
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = cameraView.bounds
                
                if let videoPreviewLayer = videoPreviewLayer {
                    cameraView.layer.addSublayer(videoPreviewLayer)
                }
                
                // Start capture session in background for better UI responsiveness
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession?.startRunning()
                }
            }
        } catch {
            presentAlert(title: "Camera Error", message: "Unable to initialize the camera: \(error.localizedDescription)")
        }
    }
    
    private func optimizeForPerformance() {
        // Optimize UI elements for better performance
        [captureButton, galleryButton].forEach { button in
            button.layer.shouldRasterize = true
            button.layer.rasterizationScale = UIScreen.main.scale
        }
        
        // Optimize text rendering
        notesTextView.layer.drawsAsynchronously = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = cameraView.bounds
        captureButton.layer.cornerRadius = captureButton.frame.width / 2
    }
    
    // MARK: - Actions
    @objc private func capturePhoto() {
        guard let stillImageOutput = stillImageOutput else { return }
        
        // Add animation for capture button
        animateCaptureButton()
        
        let settings = AVCapturePhotoSettings()
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func buttonTapped() {
        // Generate haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func animateCaptureButton() {
        // Create a quick pulse animation
        UIView.animate(withDuration: 0.1, animations: {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.captureButton.transform = CGAffineTransform.identity
            }
        })
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        // Process the captured image with a smooth transition
        showImagePreview(with: image)
    }
    
    private func showImagePreview(with image: UIImage) {
        let previewVC = ImagePreviewViewController(image: image, notes: notesTextView.text)
        
        // Add smooth transition
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: nil)
        
        navigationController?.pushViewController(previewVC, animated: false)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            showImagePreview(with: image)
        }
    }
}

// MARK: - UITextViewDelegate
extension CameraViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
        
        // Add keyboard notification observers when editing begins
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add Done button above keyboard
        addDoneButtonToKeyboard()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add notes about the bite or sting..."
            textView.textColor = .lightGray
        }
        
        // Remove observers when editing ends
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        // Get keyboard size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // Update constraint to move textView above keyboard
        notesTextViewBottomConstraint?.constant = -keyboardSize.height - 16
        
        // Animate the change with smoother animation
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Reset constraint
        notesTextViewBottomConstraint?.constant = -16
        
        // Animate the change with smoother animation
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func addDoneButtonToKeyboard() {
        // Create toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        
        // Add Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexSpace, doneButton]
        
        // Add toolbar to textView
        notesTextView.inputAccessoryView = toolBar
    }
}
