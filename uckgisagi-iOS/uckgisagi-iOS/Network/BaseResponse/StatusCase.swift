//
//  StatusCase.swift
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

enum StatusCase: String, Decodable {
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
}
