module reflect

union Val {
	bool   bool
	string string
	i8     i8
	i16    i16
	int    int
	i64    i64
	byte   byte
	u16    u16
	u32    u32
	u64    u64
	rune   rune
	f32    f32
	f64    f64
}

pub struct Value {
mut:
	value Val

	array_or_map_len int

	array_cap       int
	array_elem_size int

	map_keys   []Value
	map_values []Value
	// structs
	f  map[string]voidptr
	ft map[string]Type
	// pointer to the array, map or struct
	obj voidptr
pub:
	typ Type
}

// value_of is used to create a Value
pub fn value_of<T>(x T) Value {
	$if T is bool {
		return Value{
			typ: Type{Kind.is_bool, none_type(), none_type(), ''}
			value: Val{
				bool: x
			}
		}
	}

	$if T is string {
		return Value{
			typ: Type{Kind.is_string, none_type(), none_type(), ''}
			value: Val{
				string: x
			}
		}
	}

	$if T is i8 {
		return Value{
			typ: Type{Kind.is_i8, none_type(), none_type(), ''}
			value: Val{
				i8: x
			}
		}
	}

	$if T is i16 {
		return Value{
			typ: Type{Kind.is_i16, none_type(), none_type(), ''}
			value: Val{
				i16: x
			}
		}
	}

	$if T is int {
		return Value{
			typ: Type{Kind.is_int, none_type(), none_type(), ''}
			value: Val{
				int: x
			}
		}
	}

	$if T is i64 {
		return Value{
			typ: Type{Kind.is_i64, none_type(), none_type(), ''}
			value: Val{
				i64: x
			}
		}
	}

	$if T is byte {
		return Value{
			typ: Type{Kind.is_byte, none_type(), none_type(), ''}
			value: Val{
				byte: x
			}
		}
	}

	$if T is u16 {
		return Value{
			typ: Type{Kind.is_u16, none_type(), none_type(), ''}
			value: Val{
				u16: x
			}
		}
	}

	$if T is u32 {
		return Value{
			typ: Type{Kind.is_u32, none_type(), none_type(), ''}
			value: Val{
				u32: x
			}
		}
	}

	$if T is u64 {
		return Value{
			typ: Type{Kind.is_u64, none_type(), none_type(), ''}
			value: Val{
				u64: x
			}
		}
	}

	$if T is rune {
		return Value{
			typ: Type{Kind.is_rune, none_type(), none_type(), ''}
			value: Val{
				rune: x
			}
		}
	}

	$if T is f32 {
		return Value{
			typ: Type{Kind.is_f32, none_type(), none_type(), ''}
			value: Val{
				f32: x
			}
		}
	}

	$if T is f64 {
		return Value{
			typ: Type{Kind.is_f64, none_type(), none_type(), ''}
			value: Val{
				f64: x
			}
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

pub fn struct_of<T>(x &T) Value {
	mut f := map[string]voidptr{}
	mut ft := map[string]Type{}
	$for field in T.fields {
		f[field.name] = &x.$(field.name)
		ft[field.name] = parse_type(typeof(field).name) or { panic(err) }
	}
	return Value{
		obj: voidptr(x)
		f: f
		ft: ft
		typ: Type{Kind.is_struct, none_type(), none_type(), ''}
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
			.is_bool, .is_string, .is_i8, .is_i16, .is_int, .is_i64, .is_byte, .is_u16, .is_u32,
			.is_u64, .is_rune, .is_f32, .is_f64 {
				voidptr(&v2.value)
			}
			// TODO(elliotchance): Doesn't support multidimensional arrays.
			else {
				voidptr(0)
			}
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
	unsafe {
		return v.value.bool
	}
}

pub fn (v Value) get_string() string {
	v.must_be(Kind.is_string)
	unsafe {
		return v.value.string
	}
}

pub fn (v Value) get_i8() i8 {
	v.must_be(Kind.is_i8)
	unsafe {
		return v.value.i8
	}
}

pub fn (v Value) get_i16() i16 {
	v.must_be(Kind.is_i16)
	unsafe {
		return v.value.i16
	}
}

pub fn (v Value) get_int() int {
	v.must_be(Kind.is_int)
	unsafe {
		return v.value.int
	}
}

pub fn (v Value) get_i64() i64 {
	v.must_be(Kind.is_i64)
	unsafe {
		return v.value.i64
	}
}

pub fn (v Value) get_byte() byte {
	v.must_be(Kind.is_byte)
	unsafe {
		return v.value.byte
	}
}

pub fn (v Value) get_u16() u16 {
	v.must_be(Kind.is_u16)
	unsafe {
		return v.value.u16
	}
}

pub fn (v Value) get_u32() u32 {
	v.must_be(Kind.is_u32)
	unsafe {
		return v.value.u32
	}
}

pub fn (v Value) get_u64() u64 {
	v.must_be(Kind.is_u64)
	unsafe {
		return v.value.u64
	}
}

pub fn (v Value) get_rune() rune {
	v.must_be(Kind.is_rune)
	unsafe {
		return v.value.rune
	}
}

pub fn (v Value) get_f32() f32 {
	v.must_be(Kind.is_f32)
	unsafe {
		return v.value.f32
	}
}

pub fn (v Value) get_f64() f64 {
	v.must_be(Kind.is_f64)
	unsafe {
		return v.value.f64
	}
}

pub fn (v Value) get_key(key Value) Value {
	v.must_be(Kind.is_map)
	key.must_be(v.typ.key.kind)

	for i, k in v.map_keys {
		if k.eq(key) {
			return Value{
				typ: *v.typ.elem
				value: v.map_values[i].value
			}
		}
	}

	panic('key not found: $key')
}

fn (v Value) eq(v2 Value) bool {
	if v.typ.kind != v2.typ.kind {
		return false
	}

	unsafe {
		return match v.typ.kind {
			.is_bool, .is_string, .is_i8, .is_i16, .is_int, .is_i64, .is_byte, .is_u16, .is_u32,
			.is_u64, .is_rune, .is_f32, .is_f64 {
				// Biggest by memory, 16 bytes
				v.value.string == v2.value.string
			}
			else {
				panic('cannot compare $v.str() and $v2.str()')
				false
			}
		}
	}
}

fn (v Value) str() string {
	unsafe {
		return match v.typ.kind {
			.is_bool { '$v.value.bool' }
			.is_string { '$v.value.string' }
			.is_i8 { '$v.value.i8' }
			.is_i16 { '$v.value.i16' }
			.is_int { '$v.value.int' }
			.is_i64 { '$v.value.i64' }
			.is_byte { '$v.value.byte' }
			.is_u16 { '$v.value.u16' }
			.is_u32 { '$v.value.u32' }
			.is_u64 { '$v.value.u64' }
			.is_rune { '$v.value.rune' }
			.is_f32 { '$v.value.f32' }
			.is_f64 { '$v.value.f64' }
			// TODO(elliotchance): We should print arrays and maps
			else { '<Value:$v.typ.kind>' }
		}
	}
}

pub fn (v Value) keys() []Value {
	v.must_be(Kind.is_map)
	return v.map_keys
}

pub fn (v Value) fields() []string {
	v.must_be(Kind.is_struct)
	mut fields := []string{cap: v.f.len}
	for field, _ in v.f {
		fields << field
	}

	return fields
}

pub fn (v Value) field(name string) Value {
	v2 := Value{
		typ: v.ft[name]
		obj: v.f[name]
	}

	unsafe {
		match v2.typ.kind {
			.is_none {}
			.is_bool { C.memcpy(voidptr(&v2.value.bool), v.f[name], sizeof(bool)) }
			.is_string { C.memcpy(voidptr(&v2.value.string), v.f[name], sizeof(string)) }
			.is_i8 { C.memcpy(voidptr(&v2.value.i8), v.f[name], sizeof(i8)) }
			.is_i16 { C.memcpy(voidptr(&v2.value.i16), v.f[name], sizeof(i16)) }
			.is_int { C.memcpy(voidptr(&v2.value.int), v.f[name], sizeof(int)) }
			.is_i64 { C.memcpy(voidptr(&v2.value.i64), v.f[name], sizeof(i64)) }
			.is_byte { C.memcpy(voidptr(&v2.value.byte), v.f[name], sizeof(byte)) }
			.is_u16 { C.memcpy(voidptr(&v2.value.u16), v.f[name], sizeof(u16)) }
			.is_u32 { C.memcpy(voidptr(&v2.value.u32), v.f[name], sizeof(u32)) }
			.is_u64 { C.memcpy(voidptr(&v2.value.u64), v.f[name], sizeof(u64)) }
			.is_rune { C.memcpy(voidptr(&v2.value.rune), v.f[name], sizeof(rune)) }
			.is_f32 { C.memcpy(voidptr(&v2.value.f32), v.f[name], sizeof(f32)) }
			.is_f64 { C.memcpy(voidptr(&v2.value.f64), v.f[name], sizeof(f64)) }
			else { panic('bad type $v2.typ for field $name') }
		}
	}
	return v2
}

pub fn (v Value) set_bool(x bool) {
	v.must_be(Kind.is_bool)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_string(x string) {
	v.must_be(Kind.is_string)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_i8(x i8) {
	v.must_be(Kind.is_i8)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_i16(x i16) {
	v.must_be(Kind.is_i16)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_int(x int) {
	v.must_be(Kind.is_int)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_i64(x i64) {
	v.must_be(Kind.is_i64)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_byte(x byte) {
	v.must_be(Kind.is_byte)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_u16(x u16) {
	v.must_be(Kind.is_u16)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_u32(x u32) {
	v.must_be(Kind.is_u32)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_u64(x u64) {
	v.must_be(Kind.is_u64)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_rune(x rune) {
	v.must_be(Kind.is_rune)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_f32(x f32) {
	v.must_be(Kind.is_f32)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}

pub fn (v Value) set_f64(x f64) {
	v.must_be(Kind.is_f64)
	unsafe { C.memcpy(voidptr(v.obj), &x, sizeof(x)) }
}
