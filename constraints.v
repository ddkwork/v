module ddk

pub type Signed = int | i8 | i16 | i32 | i64
pub type Unsigned = u8 | u16 | u32 | u64
pub type Integer = Signed | Unsigned
pub type Float = f32 | f64
pub type Bytes = []u8

// pub type Complex = complex64 | complex128
pub type Ordered = Integer | Float | string

pub type BufferType = Bytes | string

// pub  type Buffer =[]byte | string

fn dump_hex(buf BufferType) string {
	//   mut b :=[]
	//
	// match buf {
	// 	string{
	// 		b = []u8(buf)
	// 	}
	// 	Bytes {
	// 		b = buf
	// 	}
	// }
	return ''

	//
	// switch v := any(buf).(type) {
	// case []byte:
	// 	b = v
	// case *bytes.Buffer:
	// 	b = v.Bytes()
	// default:
	// 	panic(fmt.Sprintf("unsupported type %T", v))
	// }

	// if len(b) == 0 {
	// 	return "[]bytes{}"
	// }
	//
	// length := len(b)
	// switch {
	// case length == 0:
	// 	return "[]bytes{}"
	// case length < 16+1:
	// 	// 结构体字段格式打印优先
	// 	dump += fmt.Sprintf("%#v", b) // 兼容结构体字段打印样式,复制到单元测试方便，todo 输入c语法样式,目前感觉太占空间了
	// 	dump += "\t//"
	// 	dump += hex.EncodeToString(b) // 方便复制到rsa解密工具测试
	// 	dump += hex.Dump(b)
	// 	if length < 9 {
	// 		dump = strings.ReplaceAll(dump, "                           |", "  ")
	// 	}
	// 	dump = strings.TrimSuffix(dump, "\n")
	// 	return dump
	// default:
	// 	if length > 4096 { // for x64dbg big packet
	// 		fmt.Println("big data", length)
	// 		b = b[:4096]
	// 	}
	// 	dump += format_bytes_as_go_code(b)
	// 	dump += make_multi_line_comment(strings.NewReplacer(
	// 		"[]byte", "unsigned char b[]=",
	// 		"}", "};\n",
	// 	).Replace(format_bytes_as_go_code(b)))
	// 	dump += "\n//" + hex.EncodeToString(b) // 方便复制到rsa解密工具测试
	// 	dump += make_multi_line_comment(hex.Dump(b))
	// 	return
	// }
}

fn make_multi_line_comment(data string) string {
	mut s := '\n'
	s += '/*'
	s += '\n'
	s += data
	s += '*/'
	return s
}

// fn format_bytes_as_go_code(data []byte) string {
// 	var buffer bytes.Buffer
// 	buffer.WriteString("[]byte{\n")
// 	// 使用 slices.Chunk 将数据分为每8个字节一组
// 	for chunk := range slices.Chunk(data, 8) {
// 		buffer.WriteString("\t") // 添加一层缩进
// 		for i, b := range chunk {
// 			if i > 0 {
// 				buffer.WriteString(", ")
// 			}
// 			buffer.WriteString(fmt.Sprintf("0x%s", hex.EncodeToString([]byte{b}))) // todo 1字节需要对齐
// 		}
// 		buffer.WriteString(",\n")
// 	}
// 	buffer.WriteString("}")
// 	return buffer.String()
// }

// fn format_integer(data Integer) string {
// return fmt.Sprintf("%d", reflect.ValueOf(data).Interface()) + "[" + format_integer_hex_0_x(data) + "]"
// return format_integer_hex_0_x(data) + " # " + fmt.Sprintf("%d", reflect.ValueOf(data).Interface())
// }

// fn format_integer_hex_0_x(data Integer) string {
// 	return '0x' + format_integer_hex(data)
// }

// fn format_integer_hex(data Integer) string {
// 	format := ""
// 	switch any(data).(type) {
// 	case int, int64, uint, uint64, uintptr:
// 		format = "%016X"
// 	case int8, uint8:
// 		format = "%02X"
// 	case int16, uint16:
// 		format = "%04X"
// 	case int32, uint32:
// 		format = "%08X"
// 	default:
// 		switch reflect.TypeOf(data).Kind() {
// 		case reflect.Int, reflect.Uint, reflect.Uint64, reflect.Uintptr, reflect.Int64:
// 			format = "%016X"
// 		case reflect.Int8, reflect.Uint8:
// 			format = "%02X"
// 		case reflect.Int16, reflect.Uint16:
// 			format = "%04X"
// 		case reflect.Int32, reflect.Uint32:
// 			format = "%08X"
// 		default:
// 			panic("unsupported type ---> " + reflect.TypeOf(data).Name())
// 		}
// 	}
// 	return fmt.Sprintf(format, data)
// }

// fn integer_2_bool(value Integer) bool {
// 	switch v := any(value).(type) {
// 	case int, int8, int16, int32, int64, uint, uint8, uint16, uint32, uint64, uintptr:
// 		if v == 1 {
// 			return true
// 		}
// 	}
// 	return false
// }

// fn bool_2_integer(b bool) Integer {
// 	mut zero= T
// 	switch any(zero).(type) {
// 	case int, int8, int16, int32, int64, uint, uint8, uint16, uint32, uint64, uintptr:
// 		if b {
// 			zero = 1
// 		}
// 	}
// 	return zero
// }

fn is_include_line(data string) bool {
	mut s := data.trim_space()

	if !s.starts_with('#') {
		return false
	}
	s = s.trim_left('#')
	s = s.trim_space()
	return s.starts_with('include')
}

// fn value_is_bytes_type(v reflect.Value) bool {
// 	return v.Type().Elem().Kind() == reflect.Uint8
// }

// fn isASCIILower(c byte) bool { return 'a' <= c && c <= 'z' }
// fn isASCIIUpper(c byte) bool { return 'A' <= c && c <= 'Z' }
// fn is_ascii_digit(c u8) bool {
// 	return '0' <= c && c <= '9'
// }

// fn IsASCIIAlpha(s string) bool {
//	for i := 0; i < len(s); i++ {
//		c := s[i] // 直接按字节获取
//		if !isASCIILower(c) && !isASCIIUpper(c) {
//			return false
//		}
//	}
//	return true
// }

// fn is_ascii_digit(s string) bool {
// 	for i := range len(s) {
// 		if !is_ascii_digit(s[i]) {
// 			return false
// 		}
// 	}
// 	return len(s) > 0 // 确保字符串非空
// }

// fn IsAlphanumeric(s string) bool {
//	for i := 0; i < len(s); i++ {
//		c := s[i]
//		if !is_ascii_digit(c) && !isASCIILower(c) && !isASCIIUpper(c) {
//			return false
//		}
//	}
//	return len(s) > 0 // 确保字符串非空
// }

// fn isOneByteInteger(n int) bool {
//	return n >= -128 && n <= 127 // 检查有符号整数
//	// return n >= 0 && n <= 255 // 可以用于无符号整数
// }
