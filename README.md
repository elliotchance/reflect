elliotchance.reflect
====================

Runtime reflection for [V](https://vlang.io).

V does not carry runtime information about types. Although compile-time
reflection is more performant it can be limiting in some cases that can't be
avoided.

*IMPORTANT: This project is more to demonstrate that a lot of the runtime
reflection functionality one might need can be done without technically using
runtime types. This implementation relies on static code being generated from
compile-time reflection for known types going into the appropriate
constructors.*

- [Installation](#installation)
- [Values](#values)
- [Types](#types)
- [Arrays](#arrays)
- [Maps](#maps)
- [Structs](#structs)

Installation
------------

```bash
v install elliotchance.reflect
```

Values
------

A `Value` can be created from any literal or simple value, for example:

```v
import elliotchance.reflect

fn main() {
	v := reflect.value_of(1.23)

	println(v.typ)         // "f64"
	println(v.get_f64())   // 1.23
	println(v.get_int())   // V panic: value must be int but is f64
}
```

This becomes especially useful when dealing with arrays of mixed types:

```v
// Only sum numbers.
fn sum(items []reflect.Value) f64 {
	mut total := 0.0

	for item in items {
		match item.typ.kind {
			.is_f64 { total += item.get_f64() }
			.is_int { total += item.get_int() }
			else { /* ignore */ }
		}
	}

	return total
}

fn main() {
	v := [
		reflect.value_of(1.23),
		reflect.value_of("hello"),
		reflect.value_of(7),
	]
	println(sum(v)) // 8.23
}
```

Types
-----

All `Values` have a `Type` which can be accessed on the `.typ` field.

- `.kind`: one of the `Kind` values: `is_bool`, `is_string`, `is_i8`, `is_i16`,
`is_int`, `is_i64`, `is_byte`, `is_u16`, `is_u32`, `is_u64`, `is_rune`,
`is_f32`, `is_f64`.
- `.elem`: Only applies for arrays, describes the element type.
- `.str()`: The string representation that matches the compile-time type in V.

Arrays
------

```v
import elliotchance.reflect

fn main() {
	v := reflect.array_of([5, 6, 7])

	println(v.typ)                      // "[]int"
	println(v.typ.kind)                 // "array"
	println(v.typ.elem.kind)            // "int"
	println(v.len())                    // 3
	println(v.cap())                    // 3
	println(v.get_index(1).get_int())   // 6
	println(v.get_index(5))             // V panic: array index 5 is out of bounds (len = 3)
}
```

Maps
----

```v
import elliotchance.reflect

fn main() {
	mut m := map[string]int{}
	m['a'] = 5
	m['b'] = 7
	m['c'] = 9

	v := reflect.map_of(m)

	println(v.typ)                                        // "map[string]int"
	println(v.typ.kind)                                   // "map"
	println(v.typ.key.kind)                               // "string"
	println(v.typ.elem.kind)                              // "int"
	println(v.len())                                      // 3
	println(v.keys())                                     // ['a', 'b', 'c']
	println(v.get_key(reflect.value_of('b')).get_int())   // 7
	println(v.get_key(reflect.value_of('d')))             // V panic: key not found: d
	println(v.get_key(reflect.value_of(123)))             // V panic: value must be string but is int
}
```

Structs
-------

```v
import elliotchance.reflect

struct Foo {
	a int
	b f64
	c string
}

fn main() {
	s := Foo{123, 4.56, 'hello'}
	v := reflect.struct_of(&s)

	println(v.typ)                    // "main.Foo"
	println(v.typ.kind)               // "struct"
	println(v.fields())               // ['a', 'b', 'c']
	println(v.field('b').typ)         // "f64"
	println(v.field('b').get_f64())   // 4.56
	println(v.field('d'))             // V panic: field not found: d

	v.field('b').set_string('hi')     // V panic: value must be f64 but is string

	v.field('c').set_string('hi')
	println(v.field('c').get_string()) // "hi"
	println(s.c)                       // "hi"
}
```
