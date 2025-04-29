

import SwiftUI
import Combine


private let USER_DEFAULTS = UserDefaults.standard


//@propertyWrapper
//struct ValueSubject<Value> {
//    let defaultValue: Value
//    private var publisher: CurrentValueSubject<Value, Never>!
//    
//    init(defaultValue: Value) {
//        self.defaultValue = defaultValue
//        self.publisher = CurrentValueSubject<Value, Never>(defaultValue)
//    }
//
//    var wrappedValue: Value {
//        get {
//            publisher.value
//        }
//        set {
//            publisher.send(newValue)
//        }
//    }
//    
//    var projectedValue: CurrentValueSubject<Value, Never> {
//        publisher
//    }
//}


@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults
    private var publisher: CurrentValueSubject<Value, Never>!
    
    init(key: String,
         defaultValue: Value,
         container: UserDefaults = USER_DEFAULTS) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
        self.publisher = CurrentValueSubject<Value, Never>(wrappedValue)
    }

    var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
            container.synchronize()
            publisher.send(newValue)
        }
    }
    
    var projectedValue: CurrentValueSubject<Value, Never> {
        publisher
    }
}
//
//@propertyWrapper
//struct CodableUserDefault<Value: Codable> {
//    let key: String
//    let defaultValue: Value
//    var container: UserDefaults = USER_DEFAULTS
//
//    var wrappedValue: Value {
//        get {
//            let decoder = JSONDecoder()
//            guard let data = container.value(forKey: key) as? Data else { return defaultValue }
//            let obj = try? decoder.decode(Value.self, from: data)
//            return obj ?? defaultValue
//        }
//        set {
//            let encoder = JSONEncoder()
//            let data = try? encoder.encode(newValue)
//            container.set(data, forKey: key)
//            container.synchronize()
//        }
//    }
//}
//
//@propertyWrapper
//class ArrayUserDefault<Value: Codable & Equatable>: Sequence, MutableCollection {
//    let key: String
//    let defaultValue: [Value]
//    var container: UserDefaults
//    let publisher: CurrentValueSubject<[Value], Never>
//    
//    init(key: String, defaultValue: [Value], container: UserDefaults = USER_DEFAULTS) {
//        self.key = key
//        self.defaultValue = defaultValue
//        self.container = container
//        self.publisher = CurrentValueSubject(defaultValue)
//    }
//
//    var wrappedValue: [Value] {
//        get {
//            guard let data = container.data(forKey: key),
//            let array = try? JSONDecoder().decode([Value].self, from: data) else { return defaultValue }
//            
//            return array
//        }
//        set {
//            do {
//                let encodedData = try JSONEncoder().encode(newValue)
//                container.set(encodedData, forKey: key)
//                container.synchronize()
//                publisher.send(newValue)
//            } catch {
//                print("Ошибка кодирования: \(error)")
//            }
//        }
//    }
//    
//    var projectedValue: ArrayUserDefault<Value> {
//        self
//    }
//    
//    func makeIterator() -> Array<Value>.Iterator {
//        wrappedValue.makeIterator()
//    }
//
//    typealias Index = Int
//    typealias Element = Value
//
//    var startIndex: Int {
//        wrappedValue.startIndex
//    }
//
//    var endIndex: Int {
//        wrappedValue.endIndex
//    }
//
//    func index(after i: Int) -> Int {
//        wrappedValue.index(after: i)
//    }
//
//    subscript(position: Int) -> Value {
//        get {
//            return wrappedValue[position]
//        }
//        set {
//            var currentArray = wrappedValue
//            currentArray[position] = newValue
//            wrappedValue = currentArray 
//        }
//    }
//    
//    func swapAt(_ i: Int, _ j: Int) {
//        var array = wrappedValue
//        array.swapAt(i, j)
//        wrappedValue = array
//    }
//}
