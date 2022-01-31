//
//  MangaModel Modal Class.swift
//  Amako
//
//  Created by Khim Chua on 31/1/22.
//

import Foundation

// MARK: - MangaRootObject
struct MangaRootObject: Codable {
    let data: [MangaModel]
    let limit, offset, total: Int
}

// MARK: MangaRootObject convenience initializers and mutators

extension MangaRootObject {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MangaRootObject.self, from: data)
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
        data: [MangaModel]? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        total: Int? = nil
    ) -> MangaRootObject {
        return MangaRootObject(
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

// MARK: - MangaModel
struct MangaModel: Codable {
    let id: String
    let attributes: MangaAttributes
}

// MARK: MangaModel convenience initializers and mutators

extension MangaModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MangaModel.self, from: data)
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
        attributes: MangaAttributes? = nil
    ) -> MangaModel {
        return MangaModel(
            id: id ?? self.id,
            attributes: attributes ?? self.attributes
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - MangaAttributes
struct MangaAttributes: Codable {
    let title: Title
//    let description: Description?
    let status: Status

    enum CodingKeys: String, CodingKey {
        case title
        case status
    }
}

// MARK: MangaAttributes convenience initializers and mutators

extension MangaAttributes {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MangaAttributes.self, from: data)
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
        title: Title? = nil,
//        description: Description? = nil,
        status: Status? = nil
    ) -> MangaAttributes {
        return MangaAttributes(
            title: title ?? self.title,
//            description: description ?? self.description,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Description
struct Description: Codable {
    let en: String
}

// MARK: Description convenience initializers and mutators

extension Description {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Description.self, from: data)
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
        en: String? = nil
    ) -> Description {
        return Description(
            en: en ?? self.en
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


enum Status: String, Codable {
    case completed = "completed"
    case ongoing = "ongoing"
    case hiatus = "hiatus"
    case cancelled = "cancelled"
}

// MARK: - Title
struct Title: Codable {
    let en: String
}

// MARK: Title convenience initializers and mutators

extension Title {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Title.self, from: data)
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
        en: String? = nil
    ) -> Title {
        return Title(
            en: en ?? self.en
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
