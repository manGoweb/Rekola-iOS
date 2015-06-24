//
//  Argo+RAC.swift
//  Rekola
//
//  Created by Petr Šíma on Jun/24/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Argo

struct ArgoErrors {
	static let domain = "ArgoErrorDomain"
	static let missingKeyErrorKey = "ArgoMissingKey"
	static let typeMismatchErrorKey = "ArgoTypeMismatch"
}

extension Decoded { //Argo errors
	var errorCode : Int {
		switch self {
		case .MissingKey(_): return 1404
		case .TypeMismatch(_): return 1400
		default: return 0
		}
	}
}

public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T,NSError> {
	return SignalProducer { sink, disposable in
		
		let decoded : Decoded<T> = decode(object)
		switch decoded {
		case .Success(let box):
			sendNext(sink, box.value)
			sendCompleted(sink)
		case .MissingKey(let k):
			let error = NSError(domain: ArgoErrors.domain, code: decoded.errorCode, userInfo: [ArgoErrors.missingKeyErrorKey : k])
			sendError(sink, error)
		case .TypeMismatch(let t):
			let error = NSError(domain: ArgoErrors.domain, code: decoded.errorCode, userInfo: [ArgoErrors.missingKeyErrorKey : t])
			sendError(sink, error)
		}
		
		
	}
}



public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<[T]?, NSError>  {
	return SignalProducer { sink, disposable in
		
		let decoded : Decoded<[T]> = decode(object)
		switch decoded {
		case .Success(let box):
			sendNext(sink, box.value)
			sendCompleted(sink)
		case .MissingKey(let k):
			let error = NSError(domain: ArgoErrors.domain, code: decoded.errorCode, userInfo: [ArgoErrors.missingKeyErrorKey : k])
			sendError(sink, error)
		case .TypeMismatch(let t):
			let error = NSError(domain: ArgoErrors.domain, code: decoded.errorCode, userInfo: [ArgoErrors.missingKeyErrorKey : t])
			sendError(sink, error)
		}
	}
	
}

public func rac_decodeByOne<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T, NSError>  {
	return SignalProducer { sink, disposable in
		
		let decoded : Decoded<[T]> = decode(object)
		switch decoded {
		case .Success(let box):
			for value in box.value {
				sendNext(sink, value)
			}
			sendCompleted(sink)
		case .MissingKey(let k):
			let error = NSError(domain: ArgoErrors.domain, code: decoded.errorCode, userInfo: [ArgoErrors.missingKeyErrorKey : k])
			sendError(sink, error)
		case .TypeMismatch(let t):
			let error = NSError(domain: ArgoErrors.domain, code: decoded.errorCode, userInfo: [ArgoErrors.missingKeyErrorKey : t])
			sendError(sink, error)
		}

	}
}
