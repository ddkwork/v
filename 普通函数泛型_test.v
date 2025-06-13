module ddk

fn fuck(a int, b int) int {
	return a + b
}

fn get_keys_from_[T]() []string {
	mut struct_keys := []string{}
	$if T is $struct {
		$for field in T.fields {
			struct_keys << field.name
		}
	}
	return struct_keys
}

@[inline]
pub fn min[T](a T, b T) T {
	return if a < b { a } else { b }
}

@[inline]
pub fn max[T](a T, b T) T {
	return if a > b { a } else { b }
}

@[inline]
pub fn abs[T](a T) T {
	return if a > 0 { a } else { -a }
}

fn test_min() {
	assert min(42, 13) == 13
	assert min(5, -10) == -10
	assert min(7.1, 7.3) == 7.1
	assert min(u32(32), u32(17)) == 17
}

fn test_max() {
	assert max(42, 13) == 42
	assert max(5, -10) == 5
	assert max(7.1, 7.3) == 7.3
	assert max(u32(60), u32(17)) == 60
}

fn test_abs() {
	assert abs(99) == 99
	assert abs(-10) == 10
	assert abs(1.2345) == 1.2345
	assert abs(-5.5) == 5.5
}
