//
//  Combine+Extensions.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation
import SwiftUI
import Combine

extension Binding {
    func map<MappedValue>(
        valueToMappedValue: @escaping (Value) -> MappedValue,
        mappedValueToValue: @escaping (MappedValue) -> Value
    ) -> Binding<MappedValue> {
        Binding<MappedValue>.init { () -> MappedValue in
            return valueToMappedValue(wrappedValue)
        } set: { mappedValue in
            wrappedValue = mappedValueToValue(mappedValue)
        }
    }

    func onSet(_ action: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding { () -> Value in
            return wrappedValue
        } set: { value in
            action(value)
            wrappedValue = value
        }
    }
}

extension Publisher where Failure == Never {
    public func sinkOnMain(
        receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
            receive(on: RunLoop.main)
                .sink(receiveValue: receiveValue)
        }
}

extension Publisher {
    public func sinkOnMain(
        receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void)) -> AnyCancellable {
            receive(on: RunLoop.main)
                .sink(receiveCompletion: receiveCompletion, receiveValue: {_ in})
        }
}

extension Publisher {
    public func sinkOnMain(
        receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void),
        receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
            receive(on: RunLoop.main)
                .sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
        }
}
