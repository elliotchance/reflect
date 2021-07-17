module reflect

struct ParseTypeTest {
	typ           string
	expected_kind Kind
	expected_elem Type
	expected_key  Type
}

fn test_parse_type() ? {
	tests := [
		ParseTypeTest{'bool', Kind.is_bool, none_type(), none_type()},
		ParseTypeTest{'string', Kind.is_string, none_type(), none_type()},
		ParseTypeTest{'i8', Kind.is_i8, none_type(), none_type()},
		ParseTypeTest{'i16', Kind.is_i16, none_type(), none_type()},
		ParseTypeTest{'int', Kind.is_int, none_type(), none_type()},
		ParseTypeTest{'i64', Kind.is_i64, none_type(), none_type()},
		ParseTypeTest{'byte', Kind.is_byte, none_type(), none_type()},
		ParseTypeTest{'u16', Kind.is_u16, none_type(), none_type()},
		ParseTypeTest{'u32', Kind.is_u32, none_type(), none_type()},
		ParseTypeTest{'u64', Kind.is_u64, none_type(), none_type()},
		ParseTypeTest{'rune', Kind.is_rune, none_type(), none_type()},
		ParseTypeTest{'f32', Kind.is_f32, none_type(), none_type()},
		ParseTypeTest{'f64', Kind.is_f64, none_type(), none_type()},
		ParseTypeTest{'[]int', Kind.is_array, &Type{Kind.is_int, none_type(), none_type(), ''}, none_type()},
		ParseTypeTest{'[]f64', Kind.is_array, &Type{Kind.is_f64, none_type(), none_type(), ''}, none_type()},
		ParseTypeTest{'map[string]int', Kind.is_map, &Type{Kind.is_int, none_type(), none_type(), ''}, &Type{Kind.is_string, none_type(), none_type(), ''}},
		ParseTypeTest{'map[f64]string', Kind.is_map, &Type{Kind.is_string, none_type(), none_type(), ''}, &Type{Kind.is_f64, none_type(), none_type(), ''}},
		ParseTypeTest{'main.Foo', Kind.is_struct, none_type(), none_type()},
	]
	for test in tests {
		println(test.typ)
		typ := parse_type(test.typ) ?
		assert typ.kind == test.expected_kind
		assert (*typ.elem).str() == test.expected_elem.str()
		assert (*typ.key).str() == test.expected_key.str()
		assert typ.str() == test.typ
	}
}
