module demo

struct Container[T] {
mut:
	value T
}

fn (c &Container[T]) get() T {
	return c.value
}

fn (mut c Container[T]) set(value T) {
	c.value = value
}

fn test_container() {
}
