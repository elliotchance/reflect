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

<<<<<<< HEAD
=======
	array_len int
	array_cap int
	array_elem_size int
	array voidptr

>>>>>>> 79bf144 (WIP)
pub:
	typ Type
}

// value_of is used to create a Value
pub fn value_of<T>(x T) Value {
	$if T is bool {
		return {
			typ: Type{Kind.is_bool}
			value_bool: x
		}
	}

	$if T is string {
		return {
			typ: Type{Kind.is_string}
			value_string: x
		}
	}

	$if T is i8 {
		return {
			typ: Type{Kind.is_i8}
			value_i8: x
		}
	}

	$if T is i16 {
		return {
			typ: Type{Kind.is_i16}
			value_i16: x
		}
	}

	$if T is int {
		return {
			typ: Type{Kind.is_int}
			value_int: x
		}
	}

	$if T is i64 {
		return {
			typ: Type{Kind.is_i64}
			value_i64: x
		}
	}

	$if T is byte {
		return {
			typ: Type{Kind.is_byte}
			value_byte: x
		}
	}

	$if T is u16 {
		return {
			typ: Type{Kind.is_u16}
			value_u16: x
		}
	}

	$if T is u32 {
		return {
			typ: Type{Kind.is_u32}
			value_u32: x
		}
	}

	$if T is u64 {
		return {
			typ: Type{Kind.is_u64}
			value_u64: x
		}
	}

	$if T is rune {
		return {
			typ: Type{Kind.is_rune}
			value_rune: x
		}
	}

	$if T is f32 {
		return {
			typ: Type{Kind.is_f32}
			value_f32: x
		}
	}

	$if T is f64 {
		return {
			typ: Type{Kind.is_f64}
			value_f64: x
		}
	}

	panic('unsupported value $x')
}

// array_of creates a Value from an array.
pub fn array_of<T>(x []T) Value {
	return Value{
		kind: Kind.is_array,
		array_len: x.len,
		array_cap: x.cap,
		array_elem_size: x.element_size,
		array: x.data,
	}
}

pub fn (v Value) len() int {
	v.must_be(Kind.is_array)
	return v.array_len
}

pub fn (v Value) cap() int {
	v.must_be(Kind.is_array)
	return v.array_cap
}

pub fn (v Value) get_index(index int) Value {
	v.must_be(Kind.is_array)

	if v.array_len < 0 || v.array_len <= index {
		panic('array index $index is out of bounds (len = ${v.array_len})')
	}

	v2 := Value{kind: Kind.is_int}
	unsafe {
		C.memcpy(&v2.value_int, voidptr(u64(v.array) + u64(index * v.array_elem_size)), v.array_elem_size)
	}

	return v2
}

fn (v Value) must_be(k Kind) {
	if v.typ.kind != k {
		panic('value must be $k but is $v.typ.kind')
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

// pub fn (v Value) get_type() Type {
// 	v.must_be(Kind.is_f64)
// 	return v.value_f64
// }
