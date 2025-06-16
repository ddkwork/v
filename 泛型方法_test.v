module main

import time

//编译通过，这才是真正的泛型方法，泛型结构体方法是约束字段类型，泛型方法是约束方法参数类型
// 基于标准库最佳实践定义Value类型
pub type T = []T
	| bool
	| f64
	| f32
	| i64
	| int
	| i32
	| i16
	| i8
	| map[string]T
	| string
	| time.Time
	| u64
	| u32
	| u16
	| u8
	| Null

// Null类型实现
struct Null {
pub mut:
	is_null bool = true
}

pub const null = Null{}

// 缓冲区结构体
pub struct Buffer {
mut:
	data []u8
}

// add_str 添加字符串
@[direct_array_access]
fn (mut b Buffer) add_str(s string) {
	b.data << s.bytes()
}

// add_byte 添加字节
@[direct_array_access]
fn (mut b Buffer) add_byte(c u8) {
	b.data << c
}

// add_num 添加数字
fn (mut b Buffer) add_num(n int) {
	b.add_str(n.str())
}

// add_value 主方法：添加值
pub fn (mut b Buffer) add_value(val T) {
	match val {
		// 处理基本类型
		string {
			b.add_str('"')
			b.add_str(val)
			b.add_str('"')
		}
		int, i8, i16, i32, i64 {
			b.add_num(int(val))
		}
		u8, u16, u32, u64 {
			b.add_num(int(val))
		}
		f32, f64 {
			b.add_str(val.str())
		}
		bool {
			b.add_str(if val { 'true' } else { 'false' })
		}
		time.Time {
			b.add_str('"')
			b.add_str(val.str())
			b.add_str('"')
		}
		Null {
			b.add_str('null')
		}
		// 处理集合类型
		[]T {
			b.add_byte(`[`)
			for i, item in val {
				if i > 0 {
					b.add_byte(`,`)
				}
				b.add_value(item)
			}
			b.add_byte(`]`)
		}
		map[string]T {
			b.add_byte(`{`)
			mut first := true
			for key, value in val {
				if !first {
					b.add_byte(`,`)
				}
				first = false
				b.add_str('"${key}"')
				b.add_byte(`:`)
				b.add_value(value)
			}
			b.add_byte(`}`)
		}
	}
}

// str 作为字符串输出
pub fn (b Buffer) str() string {
	return b.data.bytestr()
}

// reset 重置缓冲区
pub fn (mut b Buffer) reset() {
	b.data.clear()
}

// new_buffer 创建新缓冲区
pub fn new_buffer() Buffer {
	return Buffer{}
}

type Xx00Obj = struct {
	name string
}

fn test_xx00_obj() {
	mut buf := new_buffer()

	//   obj := Xx00Obj{
	// 	name: 'Bob'
	// }
	// 添加基本类型
	// buf.add_value(obj )
	buf.add_value('hello')
	buf.add_byte(` `)
	buf.add_value(42)
	buf.add_byte(` `)
	buf.add_value(3.14)
	buf.add_byte(` `)
	buf.add_value(true)

	println('基本类型: ${buf.str()}') // "hello" 42 3.14 true
	buf.reset()

	// 添加复杂结构
	mut map_val := map[string]T{}
	map_val['name'] = 'Alice'
	map_val['age'] = 30

	mut arr_val := []T{}
	arr_val << 10
	arr_val << 20
	arr_val << 30

	buf.add_value(arr_val)
	buf.add_byte(` `)
	buf.add_value(map_val)

	println('复杂结构: ${buf.str()}') // [10,20,30] {"name":"Alice","age":30}
	buf.reset()

	// 添加时间类型
	buf.add_value(time.now())
	println('当前时间: ${buf.str()}') // "2023-12-01 12:34:56"
}
