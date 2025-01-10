import Firebase

// MARK: - ABRealtimeEndPoint Protocol

@available(iOS 13.0, *)
public protocol ABRealtimeEndPoint {
    /// The path used to access a specific reference in the Realtime Database.
    /// - Returns: The reference for the Realtime Database query or path.
    var path: ABRealtimeDatabaseReference { get }
    
    /// The method to be used for the operation (e.g., get, post, update, delete).
    /// - Returns: The method to be used for the operation.
    var method: ABFirebaseMethod { get }
    
    /// The instance of the Firebase Realtime Database.
    /// - Returns: The Firebase Database instance for performing the operation.
    var database: Database { get }
}

// MARK: - Default Database Implementation for ABRealtimeEndPoint

@available(iOS 13.0, *)
public extension ABRealtimeEndPoint {
    /// Default implementation that provides a shared instance of the Firebase Realtime Database.
    /// This is used to perform database operations in the protocol.
    var database: Database {
        Database.database() // Returns the shared Firebase Database instance
    }
}

// MARK: - ABRealtimeDatabaseReference Protocol

/// A protocol that defines a reference in the Firebase Realtime Database.
/// This can be used to abstract away different types of references that are used in Firebase operations.
public protocol ABRealtimeDatabaseReference {}

/// Extend `DatabaseQuery` to conform to `ABRealtimeDatabaseReference`.
/// This allows a `DatabaseQuery` to be used as a reference in Firebase Realtime Database operations.
extension DatabaseQuery: ABRealtimeDatabaseReference {}
