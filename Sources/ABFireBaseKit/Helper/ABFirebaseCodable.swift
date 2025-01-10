import Foundation

/// Protocol defining requirements for a Firebase-compatible model.
/// Models conforming to this protocol must be:
/// - `Hashable`: Ensures models can be used in sets or as dictionary keys.
/// - `Codable`: Allows encoding and decoding of model data.
/// - `Identifiable`: Requires models to have a unique identifier.
@available(iOS 13.0, *)
public protocol ABFirebaseCodable: Hashable, Codable, Identifiable {
    /// The unique identifier for the Firebase model.
    var id: String { get set }
}

/// Typealias for a dictionary with `String` keys and `Any` values.
/// Commonly used to represent serialized data from a model.
public typealias Dictionary = [String: Any]

/// Extension for `Encodable` to convert objects into a dictionary representation.
extension Encodable {
    
    // MARK: - Convert Encodable to Dictionary
    
    /// Converts an `Encodable` object to a dictionary representation.
    /// This is useful for serializing data to send to Firebase or other APIs.
    ///
    /// - Returns: A dictionary representation of the object, or an empty dictionary if conversion fails.
    func asDictionary() -> Dictionary {
        // Try to encode the object to JSON data.
        guard let data = try? JSONEncoder().encode(self) else {
            return [:] // Return an empty dictionary if encoding fails.
        }
        // Try to convert JSON data to a dictionary.
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary else {
            return [:] // Return an empty dictionary if conversion fails.
        }
        return dictionary
    }
}
