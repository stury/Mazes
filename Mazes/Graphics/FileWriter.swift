//
//  FileWriter.swift
//  Plant
//
//  Created by Scott Tury on 10/2/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import Foundation

class FileWriter {
    let additionalDirectory : String
    private let basicPath : String
    private let computedPath : String
    private let directory: FileManager.SearchPathDirectory
    private let domainMask: FileManager.SearchPathDomainMask
    
    init( directory: FileManager.SearchPathDirectory = .documentDirectory, domainMask: FileManager.SearchPathDomainMask = .userDomainMask, additionalOutputDirectory: String?) throws {
        
        self.directory = directory
        self.domainMask = domainMask

        self.basicPath = NSSearchPathForDirectoriesInDomains(self.directory, self.domainMask, true)[0]
        if let additionalOutputDirectory = additionalOutputDirectory {
            self.additionalDirectory = additionalOutputDirectory
        }
        else {
            self.additionalDirectory = ""
        }
        
        // Ok, maybe I should do this in another method, but I want to generate the basic path once,
        // and be able to use it over and over again without running through the same code.
        // Plus we need to initialize all of our variables right here in the init!
        if additionalDirectory.count > 0 {
            computedPath = "\(basicPath)/\(additionalDirectory)"
            
            // Check to see if the directory exists already, and if not, create it!
            let fileManager = FileManager.default
            var isDirectory : ObjCBool = true
            if !fileManager.fileExists(atPath: computedPath, isDirectory: &isDirectory ) {
                do {
                    try fileManager.createDirectory(atPath: computedPath, withIntermediateDirectories: true)
                }
                catch {
                    print( error )
                    throw error
                }
            }
         }
        else {
            self.computedPath = basicPath
        }
    }
    
    convenience init(_ additionalOutputDirectory: String? = nil) throws {
        do {
            try self.init(directory: .documentDirectory, domainMask: .userDomainMask, additionalOutputDirectory: additionalOutputDirectory)
        }
        catch {
            throw error
        }
    }
    
    // MARK: - Writing

    public func export(fileType: String, name: String = "maze", data: Data?) {
        
        if let documentURL = URL(string: "\(name).\(fileType)", relativeTo: URL(fileURLWithPath: computedPath)) {
            self.write(documentURL, data: data)
        }
    }

    /// Just a helper method to write a data blob out to the disk
    public func write( _ url:URL, data: Data? ) {
        if let fileData = data {
            do {
                try fileData.write(to: url)
                print( "Wrote file to \(url)" )
            }
            catch {
                print( "ERROR when writing data out to disk.  \(error)" )
            }
        }
    }
    /// Just a helper method to write a data blob out to the disk
    public func write( _ path:String, data: Data? ) {
        write(URL(fileURLWithPath: path), data: data)
    }
    
    /// Simple method to write the data out asyncronously.
    public func asyncWrite( _ url: URL, data: Data?, completion: @escaping (()->Void) ) {
        DispatchQueue.global().async { [weak self] in
            if let strongSelf = self {
                strongSelf.write(url, data: data)
                completion()
            }
        }
    }
    
    /// Simple method to write the data out asyncronously.
    public func asyncWrite( _ path: String, data: Data?, completion: @escaping (()->Void) ) {
        asyncWrite(URL(fileURLWithPath: path), data: data, completion: completion)
    }
    
}

extension FileWriter {
    /// Convienience method for writing an image out, using the ImageRenderEnum as the extension of the filename.
    public func export(type: ImageRenderEnum, name: String = "maze", data: Data?) {
                export(fileType: type.rawValue, name: name, data: data)
    }
}
