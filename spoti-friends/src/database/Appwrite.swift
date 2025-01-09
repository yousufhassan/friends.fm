import Foundation
import Appwrite
import JSONCodable

/// A singleton service class for interacting with Appwrite's Client and Database.
class Appwrite {
    static let shared = Appwrite()
    private var client: Client
    private var database: Databases
    
    private let clientEndpoint = "https://cloud.appwrite.io/v1"
    private let projectId = "friends-fm"
    private let databaseId = "friends-fm"
    
    public init() {
        self.client = Client()
            .setEndpoint(clientEndpoint)
            .setProject(projectId)
        
        self.database = Databases(client)
    }
    
    /// Returns the Appwrite Client.
    public func getClient() -> Client {
        return self.client
    }
    
    /// Returns the Appwrite Database.
    public func getDatabase() -> Databases {
        return self.database
    }
    
    /// Returns the Appwrite Database ID.
    public func getDatabaseId() -> String {
        return self.databaseId
    }
    
    
    /// Creates a new document in the specified Appwrite collection.
    ///
    /// - Parameters:
    ///   - databaseId: Optional. The database ID. If nil, the default database ID is used.
    ///   - collectionId: The ID of the collection where the document will be created.
    ///   - documentId: Optional. The ID of the document to create. If not passed in, a random ID will be assigned.
    ///   - data: The `Data` object representing the document content.
    ///   - permissions: Optional. A list of permissions to assign to the document.
    ///
    /// - Throws: Throws an error if the document creation fails.
    ///
    /// This method creates a document in the specified collection, ensuring that the `$id` field is removed from the data object
    /// before sending the request to the server because that needs to be passed in as the `documentId` and not part of `data`.
    public func createDocument(databaseId: String? = nil, collectionId: String,
                               documentId: String = ID.unique(), data: Data, permissions: [String]? = nil) async throws {
        do {
            let databaseId = databaseId ?? self.getDatabaseId()
            let data = try remove$IdFieldFromData(data)
            
            let dataJSONString = String(data: data, encoding: .utf8) as Any
            let _ = try await self.database.createDocument(databaseId: databaseId,
                                                           collectionId: collectionId,
                                                           documentId: documentId,
                                                           data: dataJSONString,
                                                           permissions: permissions)
            
            printInfo("Created document (id=\(documentId)) in '\(collectionId)' collection.")
        } catch {
            printError("Error when trying to create Appwrite document: \(error)")
            throw error
        }
    }
    
    /// Updates the specified document in the specified Appwrite collection.
    ///
    /// - Parameters:
    ///   - databaseId: Optional. The database ID. If nil, the default database ID is used.
    ///   - collectionId: The ID of the collection where the document will be created.
    ///   - documentId: The ID of the document to create.
    ///   - data: The `Data` object representing the document content.
    ///   - permissions: Optional. A list of permissions to assign to the document.
    ///
    /// - Throws: Throws an error if the document creation fails.
    ///
    /// This method updates a document in the specified collection, ensuring that the `$id` field is removed from the data object
    /// before sending the request to the server because that needs to be passed in as the `documentId` and not part of `data`.
    public func updateDocument(databaseId: String? = nil, collectionId: String, documentId: String,
                               data: Data, permissions: [String]? = nil) async throws {
        do {
            let databaseId = databaseId ?? self.getDatabaseId()
            let data = try remove$IdFieldFromData(data)
            
            let dataJSONString = String(data: data, encoding: .utf8) as Any
            let _ = try await self.database.updateDocument(databaseId: databaseId,
                                                           collectionId: collectionId,
                                                           documentId: documentId,
                                                           data: dataJSONString,
                                                           permissions: permissions)
            
            printInfo("Updated document (id=\(documentId)) in '\(collectionId)' collection.")
        } catch {
            printError("Error when trying to update Appwrite document: \(error)")
            throw error
        }
    }
    
    /// Fetches a single document from the specified Appwrite collection using the specified document ID and query filters.
    ///
    /// - Parameters:
    ///   - databaseId: Optional. The database ID. If nil, the default database ID is used.
    ///   - collectionId: The ID of the collection to fetch the document from.
    ///   - documentId: The ID of the document to fetch.
    ///   - queries: Optional. A list of queries to filter the document request.
    ///
    /// - Returns: A `Document` object containing the document data, or `nil` if the request fails.
    public func getDocument(databaseId: String? = nil, collectionId: String, documentId: String,
                            queries: [String] = []) async -> Document<[String:AnyCodable]>? {
        do {
            let databaseId = databaseId ?? self.databaseId
            
            let document = try await self.database.getDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId, queries: queries)
            
            printInfo("Retrieved document (id=\(documentId)) from '\(collectionId)' collection.")
            return document
        } catch {
            printError("Error when trying to get Appwrite document: \(error)")
            return nil
        }
    }
    
    /// Fetches a list of documents from the specified Appwrite collection based on the provided query filters.
    ///
    /// - Parameters:
    ///   - databaseId: Optional. The database ID. If nil, the default database ID is used.
    ///   - collectionId: The ID of the collection to list documents from.
    ///   - queries: Optional. A list of queries to filter the document results.
    ///
    /// - Returns: A `DocumentList` containing the documents matching the query, or `nil` if the request fails.
    public func listDocuments(databaseId: String? = nil, collectionId: String, queries: [String] = [])
    async -> DocumentList<[String:AnyCodable]>? {
        do {
            let databaseId = databaseId ?? self.getDatabaseId()
            
            let documentList = try await self.database.listDocuments(
                databaseId: databaseId, collectionId: collectionId, queries: queries)
            
            printInfo("Retrieved \(documentList.total) document(s) from '\(collectionId)' collection.")
            return documentList
        } catch {
            printError("Error when trying to list Appwrite documents: \(error)")
            return nil
        }
    }
    
    /// Deletes a document in the specified Appwrite collection.
    ///
    /// - Parameters:
    ///   - databaseId: Optional. The database ID. If nil, the default database ID is used.
    ///   - collectionId: The ID of the collection where the document will be created.
    ///   - documentId: The ID of the document to create. If not passed in, a random ID will be assigned.
    ///
    /// - Throws: Throws an error if the document creation fails.
    public func deleteDocument(databaseId: String? = nil, collectionId: String, documentId: String)
    async throws {
        do {
            let databaseId = databaseId ?? self.getDatabaseId()
            let _ = try await self.database.deleteDocument(databaseId: databaseId,
                                                           collectionId: collectionId,
                                                           documentId: documentId)
            
            printInfo("Deleted document (id=\(documentId)) from '\(collectionId)' collection.")
        } catch {
            printError("Error when trying to delete Appwrite document: \(error)")
            throw error
        }
    }
    
    /// Removes the `$id` field from the provided document data.
    ///
    /// - Parameter data: The `Data` object representing the document.
    /// - Returns: The modified `Data` object without the `$id` field, or `nil` if an error occurs.
    ///
    /// This private method removes the `$id` field from the given JSON-encoded `Data` object.
    /// It is useful for ensuring that the ID field doesn't conflict during document creation.
    private func remove$IdFieldFromData(_ data: Data) throws -> Data {
        if var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            jsonObject.removeValue(forKey: "$id")
            
            if let modifiedData = try? JSONSerialization.data(withJSONObject: jsonObject) {
                return modifiedData
            }
        }
        
        throw AppwriteDatabaseError.dataTransformationFailed
    }
}

enum AppwriteDatabaseError: Error {
    case dataTransformationFailed
}
