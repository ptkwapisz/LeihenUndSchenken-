//
//  Extention.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 03.05.23.
//
//


import SwiftUI
import Foundation

// Diese Erweiterung endcodiert Image-String in ein Image
// Benutzung: Image(base64Str: imgString)
extension Image {
    init?(base64Str: String) {
        guard let data = Data(base64Encoded: base64Str) else { return nil }
        guard let uiImg = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImg)
    } // Ende init
} // Ende extension

// Diese Extention entfernt in einem Array alle Duplicate
// Benutzung: array.unique()
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    } // Ende func unique
} // Ende extensiopn

// Diese Erweiterung ermöglicht die genaue Bildschirmbreite zu ermitteln.
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
} // Ende Extension

// Diese Extension ist notwändig, um in ContentVie folgende Einstellungen zu machn:
// Ausschalten des Dark-Modus für die App
//.preferredColorScheme(.light)
// Das setzt die dynamische Taxtgrösse auf .large.
//.dynamicTypeSize(.large)
extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        } // Ende else
    } // Ende some View
} // Ende extension


// Diese Extension wird für Längeneinschränkung beim TextField benutzt
// In der View ShapeViewAddGegenstand
extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }// Ende DispatchQueue
        } // Ende limit
        return self
    } // Ende Self
} // Ende Extension

// Diese Erweiterung wird benutzt, um zu ermitteln, wie oft ein bestimmtes Zeichen in einem String vorkommt.
extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    } // Ende func
} // Ende extension

// Das ist die extension für erfassung des lokalen Speicherplatzes
// Die benutzung:
// print(UIDevice.current.freeDiskSpaceInGB)
// print(UIDevice.current.usedDiskSpaceInGB)
extension UIDevice {
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    } // Ende func
    
    //MARK: Get String Value
    var totalDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    } // Ende var
    
    var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    } // Ende var
    
    var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    } // Ende var
    
    var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    } // Ende var
    
    var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    } // Ende var
    
    var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    } // Ende var
    
    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    } // Ende var
    
    var freeDiskSpaceInBytes:Int64 {
        /*
         if #available(iOS 11.0, *) {
         if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
         return space // ?? 0
         } else {
         return 0
         } // Ende if/else
         } else {
         */
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
           let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
            return freeSpace
        } else {
            return 0
        }// Ende if/else
        //} // Ende if/else
    } // Ende var
    
    var usedDiskSpaceInBytes:Int64 {
        return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    } // Ende var
    
} // Ende extension


// Das ist die Extension für die getFileSitze funktion
extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        } // Ende catch
        return nil
    } // Ende var
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    } // Ende var
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }// Ende var
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    } // Ende var
} // Ende extension URL


// Diese erweiterung erlaub einen .if Modyfier
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }// Ende if/else
    } // Ende view
}// Ende extension

// Diese Erwiterung erlaubt if/else für nutzung eines Modifiers
// How to use:
// .applyIf( Bedienung, apply: {$0.sheet() {} ...}, else: {$0.sheet() {}} )
extension View {
    @ViewBuilder
    func applyIf<T: View, U: View>(
        _ condition: Bool,
        apply: (Self) -> T,
        else: (Self) -> U
    ) -> some View {
        if condition {
            apply(self)
        } else {
            `else`(self)
        } // Ende if/else
    } // Ende some View
} // Ende View


// Diese erweiterung erlaubt if für nutzung eines Modifiers
// How to use:
//.applyModifier(Bedinung){$0.modifier}
extension View {
    @ViewBuilder
    func applyModifier<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}
