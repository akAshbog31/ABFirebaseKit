import Foundation

// MARK: - ABFirebaseMethod Enum

/// Enum representing the different HTTP methods that can be used in Firebase operations.
@available(iOS 13.0, *)
public enum ABFirebaseMethod {
    
    // MARK: - Cases

    /// Represents a `GET` method for fetching data.
    case get
    
    /// Represents a `POST` method for creating or submitting new data.
    /// The associated value contains the data to be posted, which must conform to `ABFirebaseCodable`.
    case post(any ABFirebaseCodable)
    
    /// Represents an `UPDATE` method for modifying existing data.
    /// The associated value contains the data to be updated, which must conform to `ABFirebaseCodable`.
    case update(any ABFirebaseCodable)
    
    /// Represents a `DELETE` method for removing data.
    case delete
}
