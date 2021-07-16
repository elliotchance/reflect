module reflect

pub enum Kind {
	is_bool
	is_string
	is_i8
	is_i16
	is_int
	is_i64
	is_byte
	is_u16
	is_u32
	is_u64
	is_rune
	is_f32
	is_f64
	is_array
}

pub fn (k Kind) str() string {
	return match k {
		.is_bool { 'bool' }
		.is_string { 'string' }
		.is_i8 { 'i8' }
		.is_i16 { 'i16' }
		.is_int { 'int' }
		.is_i64 { 'i64' }
		.is_byte { 'byte' }
		.is_u16 { 'u16' }
		.is_u32 { 'u32' }
		.is_u64 { 'u64' }
		.is_rune { 'rune' }
		.is_f32 { 'f32' }
		.is_f64 { 'f64' }
		.is_array { 'array' }
	}
}
