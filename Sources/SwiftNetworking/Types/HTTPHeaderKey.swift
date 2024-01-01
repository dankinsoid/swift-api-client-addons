import Foundation

/// Type safe header key wrapper
public struct HTTPHeaderKey {

	public var rawValue: String

	public init(_ rawValue: String) { self.rawValue = rawValue }

	public static func custom(_ key: String) -> HTTPHeaderKey {
		HTTPHeaderKey(key)
	}

	@available(*, deprecated, message: "Use key directly")
	public static func key(_ key: HTTPHeaderKey) -> HTTPHeaderKey { key }

	/// Authorization header
	public static let authorization: HTTPHeaderKey = "Authorization"

	/// Accept header
	public static let accept: HTTPHeaderKey = "Accept"

	/// Permanent Message Header Field Names
	public static let acceptLanguage: HTTPHeaderKey = "Accept-Language"
	public static let alsoControl: HTTPHeaderKey = "Also-Control"
	public static let alternateRecipient: HTTPHeaderKey = "Alternate-Recipient"
	public static let approved: HTTPHeaderKey = "Approved"
	public static let aRCAuthenticationResults: HTTPHeaderKey =
		"ARC-Authentication-Results"
	public static let aRCMessageSignature: HTTPHeaderKey =
		"ARC-Message-Signature"
	public static let aRCSeal: HTTPHeaderKey = "ARC-Seal"
	public static let archive: HTTPHeaderKey = "Archive"
	public static let archivedAt: HTTPHeaderKey = "Archived-At"
	public static let articleNames: HTTPHeaderKey = "Article-Names"
	public static let articleUpdates: HTTPHeaderKey = "Article-Updates"
	public static let authenticationResults: HTTPHeaderKey =
		"Authentication-Results"
	public static let autoSubmitted: HTTPHeaderKey = "Auto-Submitted"
	public static let autoforwarded: HTTPHeaderKey = "Autoforwarded"
	public static let autosubmitted: HTTPHeaderKey = "Autosubmitted"
	public static let base: HTTPHeaderKey = "Base"
	public static let bcc: HTTPHeaderKey = "Bcc"
	public static let body: HTTPHeaderKey = "Body"
	public static let cancelKey: HTTPHeaderKey = "Cancel-Key"
	public static let cancelLock: HTTPHeaderKey = "Cancel-Lock"
	public static let cc: HTTPHeaderKey = "Cc"
	public static let comments: HTTPHeaderKey = "Comments"
	public static let cookie: HTTPHeaderKey = "Cookie"
	public static let contentAlternative: HTTPHeaderKey = "Content-Alternative"
	public static let contentBase: HTTPHeaderKey = "Content-Base"
	public static let contentDescription: HTTPHeaderKey = "Content-Description"
	public static let contentDisposition: HTTPHeaderKey = "Content-Disposition"
	public static let contentDuration: HTTPHeaderKey = "Content-Duration"
	public static let contentfeatures: HTTPHeaderKey = "Content-features"
	public static let contentID: HTTPHeaderKey = "Content-ID"
	public static let contentIdentifier: HTTPHeaderKey = "Content-Identifier"
	public static let contentLanguage: HTTPHeaderKey = "Content-Language"
	public static let contentLocation: HTTPHeaderKey = "Content-Location"
	public static let contentMD5: HTTPHeaderKey = "Content-MD5"
	public static let contentReturn: HTTPHeaderKey = "Content-Return"
	public static let contentTransferEncoding: HTTPHeaderKey =
		"Content-Transfer-Encoding"
	public static let contentTranslationType: HTTPHeaderKey =
		"Content-Translation-Type"
	public static let contentType: HTTPHeaderKey = "Content-Type"
	public static let control: HTTPHeaderKey = "Control"
	public static let conversion: HTTPHeaderKey = "Conversion"
	public static let conversionWithLoss: HTTPHeaderKey = "Conversion-With-Loss"
	public static let dLExpansionHistory: HTTPHeaderKey = "DL-Expansion-History"
	public static let date: HTTPHeaderKey = "Date"
	public static let dateReceived: HTTPHeaderKey = "Date-Received"
	public static let deferredDelivery: HTTPHeaderKey = "Deferred-Delivery"
	public static let deliveryDate: HTTPHeaderKey = "Delivery-Date"
	public static let discardedX400IPMSExtensions: HTTPHeaderKey =
		"Discarded-X400-IPMS-Extensions"
	public static let discardedX400MTSExtensions: HTTPHeaderKey =
		"Discarded-X400-MTS-Extensions"
	public static let discloseRecipients: HTTPHeaderKey = "Disclose-Recipients"
	public static let dispositionNotificationOptions: HTTPHeaderKey =
		"Disposition-Notification-Options"
	public static let dispositionNotificationTo: HTTPHeaderKey =
		"Disposition-Notification-To"
	public static let distribution: HTTPHeaderKey = "Distribution"
	public static let dKIMSignature: HTTPHeaderKey = "DKIM-Signature"
	public static let downgradedBcc: HTTPHeaderKey = "Downgraded-Bcc"
	public static let downgradedCc: HTTPHeaderKey = "Downgraded-Cc"
	public static let downgradedDispositionNotificationTo: HTTPHeaderKey =
		"Downgraded-Disposition-Notification-To"
	public static let downgradedFinalRecipient: HTTPHeaderKey =
		"Downgraded-Final-Recipient"
	public static let downgradedFrom: HTTPHeaderKey = "Downgraded-From"
	public static let downgradedInReplyTo: HTTPHeaderKey =
		"Downgraded-In-Reply-To"
	public static let downgradedMailFrom: HTTPHeaderKey = "Downgraded-Mail-From"
	public static let downgradedMessageId: HTTPHeaderKey =
		"Downgraded-Message-Id"
	public static let downgradedOriginalRecipient: HTTPHeaderKey =
		"Downgraded-Original-Recipient"
	public static let downgradedRcptTo: HTTPHeaderKey = "Downgraded-Rcpt-To"
	public static let downgradedReferences: HTTPHeaderKey =
		"Downgraded-References"
	public static let downgradedReplyTo: HTTPHeaderKey = "Downgraded-Reply-To"
	public static let downgradedResentBcc: HTTPHeaderKey =
		"Downgraded-Resent-Bcc"
	public static let downgradedResentCc: HTTPHeaderKey = "Downgraded-Resent-Cc"
	public static let downgradedResentFrom: HTTPHeaderKey =
		"Downgraded-Resent-From"
	public static let downgradedResentReplyTo: HTTPHeaderKey =
		"Downgraded-Resent-Reply-To"
	public static let downgradedResentSender: HTTPHeaderKey =
		"Downgraded-Resent-Sender"
	public static let downgradedResentTo: HTTPHeaderKey = "Downgraded-Resent-To"
	public static let downgradedReturnPath: HTTPHeaderKey =
		"Downgraded-Return-Path"
	public static let downgradedSender: HTTPHeaderKey = "Downgraded-Sender"
	public static let downgradedTo: HTTPHeaderKey = "Downgraded-To"
	public static let encoding: HTTPHeaderKey = "Encoding"
	public static let encrypted: HTTPHeaderKey = "Encrypted"
	public static let expires: HTTPHeaderKey = "Expires"
	public static let expiryDate: HTTPHeaderKey = "Expiry-Date"
	public static let followupTo: HTTPHeaderKey = "Followup-To"
	public static let from: HTTPHeaderKey = "From"
	public static let generateDeliveryReport: HTTPHeaderKey =
		"Generate-Delivery-Report"
	public static let importance: HTTPHeaderKey = "Importance"
	public static let inReplyTo: HTTPHeaderKey = "In-Reply-To"
	public static let incompleteCopy: HTTPHeaderKey = "Incomplete-Copy"
	public static let injectionDate: HTTPHeaderKey = "Injection-Date"
	public static let injectionInfo: HTTPHeaderKey = "Injection-Info"
	public static let keywords: HTTPHeaderKey = "Keywords"
	public static let language: HTTPHeaderKey = "Language"
	public static let latestDeliveryTime: HTTPHeaderKey = "Latest-Delivery-Time"
	public static let lines: HTTPHeaderKey = "Lines"
	public static let listArchive: HTTPHeaderKey = "List-Archive"
	public static let listHelp: HTTPHeaderKey = "List-Help"
	public static let listID: HTTPHeaderKey = "List-ID"
	public static let listOwner: HTTPHeaderKey = "List-Owner"
	public static let listPost: HTTPHeaderKey = "List-Post"
	public static let listSubscribe: HTTPHeaderKey = "List-Subscribe"
	public static let listUnsubscribe: HTTPHeaderKey = "List-Unsubscribe"
	public static let listUnsubscribePost: HTTPHeaderKey =
		"List-Unsubscribe-Post"
	public static let messageContext: HTTPHeaderKey = "Message-Context"
	public static let messageID: HTTPHeaderKey = "Message-ID"
	public static let messageType: HTTPHeaderKey = "Message-Type"
	public static let mIMEVersion: HTTPHeaderKey = "MIME-Version"
	public static let mMHSExemptedAddress: HTTPHeaderKey =
		"MMHS-Exempted-Address"
	public static let mMHSExtendedAuthorisationInfo: HTTPHeaderKey =
		"MMHS-Extended-Authorisation-Info"
	public static let mMHSSubjectIndicatorCodes: HTTPHeaderKey =
		"MMHS-Subject-Indicator-Codes"
	public static let mMHSHandlingInstructions: HTTPHeaderKey =
		"MMHS-Handling-Instructions"
	public static let mMHSMessageInstructions: HTTPHeaderKey =
		"MMHS-Message-Instructions"
	public static let mMHSCodressMessageIndicator: HTTPHeaderKey =
		"MMHS-Codress-Message-Indicator"
	public static let mMHSOriginatorReference: HTTPHeaderKey =
		"MMHS-Originator-Reference"
	public static let mMHSPrimaryPrecedence: HTTPHeaderKey =
		"MMHS-Primary-Precedence"
	public static let mMHSCopyPrecedence: HTTPHeaderKey = "MMHS-Copy-Precedence"
	public static let mMHSMessageType: HTTPHeaderKey = "MMHS-Message-Type"
	public static let mMHSOtherRecipientsIndicatorTo: HTTPHeaderKey =
		"MMHS-Other-Recipients-Indicator-To"
	public static let mMHSOtherRecipientsIndicatorCC: HTTPHeaderKey =
		"MMHS-Other-Recipients-Indicator-CC"
	public static let mMHSAcp127MessageIdentifier: HTTPHeaderKey =
		"MMHS-Acp127-Message-Identifier"
	public static let mMHSOriginatorPLAD: HTTPHeaderKey = "MMHS-Originator-PLAD"
	public static let mTPriority: HTTPHeaderKey = "MT-Priority"
	public static let newsgroups: HTTPHeaderKey = "Newsgroups"
	public static let nNTPPostingDate: HTTPHeaderKey = "NNTP-Posting-Date"
	public static let nNTPPostingHost: HTTPHeaderKey = "NNTP-Posting-Host"
	public static let obsoletes: HTTPHeaderKey = "Obsoletes"
	public static let organization: HTTPHeaderKey = "Organization"
	public static let originalEncodedInformationTypes: HTTPHeaderKey =
		"Original-Encoded-Information-Types"
	public static let originalFrom: HTTPHeaderKey = "Original-From"
	public static let originalMessageID: HTTPHeaderKey = "Original-Message-ID"
	public static let originalRecipient: HTTPHeaderKey = "Original-Recipient"
	public static let originalSender: HTTPHeaderKey = "Original-Sender"
	public static let originatorReturnAddress: HTTPHeaderKey =
		"Originator-Return-Address"
	public static let originalSubject: HTTPHeaderKey = "Original-Subject"
	public static let path: HTTPHeaderKey = "Path"
	public static let pICSLabel: HTTPHeaderKey = "PICS-Label"
	public static let postingVersion: HTTPHeaderKey = "Posting-Version"
	public static let preventNonDeliveryReport: HTTPHeaderKey =
		"Prevent-NonDelivery-Report"
	public static let priority: HTTPHeaderKey = "Priority"
	public static let received: HTTPHeaderKey = "Received"
	public static let receivedSPF: HTTPHeaderKey = "Received-SPF"
	public static let references: HTTPHeaderKey = "References"
	public static let relayVersion: HTTPHeaderKey = "Relay-Version"
	public static let replyBy: HTTPHeaderKey = "Reply-By"
	public static let replyTo: HTTPHeaderKey = "Reply-To"
	public static let requireRecipientValidSince: HTTPHeaderKey =
		"Require-Recipient-Valid-Since"
	public static let resentBcc: HTTPHeaderKey = "Resent-Bcc"
	public static let resentCc: HTTPHeaderKey = "Resent-Cc"
	public static let resentDate: HTTPHeaderKey = "Resent-Date"
	public static let resentFrom: HTTPHeaderKey = "Resent-From"
	public static let resentMessageID: HTTPHeaderKey = "Resent-Message-ID"
	public static let resentReplyTo: HTTPHeaderKey = "Resent-Reply-To"
	public static let resentSender: HTTPHeaderKey = "Resent-Sender"
	public static let resentTo: HTTPHeaderKey = "Resent-To"
	public static let returnPath: HTTPHeaderKey = "Return-Path"
	public static let seeAlso: HTTPHeaderKey = "See-Also"
	public static let sender: HTTPHeaderKey = "Sender"
	public static let sensitivity: HTTPHeaderKey = "Sensitivity"
	public static let setCookie: HTTPHeaderKey = "Set-Cookie"
	public static let solicitation: HTTPHeaderKey = "Solicitation"
	public static let subject: HTTPHeaderKey = "Subject"
	public static let summary: HTTPHeaderKey = "Summary"
	public static let supersedes: HTTPHeaderKey = "Supersedes"
	public static let tLSReportDomain: HTTPHeaderKey = "TLS-Report-Domain"
	public static let tLSReportSubmitter: HTTPHeaderKey = "TLS-Report-Submitter"
	public static let tLSRequired: HTTPHeaderKey = "TLS-Required"
	public static let to: HTTPHeaderKey = "To"
	public static let userAgent: HTTPHeaderKey = "User-Agent"
	public static let vBRInfo: HTTPHeaderKey = "VBR-Info"
	public static let x400ContentIdentifier: HTTPHeaderKey =
		"X400-Content-Identifier"
	public static let x400ContentReturn: HTTPHeaderKey = "X400-Content-Return"
	public static let x400ContentType: HTTPHeaderKey = "X400-Content-Type"
	public static let x400MTSIdentifier: HTTPHeaderKey = "X400-MTS-Identifier"
	public static let x400Originator: HTTPHeaderKey = "X400-Originator"
	public static let x400Received: HTTPHeaderKey = "X400-Received"
	public static let x400Recipients: HTTPHeaderKey = "X400-Recipients"
	public static let x400Trace: HTTPHeaderKey = "X400-Trace"
	public static let xrefcase: HTTPHeaderKey = "Xrefcase"
	/// Provisional Message Header Field Names
	public static let apparentlyTo: HTTPHeaderKey = "Apparently-To"
	public static let author: HTTPHeaderKey = "Author"
	public static let eDIINTFeatures: HTTPHeaderKey = "EDIINT-Features"
	public static let eesstVersion: HTTPHeaderKey = "Eesst-Version"
	public static let errorsTo: HTTPHeaderKey = "Errors-To"
	public static let formSub: HTTPHeaderKey = "Form-Sub"
	public static let jabberID: HTTPHeaderKey = "Jabber-ID"
	public static let mMHSAuthorizingUsers: HTTPHeaderKey =
		"MMHS-Authorizing-Users"
	public static let privicon: HTTPHeaderKey = "Privicon"
	public static let sIOLabel: HTTPHeaderKey = "SIO-Label"
	public static let sIOLabelHistory: HTTPHeaderKey = "SIO-Label-History"
	public static let xArchivedAt: HTTPHeaderKey = "X-Archived-At"
	public static let xMittente: HTTPHeaderKey = "X-Mittente"
	public static let xPGPSig: HTTPHeaderKey = "X-PGP-Sig"
	public static let xRicevuta: HTTPHeaderKey = "X-Ricevuta"
	public static let xRiferimentoMessageID: HTTPHeaderKey =
		"X-Riferimento-Message-ID"
	public static let xTipoRicevuta: HTTPHeaderKey = "X-TipoRicevuta"
	public static let xTrasporto: HTTPHeaderKey = "X-Trasporto"
	public static let xVerificaSicurezza: HTTPHeaderKey = "X-VerificaSicurezza"
}

extension HTTPHeaderKey: Hashable, Codable, ExpressibleByStringLiteral,
	RawRepresentable, CustomStringConvertible, Equatable
{

	public var description: String { rawValue }

	/// Creates a new instance with the specified raw value.
	/// - Parameter rawValue: The raw value to use for the new instance.
	public init?(rawValue: String) { self.init(rawValue) }

	/// Creates an instance initialized to the given string value.
	///
	/// - Parameter value: The value of the new instance.
	public init(stringLiteral value: String) { self.init(value) }

	/// Creates a new instance by decoding from the given decoder.
	///
	/// This initializer throws an error if reading from the decoder fails, or
	/// if the data read is corrupted or otherwise invalid.
	///
	/// - Parameter decoder: The decoder to read data from.
	public init(from decoder: Decoder) throws {
		try self.init(String(from: decoder))
	}

	/// Hashes the essential components of this value by feeding them into the
	/// given hasher.
	///
	/// Implement this method to conform to the `Hashable` protocol. The
	/// components used for hashing must be the same as the components compared
	/// in your type's `==` operator implementation. Call `hasher.combine(_:)`
	/// with each of these components.
	///
	/// - Important: Never call `finalize()` on `hasher`. Doing so may become a
	///   compile-time error in the future.
	///
	/// - Parameter hasher: The hasher to use when combining the components
	///   of this instance.
	public func hash(into hasher: inout Hasher) {
		rawValue.hash(into: &hasher)
	}

	/// Encodes this value into the given encoder.
	///
	/// If the value fails to encode anything, `encoder` will encode an empty
	/// keyed container in its place.
	///
	/// This function throws an error if any values are invalid for the given
	/// encoder's format.
	///
	/// - Parameter encoder: The encoder to write data to.
	public func encode(to encoder: Encoder) throws {
		try rawValue.encode(to: encoder)
	}
}
