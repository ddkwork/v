module ddk

import time

// `Any` is a sum type that lists the possible types to be decoded and used.
// `Any` priority order for numbers: floats -> signed integers -> unsigned integers
// `Any` priority order for strings: string -> time.Time
pub type Any = []Any
	| bool
	| f64
	| f32
	| i64
	| int
	| i32
	| i16
	| i8
	| map[string]Any
	| string
	| time.Time
	| u64
	| u32
	| u16
	| u8
	| Null

pub interface Marshaler {
	// Marshal() string // MarshalIndent
}

pub interface Unmarshaler {
	// Unmarshal(f Any)
}

// `Null` struct is a simple representation of the `null` value in JSON.
pub struct Null {
	is_null bool = true
}

pub const null = Null{}

// ValueKind enumerates the kinds of possible values of the Any sumtype.
pub enum ValueKind {
	unknown
	array
	object
	string_
	number
}

// str returns the string representation of the specific ValueKind
pub fn (k ValueKind) str() string {
	return match k {
		.unknown { 'unknown' }
		.array { 'array' }
		.object { 'object' }
		.string_ { 'string' }
		.number { 'number' }
	}
}
