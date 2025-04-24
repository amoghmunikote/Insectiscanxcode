import UIKit
import TensorFlowLite

class ImagePreviewViewController: UIViewController {
    // MARK: - Properties
    private let image: UIImage
    private let notes: String
    private var interpreter: Interpreter?

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

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
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
        setupInterpreter()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Image Preview"
        view.backgroundColor = .white
        imageView.image = image

        notesLabel.text = notes == "Add notes about the bite or sting..." ? "No notes added" : notes

        view.addSubview(imageView)
        view.addSubview(notesLabel)
        view.addSubview(resultLabel)
        view.addSubview(riskAssessmentButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            notesLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            notesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            resultLabel.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 24),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            riskAssessmentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            riskAssessmentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            riskAssessmentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            riskAssessmentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupInterpreter() {
        guard let modelPath = Bundle.main.path(forResource: "converted_model", ofType: "tflite") else {
            print("Failed to load model: file not found in bundle")
            return
        }

        do {
            interpreter = try Interpreter(modelPath: modelPath)
            try interpreter?.allocateTensors()
        } catch {
            print("Error setting up interpreter: \(error.localizedDescription)")
        }
    }

    // MARK: - Actions
    @objc private func assessRisk() {
        guard let interpreter = interpreter else {
            showAlert(message: "Model not loaded properly")
            return
        }

        guard let inputData = prepareInputData() else {
            showAlert(message: "Failed to prepare image for processing")
            return
        }

        do {
            try interpreter.copy(inputData, toInputAt: 0)
            try interpreter.invoke()
            let outputTensor = try interpreter.output(at: 0)

            if let results = processResults(outputTensor: outputTensor) {
                displayResults(results)
            } else {
                showAlert(message: "Failed to process results")
            }
        } catch {
            showAlert(message: "Error during inference: \(error.localizedDescription)")
        }
    }

    private func prepareInputData() -> Data? {
        let imageSize = CGSize(width: 224, height: 224)
        return image.resized(to: imageSize)?.rgbData()
    }

    private func processResults(outputTensor: Tensor) -> [String: Float]? {
        guard let outputData = outputTensor.data.toArray(type: Float.self) else {
            return nil
        }

        let classNames = ["Bee", "Mosquito", "None", "Spider", "Tick"]
        var results: [String: Float] = [:]
        for (index, probability) in outputData.enumerated() where index < classNames.count {
            results[classNames[index]] = probability
        }
        return results
    }

    private func displayResults(_ results: [String: Float]) {
        guard let highest = results.max(by: { $0.value < $1.value }) else { return }
        let probability = (highest.value * 100).rounded() / 100
        resultLabel.text = "Likely: \(highest.key.capitalized) (\(probability * 100)%)"
        resultLabel.textColor = .black
        resultLabel.isHidden = false
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIImage Extensions
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func rgbData() -> Data? {
        guard let cgImage = self.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height

        let imageRect = CGRect(x: 0, y: 0, width: width, height: height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        var rawData = [UInt8](repeating: 0, count: Int(height * bytesPerRow))

        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        ) else {
            return nil
        }

        context.draw(cgImage, in: imageRect)

        // Convert to normalized Float32 RGB values
        var floatData = [Float]()
        for y in 0..<height {
            for x in 0..<width {
                let byteIndex = y * bytesPerRow + x * bytesPerPixel
                let r = Float(rawData[byteIndex]) / 255.0
                let g = Float(rawData[byteIndex + 1]) / 255.0
                let b = Float(rawData[byteIndex + 2]) / 255.0

                floatData.append(r)
                floatData.append(g)
                floatData.append(b)
            }
        }

        return Data(buffer: UnsafeBufferPointer(start: &floatData, count: floatData.count))
    }

}

// MARK: - Data Extension
extension Data {
    func toArray<T>(type: T.Type) -> [T]? {
        return withUnsafeBytes {
            guard let baseAddress = $0.baseAddress else { return nil }
            let count = count / MemoryLayout<T>.stride
            return Array(UnsafeBufferPointer(start: baseAddress.assumingMemoryBound(to: T.self), count: count))
        }
    }
}
