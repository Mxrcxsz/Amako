//
//  Manga.swift
//  MAD2_ASG
//
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseWelcome { response in
//     if let welcome = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire
// MARK: - Welcome
struct Root: Codable {
    let result, response: String
    let data: [Result]
    let limit, offset, total: Int
}

// MARK: - Datum
struct Result: Codable {
    let id, type: String
    let attributes: MangaDetails
}


// MARK: - Manga
struct MangaDetails: Codable {
    let title: Title
    let attributesDescription: Description
    let originalLanguage, lastVolume, lastChapter: String
    let status: String
    let year: Int
    let contentRating: String
    let state: String
    let chapterNumbersResetOnNewVolume: Bool
    let createdAt, updatedAt: Date
    let version: Int

    enum CodingKeys: String, CodingKey {
        case title
        case attributesDescription = "description"
        case originalLanguage, lastVolume, lastChapter, status, year, contentRating, state, chapterNumbersResetOnNewVolume, createdAt, updatedAt, version
    }
}

// MARK: - Description
struct Description: Codable {
    let en: String
}

// MARK: - Title
struct Title: Codable {
    let en: String
}

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

// MARK: - Alamofire response handlers

//extension DataRequest {
//    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
//        return DataResponseSerializer { _, response, data, error in
//            guard error == nil else { return .failure(error!) }
//
//            guard let data = data else {
//                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
//            }
//
//            return Result { try newJSONDecoder().decode(T.self, from: data) }
//        }
//    }
//
//    @discardableResult
//    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
//    }
//
//    @discardableResult
//    func responseWelcome(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Welcome>) -> Void) -> Self {
//        return responseDecodable(queue: queue, completionHandler: completionHandler)
//    }
//}
