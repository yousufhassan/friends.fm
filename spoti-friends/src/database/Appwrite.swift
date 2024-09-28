import Foundation
import Appwrite
import JSONCodable

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
    
    
    // TODO: Add docs
    public func createDocument(databaseId: String? = nil, collectionId: String, documentId: String,
                               data: Data, permissions: [String] = []) async {
        do {
            let databaseId = databaseId ?? self.getDatabaseId()
            guard let data = remove$IdFieldFromData(data) else {
                throw AppwriteDocumentError.dataTransformationFailed
            }
            let dataJSONString = String(data: data, encoding: .utf8) as Any
            
            let response = try await self.database.createDocument(databaseId: databaseId,
                                                                  collectionId: collectionId,
                                                                  documentId: documentId,
                                                                  data: dataJSONString)
            
            // TODO: Verify a successful response
            // verifyResponse(response)
            printInfo("Created document (id=\(documentId)) in '\(collectionId)' collection.")
        } catch {
            printError("Error when trying to create Appwrite document.")
            printError("\(error)")
        }
    }
    
    public func getDocument(databaseId: String? = nil, collectionId: String, documentId: String,
                            queries: [String] = []) async -> Document<[String:AnyCodable]>? {
        do {
            let databaseId = databaseId ?? self.getDatabaseId()
            
            let document = try await self.database.getDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId, queries: queries)
            
            printInfo("Retrieved document (id=\(documentId)) from '\(collectionId)' collection.")
            return document
        } catch {
            printError("Error when trying to get Appwrite document.")
            printError("\(error)")
            return nil
        }
    }
    
    public func listDocuments(databaseId: String? = nil, collectionId: String, queries: [String] = [])
    async -> DocumentList<[String:AnyCodable]>? {
        do {
            let databaseId = databaseId ?? self.getDatabaseId()

            let documentList = try await self.database.listDocuments(
                databaseId: databaseId, collectionId: collectionId, queries: queries)
            
            printInfo("Retrieved \(documentList.total) document(s) from '\(collectionId)' collection.")
            return documentList
        } catch {
            printError("Error when trying to list Appwrite documents.")
            printError("\(error)")
            return nil
        }
    }
    
    
    // TODO: Add docs
    private func remove$IdFieldFromData(_ data: Data) -> Data? {
        if var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            jsonObject.removeValue(forKey: "$id")
            
            if let modifiedData = try? JSONSerialization.data(withJSONObject: jsonObject) {
                return modifiedData
            }
        }
        
        // TODO: Throw some error instead
        return nil
    }
    
}

enum AppwriteDocumentError: Error {
    case dataTransformationFailed
}
