//
//  SetSwiftTests.swift
//  SetSwiftTests
//
//  Created by Walter Da Col on 01/10/14.
//  Copyright (c) 2014 Walter Da Col. All rights reserved.
//

import UIKit
import XCTest
import SetSwift

class SetSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSyntax() {
        let type = Set<Int>.self
    }

    func testInit() {
        var a = Set<Int>()

        var array : [Int] = []
        let b : Set<Int> = Set(array)
        XCTAssertEqual(a,b, "Inits fail")

        var c = Set([1,1,1])
        XCTAssertEqual(c, Set([1]), "Set.init fail")
    }

    func testEquality () {
        var a = Set([UINT64_MAX,UINT64_MAX-1])
        var b = Set([UINT64_MAX-1,UINT64_MAX])

        XCTAssertEqual(a,b, "Equal fail")
        XCTAssertEqual(a.hashValue,b.hashValue, "Hash fail")

    }

    func testAdd() {
        var a = Set<Int>()

        var r = a.add(1)
        XCTAssertEqual(a, Set([1]), "Set.add() fail")
        XCTAssert(r == 1, "Set.add() fail")

        r = a.add(1)
        XCTAssertEqual(a, Set([1]), "Set.add() fail")
        XCTAssert(r == nil, "Set.add() fail")

        var rs = a.addSequence([1,1,1])
        XCTAssertEqual(a, Set([1]), "Set.addSequence() fail")
        XCTAssertEqual(rs, [], "Set.addSequence() fail")

        rs = a.addSequence([2,2,3])
        XCTAssertEqual(a, Set([1,2,3]), "Set.addSequence() fail")
        XCTAssertEqual(rs, [2,3], "Set.addSequence() fail")
    }

    func testRemove() {
        var a = Set([1,2,3])

        var r = a.remove(1)
        XCTAssertEqual(a, Set([2,3]), "Set.remove() fail")
        XCTAssert(r == nil ? false : (r! == 1 ? true : false), "Set.remove() fail")

        r = a.remove(1)
        XCTAssertEqual(a, Set([2,3]), "Set.remove() fail")
        XCTAssert(r == nil ? true : false, "Set.remove() fail")

        var rs = a.removeSequence([1,1,1])
        XCTAssertEqual(a, Set([2,3]), "Set.removeSequence() fail")
        XCTAssertEqual(rs, [], "Set.removeSequence() fail")

        rs = a.removeSequence([2,2,3])
        XCTAssertEqual(a, Set<Int>([]), "Set.addSequence() fail")
        XCTAssertEqual(rs, [2,3], "Set.removeSequence() fail")
    }

    func testContain() {
        var a = Set([1,2,3])
        var b : Set<Int> = Set()

        XCTAssert(a.contain(1), "Set.contain() fail")
        XCTAssert(!a.contain(4), "Set.contain() fail")
        XCTAssert(!b.contain(1), "Set.contain() fail")
    }

    func testUnion() {
        var a = Set([1,2])
        var b = Set([2,3])
        var c = Set([4,5])

        XCTAssertEqual(Set.union(a,b), Set([1,2,3]), "Set.union() fail")
        XCTAssertEqual(Set.union(a,b,c), Set([1,2,3,4,5]), "Set.union() fail")
        XCTAssertEqual(Set.union(a,b), Set.union(b,a), "Set.union() fail")
        XCTAssertEqual(Set.union(a, Set.union(b,c)), Set.union(Set.union(a,b), c), "Set.union() fail")
        // A c (A u B)
        XCTAssert(a.array.map { Set.union(a,b).contain($0) } .reduce(true, {$0 & $1}) == true, "Set.union() fail")
        XCTAssertEqual(Set.union(a,a), a, "Set.union() fail")
        XCTAssertEqual(Set.union(a,Set<Int>()), a, "Set.union() fail")

        XCTAssertEqual(a | b, Set([1,2,3]), "Set.union() fail")
        XCTAssertEqual(a | b | c, Set([1,2,3,4,5]), "Set.union() fail")
        XCTAssertEqual(a | b, Set.union(b,a), "Set.union() fail")
        XCTAssertEqual(a|(b|c), (a|b)|c, "Set.union() fail")
        // A c (A u B)
        XCTAssert(a.array.map { (a|b).contain($0) } .reduce(true, {$0 & $1}) == true, "Set.union() fail")
        XCTAssertEqual(a|a, a, "Set.union() fail")
        XCTAssertEqual((a|Set<Int>()), a, "Set.union() fail")
    }

    func testDifference() {
        var a = Set([1,2])
        var b = Set([2,3])
        var c = Set([4,5])

        XCTAssertEqual(Set.difference(a,b), Set([1]), "Set.difference() fail")
        XCTAssertEqual(Set.difference(a,c), Set([1,2]), "Set.difference() fail")
        XCTAssertEqual(Set.difference(a,b,c), Set([1]), "Set.difference() fail")
        XCTAssertNotEqual(Set.difference(a,b),Set.difference(b,a),"Set.difference() fail")
        XCTAssertEqual(Set.difference(a,a),Set<Int>(),"Set.difference() fail")

        XCTAssertEqual(a - b, Set([1]), "Set.difference() fail")
        XCTAssertEqual(a - c, Set([1,2]), "Set.difference() fail")
        XCTAssertEqual(a - b - c, Set([1]), "Set.difference() fail")
        XCTAssertNotEqual(a - b,b - a,"Set.difference() fail")
        XCTAssertEqual(a - a,Set<Int>(),"Set.difference() fail")

    }
    func testIntersection() {
        var a = Set([1,2])
        var b = Set([2,3])
        var c = Set([4,5])
        var d = Set([2])

        XCTAssertEqual(Set.intersection(a,b),Set([2]),"Set.intersection() fail")
        XCTAssertEqual(Set.intersection(a,c),Set<Int>(),"Set.intersection() fail")
        XCTAssertEqual(Set.intersection(a,b,c),Set<Int>(),"Set.intersection() fail")
        XCTAssertEqual(Set.intersection(a,b,d),Set([2]),"Set.intersection() fail")
        XCTAssertEqual(Set.intersection(a,b),Set.intersection(b,a),"Set.intersection() fail")
        XCTAssertEqual(Set.intersection(a,Set.intersection(b,c)),Set.intersection(Set.intersection(a,b),c),"Set.intersection() fail")
        // A  int B c A
        XCTAssert(Set.intersection(a,b).array.map { a.contain($0) } .reduce(true, {$0 & $1}) == true, "Set.intersection() fail")
        XCTAssertEqual(Set.intersection(a,a),a,"Set.intersection() fail")
        XCTAssertEqual(Set.intersection(a,Set<Int>()),Set<Int>(),"Set.intersection() fail")

        XCTAssertEqual(a & b,Set([2]),"Set.intersection() fail")
        XCTAssertEqual(a & c,Set<Int>(),"Set.intersection() fail")
        XCTAssertEqual(a & b & c,Set<Int>(),"Set.intersection() fail")
        XCTAssertEqual(a & b & d,Set([2]),"Set.intersection() fail")
        XCTAssertEqual(a & b,b & a,"Set.intersection() fail")
        XCTAssertEqual((a & (b & c)),((a&b)&c),"Set.intersection() fail")
        // A  int B c A
        XCTAssert((a & b).array.map { a.contain($0) } .reduce(true, {$0 & $1}) == true, "Set.intersection() fail")
        XCTAssertEqual(a & a,a,"Set.intersection() fail")
        XCTAssertEqual((a & Set<Int>()),Set<Int>(),"Set.intersection() fail")
    }

    func testCount() {
        var a = Set([1,2,3,4])
        var b = Set<Int>()

        XCTAssertEqual(a.count,4,"Set.count() fail")
        XCTAssertEqual(b.count,0,"Set.count() fail")
    }

    func testEmpty() {
        var a = Set([1,2,3,4])
        var b = Set<Int>()

        XCTAssert(a.isEmpty == false, "Set.isEmpty() fail")
        XCTAssert(b.isEmpty, "Set.isEmpty() fail")

    }

    func testArray() {
        var a = Set([1,2,3,4])
        var b = Set<Int>()

        XCTAssertEqual(a.array,[1,2,3,4],"Set.array fail")
        XCTAssertEqual(b.array,Array<Int>([]),"Set.array fail")
    }
}
