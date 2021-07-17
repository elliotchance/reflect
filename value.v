module reflect

pub struct Value {
	// TODO(elliot): I know this is extremely wasteful. We'll come up with
	//  something more sane later.
	value_bool   bool
	value_string string
	value_i8     i8
	value_i16    i16
	value_int    int
	value_i64    i64
	value_byte   byte
	value_u16    u16
	value_u32    u32
	value_u64    u64
	value_rune   rune
	value_f32    f32
	value_f64    f64

	array_or_map_len int

	array_cap       int
	array_elem_size int

	map_keys   []Value
	map_values []Value
	// pointer to the array or map
	obj voidptr
pub:
	typ Type
}

// value_of is used to create a Value
pub fn value_of<T>(x T) Value {
	$if T is bool {
		return Value{
			typ: Type{Kind.is_bool, none_type(), none_type()}
			value_bool: x
		}
	}

	$if T is string {
		return Value{
			typ: Type{Kind.is_string, none_type(), none_type()}
			value_string: x
		}
	}

	$if T is i8 {
		return Value{
			typ: Type{Kind.is_i8, none_type(), none_type()}
			value_i8: x
		}
	}

	$if T is i16 {
		return Value{
			typ: Type{Kind.is_i16, none_type(), none_type()}
			value_i16: x
		}
	}

	$if T is int {
		return Value{
			typ: Type{Kind.is_int, none_type(), none_type()}
			value_int: x
		}
	}

	$if T is i64 {
		return Value{
			typ: Type{Kind.is_i64, none_type(), none_type()}
			value_i64: x
		}
	}

	$if T is byte {
		return Value{
			typ: Type{Kind.is_byte, none_type(), none_type()}
			value_byte: x
		}
	}

	$if T is u16 {
		return Value{
			typ: Type{Kind.is_u16, none_type(), none_type()}
			value_u16: x
		}
	}

	$if T is u32 {
		return Value{
			typ: Type{Kind.is_u32, none_type(), none_type()}
			value_u32: x
		}
	}

	$if T is u64 {
		return Value{
			typ: Type{Kind.is_u64, none_type(), none_type()}
			value_u64: x
		}
	}

	$if T is rune {
		return Value{
			typ: Type{Kind.is_rune, none_type(), none_type()}
			value_rune: x
		}
	}

	$if T is f32 {
		return Value{
			typ: Type{Kind.is_f32, none_type(), none_type()}
			value_f32: x
		}
	}

	$if T is f64 {
		return Value{
			typ: Type{Kind.is_f64, none_type(), none_type()}
			value_f64: x
		}
	}

	panic('unsupported value $x')
}

// array_of creates a Value from an array.
pub fn array_of<T>(x []T) Value {
	return Value{
		typ: parse_type(typeof(x).name) or { panic(err) }
		array_or_map_len: x.len
		array_cap: x.cap
		array_elem_size: x.element_size
		obj: x.data
	}
}

// map_of creates a Value from a map.
pub fn map_of<K, V>(x map[K]V) Value {
	mut keys := []Value{cap: x.len}
	mut values := []Value{cap: x.len}

	for k, v in x {
		keys << value_of(k)
		values << value_of(v)
	}

	return Value{
		typ: parse_type(typeof(x).name) or { panic(err) }
		array_or_map_len: x.len
		map_keys: keys
		map_values: values
	}
}

pub fn (v Value) len() int {
	v.must_be2(Kind.is_array, Kind.is_map)
	return v.array_or_map_len
}

pub fn (v Value) cap() int {
	v.must_be(Kind.is_array)
	return v.array_cap
}

pub fn (v Value) get_index(index int) Value {
	v.must_be(Kind.is_array)

	if v.array_or_map_len < 0 || v.array_or_map_len <= index {
		panic('array index $index is out of bounds (len = $v.array_or_map_len)')
	}

	v2 := Value{
		typ: *v.typ.elem
	}
	unsafe {
		dest := match v2.typ.kind {
			.is_bool { voidptr(&v2.value_bool) }
			.is_string { voidptr(&v2.value_string) }
			.is_i8 { voidptr(&v2.value_i8) }
			.is_i16 { voidptr(&v2.value_i16) }
			.is_int { voidptr(&v2.value_int) }
			.is_i64 { voidptr(&v2.value_i64) }
			.is_byte { voidptr(&v2.value_byte) }
			.is_u16 { voidptr(&v2.value_u16) }
			.is_u32 { voidptr(&v2.value_u32) }
			.is_u64 { voidptr(&v2.value_u64) }
			.is_rune { voidptr(&v2.value_rune) }
			.is_f32 { voidptr(&v2.value_f32) }
			.is_f64 { voidptr(&v2.value_f64) }
			// TODO(elliotchance): Doesn't support multidimensional arrays.
			else { voidptr(0) }
		}

		C.memcpy(dest, voidptr(u64(v.obj) + u64(index * v.array_elem_size)), v.array_elem_size)
	}
	return v2
}

fn (v Value) must_be(k Kind) {
	if v.typ.kind != k {
		panic('value must be $k but is $v.typ.kind')
	}
}

fn (v Value) must_be2(k1 Kind, k2 Kind) {
	if v.typ.kind != k1 && v.typ.kind != k2 {
		panic('value must be $k1 or $k2 but is $v.typ.kind')
	}
}

pub fn (v Value) get_bool() bool {
	v.must_be(Kind.is_bool)
	return v.value_bool
}

pub fn (v Value) get_string() string {
	v.must_be(Kind.is_string)
	return v.value_string
}

pub fn (v Value) get_i8() i8 {
	v.must_be(Kind.is_i8)
	return v.value_i8
}

pub fn (v Value) get_i16() i16 {
	v.must_be(Kind.is_i16)
	return v.value_i16
}

pub fn (v Value) get_int() int {
	v.must_be(Kind.is_int)
	return v.value_int
}

pub fn (v Value) get_i64() i64 {
	v.must_be(Kind.is_i64)
	return v.value_i64
}

pub fn (v Value) get_byte() byte {
	v.must_be(Kind.is_byte)
	return v.value_byte
}

pub fn (v Value) get_u16() u16 {
	v.must_be(Kind.is_u16)
	return v.value_u16
}

pub fn (v Value) get_u32() u32 {
	v.must_be(Kind.is_u32)
	return v.value_u32
}

pub fn (v Value) get_u64() u64 {
	v.must_be(Kind.is_u64)
	return v.value_u64
}

pub fn (v Value) get_rune() rune {
	v.must_be(Kind.is_rune)
	return v.value_rune
}

pub fn (v Value) get_f32() f32 {
	v.must_be(Kind.is_f32)
	return v.value_f32
}

pub fn (v Value) get_f64() f64 {
	v.must_be(Kind.is_f64)
	return v.value_f64
}

pub fn (v Value) get_key(key Value) Value {
	v.must_be(Kind.is_map)
	key.must_be(v.typ.key.kind)

	for i, k in v.map_keys {
		if k.eq(key) {
			return Value{
				typ: *v.typ.elem
				value_bool: v.map_values[i].value_bool
				value_string: v.map_values[i].value_string
				value_i8: v.map_values[i].value_i8
				value_i16: v.map_values[i].value_i16
				value_int: v.map_values[i].value_int
				value_i64: v.map_values[i].value_i64
				value_byte: v.map_values[i].value_byte
				value_u16: v.map_values[i].value_u16
				value_u32: v.map_values[i].value_u32
				value_u64: v.map_values[i].value_u64
				value_rune: v.map_values[i].value_rune
				value_f32: v.map_values[i].value_f32
				value_f64: v.map_values[i].value_f64
			}
		}
	}

	panic('key not found: $key')
}

fn (v Value) eq(v2 Value) bool {
	if v.typ.kind != v2.typ.kind {
		return false
	}

	return match v.typ.kind {
		.is_bool {
			v.value_bool == v2.value_bool
		}
		.is_string {
			v.value_string == v2.value_string
		}
		.is_i8 {
			v.value_i8 == v2.value_i8
		}
		.is_i16 {
			v.value_i16 == v2.value_i16
		}
		.is_int {
			v.value_int == v2.value_int
		}
		.is_i64 {
			v.value_i64 == v2.value_i64
		}
		.is_byte {
			v.value_byte == v2.value_byte
		}
		.is_u16 {
			v.value_u16 == v2.value_u16
		}
		.is_u32 {
			v.value_u32 == v2.value_u32
		}
		.is_u64 {
			v.value_u64 == v2.value_u64
		}
		.is_rune {
			v.value_rune == v2.value_rune
		}
		.is_f32 {
			v.value_f32 == v2.value_f32
		}
		.is_f64 {
			v.value_f64 == v2.value_f64
		}
		else {
			panic('cannot compare $v.str() and $v2.str()')
			false
		}
	}
}

fn (v Value) str() string {
	return match v.typ.kind {
		.is_bool { '$v.value_bool' }
		.is_string { '$v.value_string' }
		.is_i8 { '$v.value_i8' }
		.is_i16 { '$v.value_i16' }
		.is_int { '$v.value_int' }
		.is_i64 { '$v.value_i64' }
		.is_byte { '$v.value_byte' }
		.is_u16 { '$v.value_u16' }
		.is_u32 { '$v.value_u32' }
		.is_u64 { '$v.value_u64' }
		.is_rune { '$v.value_rune' }
		.is_f32 { '$v.value_f32' }
		.is_f64 { '$v.value_f64' }
		// TODO(elliotchance): We should print arrays and maps
		else { '<Value:$v.typ.kind>' }
	}
}

pub fn (v Value) keys() []Value {
	v.must_be(Kind.is_map)
	return v.map_keys
}
