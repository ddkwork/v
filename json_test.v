module demo

import x.json2 as json

struct User {
pub mut:
	id     int
	name   string
	email  string
	active bool
}

fn test_json() {
	user := User{
		id:    123
		name:  'John Doe'
		email: 'john@example.com'
	}

	json_data := json.encode_pretty(user)
	dump(json_data)

	new_user := json.decode[User]('
{
  "id" : 123,
  "name" : "Alice",
  "email" : "alice@example.com",
  "active" : false
}
')!
	assert new_user.name == 'Alice'
	assert new_user.email == 'alice@example.com'
	assert new_user.active == false
	assert new_user.id == 123

	dump(new_user)
}
