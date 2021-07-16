module reflect

fn test_value_of_bool() {
	v := value_of(true)
	assert v.typ.kind == Kind.is_bool
	assert v.typ.str() == 'bool'
	assert v.get_bool() == true
}

fn test_value_of_string() {
	v := value_of('hello')
	assert v.typ.kind == Kind.is_string
	assert v.typ.str() == 'string'
	assert v.get_string() == 'hello'
}

fn test_value_of_i8() {
	v := value_of(i8(57))
	assert v.typ.kind == Kind.is_i8
	assert v.typ.str() == 'i8'
	assert v.get_i8() == 57
}

fn test_value_of_i16() {
	v := value_of(i16(43))
	assert v.typ.kind == Kind.is_i16
	assert v.typ.str() == 'i16'
	assert v.get_i16() == 43
}

fn test_value_of_int() {
	v := value_of(123)
	assert v.typ.kind == Kind.is_int
	assert v.typ.str() == 'int'
	assert v.get_int() == 123
}

fn test_value_of_i64() {
	v := value_of(i64(123456))
	assert v.typ.kind == Kind.is_i64
	assert v.typ.str() == 'i64'
	assert v.get_i64() == 123456
}

fn test_value_of_byte() {
	v := value_of(byte(45))
	assert v.typ.kind == Kind.is_byte
	assert v.typ.str() == 'byte'
	assert v.get_byte() == 45
}

fn test_value_of_u16() {
	v := value_of(u16(34))
	assert v.typ.kind == Kind.is_u16
	assert v.typ.str() == 'u16'
	assert v.get_u16() == 34
}

fn test_value_of_u32() {
	v := value_of(u32(4567))
	assert v.typ.kind == Kind.is_u32
	assert v.typ.str() == 'u32'
	assert v.get_u32() == 4567
}

fn test_value_of_u64() {
	v := value_of(u64(56789))
	assert v.typ.kind == Kind.is_u64
	assert v.typ.str() == 'u64'
	assert v.get_u64() == 56789
}

fn test_value_of_rune() {
	v := value_of(`😃`)
	assert v.typ.kind == Kind.is_rune
	assert v.typ.str() == 'rune'
	assert v.get_rune() == `😃`
}

fn test_value_of_f32() {
	v := value_of(f32(1.23))
	assert v.typ.kind == Kind.is_f32
	assert v.typ.str() == 'f32'
	assert v.get_f32() == f32(1.23)
}

fn test_value_of_f64() {
	v := value_of(4.56)
	assert v.typ.kind == Kind.is_f64
	assert v.typ.str() == 'f64'
	assert v.get_f64() == 4.56
}

fn test_array_of_int() {
	v := array_of([5, 7, 9])
	assert v.kind == Kind.is_array
	// t := v.get_type()
	assert v.len() == 3
}

fn test_len() {
	v := array_of([5, 7, 9])
	assert v.kind == Kind.is_array
	assert v.len() == 3
}

fn test_cap() {
	v := array_of([]f32{len: 1, cap: 5})
	assert v.kind == Kind.is_array
	assert v.len() == 1
	assert v.cap() == 5
}

fn test_get_index_int() {
	v := array_of([5, 7, 9])
	e := v.get_index(1)
	assert e.get_int() == 7
}

// fn test_get_index_f64() {
// 	v := array_of([1.23, 4.56, 7.89])
// 	e := v.get_index(2)
// 	assert e.get_f64() == 7.89
// }

// TODO(elliot): Not sure how to test for panics?
// fn test_get_index_bounds() {
// 	v := array_of([5, 7, 9])
// 	v.get_index(3)
// }
