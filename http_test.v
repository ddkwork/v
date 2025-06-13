module demo

import log
import net.http
import time

struct MyCountingHandler {
mut:
	counter int
}

fn (mut handler MyCountingHandler) handle(req http.Request) http.Response {
	handler.counter++
	mut r := http.Response{
		body:   req.data + ', ${req.url}, counter: ${handler.counter}'
		header: req.header
	}
	match req.url.all_before('?') {
		'/count' {
			r.set_status(.ok)
		}
		else {
			r.set_status(.not_found)
		}
	}
	r.set_version(req.version)
	return r
}

const atimeout = 500 * time.millisecond

fn test_my_counting_handler_on_random_port() {
	log.warn('${@FN} started')
	defer {
		log.warn('${@FN} finished')
	}
	ip := '127.0.0.1'
	port := 8888
	mut server := &http.Server{
		// read_timeout: 0
		// write_timeout: 0
		// pool_channel_slots: 0
		// worker_num: 0
		// listener: 0
		// on_stopped: fn (mut s Server) {}
		// on_closed: fn (mut s Server) {}
		show_startup_message: false
		addr:                 '${ip}:${port}'
		accept_timeout:       atimeout
		handler:              MyCountingHandler{}
		on_running:           fn (mut server http.Server) {
			spawn fn (mut server http.Server) {
				log.warn('server started')
				url := 'http://${server.addr}/count'
				log.info('fetching from url: ${url}')
				for _ in 0 .. 5 {
					x := http.fetch(url: url, data: 'my data') or { panic(err) }
					log.info(x.body)
				}
				server.stop()
				log.warn('server stopped')
			}(mut server)
		}
	}
	server.listen_and_serve()
	if mut server.handler is MyCountingHandler {
		dump(server.handler.counter)
		assert server.handler.counter == 5
	}
	assert true
}
