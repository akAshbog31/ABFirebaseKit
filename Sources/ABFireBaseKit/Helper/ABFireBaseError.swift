import Foundation

// MARK: - ABFireBaseError Enum

/// Enum representing various errors that can occur while interacting with Firebase.
public enum ABFireBaseError: Error {
    case invalidPath               // Error for an invalid or non-existent path.
    case invalidType               // Error for mismatched data types.
    case collectionNotFound        // Error for a missing collection.
    case documentNotFound          // Error for a missing document.
    case referenceNotFound         // Error for a missing reference.
    case unknownError              // Error for an unknown issue.
    case parseError                // Error for data parsing failures.
    case invalidRequest            // Error for malformed or invalid requests.
    case operationNotSupported     // Error for unsupported operations.
    case invalidQuery              // Error for invalid query syntax.
    case operationNotAllowed       // Error for restricted operations.
}

// MARK: - LocalizedError Conformance

/// Extension to provide localized error descriptions, reasons, and recovery suggestions for `ABFireBaseError`.
extension ABFireBaseError: LocalizedError {
    
    // MARK: - Error Description
    
    /// A user-friendly description of the error.
    public var errorDescription: String? {
        switch self {
        case .invalidPath:
            return NSLocalizedString("Path not found.", comment: "Invalid Path Error")
        case .invalidType:
            return NSLocalizedString("Invalid type.", comment: "Invalid Type Error")
        case .collectionNotFound:
            return NSLocalizedString("Collection not found.", comment: "Collection Not Found Error")
        case .documentNotFound:
            return NSLocalizedString("Document not found.", comment: "Document Not Found Error")
        case .referenceNotFound:
            return NSLocalizedString("Reference not found.", comment: "Reference Not Found Error")
        case .unknownError:
            return NSLocalizedString("Unknown error.", comment: "Unknown Error")
        case .parseError:
            return NSLocalizedString("Data did not parse.", comment: "Parse Error")
        case .invalidRequest:
            return NSLocalizedString("Request is invalid.", comment: "Invalid Request Error")
        case .operationNotSupported:
            return NSLocalizedString("Operation not supported.", comment: "Operation Not Supported Error")
        case .invalidQuery:
            return NSLocalizedString("Query is not valid.", comment: "Invalid Query Error")
        case .operationNotAllowed:
            return NSLocalizedString("Operation not allowed.", comment: "Operation Not Allowed Error")
        }
    }
    
    // MARK: - Failure Reason
    
    /// A localized explanation of why the error occurred.
    public var failureReason: String? {
        switch self {
        case .invalidPath:
            return NSLocalizedString("The specified path is invalid or does not exist.", comment: "Failure Reason for Invalid Path")
        case .invalidType:
            return NSLocalizedString("The data type does not match the expected type.", comment: "Failure Reason for Invalid Type")
        case .collectionNotFound:
            return NSLocalizedString("The requested collection could not be found.", comment: "Failure Reason for Collection Not Found")
        case .documentNotFound:
            return NSLocalizedString("The requested document could not be found.", comment: "Failure Reason for Document Not Found")
        case .referenceNotFound:
            return NSLocalizedString("The requested reference could not be found.", comment: "Failure Reason for Reference Not Found")
        case .unknownError:
            return NSLocalizedString("An unexpected error occurred.", comment: "Failure Reason for Unknown Error")
        case .parseError:
            return NSLocalizedString("Failed to parse the data into the expected format.", comment: "Failure Reason for Parse Error")
        case .invalidRequest:
            return NSLocalizedString("The request is invalid or malformed.", comment: "Failure Reason for Invalid Request")
        case .operationNotSupported:
            return NSLocalizedString("The requested operation is not supported by the current setup.", comment: "Failure Reason for Unsupported Operation")
        case .invalidQuery:
            return NSLocalizedString("The query provided is invalid or malformed.", comment: "Failure Reason for Invalid Query")
        case .operationNotAllowed:
            return NSLocalizedString("The operation is not allowed due to configuration or policy restrictions.", comment: "Failure Reason for Operation Not Allowed")
        }
    }
    
    // MARK: - Recovery Suggestion
    
    /// A localized suggestion for how to recover from the error.
    public var recoverySuggestion: String? {
        switch self {
        case .invalidPath:
            return NSLocalizedString("Check the path for typos or verify that it exists.", comment: "Recovery Suggestion for Invalid Path")
        case .invalidType:
            return NSLocalizedString("Ensure the data type matches the expected type.", comment: "Recovery Suggestion for Invalid Type")
        case .collectionNotFound:
            return NSLocalizedString("Verify that the collection exists and the path is correct.", comment: "Recovery Suggestion for Collection Not Found")
        case .documentNotFound:
            return NSLocalizedString("Ensure the document exists in the specified collection.", comment: "Recovery Suggestion for Document Not Found")
        case .referenceNotFound:
            return NSLocalizedString("Check the reference path for correctness.", comment: "Recovery Suggestion for Reference Not Found")
        case .unknownError:
            return NSLocalizedString("Try again or contact support for assistance.", comment: "Recovery Suggestion for Unknown Error")
        case .parseError:
            return NSLocalizedString("Verify the data format matches the expected structure.", comment: "Recovery Suggestion for Parse Error")
        case .invalidRequest:
            return NSLocalizedString("Review the request and ensure it meets all required criteria.", comment: "Recovery Suggestion for Invalid Request")
        case .operationNotSupported:
            return NSLocalizedString("Consider alternative methods or consult the documentation.", comment: "Recovery Suggestion for Unsupported Operation")
        case .invalidQuery:
            return NSLocalizedString("Check the query syntax and ensure it adheres to the API guidelines.", comment: "Recovery Suggestion for Invalid Query")
        case .operationNotAllowed:
            return NSLocalizedString("Verify your configuration or permissions and try again.", comment: "Recovery Suggestion for Operation Not Allowed")
        }
    }
}
