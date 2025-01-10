import Firebase

// MARK: - ABRealtimeDatabaseServiceProtocol

@available(iOS 13.0, *)
public protocol ABRealtimeDatabaseServiceProtocol {
    /// Observes changes for a specified endpoint and handles events based on the event type.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    ///   - eventType: The type of event to listen for (e.g., `.value`, `.childAdded`).
    ///   - handler: A closure that is called with the result of the observation (success or failure).
    static func observe<T>(for endPoint: ABRealtimeEndPoint, eventType: DataEventType, handler: @escaping (Result<T, Error>) -> Void)
    
    /// Requests data from the specified endpoint and returns a single object.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    /// - Throws: An error if the request fails.
    /// - Returns: The requested object of type `T`.
    static func request<T>(for endPoint: ABRealtimeEndPoint) async throws -> T where T: ABFirebaseCodable
    
    /// Requests data from the specified endpoint and returns a collection of objects.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    /// - Throws: An error if the request fails.
    /// - Returns: An array of objects of type `T`.
    static func request<T>(for endPoint: ABRealtimeEndPoint) async throws -> [T] where T: ABFirebaseCodable
    
    /// Performs a write operation (post, update, or delete) at the specified endpoint.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    /// - Throws: An error if the operation fails.
    static func request(for endPoint: ABRealtimeEndPoint) async throws
}

// MARK: - ABRealtimeDatabaseService

@available(iOS 13.0, *)
public class ABRealtimeDatabaseService: ABRealtimeDatabaseServiceProtocol {
    
    // MARK: - Observing Data
    
    /// Observes a real-time data change for a specified endpoint and triggers the handler when an event occurs.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    ///   - eventType: The type of event to observe.
    ///   - handler: A closure to handle the result of the observation.
    public static func observe<T>(for endPoint: any ABRealtimeEndPoint, eventType: DataEventType, handler: @escaping (Result<T, any Error>) -> Void) {
        guard let reference = endPoint.path as? DatabaseQuery else {
            handler(.failure(ABFireBaseError.invalidPath)) // If path is invalid, return failure
            return
        }
        
        switch endPoint.method {
        case .get:
            // Observing the database reference for real-time changes
            reference.observe(eventType) { snapshot in
                guard let value = snapshot.value as? T else {
                    handler(.failure(ABFireBaseError.invalidType)) // If the value type is incorrect, return failure
                    return
                }
                handler(.success(value)) // If successful, return the parsed value
            }
        default:
            handler(.failure(ABFireBaseError.invalidRequest)) // Return failure for unsupported methods
        }
    }
    
    // MARK: - Requesting Data (Single Object)
    
    /// Requests a single object from the specified endpoint.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    /// - Throws: An error if the request fails.
    /// - Returns: A single object of type `T` parsed from the data.
    public static func request<T>(for endPoint: any ABRealtimeEndPoint) async throws -> T where T: ABFirebaseCodable {
        guard let reference = endPoint.path as? DatabaseQuery else {
            throw ABFireBaseError.invalidPath // Return an error if the path is invalid
        }
        
        switch endPoint.method {
        case .get:
            guard let snapshot = try await reference.getData().value as? Dictionary else {
                throw ABFireBaseError.invalidRequest // Return an error if data retrieval fails
            }
            let singleResponse: T = try ABParser.parse(snapshot) // Parse the snapshot into the expected type
            return singleResponse
        default:
            throw ABFireBaseError.invalidRequest // Return error for unsupported methods
        }
    }
    
    // MARK: - Requesting Data (Array of Objects)
    
    /// Requests multiple objects from the specified endpoint.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    /// - Throws: An error if the request fails.
    /// - Returns: An array of objects of type `T` parsed from the data.
    public static func request<T>(for endPoint: any ABRealtimeEndPoint) async throws -> [T] where T: ABFirebaseCodable {
        guard let reference = endPoint.path as? DatabaseQuery else {
            throw ABFireBaseError.invalidPath // Return an error if the path is invalid
        }
        
        switch endPoint.method {
        case .get:
            guard let snapshot = try await reference.getData().value as? Dictionary else {
                throw ABFireBaseError.invalidRequest // Return an error if data retrieval fails
            }
            let models: [T] = try snapshot.compactMap { (_, data) in
                return try ABParser.parse(data) // Parse each document data into the expected type
            }
            return models
        default:
            throw ABFireBaseError.invalidRequest // Return error for unsupported methods
        }
    }
    
    // MARK: - Performing Write Operations
    
    /// Performs write operations (post, update, delete) at the specified endpoint.
    /// - Parameters:
    ///   - endPoint: The endpoint specifying the data reference and method.
    /// - Throws: An error if the operation fails.
    public static func request(for endPoint: any ABRealtimeEndPoint) async throws {
        guard let reference = endPoint.path as? DatabaseReference else {
            throw ABFireBaseError.invalidPath // Return an error if the reference path is invalid
        }
        
        switch endPoint.method {
        case let .post(model):
            try await reference.setValue(model.asDictionary()) // Post the data to the reference
        case let .update(model):
            try await reference.updateChildValues(model.asDictionary()) // Update the data at the reference
        case .delete:
            try await reference.removeValue() // Remove the data at the reference
        default:
            throw ABFireBaseError.invalidRequest // Return error for unsupported methods
        }
    }
}
