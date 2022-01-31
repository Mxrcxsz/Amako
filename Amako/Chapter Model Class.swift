//
//  ChapterModel Model Class.swift
//  Amako
//
//  Created by Khim Chua on 1/2/22.
//

import Foundation

// MARK: - ChapterRootObject
struct ChapterRootObject: Codable {
    let data: [ChapterModel]
    let limit, offset, total: Int
}

// MARK: ChapterRootObject convenience initializers and mutators

extension ChapterRootObject {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ChapterRootObject.self, from: data)
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
        result: String? = nil,
        data: [ChapterModel]? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        total: Int? = nil
    ) -> ChapterRootObject {
        return ChapterRootObject(
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

// MARK: - ChapterModel
struct ChapterModel: Codable {
    let id: String
    let attributes: ChapterAttributes
}

// MARK: ChapterModel convenience initializers and mutators

extension ChapterModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ChapterModel.self, from: data)
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
        attributes: ChapterAttributes? = nil
    ) -> ChapterModel {
        return ChapterModel(
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

// MARK: - ChapterAttributes
struct ChapterAttributes: Codable {
    let volume, chapter, title: String
    let publishAt, readableAt, createdAt, updatedAt: Date
    let pages, version: Int

    enum CodingKeys: String, CodingKey {
        case volume, chapter, title
        case publishAt, readableAt, createdAt, updatedAt, pages, version
    }
}

// MARK: ChapterAttributes convenience initializers and mutators

extension ChapterAttributes {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ChapterAttributes.self, from: data)
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
        volume: String? = nil,
        chapter: String? = nil,
        title: String? = nil,
        publishAt: Date? = nil,
        readableAt: Date? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        pages: Int? = nil,
        version: Int? = nil
    ) -> ChapterAttributes {
        return ChapterAttributes(
            volume: volume ?? self.volume,
            chapter: chapter ?? self.chapter,
            title: title ?? self.title,
            publishAt: publishAt ?? self.publishAt,
            readableAt: readableAt ?? self.readableAt,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            pages: pages ?? self.pages,
            version: version ?? self.version
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
