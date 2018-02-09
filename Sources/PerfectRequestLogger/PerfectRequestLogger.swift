import PerfectLib
import PerfectCrypto
import PerfectHTTP
import PerfectNet
import PerfectLogger

#if os(Linux)
	import LinuxBridge
#else
	import Darwin
#endif

extension String {
  public init(randomAlphaNumericLength: Int) {
    let array = Array<UInt8>(randomCount: randomAlphaNumericLength)
    var u:[UInt8] = array.map { ch in
      let m = ch % 62
      let (x, y) = m < 10 ? ("0", m) : ( m < 36 ? ("a", m - 10) : ("A", m - 36) )
      return UInt8(UnicodeScalar(x)?.value ?? 0) + y
    }
    u.append(0)
    self = String(cString: u)
  }
}

/// Contains the location of the default log file.
public struct RequestLogFile {
	private init(){}
	/// Holds the location of the log file.
	public static var location = "/var/log/perfectLog.log"
}


/// The main class for logging functionality
open class RequestLogger: HTTPRequestFilter, HTTPResponseFilter {

	let defaultLogFile = RequestLogFile.location

	let randomID: String
	var sequence: UInt32

	/// The initializer.
	public init() {
		// Generate random string to prefix request IDs
		randomID = String(randomAlphaNumericLength: 8)
		// Initialize a request count
		sequence = 0
	}

	/// Implementation of the HTTPRequestFilter
	open func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {

		// Store request start time
		request.scratchPad["start"] = getNow()

		// Store a unique request ID, this can be used in other logging to correlate to the request log
		sequence += 1
		request.scratchPad["requestID"] = "\(randomID)-\(sequence)"

		callback(.continue(request, response))
	}

	/// Implement of the HTTPResponseFilter
	open func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
		let hostname = response.request.serverName
		let requestID = response.request.scratchPad["requestID"] as? String ?? "NoRequestID"
		let method = response.request.method
		let requestURL = response.request.uri
		let remoteAddress = response.request.remoteAddress.host
		let start = response.request.scratchPad["start"] as? Double ?? getNow()
		let protocolVersion = response.request.protocolVersion
		let status = response.status.code
		let length = response.bodyBytes.count
		let requestProtocol = response.request.connection is PerfectNet.NetTCPSSL ? "HTTPS" : "HTTP"

		let interval = Int(getNow() - start)
    let started = (try? formatDate(start, format: "%Y-%m-%d %H:%M:%S %Z")) ?? "1970-01-01 00:00:00 UTC"

		var useFile = RequestLogFile.location
		if useFile.isEmpty { useFile = "/var/log/perfectLog.log" }

		LogFile.info("[\(hostname)/\(requestID)] \(started) \"\(method) \(requestURL) \(requestProtocol)/\(protocolVersion.0).\(protocolVersion.1)\" from \(remoteAddress) - \(status) \(length)B in \(interval)ms", logFile: useFile)

		callback(.continue)
	}

	/// Wrapper enabling PerfectHTTP 2.1 filter support
	open static func filterAPIRequest(data: [String:Any]) throws -> HTTPRequestFilter {
		return RequestLogger()
	}
	/// Wrapper enabling PerfectHTTP 2.1 filter support
	open static func filterAPIResponse(data: [String:Any]) throws -> HTTPResponseFilter {
		return RequestLogger()
	}

	/// Implement of the HTTPResponseFilter
	open func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
		callback(.continue)
	}
}
