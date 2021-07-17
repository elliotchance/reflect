module reflect

pub struct Type {
	kind Kind
}

pub fn (t Type) str() string {
	return t.kind.str()
}

// parse_type returns the Type definition from the string representation.
pub fn parse_type(t string) ?Type {
	return Type{
		kind: match t {
			'bool' { Kind.is_bool }
			'string' { Kind.is_string }
			'i8' { Kind.is_i8 }
			'i16' { Kind.is_i16 }
			'int' { Kind.is_int }
			'i64' { Kind.is_i64 }
			'byte' { Kind.is_byte }
			'u16' { Kind.is_u16 }
			'u32' { Kind.is_u32 }
			'u64' { Kind.is_u64 }
			'rune' { Kind.is_rune }
			'f32' { Kind.is_f32 }
			'f64' { Kind.is_f64 }
			else { Kind.is_bool } // TODO(elliotchance): Fix me.
		}
	}
}
