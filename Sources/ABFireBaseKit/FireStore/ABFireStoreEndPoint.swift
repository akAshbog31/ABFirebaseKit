import Firebase

/// Protocol defining the requirements for a Firestore endpoint.
/// This is used to specify the Firestore path, method, and Firestore instance for any Firestore operation.
@available(iOS 13.0, *)
public protocol ABFireStoreEndPoint {
    /// The Firestore path, which can be a `DocumentReference` or `Query`.
    var path: ABFirestoreReference { get }
    
    /// The Firestore method specifying the type of operation (e.g., get, post, update, delete).
    var method: ABFirebaseMethod { get }
    
    /// The Firestore instance used to perform operations.
    var firestore: Firestore { get }
}

/// Extension providing a default implementation of the `firestore` property.
/// This allows the protocol to supply a default Firestore instance without requiring explicit implementation.
@available(iOS 13.0, *)
public extension ABFireStoreEndPoint {
    /// Default Firestore instance used by the endpoint.
    var firestore: Firestore {
        Firestore.firestore()
    }
}

/// Protocol that serves as a marker for Firestore references.
/// This abstracts Firestore path types (e.g., `DocumentReference` and `Query`) into a common protocol.
public protocol ABFirestoreReference {}

/// Conform `DocumentReference` to `ABFirestoreReference`.
/// This allows `DocumentReference` to be used as a valid Firestore path.
extension DocumentReference: ABFirestoreReference {}

/// Conform `Query` to `ABFirestoreReference`.
/// This allows `Query` to be used as a valid Firestore path.
extension Query: ABFirestoreReference {}
