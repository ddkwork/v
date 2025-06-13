module demo

import encoding.binary
import encoding.hex

struct User {
pub mut:
	id     int
	name   string
	email  string
	active bool
}

fn test_binary() {
	user := User{
		id:    666
		name:  'xxoo'
		email: 'xxoo@example.com'
	}
	buf := binary.encode_binary(user, binary.EncodeConfig{
		buffer_len: 0
		big_endian: false
	})!
	dump(buf)

	// mut buf2:= []u8{154, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 120, 120, 111, 111, 16, 0, 0, 0, 0, 0, 0, 0, 120, 120, 111, 111, 64, 101, 120, 97, 109, 112, 108, 101, 46, 99, 111, 109, 0}
	binary.decode_binary[User](buf, binary.DecodeConfig{
		buffer_len: 0
		big_endian: false
	})!
	dump(user)

	name := hex.encode('hello world'.bytes())
	dump(name)
}
