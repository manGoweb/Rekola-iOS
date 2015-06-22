//
//  RACHelpers.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import ReactiveCocoa
import Argo

public func ignoreError<T, E>(signalProducer: SignalProducer<T, E>) -> SignalProducer<T, NoError> {
    return signalProducer
        |> catch { _ in
            SignalProducer<T, NoError>.empty
        }
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals)
        |> flatten(.Merge)
}

public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T,NSError> {
    return SignalProducer { sink, disposable in
        
        let user : T? = decode(object).value
        
        if let user = user {
            sendNext(sink, user)
            sendCompleted(sink)
        } else {
            sendError(sink, NSError())
        }
        
        
    }
}



public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<[T]?, NSError>  {
    return SignalProducer { sink, disposable in
        
        let user : [T]? = decode(object)
        
        if let user = user {
            sendNext(sink, user)
            sendCompleted(sink)
        } else {
            sendError(sink, NSError())
        }
        
        
    }
    
}

public func rac_decodeByOne<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T, NSError>  {
    return SignalProducer { sink, disposable in
        
        let user : [T]? = decode(object).value
        if let user = user {
            for u in user {
                sendNext(sink, u)
            }
            sendCompleted(sink)
        } else {
            sendError(sink, NSError())
        }
    }
}
