//
//  TFLiteModelHandler.swift
//  insectiscan
//
//  Created by Amogh Munikote on 3/23/25.
//
import TensorFlowLite

class TFLiteModelHandler {
    private var interpreter: Interpreter?

    init?(modelName: String) {
        do {
            guard let modelPath = Bundle.main.path(forResource: modelName, ofType: "tflite") else {
                print("Model file not found.")
                return nil
            }
            interpreter = try Interpreter(modelPath: modelPath)
            try interpreter?.allocateTensors()
        } catch {
            print("Failed to create the interpreter: \(error)")
            return nil
        }
    }

    func runModel(inputData: [Float]) -> [Float]? {
        do {
            try interpreter?.copy(inputData, toInputAt: 0)
            try interpreter?.invoke()

            let outputTensor = try interpreter?.output(at: 0)
            return outputTensor?.data.toArray(type: Float.self)
        } catch {
            print("Error running the model: \(error)")
            return nil
        }
    }
}

// Helper extension to convert Data to an array
extension Data {
    func toArray<T>(type: T.Type) -> [T] {
        return withUnsafeBytes {
            Array(UnsafeBufferPointer<T>(start: $0.baseAddress?.assumingMemoryBound(to: T.self), count: self.count / MemoryLayout<T>.stride))
        }
    }
}
