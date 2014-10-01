Set (Swift)
===
This is a basic Set implementation using Swift.

Set in swift are an unordered collection of unique elements. Every element must be conform to **Hashable** protocol and nothing else.

## Hidden feature? Nope
Swift will behave strangely when you try to put different type of objects together as literal sequence.

You can initialize a Set with different type of objects (say String and Int)

	var x = Set(["string", 1])

in this case `x` will became a `Set<NSObject>` but if you do like this:

	var x = [1, 1.2] // This became an NSArray
	var y = Set(x) // Error
	var k = Set([1, 1.2]) // This became a Set<Int> equal to Set(1)
	var w = Set([1.0, 1.2]) // This became a Set<Float> equal to Set(1.0, 1.2)

as you can see in `k`, Swift automatically convert Double to Int

I'm looking for a solution (basically lock same type for sequence arguments) but keep this bug in mind
## Basic usage

	var a : Set<Int>
	var b = Set<Int>()
	var c = Set([1,2]) // Any SequenceType as argument
	
	c.contain(1) // Return: true
	c.contain(2) // Return: false
	c.add(3) // Return: 3
	c.add(2) // Return: nil
	c.addSequence([3,4]) // Return: [4] (3 was already present)
	c.remove(4) // Return: 4
	c.remove(4) // Return: nil
	c.removeSequence([2,4]) // Return: [2] (4 was already missing)

## Supported set operations

	var a = Set([1,2])
	var b = Set([2,3])
	var c = Set([3,4])

* Union
		
		// Func
		var x = Sets.union(a,b,c)
		
		// Binary
		var y = (a | b | c)
		

* Difference

		// Func
		var x = Sets.difference(a,b,c)
		
		// Binary
		var y = (a - b - c)

* Intersection

		// Func
		var x = Sets.interserction(a,b,c)
		
		// Binary
		var y = (a & b & c)