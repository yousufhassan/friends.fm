import Foundation
import Appwrite

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
    
    
    public func createDocument(databaseId: String? = nil, collectionId: String, documentId: String,
                               data: Data, permissions: [String] = []) async {
        do {
            // Use "friends-fm" as the databaseId unless otherwise passed in
            let databaseId = databaseId ?? self.databaseId
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
            printInfo("Document created.")
        } catch {
            printError("Error when trying to create Appwrite document.")
            printError("\(error)")
        }
    }
    
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
