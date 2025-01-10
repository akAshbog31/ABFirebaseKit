import Firebase

/// Protocol defining Firestore Database Service operations.
@available(iOS 13.0, *)
public protocol ABFireStoreDatabaseServiceProtocol {
    /// Request a single document of type `T` from Firestore.
    static func request<T>(for endPoint: ABFireStoreEndPoint) async throws -> T where T: ABFirebaseCodable
    
    /// Request a collection of documents of type `[T]` from Firestore.
    static func request<T>(for endPoint: ABFireStoreEndPoint) async throws -> [T] where T: ABFirebaseCodable
    
    /// Perform an operation (e.g., post, update, delete) on Firestore.
    static func request(for endPoint: ABFireStoreEndPoint) async throws
}

/// Implementation of the Firestore Database Service protocol.
@available(iOS 13.0, *)
public class ABFireStoreDatabaseService: ABFireStoreDatabaseServiceProtocol {
    
    /// Fetch a single document from Firestore, decode it into a model of type `T`, and return it.
    /// - Parameters:
    ///   - endPoint: The `ABFireStoreEndPoint` specifying the Firestore path and request method.
    /// - Returns: A decoded model of type `T`.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    public static func request<T>(for endPoint: ABFireStoreEndPoint) async throws -> T where T: ABFirebaseCodable {
        // Ensure the endpoint path is a valid Firestore DocumentReference.
        guard let refrance = endPoint.path as? DocumentReference else {
            throw ABFireBaseError.documentNotFound
        }
        switch endPoint.method {
        case .get:
            // Attempt to fetch the document.
            guard let documentSnapshot = try? await refrance.getDocument() else {
                throw ABFireBaseError.invalidPath
            }
            // Ensure the document has data.
            guard let documentData = documentSnapshot.data() else {
                throw ABFireBaseError.parseError
            }
            // Parse the document data into the expected model type `T`.
            let singleResponse: T = try ABParser.parse(documentData)
            return singleResponse
        default:
            throw ABFireBaseError.invalidRequest
        }
    }
    
    /// Fetch a collection of documents from Firestore, decode them into models of type `[T]`, and return them.
    /// - Parameters:
    ///   - endPoint: The `ABFireStoreEndPoint` specifying the Firestore path and request method.
    /// - Returns: An array of decoded models of type `[T]`.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    public static func request<T>(for endPoint: ABFireStoreEndPoint) async throws -> [T] where T: ABFirebaseCodable {
        // Ensure the endpoint path is a valid Firestore Query.
        guard let refrance = endPoint.path as? Query else {
            throw ABFireBaseError.collectionNotFound
        }
        switch endPoint.method {
        case .get:
            // Fetch the documents matching the query.
            let querySnapshot = try await refrance.getDocuments()
            var response: [T] = []
            // Parse each document into the expected model type `T`.
            for document in querySnapshot.documents {
                let data: T = try ABParser.parse(document.data())
                response.append(data)
            }
            return response
        default:
            throw ABFireBaseError.operationNotSupported
        }
    }
    
    /// Perform an operation (e.g., create, update, or delete) on a Firestore document.
    /// - Parameters:
    ///   - endPoint: The `ABFireStoreEndPoint` specifying the Firestore path, request method, and data.
    /// - Throws: An error if the operation fails.
    public static func request(for endPoint: ABFireStoreEndPoint) async throws {
        // Ensure the endpoint path is a valid Firestore DocumentReference.
        guard let refrance = endPoint.path as? DocumentReference else {
            throw ABFireBaseError.documentNotFound
        }
        switch endPoint.method {
        case .get:
            // `get` is not supported for this method.
            throw ABFireBaseError.operationNotSupported
        case var .post(model):
            // Set the document ID in the model.
            model.id = refrance.documentID
            // Create a new document with the provided data.
            try await refrance.setData(model.asDictionary())
        case let .update(model):
            // Update the document with the provided data.
            try await refrance.setData(model.asDictionary())
        case .delete:
            // Delete the document.
            try await refrance.delete()
        }
    }
}
