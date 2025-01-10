import Foundation

// MARK: - ABParser

/// A utility class for parsing Firebase document data into `Decodable` models.
public struct ABParser {
    
    // MARK: - Parsing Methods
    
    /// Parses a `Dictionary` into a `Decodable` type.
    ///
    /// - Parameters:
    ///   - documentData: The dictionary representing the document data.
    /// - Throws: An `ABFireBaseError.parseError` if parsing fails.
    /// - Returns: The parsed object of type `T` where `T` conforms to `Decodable`.
    public static func parse<T: Decodable>(_ documentData: Dictionary) throws -> T {
        do {
            // Convert the dictionary to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
            
            // Decode the JSON data into the specified type
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            // If parsing fails, throw a parse error
            throw ABFireBaseError.parseError
        }
    }
    
    /// Parses any `JSONSerializable` object into a `Decodable` type.
    ///
    /// - Parameters:
    ///   - documentData: The object representing the document data, which will be serialized into JSON.
    /// - Throws: An `ABFireBaseError.parseError` if parsing fails.
    /// - Returns: The parsed object of type `T` where `T` conforms to `Decodable`.
    public static func parse<T: Decodable>(_ documentData: Any) throws -> T {
        do {
            // Convert the object to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: documentData)
            
            // Decode the JSON data into the specified type
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            // If parsing fails, throw a parse error
            throw ABFireBaseError.parseError
        }
    }
}
