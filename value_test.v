module reflect

fn test_value_of_bool() {
	v := value_of(true)
	assert v.kind == Kind.is_bool
	assert v.get_bool() == true
}

fn test_value_of_string() {
	v := value_of('hello')
	assert v.kind == Kind.is_string
	assert v.get_string() == 'hello'
}

fn test_value_of_i8() {
	v := value_of(i8(57))
	assert v.kind == Kind.is_i8
	assert v.get_i8() == 57
}

fn test_value_of_i16() {
	v := value_of(i16(43))
	assert v.kind == Kind.is_i16
	assert v.get_i16() == 43
}

fn test_value_of_int() {
	v := value_of(123)
	assert v.kind == Kind.is_int
	assert v.get_int() == 123
}

fn test_value_of_i64() {
	v := value_of(i64(123456))
	assert v.kind == Kind.is_i64
	assert v.get_i64() == 123456
}

fn test_value_of_byte() {
	v := value_of(byte(45))
	assert v.kind == Kind.is_byte
	assert v.get_byte() == 45
}

fn test_value_of_u16() {
	v := value_of(u16(34))
	assert v.kind == Kind.is_u16
	assert v.get_u16() == 34
}

fn test_value_of_u32() {
	v := value_of(u32(4567))
	assert v.kind == Kind.is_u32
	assert v.get_u32() == 4567
}

fn test_value_of_u64() {
	v := value_of(u64(56789))
	assert v.kind == Kind.is_u64
	assert v.get_u64() == 56789
}

fn test_value_of_rune() {
	v := value_of(`😃`)
	assert v.kind == Kind.is_rune
	assert v.get_rune() == `😃`
}

fn test_value_of_f32() {
	v := value_of(f32(1.23))
	assert v.kind == Kind.is_f32
	assert v.get_f32() == f32(1.23)
}

fn test_value_of_f64() {
	v := value_of(4.56)
	assert v.kind == Kind.is_f64
	assert v.get_f64() == 4.56
}
