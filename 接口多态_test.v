module ddk

import log

// import io
pub interface Interface {
	method1()
	method2()
}

pub struct Struct1 {}

fn (s &Struct1) method1() {
	log.info('Struct1.method1()')
}

fn (s &Struct1) method2() {
	log.info('Struct1.method2()')
}

pub struct Struct2 {}

fn (s &Struct2) method1() {
	log.info('Struct2.method1()')
}

fn (s &Struct2) method2() {
	log.info('Struct2.method2()')
}

fn test_interface() {
	mut s1 := Struct1{}
	mut s2 := Struct2{}
	s1.method1()
	s2.method2()
}
