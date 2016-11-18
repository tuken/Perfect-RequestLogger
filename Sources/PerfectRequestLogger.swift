import PerfectLib
import PerfectHTTP
import PerfectNet
import SwiftMoment
import PerfectLogger
import SwiftRandom

#if os(Linux)
	import LinuxBridge
#else
	import Darwin
#endif

public struct RequestLogFile {
	private init(){}
	public static var location = "/var/log/perfectLog.log"
}

public class RequestLogger: HTTPRequestFilter, HTTPResponseFilter {

	var defaultLogFile = RequestLogFile.location

	var randomID: String
	var sequence: UInt32

	public init() {
		// Generate random string to prefix request IDs
		randomID = Randoms.randomAlphaNumericString(length: 8)
		// Initialize a request count
		sequence = 0
	}

	// Returns the current time according to ICU
	// ICU dates are the number of milliseconds since the reference date of Thu, 01-Jan-1970 00:00:00 GMT
	func getNow() -> Double {

		var posixTime = timeval()
		gettimeofday(&posixTime, nil)
		return Double((posixTime.tv_sec * 1000) + (Int(posixTime.tv_usec)/1000))
	}

	// Implement HTTPRequestFilter
	public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {

		// Store request start time
		request.scratchPad["start"] = getNow()

		// Store a unique request ID, this can be used in other logging to correlate to the request log
		sequence += 1
		request.scratchPad["requestID"] = "\(randomID)-\(sequence)"

		callback(.continue(request, response))
	}

	// Implement HTTPResponseFilter
	public func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
		let hostname = response.request.serverName
		let requestID = response.request.scratchPad["requestID"] as! String
		let method = response.request.method
		let requestURL = response.request.uri
		let remoteAddress = response.request.remoteAddress.host
		let start = response.request.scratchPad["start"] as! Double
		let protocolVersion = response.request.protocolVersion
		let status = response.status.code
		let length = response.bodyBytes.count
		let requestProtocol = response.request.connection is PerfectNet.NetTCPSSL ? "HTTPS" : "HTTP"

		let interval = Int(self.getNow() - start)
		let started = moment(start/1000)

		var useFile = RequestLogFile.location
		if useFile.isEmpty { useFile = "/var/log/perfectLog.log" }

		LogFile.info("[\(hostname)/\(requestID)] \(started) \"\(method) \(requestURL) \(requestProtocol)/\(protocolVersion.0).\(protocolVersion.1)\" from \(remoteAddress) - \(status) \(length)B in \(interval)ms", logFile: useFile)

		callback(.continue)
	}

	// Implement HTTPResponseFilter
	public func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
		callback(.continue)
	}
}
