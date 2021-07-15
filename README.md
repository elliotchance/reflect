elliotchance.reflect
====================

Runtime reflection for [V](https://vlang.io).

V does not carry runtime information about types. Although compile-time
reflection is more performant it can be limiting in some cases that can't be
avoided.

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

	println(v.kind)        // "f64"
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
		match item.kind {
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
