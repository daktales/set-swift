//
//  Set.swift
//  baclavios
//
//  Created by Walter Da Col on 30/09/14.
//  Copyright (c) 2014 Walter Da Col. All rights reserved.
//

import Foundation

struct Set<SetElement:Hashable>: SequenceType{
    // Real hidden structure
    private var elements : [SetElement : SetElement] = [:]

    /// How many elements the `Set` stores.
    var count : Int { get { return self.elements.count }}
    /// `true` if and only if the `Set` is empty.
    var isEmpty : Bool { get { return self.count == 0 }}
    /// An `Array`, created on demand, containing the element of this `Set`
    var array : [SetElement] { get { return self.elements.keys.array }}

    func generate() -> GeneratorOf<SetElement> {
        var generator = self.elements.keys.generate()
        return GeneratorOf {
            return generator.next()
        }
    }

    // Initializer

    init(){}

    init<E : SequenceType where E.Generator.Element == SetElement>(_ sequence: E){
        self.init()
        self.addSequence(sequence)
    }

    /**
    Add newElement to the `Set`

    :param: newElement the element

    :returns: newElement if the element did not exist, `nil` otherwise
    */
    mutating func add(newElement:SetElement) -> SetElement? {
        return (self.elements.updateValue(newElement, forKey: newElement) == nil) ? newElement : nil
    }

    /**
    Add all elements contained in sequence to the `Set`

    :param: sequence the sequence

    :returns: an `Array` of added elements
    */
    mutating func addSequence<E : SequenceType where E.Generator.Element == SetElement>(sequence: E) -> [SetElement]{
        var result:[SetElement] = []
        for element in [SetElement](sequence) {
            if self.add(element) != nil{
                result.append(element)
            }
        }
        return result
    }

    /**
    Remove a given element from the `Set`

    :param: element the element

    :returns: the removed element
    */
    mutating func remove(element:SetElement) -> SetElement? {
        return self.elements.removeValueForKey(element)
    }

    /**
    Remove a given sequence of elements from the `Set`

    :param: sequence the sequence

    :returns: the removed elements
    */
    mutating func removeSequence<E : SequenceType where E.Generator.Element == SetElement>(sequence: E) -> [SetElement]{
        var result:[SetElement] = []

        for element in [SetElement](sequence) {
            if let x = self.remove(element) {
                result.append(x)
            }
        }
        return result
    }

    /**
    Returns `true` if and only if `Set` contain the given element

    :param: element the element

    :returns: `true` if and only if `Set` contain the given element
    */
    func contain(element:SetElement) -> Bool {
        return self.elements.indexForKey(element) != nil
    }

    /**
    Returns the union between multiple `Set`

    :param: sets a variable list of sets

    :returns: the union between given sets
    */
    static func union(sets: Set<SetElement>...) -> Set<SetElement> {
        var result = Set<SetElement>()
        for set in sets {
            result.addSequence(set.elements.keys)
        }
        return result
    }

    /**
    Returns the difference between multiple `Set`

    :param: sets a variable list of sets

    :returns: the difference between given sets
    */
    static func difference(sets: Set<SetElement>...) -> Set<SetElement> {
        var result = sets.first ?? Set<SetElement>()
        if sets.count < 2 { return result }

        for set in sets[1..<sets.count] {
            result.removeSequence(set.elements.keys)
        }
        return result
    }

    /**
    Returns the intersection between multiple `Set`

    :param: sets a variable list of sets

    :returns: the intersection between given sets
    */
    static func intersection(sets: Set<SetElement>...) ->Set<SetElement> {
        var sortedSets = sets.sorted { return $0.count < $1.count }
        var result = sortedSets.first ?? Set<SetElement>()
        if sets.count < 2 { return result }

        for set in sets[1..<sets.count] {
            var contained = Set<SetElement>()
            for element in result.elements.keys {
                if set.elements.indexForKey(element) != nil {
                    contained.add(element)
                }
            }
            result = contained
        }
        return result
    }
}

// Hashable protocol
extension Set : Hashable {
    var hashValue: Int { get {
        return self.array.map { $0.hashValue } .reduce(0, +)
        }
    }
}
// Equatable
func == <SetElement>(lhs:Set<SetElement>, rhs:Set<SetElement>) -> Bool {
    return lhs.elements.keys.array == rhs.elements.keys.array
}

// Binary operators
func | <SetElement>(lhs:Set<SetElement>, rhs:Set<SetElement>) -> Set<SetElement> {
    return Set.union(lhs, rhs)
}

func - <SetElement>(lhs:Set<SetElement>, rhs:Set<SetElement>) -> Set<SetElement> {
    return Set.difference(lhs, rhs)
}

func & <SetElement>(lhs:Set<SetElement>, rhs:Set<SetElement>) -> Set<SetElement> {
    return Set.intersection(lhs, rhs)
}

// Print protocols
extension Set : Printable, DebugPrintable {
    private var SEPARATOR : String { get { return ", " }}
    var description: String { get {return self.isEmpty ? "Set()" : "Set( \(join(SEPARATOR, map(self){toString($0)})) )" }}
    var debugDescription: String { get {return self.isEmpty ? "Set()" : "Set( \(join(SEPARATOR, map(self){toString($0)})) )" }}
}