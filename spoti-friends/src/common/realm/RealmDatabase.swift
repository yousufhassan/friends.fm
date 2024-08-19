import Foundation
import RealmSwift

/// Singleton class for performing Realm database operations.
class RealmDatabase {
    static let shared: RealmDatabase = RealmDatabase()
    private let realm: Realm
    private let schemaVersion: UInt64 = 19  // Increment this when making schema changes
    
    init() {
        // Use this configuration when opening realms
        let config = Realm.Configuration(schemaVersion: self.schemaVersion)
        Realm.Configuration.defaultConfiguration = config
        self.realm = try! Realm()
        
        // For debugging
        // printRealmOnDeviceLocation()
    }
    
    /// Returns the Realm instance.
    public func getRealmInstance() -> Realm {
        // TODO: Replace this to verify if functionality still works. If so, delete `realm` property on object.
        // return try! Realm()
        return self.realm
    }
    
    /// Adds the `object` to the Realm.
    @MainActor public func addToRealm(object: Object) async -> Void {
            try! self.realm.write {
                self.realm.add(object)
            }
    }
    
    public func updateObjectInRealm(updateFunction: @escaping () -> Void) -> Void {
        try! self.realm.write {
            updateFunction()
        }
    }
    
    /// Prints the location where the Realm is stored on the device.
    private func printRealmOnDeviceLocation() -> Void {
        printInfo("User Realm User file location is \(self.realm.configuration.fileURL!.path)")
    }
}
