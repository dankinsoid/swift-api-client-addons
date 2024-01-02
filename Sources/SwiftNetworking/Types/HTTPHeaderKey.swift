import Foundation

public extension HTTPHeader {

	/// Type safe header key wrapper
	struct Key {

		public var rawValue: String

		public init(_ rawValue: String) { self.rawValue = rawValue }

		public static func custom(_ key: String) -> HTTPHeader.Key {
			HTTPHeader.Key(key)
		}

		@available(*, deprecated, message: "Use key directly")
		public static func key(_ key: HTTPHeader.Key) -> HTTPHeader.Key { key }

		/// Authorization header
		public static let authorization: HTTPHeader.Key = "Authorization"

		/// Accept header
		public static let accept: HTTPHeader.Key = "Accept"

		/// Permanent Message Header Field Names
		public static let acceptLanguage: HTTPHeader.Key = "Accept-Language"
		/// Accept-Charset
		public static let acceptCharset: HTTPHeader.Key = "Accept-Charset"
		public static let alsoControl: HTTPHeader.Key = "Also-Control"
		public static let alternateRecipient: HTTPHeader.Key = "Alternate-Recipient"
		public static let approved: HTTPHeader.Key = "Approved"
		public static let aRCAuthenticationResults: HTTPHeader.Key =
			"ARC-Authentication-Results"
		public static let aRCMessageSignature: HTTPHeader.Key =
			"ARC-Message-Signature"
		public static let aRCSeal: HTTPHeader.Key = "ARC-Seal"
		public static let archive: HTTPHeader.Key = "Archive"
		public static let archivedAt: HTTPHeader.Key = "Archived-At"
		public static let articleNames: HTTPHeader.Key = "Article-Names"
		public static let articleUpdates: HTTPHeader.Key = "Article-Updates"
		public static let authenticationResults: HTTPHeader.Key =
			"Authentication-Results"
		public static let autoSubmitted: HTTPHeader.Key = "Auto-Submitted"
		public static let autoforwarded: HTTPHeader.Key = "Autoforwarded"
		public static let autosubmitted: HTTPHeader.Key = "Autosubmitted"
		public static let base: HTTPHeader.Key = "Base"
		public static let bcc: HTTPHeader.Key = "Bcc"
		public static let body: HTTPHeader.Key = "Body"
		public static let cancelKey: HTTPHeader.Key = "Cancel-Key"
		public static let cancelLock: HTTPHeader.Key = "Cancel-Lock"
		public static let cc: HTTPHeader.Key = "Cc"
		public static let comments: HTTPHeader.Key = "Comments"
		public static let cookie: HTTPHeader.Key = "Cookie"
		public static let contentAlternative: HTTPHeader.Key = "Content-Alternative"
		public static let contentBase: HTTPHeader.Key = "Content-Base"
		public static let contentDescription: HTTPHeader.Key = "Content-Description"
		public static let contentDisposition: HTTPHeader.Key = "Content-Disposition"
		public static let contentDuration: HTTPHeader.Key = "Content-Duration"
		public static let contentfeatures: HTTPHeader.Key = "Content-features"
		public static let contentID: HTTPHeader.Key = "Content-ID"
		public static let contentIdentifier: HTTPHeader.Key = "Content-Identifier"
		public static let contentLanguage: HTTPHeader.Key = "Content-Language"
		public static let contentLocation: HTTPHeader.Key = "Content-Location"
		public static let contentMD5: HTTPHeader.Key = "Content-MD5"
		public static let contentReturn: HTTPHeader.Key = "Content-Return"
		public static let contentTransferEncoding: HTTPHeader.Key =
			"Content-Transfer-Encoding"
		public static let contentTranslationType: HTTPHeader.Key =
			"Content-Translation-Type"
		public static let contentType: HTTPHeader.Key = "Content-Type"
		public static let control: HTTPHeader.Key = "Control"
		public static let conversion: HTTPHeader.Key = "Conversion"
		public static let conversionWithLoss: HTTPHeader.Key = "Conversion-With-Loss"
		public static let dLExpansionHistory: HTTPHeader.Key = "DL-Expansion-History"
		public static let date: HTTPHeader.Key = "Date"
		public static let dateReceived: HTTPHeader.Key = "Date-Received"
		public static let deferredDelivery: HTTPHeader.Key = "Deferred-Delivery"
		public static let deliveryDate: HTTPHeader.Key = "Delivery-Date"
		public static let discardedX400IPMSExtensions: HTTPHeader.Key =
			"Discarded-X400-IPMS-Extensions"
		public static let discardedX400MTSExtensions: HTTPHeader.Key =
			"Discarded-X400-MTS-Extensions"
		public static let discloseRecipients: HTTPHeader.Key = "Disclose-Recipients"
		public static let dispositionNotificationOptions: HTTPHeader.Key =
			"Disposition-Notification-Options"
		public static let dispositionNotificationTo: HTTPHeader.Key =
			"Disposition-Notification-To"
		public static let distribution: HTTPHeader.Key = "Distribution"
		public static let dKIMSignature: HTTPHeader.Key = "DKIM-Signature"
		public static let downgradedBcc: HTTPHeader.Key = "Downgraded-Bcc"
		public static let downgradedCc: HTTPHeader.Key = "Downgraded-Cc"
		public static let downgradedDispositionNotificationTo: HTTPHeader.Key =
			"Downgraded-Disposition-Notification-To"
		public static let downgradedFinalRecipient: HTTPHeader.Key =
			"Downgraded-Final-Recipient"
		public static let downgradedFrom: HTTPHeader.Key = "Downgraded-From"
		public static let downgradedInReplyTo: HTTPHeader.Key =
			"Downgraded-In-Reply-To"
		public static let downgradedMailFrom: HTTPHeader.Key = "Downgraded-Mail-From"
		public static let downgradedMessageId: HTTPHeader.Key =
			"Downgraded-Message-Id"
		public static let downgradedOriginalRecipient: HTTPHeader.Key =
			"Downgraded-Original-Recipient"
		public static let downgradedRcptTo: HTTPHeader.Key = "Downgraded-Rcpt-To"
		public static let downgradedReferences: HTTPHeader.Key =
			"Downgraded-References"
		public static let downgradedReplyTo: HTTPHeader.Key = "Downgraded-Reply-To"
		public static let downgradedResentBcc: HTTPHeader.Key =
			"Downgraded-Resent-Bcc"
		public static let downgradedResentCc: HTTPHeader.Key = "Downgraded-Resent-Cc"
		public static let downgradedResentFrom: HTTPHeader.Key =
			"Downgraded-Resent-From"
		public static let downgradedResentReplyTo: HTTPHeader.Key =
			"Downgraded-Resent-Reply-To"
		public static let downgradedResentSender: HTTPHeader.Key =
			"Downgraded-Resent-Sender"
		public static let downgradedResentTo: HTTPHeader.Key = "Downgraded-Resent-To"
		public static let downgradedReturnPath: HTTPHeader.Key =
			"Downgraded-Return-Path"
		public static let downgradedSender: HTTPHeader.Key = "Downgraded-Sender"
		public static let downgradedTo: HTTPHeader.Key = "Downgraded-To"
		public static let encoding: HTTPHeader.Key = "Encoding"
		public static let encrypted: HTTPHeader.Key = "Encrypted"
		public static let expires: HTTPHeader.Key = "Expires"
		public static let expiryDate: HTTPHeader.Key = "Expiry-Date"
		public static let followupTo: HTTPHeader.Key = "Followup-To"
		public static let from: HTTPHeader.Key = "From"
		public static let generateDeliveryReport: HTTPHeader.Key =
			"Generate-Delivery-Report"
		public static let importance: HTTPHeader.Key = "Importance"
		public static let inReplyTo: HTTPHeader.Key = "In-Reply-To"
		public static let incompleteCopy: HTTPHeader.Key = "Incomplete-Copy"
		public static let injectionDate: HTTPHeader.Key = "Injection-Date"
		public static let injectionInfo: HTTPHeader.Key = "Injection-Info"
		public static let keywords: HTTPHeader.Key = "Keywords"
		public static let language: HTTPHeader.Key = "Language"
		public static let latestDeliveryTime: HTTPHeader.Key = "Latest-Delivery-Time"
		public static let lines: HTTPHeader.Key = "Lines"
		public static let listArchive: HTTPHeader.Key = "List-Archive"
		public static let listHelp: HTTPHeader.Key = "List-Help"
		public static let listID: HTTPHeader.Key = "List-ID"
		public static let listOwner: HTTPHeader.Key = "List-Owner"
		public static let listPost: HTTPHeader.Key = "List-Post"
		public static let listSubscribe: HTTPHeader.Key = "List-Subscribe"
		public static let listUnsubscribe: HTTPHeader.Key = "List-Unsubscribe"
		public static let listUnsubscribePost: HTTPHeader.Key =
			"List-Unsubscribe-Post"
		public static let messageContext: HTTPHeader.Key = "Message-Context"
		public static let messageID: HTTPHeader.Key = "Message-ID"
		public static let messageType: HTTPHeader.Key = "Message-Type"
		public static let mIMEVersion: HTTPHeader.Key = "MIME-Version"
		public static let mMHSExemptedAddress: HTTPHeader.Key =
			"MMHS-Exempted-Address"
		public static let mMHSExtendedAuthorisationInfo: HTTPHeader.Key =
			"MMHS-Extended-Authorisation-Info"
		public static let mMHSSubjectIndicatorCodes: HTTPHeader.Key =
			"MMHS-Subject-Indicator-Codes"
		public static let mMHSHandlingInstructions: HTTPHeader.Key =
			"MMHS-Handling-Instructions"
		public static let mMHSMessageInstructions: HTTPHeader.Key =
			"MMHS-Message-Instructions"
		public static let mMHSCodressMessageIndicator: HTTPHeader.Key =
			"MMHS-Codress-Message-Indicator"
		public static let mMHSOriginatorReference: HTTPHeader.Key =
			"MMHS-Originator-Reference"
		public static let mMHSPrimaryPrecedence: HTTPHeader.Key =
			"MMHS-Primary-Precedence"
		public static let mMHSCopyPrecedence: HTTPHeader.Key = "MMHS-Copy-Precedence"
		public static let mMHSMessageType: HTTPHeader.Key = "MMHS-Message-Type"
		public static let mMHSOtherRecipientsIndicatorTo: HTTPHeader.Key =
			"MMHS-Other-Recipients-Indicator-To"
		public static let mMHSOtherRecipientsIndicatorCC: HTTPHeader.Key =
			"MMHS-Other-Recipients-Indicator-CC"
		public static let mMHSAcp127MessageIdentifier: HTTPHeader.Key =
			"MMHS-Acp127-Message-Identifier"
		public static let mMHSOriginatorPLAD: HTTPHeader.Key = "MMHS-Originator-PLAD"
		public static let mTPriority: HTTPHeader.Key = "MT-Priority"
		public static let newsgroups: HTTPHeader.Key = "Newsgroups"
		public static let nNTPPostingDate: HTTPHeader.Key = "NNTP-Posting-Date"
		public static let nNTPPostingHost: HTTPHeader.Key = "NNTP-Posting-Host"
		public static let obsoletes: HTTPHeader.Key = "Obsoletes"
		public static let organization: HTTPHeader.Key = "Organization"
		public static let originalEncodedInformationTypes: HTTPHeader.Key =
			"Original-Encoded-Information-Types"
		public static let originalFrom: HTTPHeader.Key = "Original-From"
		public static let originalMessageID: HTTPHeader.Key = "Original-Message-ID"
		public static let originalRecipient: HTTPHeader.Key = "Original-Recipient"
		public static let originalSender: HTTPHeader.Key = "Original-Sender"
		public static let originatorReturnAddress: HTTPHeader.Key =
			"Originator-Return-Address"
		public static let originalSubject: HTTPHeader.Key = "Original-Subject"
		public static let path: HTTPHeader.Key = "Path"
		public static let pICSLabel: HTTPHeader.Key = "PICS-Label"
		public static let postingVersion: HTTPHeader.Key = "Posting-Version"
		public static let preventNonDeliveryReport: HTTPHeader.Key =
			"Prevent-NonDelivery-Report"
		public static let priority: HTTPHeader.Key = "Priority"
		public static let received: HTTPHeader.Key = "Received"
		public static let receivedSPF: HTTPHeader.Key = "Received-SPF"
		public static let references: HTTPHeader.Key = "References"
		public static let relayVersion: HTTPHeader.Key = "Relay-Version"
		public static let replyBy: HTTPHeader.Key = "Reply-By"
		public static let replyTo: HTTPHeader.Key = "Reply-To"
		public static let requireRecipientValidSince: HTTPHeader.Key =
			"Require-Recipient-Valid-Since"
		public static let resentBcc: HTTPHeader.Key = "Resent-Bcc"
		public static let resentCc: HTTPHeader.Key = "Resent-Cc"
		public static let resentDate: HTTPHeader.Key = "Resent-Date"
		public static let resentFrom: HTTPHeader.Key = "Resent-From"
		public static let resentMessageID: HTTPHeader.Key = "Resent-Message-ID"
		public static let resentReplyTo: HTTPHeader.Key = "Resent-Reply-To"
		public static let resentSender: HTTPHeader.Key = "Resent-Sender"
		public static let resentTo: HTTPHeader.Key = "Resent-To"
		public static let returnPath: HTTPHeader.Key = "Return-Path"
		public static let seeAlso: HTTPHeader.Key = "See-Also"
		public static let sender: HTTPHeader.Key = "Sender"
		public static let sensitivity: HTTPHeader.Key = "Sensitivity"
		public static let setCookie: HTTPHeader.Key = "Set-Cookie"
		public static let solicitation: HTTPHeader.Key = "Solicitation"
		public static let subject: HTTPHeader.Key = "Subject"
		public static let summary: HTTPHeader.Key = "Summary"
		public static let supersedes: HTTPHeader.Key = "Supersedes"
		public static let tLSReportDomain: HTTPHeader.Key = "TLS-Report-Domain"
		public static let tLSReportSubmitter: HTTPHeader.Key = "TLS-Report-Submitter"
		public static let tLSRequired: HTTPHeader.Key = "TLS-Required"
		public static let to: HTTPHeader.Key = "To"
		public static let userAgent: HTTPHeader.Key = "User-Agent"
		public static let vBRInfo: HTTPHeader.Key = "VBR-Info"
		public static let x400ContentIdentifier: HTTPHeader.Key =
			"X400-Content-Identifier"
		public static let x400ContentReturn: HTTPHeader.Key = "X400-Content-Return"
		public static let x400ContentType: HTTPHeader.Key = "X400-Content-Type"
		public static let x400MTSIdentifier: HTTPHeader.Key = "X400-MTS-Identifier"
		public static let x400Originator: HTTPHeader.Key = "X400-Originator"
		public static let x400Received: HTTPHeader.Key = "X400-Received"
		public static let x400Recipients: HTTPHeader.Key = "X400-Recipients"
		public static let x400Trace: HTTPHeader.Key = "X400-Trace"
		public static let xrefcase: HTTPHeader.Key = "Xrefcase"
		/// Provisional Message Header Field Names
		public static let apparentlyTo: HTTPHeader.Key = "Apparently-To"
		public static let author: HTTPHeader.Key = "Author"
		public static let eDIINTFeatures: HTTPHeader.Key = "EDIINT-Features"
		public static let eesstVersion: HTTPHeader.Key = "Eesst-Version"
		public static let errorsTo: HTTPHeader.Key = "Errors-To"
		public static let formSub: HTTPHeader.Key = "Form-Sub"
		public static let jabberID: HTTPHeader.Key = "Jabber-ID"
		public static let mMHSAuthorizingUsers: HTTPHeader.Key =
			"MMHS-Authorizing-Users"
		public static let privicon: HTTPHeader.Key = "Privicon"
		public static let sIOLabel: HTTPHeader.Key = "SIO-Label"
		public static let sIOLabelHistory: HTTPHeader.Key = "SIO-Label-History"
		public static let xArchivedAt: HTTPHeader.Key = "X-Archived-At"
		public static let xMittente: HTTPHeader.Key = "X-Mittente"
		public static let xPGPSig: HTTPHeader.Key = "X-PGP-Sig"
		public static let xRicevuta: HTTPHeader.Key = "X-Ricevuta"
		public static let xRiferimentoMessageID: HTTPHeader.Key =
			"X-Riferimento-Message-ID"
		public static let xTipoRicevuta: HTTPHeader.Key = "X-TipoRicevuta"
		public static let xTrasporto: HTTPHeader.Key = "X-Trasporto"
		public static let xVerificaSicurezza: HTTPHeader.Key = "X-VerificaSicurezza"
	}
}

extension HTTPHeader.Key: Hashable, Codable, ExpressibleByStringLiteral,
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
