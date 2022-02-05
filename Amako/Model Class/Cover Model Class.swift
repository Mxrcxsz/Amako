//
//  Modal Class.swift
//  Amako
//
//  Created by Khim Chua on 28/1/22.
//

import Foundation

// MARK: - Welcome
struct CoverRootObject: Codable {
//    let result, response: String
    let data: [CoverArt]
    let limit, offset, total: Int
}

// MARK: CoverRootObject convenience initializers and mutators

extension CoverRootObject {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CoverRootObject.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        data: [CoverArt]? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        total: Int? = nil
    ) -> CoverRootObject {
        return CoverRootObject(
            data: data ?? self.data,
            limit: limit ?? self.limit,
            offset: offset ?? self.offset,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Datum
struct CoverArt: Codable {
    let id: String
    let attributes: Attributes
    let relationships: [Relationship]
}

// MARK: CoverArt convenience initializers and mutators

extension CoverArt {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CoverArt.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String? = nil,
        attributes: Attributes? = nil,
        relationships: [Relationship]? = nil
    ) -> CoverArt {
        return CoverArt(
            id: id ?? self.id,
            attributes: attributes ?? self.attributes,
            relationships: relationships ?? self.relationships
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Attributes
struct Attributes: Codable {
    let fileName: String

    enum CodingKeys: String, CodingKey {
        case fileName
    }
}

// MARK: Attributes convenience initializers and mutators

extension Attributes {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Attributes.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        fileName: String? = nil
    ) -> Attributes {
        return Attributes(
            fileName: fileName ?? self.fileName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Relationship
struct Relationship: Codable {
    let id: String
}

// MARK: Relationship convenience initializers and mutators

extension Relationship {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Relationship.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String? = nil
    ) -> Relationship {
        return Relationship(
            id: id ?? self.id
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
