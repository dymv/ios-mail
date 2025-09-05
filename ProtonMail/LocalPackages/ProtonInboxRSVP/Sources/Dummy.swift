import Foundation
import Combine
import ProtonInboxICal
import ProtonCoreFeatures
import ProtonCoreDataModel

// MARK: - RSVP Public APIs (stubs)

public protocol EmailAddressStorage {
    func currentUserAddresses() -> [Address_v2]
    func addresses(userID: String) -> [Address_v2]
}

public protocol IdentifiableEvent {
    var id: String { get }
    var calendarID: String { get }
    var startDate: Date { get }
}

public enum AttendeeStatusDisplay: Equatable {
    case yes
    case no
    case maybe
}

public enum AttendeeAnswer: Equatable {
    case yes
    case no
    case maybe
    case unanswered
}

public enum EventType {
    case nonRecurring
    case recurring(Recurring)
    case singleEdit(SingleEdit)

    public struct Recurring {
        public init(mainOccurrence: ICalEvent, singleEdits: [ICalEvent]) {}
    }

    public enum SingleEdit {
        case regular(editInfo: EditInfo)
        case orphan

        public struct EditInfo {
            public enum EditCount { case one }
            public let editCount: EditCount
            public let deletionCount: Int
            public init(editCount: EditCount, deletionCount: Int) {
                self.editCount = editCount
                self.deletionCount = deletionCount
            }
        }
    }
}

public enum AnswerToEvent {
    public struct ValidatedContext {
        public struct InvitedParticipant { public let attendee: ICalAttendee; public init(attendee: ICalAttendee) { self.attendee = attendee } }
        public var invitedParticipant: InvitedParticipant
        public init() {
            self.invitedParticipant = .init(attendee: .init(user: .init(email: ""), role: .unknown, status: .unknown, token: ""))
        }
    }
}

public protocol CalendarInfo {
    var id: String { get }
    var isPersonal: Bool { get }
    var areMemberAddressesDisabled: Bool { get }
}

public protocol CalendarEvent {
    var iCalEvent: ICalEvent { get }
    var eventType: EventType { get }
}

public protocol AttendeeStorage {
    func attendeeID(for attendee: ICalAttendee) -> String?
}

public protocol CalendarKeyStorage {
    func activeKeys(calendarID: String) -> ActiveCalendarKeysInfo?
}

public protocol CalendarKey { var id: String { get } }

public struct ActiveCalendarKeysInfo {
    public let activePrimaryKey: CalendarKey
    public let activeKeys: [CalendarKey]
    public init(activePrimaryKey: CalendarKey, activeKeys: [CalendarKey]) {
        self.activePrimaryKey = activePrimaryKey
        self.activeKeys = activeKeys
    }
}

public protocol EventStorage {
    func calendarEvent(for event: any IdentifiableEvent) -> (any CalendarEvent)?
    func mainEvent(for event: any IdentifiableEvent) -> ICalEvent?
}

public protocol UserPassphraseStorage {
    var userPassphrase: String? { get }
}

public protocol CurrentUserStorage {
    associatedtype User
    var user: User? { get }
}

public protocol UserPreContactsProviding {
    associatedtype User
    func preContacts(for user: User, recipients: [String]) -> AnyPublisher<[ProtonCoreFeatures.PreContact], Error>
}

public protocol DateFormatterProviding {
    func timeFormatter(userID: String, with timeZone: TimeZone) -> DateFormatter
    func dayFormatter() -> DateFormatter
}

public protocol CurrentDateProviding { var currentDate: () -> Date { get } }

public protocol L10nProviding {
    associatedtype L10nKey
    func localizedString(for key: L10nKey) -> String
}

    // NOTE: Concrete RecipientProvider is provided by the host app via extension.

public struct AnswerToEventPermissionValidator {
    public enum Result {
        case canAnswer(validated: AnswerToEvent.ValidatedContext)
        case canNotAnswer
    }

    public init(emailAddressStorage: any EmailAddressStorage) {}

    public func canAnswer(for iCalEvent: ICalEvent, with calendarInfo: any CalendarInfo) -> Result {
        .canNotAnswer
    }
}

public protocol EventKeyPacketUpdating {
    func updateSharedKeyPacket(with sharedKeyPacket: String, calendarID: String, eventID: String) -> AnyPublisher<Void, Error>
}

public protocol EventParticipationStatusUpdating {
    func updateParticipationStatus(
        with answer: AttendeeAnswer,
        updateTime: Date,
        calendarID: String,
        eventID: String,
        attendeeID: String
    ) -> AnyPublisher<Void, Error>
}

public protocol EventPersonalPartUpdating {
    func updatePersonalPart(
        with notifications: [ICalEvent.RawNotification]?,
        calendarID: String,
        eventID: String
    ) -> AnyPublisher<Void, Error>
}

// MARK: - Use Case Stub

public struct AnswerInvitationUseCase {

    public enum L10nKey {
        case emailInvitationSubjectFullDateWithTimeAndTimeZone(String, String, String)
        case emailInvitationBodyAttendeeStatusDescriptionAccepted
        case emailInvitationBodyAttendeeStatusDescriptionDeclined
        case emailInvitationBodyAttendeeStatusDescriptionTentative
        case emailInvitationBodyContent(String, String, String)
        case emailInvitationBodyTitle(String)
        case emailInvitationBodyLocation(String)
        case emailInvitationBodyNotes(String)
        case emailCancellationBody(String)
        case emailAnswerSubjectAllDaySingle(String)
        case emailAnswerSubjectOther(String)
        case eventNoTitle
    }

    public init(
        emailSender: Any,
        localization: any L10nProviding,
        dateFormatterProvider: any DateFormatterProviding,
        currentDateProvider: any CurrentDateProviding,
        attendeeStorage: some AttendeeStorage,
        calendarKeyStorage: some CalendarKeyStorage,
        emailAddressStorage: some EmailAddressStorage,
        eventStorage: some EventStorage,
        passphraseStorage: some UserPassphraseStorage,
        userStorage: some CurrentUserStorage,
        eventKeyPacketUpdater: some EventKeyPacketUpdating,
        eventParticipationStatusUpdater: some EventParticipationStatusUpdating,
        eventPersonalPartUpdater: some EventPersonalPartUpdating,
        userPreContactsProvider: some UserPreContactsProviding,
        vTimeZonesInfoProvider: some VTimeZonesInfoProviding,
        recipientProvider: some RecipientProviding
    ) {}

    public func execute(
        with answer: AttendeeStatusDisplay,
        for event: any IdentifiableEvent,
        calendar: any CalendarInfo,
        validatedContext: AnswerToEvent.ValidatedContext
    ) -> AnyPublisher<Void, Error> {
        Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

// MARK: - Recipient providing

    public protocol RecipientProviding {
        associatedtype Dependencies
        func recipient(email: String) -> AnyPublisher<ProtonCoreFeatures.Recipient, Error>
    }
