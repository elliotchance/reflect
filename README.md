elliotchance.reflect
====================

Runtime reflection for [V](https://vlang.io).

V does not carry runtime information about types. Although compile-time
reflection is more performant it can be limiting in some cases that can't be
avoided.

- [Installation](#installation)
- [Values](#values)
- [Types](#types)

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
- `.str()`: The string representation that matches the compile-time type in V.
