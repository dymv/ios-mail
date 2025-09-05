import Foundation
import Combine
import EventKit

// MARK: - Public ICal models (stubs)

public struct ICalAddress {
    public let id: String
    public let email: String
    public let order: Int
    public let send: Bool
    public init(id: String, email: String, order: Int, send: Bool) {
        self.id = id
        self.email = email
        self.order = order
        self.send = send
    }
    public init(id: String, email: String, order: Int, send: Int) {
        self.init(id: id, email: email, order: order, send: send != 0)
    }
}

public struct ICalAttendeeData {
    public let eventID: String
    public let status: String
    public let token: Int
    public let comment: String?
    public init(eventID: String, status: String, token: Int, comment: String?) {
        self.eventID = eventID
        self.status = status
        self.token = token
        self.comment = comment
    }
    public init(eventID: String, status: Int, token: String, comment: String?) {
        self.init(eventID: eventID, status: String(status), token: Int(token) ?? 0, comment: comment)
    }
}

public struct ICalAttendee: Equatable {
    public struct User: Equatable { public var email: String; public init(email: String) { self.email = email } }
    public var user: User
    public var role: EKParticipantRole
    public var status: EKParticipantStatus
    public var token: String
    public init(user: User, role: EKParticipantRole, status: EKParticipantStatus, token: String) {
        self.user = user
        self.role = role
        self.status = status
        self.token = token
    }
}

public struct ICalRecurrence {
    public enum RepeatEveryType: Equatable { case day, week, month, year }
    public enum RepeatMonthOnIth: Equatable { case first, second, third, fourth, last }

    public var doesRepeat: Bool = false
    public var repeatEvery: Int = 1
    public var repeatEveryType: RepeatEveryType = .day
    public var repeatWeekOn: [Int]? = nil
    public var repeatMonthOnWeekDay: Int? = nil
    public var repeatMonthOnIth: RepeatMonthOnIth? = nil
    public var endsAfterNum: Int? = nil
    public var endsOnDate: Date? = nil

    public init() {}
}

public struct ICalEvent {
    public struct Location { public var title: String; public init(title: String) { self.title = title } }
    public struct RawNotification {
        public enum NotificationType { case display, email }
        public var type: NotificationType
        public var trigger: String
        public init(type: NotificationType, trigger: String) { self.type = type; self.trigger = trigger }
    }

    public var apiEventId: String = ""
    public var calendarID: String = ""
    public var title: String? = nil
    public var startDate: Date = .distantPast
    public var endDate: Date = .distantPast
    public var isAllDay: Bool = false
    public var recurrence: ICalRecurrence = .init()
    public var location: Location? = nil
    public var organizer: ICalAttendee? = nil
    public var participants: [ICalAttendee] = []
    public var status: String? = nil
    public var recurrenceID: Int? = nil

    public init() {}
}

// MARK: - Reader/Writer (stubs)

public struct ICalReaderDependecies { // note: name matches call site spelling
    public var startDate: Date
    public var startDateTimeZone: TimeZone?
    public var startDateTimeZoneIdentifier: String?
    public var endDate: Date
    public var endDateTimeZoneIdentifier: String?
    public var endDateTimeZone: TimeZone?
    public var calendarID: String
    public var localEventID: String
    public var addresses: [ICalAddress]
    public var ics: String
    public var apiEventID: String
    public var startDateCalendar: Calendar
    public var addressKeyPacket: String?
    public var sharedEventID: String?
    public var sharedKeyPacket: String?
    public var calendarKeyPacket: String?
    public var isOrganizer: Any
    public var isProtonToProtonInvitation: Any
    public var notifications: [ICalEvent.RawNotification]?
    public var lastModifiedInCoreData: Date?
    public var color: Any?

    public init(
        startDate: Date,
        startDateTimeZone: TimeZone?,
        startDateTimeZoneIdentifier: String?,
        endDate: Date,
        endDateTimeZoneIdentifier: String?,
        endDateTimeZone: TimeZone?,
        calendarID: String,
        localEventID: String,
        addresses: [ICalAddress],
        ics: String,
        apiEventID: String,
        startDateCalendar: Calendar,
        addressKeyPacket: String?,
        sharedEventID: String?,
        sharedKeyPacket: String?,
        calendarKeyPacket: String?,
        isOrganizer: Any,
        isProtonToProtonInvitation: Any,
        notifications: [ICalEvent.RawNotification]?,
        lastModifiedInCoreData: Date?,
        color: Any?
    ) {
        self.startDate = startDate
        self.startDateTimeZone = startDateTimeZone
        self.startDateTimeZoneIdentifier = startDateTimeZoneIdentifier
        self.endDate = endDate
        self.endDateTimeZoneIdentifier = endDateTimeZoneIdentifier
        self.endDateTimeZone = endDateTimeZone
        self.calendarID = calendarID
        self.localEventID = localEventID
        self.addresses = addresses
        self.ics = ics
        self.apiEventID = apiEventID
        self.startDateCalendar = startDateCalendar
        self.addressKeyPacket = addressKeyPacket
        self.sharedEventID = sharedEventID
        self.sharedKeyPacket = sharedKeyPacket
        self.calendarKeyPacket = calendarKeyPacket
        self.isOrganizer = isOrganizer
        self.isProtonToProtonInvitation = isProtonToProtonInvitation
        self.notifications = notifications
        self.lastModifiedInCoreData = lastModifiedInCoreData
        self.color = color
    }
}

public struct ICalWriter {
    public init(timestamp: @escaping () -> Date) {}
}

public struct ICalReader {
    public init(
        timeZoneProvider: TimeZoneProvider,
        currentDateProvider: @escaping () -> Date,
        icsUIDProvider: @escaping () -> String,
        iCalWriter: ICalWriter
    ) {}

    public func parse_and_merge_event_ics(old: String, new: String) -> String { new }
    public func parse_single_event_ics(dependecies: ICalReaderDependecies, attendeeData: [ICalAttendeeData]) -> ICalEvent { .init() }
}

// MARK: - Time zones info

public protocol VTimeZonesInfo {
    var timeZones: [String: String] { get }
}

public protocol VTimeZonesInfoProviding {
    func vTimeZonesInfo(timeZoneIDs: [String]) -> AnyPublisher<any VTimeZonesInfo, any Error>
}

// MARK: - TimeZone provider

public final class TimeZoneProvider {
    public init() {}
    public func timeZone(identifier: String?) -> TimeZone {
        if let id = identifier, let tz = TimeZone(identifier: id) { return tz }
        return TimeZone(secondsFromGMT: 0) ?? .current
    }
}

// MARK: - Mirror selected ICalKitWrapper API (fallbacks)

public struct icaltimetype { public init() {} }
public let ICAL_METHOD_REQUEST: Int32 = 0
public let ICAL_METHOD_CANCEL: Int32 = 1
public let ICAL_VEVENT_COMPONENT: Int32 = 0
public let ICAL_RECURRENCEID_PROPERTY: Int32 = 0
public let ICAL_TZID_PARAMETER: Int32 = 0
public func icalparser_parse_string(_ string: String) -> OpaquePointer? { OpaquePointer(bitPattern: 0x1) }
public func icalcomponent_free(_ component: OpaquePointer?) {}
public func icalcomponent_get_method(_ component: OpaquePointer?) -> Int32 { ICAL_METHOD_REQUEST }
public func icalcomponent_get_first_component(_ component: OpaquePointer?, _ kind: Int32) -> OpaquePointer? { OpaquePointer(bitPattern: 0x2) }
public func icalcomponent_get_uid(_ component: OpaquePointer?) -> UnsafePointer<CChar>? { nil }
public func icalcomponent_get_first_property(_ component: OpaquePointer?, _ kind: Int32) -> OpaquePointer? { OpaquePointer(bitPattern: 0x3) }
public func icalproperty_get_first_parameter(_ property: OpaquePointer?, _ kind: Int32) -> OpaquePointer? { OpaquePointer(bitPattern: 0x4) }
public func icalparameter_get_tzid(_ parameter: OpaquePointer?) -> UnsafePointer<CChar>? { nil }
public func icalcomponent_get_recurrenceid(_ component: OpaquePointer?) -> icaltimetype { icaltimetype() }
public func icaltime_as_ical_string(_ time: icaltimetype) -> UnsafePointer<CChar>? { nil }

// MARK: - Date helpers expected at call sites

public struct ICalDateParseResult { public let date: Date; public init(date: Date) { self.date = date } }
public extension Date {
    static func getDateFrom(timeString: String) -> ICalDateParseResult? {
        ICalDateParseResult(date: Date())
    }
}
