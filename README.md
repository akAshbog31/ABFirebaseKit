# ABFireBaseKit

**ABFireBaseKit** is a Swift package that provides a convenient wrapper around Firebase services, specifically focusing on Authentication, Realtime Database, and Firestore operations. This package simplifies Firebase integration and provides a protocol-oriented approach to handling Firebase operations.

---

## Features

- 📊 **Realtime Database CRUD Operations**
- 📚 **Cloud Firestore Support**
- 🔄 **Flexible Database Switching**
- 🧩 **Protocol-Oriented Architecture**
- ⚡ **Async/Await Support**
- 💡 **Type-Safe Database Operations**

---

## Installation

### Add ABFireBaseKit to Your Project Using Swift Package Manager

In your `Package.swift`, add the following dependency:

```swift
dependencies: [
    .package(url: "https://github.com/akAshbog31/ABFirebaseKit.git", from: "1.0.0")
]
```

## Requirements

- iOS 13.0+
- Swift 5.5+
- Firebase SDK
- Xcode 13.0+

## Usage
1. Firebase Services Protocol
The package defines a protocol for Firebase operations:

```
protocol FireBaseServices {
    func signUp(with email: String, password: String) async throws -> UserModel
    func signIn(with email: String, password: String) async throws
    func createUser(for model: UserModel) async throws
    func getUser(for id: String) async throws -> UserModel
    func getAllUser() async throws -> [UserModel]
    func getUserName(handler: @escaping (Result<[String: Any], Error>) -> Void)
}
```

2. Firebase Manager Implementation

```
let firebaseManager = FireBaseManager()

// Sign up a new user
do {
    let user = try await firebaseManager.signUp(with: "email@example.com", password: "password")
    // Handle successful sign up
} catch {
    // Handle error
}

// Sign in
do {
    try await firebaseManager.signIn(with: "email@example.com", password: "password")
    // Handle successful sign in
} catch {
    // Handle error
}

// Create user in database
let userModel = UserModel(id: "uniqueId", name: "John Doe", email: "john@example.com", createdAt: Date().formatted())
try await firebaseManager.createUser(for: userModel)
```

3. Database Operations
The package uses an enum-based approach for database operations:

```
enum DataBase {
    case createUser(user: UserModel)
    case getUser(id: String)
    case getAllUser
    case getUserName(id: String)
}
```

4. Database Extensions
The package provides flexible database implementations through extensions. You can choose between Realtime Database and Firestore by implementing the appropriate extension.
Realtime Database Implementation

```
extension DataBase: ABRealtimeEndPoint {
    var path: ABRealtimeDatabaseReference {
        switch self {
        case let .createUser(user):
            return database.reference().child("Users/\(user.id)")
        case let .getUser(id):
            return database.reference().child("Users/\(id)")
        case .getAllUser:
            return database.reference().child("Users").queryLimited(toFirst: 1)
        case let .getUserName(id):
            return database.reference().child("Users/\(id)")
        }
    }
    
    var method: ABFirebaseMethod {
        switch self {
        case let .createUser(user):
            return .post(user)
        case .getUser, .getAllUser, .getUserName:
            return .get
        }
    }
}
```

## Firestore Implementation

```
extension DataBase: ABFireStoreEndPoint {
    var path: ABFirestoreReference {
        switch self {
        case let .createUser(user):
            return firestore.collection(CollectionType.user.rawValue.uppercased()).document(user.id)
        case let .getUser(id):
            return firestore.collection(CollectionType.user.rawValue.uppercased()).document(id)
        case .getAllUser:
            return firestore.collection(CollectionType.user.rawValue.uppercased())
        }
    }
    
    var method: FirebaseMethod {
        switch self {
        case let .createUser(user):
            return .post(user)
        case .getUser, .getAllUser:
            return .get
        }
    }
}
```

5. Collection Types
Define your collections using an enum:

```
enum CollectionType: String {
    case user
}
```

6. User Model
Define your user model conforming to `ABFirebaseCodable`:

```
struct UserModel: ABFirebaseCodable {
    var id: String
    var name: String?
    var email: String?
    var createdAt: String
}
```

## Database Path Structure
#### Realtime Database

Users: `Users/<userId>`
User Details: `Users/<userId>/<field>`

## Firestore
Collection: `USER`
Documents: `<userId>`

**Switching Between Databases**
To switch between Realtime Database and Firestore:

Use the appropriate extension (`ABRealtimeEndPoint` or `ABFireStoreEndPoint`)
Update your Firebase configuration
Use the corresponding service class (`ABRealtimeDatabaseService` or `ABFirestoreService`)

## Example:

```
// For Realtime Database
try await ABRealtimeDatabaseService.request(for: DataBase.createUser(user: model))

// For Firestore
try await FirestoreService.request(for: DataBase.createUser(user: model))
```

## Error Handling
The package uses Swift's built-in error handling mechanisms. All async operations can throw errors that should be handled appropriately in your implementation.

## Best Practices
- Always handle authentication states
- Implement proper error handling
- Follow Firebase security rules
- Keep user data minimal and relevant
- Use appropriate database indexing
- Choose the appropriate database type based on your use case:

**Realtime Database:** Better for real-time sync and simpler data
**Firestore:** Better for complex queries and larger scale applications

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## Author
Akash Boghani

## Support
For support, please create an issue in the repository or contact akashboghani111@gmail.com.
