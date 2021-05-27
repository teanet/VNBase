import Foundation
import CommonCrypto

public extension String {

	var MD5: Data {
		let messageData = self.data(using:.utf8)!
		var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
		_ = digestData.withUnsafeMutableBytes { digestBytes in
			messageData.withUnsafeBytes { messageBytes in
				CC_MD5(messageBytes.baseAddress, CC_LONG(messageData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
			}
		}
		return digestData
	}

	var SHA1: Data {
		let data = Data(self.utf8)
		var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
		data.withUnsafeBytes {
			_ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
		}
		return data
	}

	var MD5String: String {
		return self.MD5.map { String(format: "%02hhx", $0) }.joined()
	}

	var SHA1String: String {
		return self.SHA1.map { String(format: "%02hhx", $0) }.joined()
	}

}
