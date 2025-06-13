module demo

import time

// 类型别名定义
type HexString = string
type HexDumpString = string

// 自定义结构体
struct Point {
	x int
	y int
}

// 缓冲区结构体
struct Buffer {
mut:
	data []u8
}

// add_str 添加字符串到缓冲区
fn (mut b Buffer) add_str(s string) {
	b.data << s.bytes()
}

// add_byte 添加字节到缓冲区
fn (mut b Buffer) add_byte(c u8) {
	b.data << c
}

// copy_from 泛型方法：将任意类型的数据复制到缓冲区
fn (mut b Buffer) copy_from[T](val T) {
	// 可选类型处理
	$if T is $option {
		if val != none {
			b.copy_from(val)
		}
	}
	// 数组类型处理
	$else $if T is $array {
		for i, element in val {
			if i > 0 {
				b.add_byte(` `)
			}
			b.copy_from(element)
		}
	}
	// 映射类型处理
	$else $if T is $map {
		mut first := true
		for k, v in val {
			if !first {
				b.add_byte(` `)
			}
			first = false
			b.copy_from(k)
			b.add_byte(`:`)
			b.copy_from(v)
		}
	}
	// 结构体类型处理
	$else $if T is $struct {
		$for field in T.fields {
			b.add_str(field.name)
			b.add_byte(`=`)
			b.copy_from(val.$(field.name))
			b.add_byte(` `)
		}
	}
	// 枚举类型处理
	$else $if T is $enum {
		b.add_str(val.str())
	}
	// 字符串类型处理
	$else $if T is string {
		b.add_byte(`"`)
		b.add_str(val)
		b.add_byte(`"`)
	}
	// 字节数组处理
	$else $if T is []byte {
		b.add_byte(`[`)
		b.data << val
		b.add_byte(`]`)
	}
	// 自定义别名处理
	$else $if T is HexString {
		b.add_str('HEX:')
		b.add_str(val)
	} $else $if T is HexDumpString {
		b.add_str('DUMP:')
		b.add_str(val)
	}
	// 数值类型处理
	$else $if T is int || T is f64 || T is u64 || T is u32 {
		b.add_str(val.str())
	}
	// 布尔类型处理
	$else $if T is bool {
		if val {
			b.add_str('true')
		} else {
			b.add_str('false')
		}
	}
	// 时间类型处理
	$else $if T is time.Time {
		b.add_str(val.str())
	}
	// 默认处理
	$else {
		b.add_str('UNSUPPORTED')

		// $compile_error('copy_from 只支持 string 或 []byte 类型，但传入了 ${T.name}')
	}
}

// str 转换为字符串
fn (b Buffer) str() string {
	return b.data.bytestr()
}

fn test_buffer() {
	mut b := Buffer{}

	// 测试字符串
	b.copy_from('Hello World')
	dump(b)
	println('字符串:' + b.str())

	// 测试整数
	b = Buffer{} // 重置缓冲区
	b.copy_from(12345)
	println('整数: ${b.str()}')

	// 测试浮点数
	b = Buffer{}
	b.copy_from(3.14159)
	println('浮点数: ${b.str()}')

	// 测试布尔值
	b = Buffer{}
	b.copy_from(true)
	println('布尔值: ${b.str()}')

	// 测试数组
	b = Buffer{}
	b.copy_from([10, 20, 30])
	println('数组: ${b.str()}')

	// 测试别名类型 (HexString)
	b = Buffer{}
	b.copy_from(HexString('0xDEADBEEF'))
	println('十六进制字符串: ${b.str()}')

	// 测试别名类型 (HexDumpString)
	b = Buffer{}
	b.copy_from(HexDumpString('00: 48 65 6c 6c 6f'))
	println('十六进制转储: ${b.str()}')

	// 测试结构体
	b = Buffer{}
	b.copy_from(Point{ x: 5, y: 10 })
	println('点结构体: ${b.str()}')

	// 测试时间
	b = Buffer{}
	b.copy_from(time.now())
	println('当前时间: ${b.str()}')

	// 测试复杂结构体
	b = Buffer{}
	b.copy_from(User2{ name: 'Alice', age: 30 })
	println('用户结构体: ${b.str()}')
}

struct User2 {
pub mut:
	id     int
	name   string
	age    int
	email  string
	active bool
}
