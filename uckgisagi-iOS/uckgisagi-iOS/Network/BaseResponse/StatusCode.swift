//
//  StatusCode.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

/*
OK(200),
CREATED(201),
ACCEPTED(202),
NO_CONTENT(204)
BAD_REQUEST(400),
UNAUTHORIZED(401),
FORBIDDEN(403),
NOT_FOUND(404),
METHOD_NOT_ALLOWED(405),
NOT_ACCEPTABLE(406),
CONFLICT(409),
UNSUPPORTED_MEDIA_TYPE(415),
INTERNAL_SERVER(500),
BAD_GATEWAY(502),
SERVICE_UNAVAILABLE(503)
 */

enum StatusCode: String, Decodable {
    case okay = "OK"
    case created = "CREATED"
    case accepted = "ACCEPTED"
    case noContent = "NO_CONTENT"
    case badRequest = "BAD_REQUEST"
    case unAuthorized = "UNAUTHORIZED"
    case forbidden = "FORBIDDEN"
    case notFound = "NOT_FOUND"
    case methodNotAllowed = "METHOD_NOT_ALLOWED"
    case notAcceptable = "NOT_ACCEPTABLE"
    case conflict = "CONFLICT"
    case unsupportedMediaType = "UNSUPPORTED_MEDIA_TYPE"
    case internalSever = "INTERNAL_SERVER"
    case badGateway = "BAD_GATEWAY"
    case serviceUnavailable = "SERVICE_UNAVAILABLE"
    case notDefined = "NOT_DEFINED_CLIENT_ERROR"

    init(_ statusCode: Int) {
        switch statusCode {
        case 200: self = .okay
        case 201: self = .created
        case 202: self = .noContent
        case 204: self = .noContent
        case 400: self = .badRequest
        case 401: self = .unAuthorized
        case 404: self = .notFound
        case 405: self = .methodNotAllowed
        case 406: self = .notAcceptable
        case 409: self = .conflict
        case 415: self = .unsupportedMediaType
        case 500: self = .internalSever
        case 502: self = .badRequest
        case 503: self = .serviceUnavailable
        default : self = .notDefined
        }
    }
}
