module reflect

pub struct Type {
pub:
	kind Kind
	// elem is the element type for arrays and the value type for maps.
	elem &Type
	// key is only used for describing the map key type.
	key &Type
	// name is used for structs
	name string
}

pub fn (t Type) str() string {
	match t.kind {
		.is_array {
			return '[]${*t.elem}'
		}
		.is_map {
			return 'map[${*t.key}]${*t.elem}'
		}
		.is_struct {
			return t.name
		}
		else {
			return t.kind.str()
		}
	}
}

// none_type is a special constructor to create a none type used in situations
// where the type is not applicable.
pub fn none_type() &Type {
	return &Type{
		kind: Kind.is_none
		elem: 0
		key: 0
	}
}

// parse_type returns the Type definition from the string representation.
pub fn parse_type(t string) ?Type {
	if t.starts_with('[]') {
		elem := parse_type(t[2..]) ?
		return Type{
			kind: Kind.is_array
			elem: &elem
			key: none_type()
		}
	}

	if t.starts_with('map[') {
		parts := t[4..].split(']')
		key := parse_type(parts[0]) ?
		elem := parse_type(parts[1]) ?
		return Type{
			kind: Kind.is_map
			elem: &elem
			key: &key
		}
	}

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
			// Another other name must be a struct name in the form of
			// "mypkg.MyType".
			else { Kind.is_struct }
		}
		elem: none_type()
		key: none_type()
		name: t
	}
}
