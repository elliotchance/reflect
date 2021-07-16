module reflect

struct ParseTypeTest {
	typ           string
	expected_kind Kind
}

fn test_parse_type() ? {
	tests := [
		ParseTypeTest{'bool', Kind.is_bool},
		ParseTypeTest{'string', Kind.is_string},
		ParseTypeTest{'i8', Kind.is_i8},
		ParseTypeTest{'i16', Kind.is_i16},
		ParseTypeTest{'int', Kind.is_int},
		ParseTypeTest{'i64', Kind.is_i64},
		ParseTypeTest{'byte', Kind.is_byte},
		ParseTypeTest{'u16', Kind.is_u16},
		ParseTypeTest{'u32', Kind.is_u32},
		ParseTypeTest{'u64', Kind.is_u64},
		ParseTypeTest{'rune', Kind.is_rune},
		ParseTypeTest{'f32', Kind.is_f32},
		ParseTypeTest{'f64', Kind.is_f64},
	]
	for test in tests {
		typ := parse_type(test.typ) ?
		assert typ.kind == test.expected_kind
		assert typ.str() == test.typ
	}
}
