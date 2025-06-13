// module ddk
//
// import strings
// import clipboard
//
// @[heap]
// pub struct Node[T] {
// pub mut:
// // id         uuid.UUID
// typ        string
// data       T
// children   []&Node[T]
// parent     &Node[T] = unsafe { nil }
// is_open    bool
// row_cells  []CellData
// // row_click  widget.Clickable
// row_number int
// }
//
// pub struct CellData {
// value string
// // width unit.Dp
// }
//
// const container_key_postfix = '_container'
//
// //------------------------------ 构造方法 ------------------------------
// pub fn new_node[T](typ string, is_container bool, data T) &Node[T] {
// mut node := &Node[T]{
// // id: uuid.new(),
// typ: if is_container { typ + container_key_postfix } else { typ },
// data: data,
// is_open: is_container,
// row_cells: []CellData{},
// // row_click: widget.Clickable{},
// }
// if is_container {
// node.children = []
// }
// return node
// }
//
// pub fn new_root[T](data T) &Node[T] {
// return new_container_node[T]("root", data)
// }
//
// pub fn new_container_node[T](typ string, data T) &Node[T] {
// return new_node[T](typ, true, data)
// }
//
// pub fn new_container_nodes[T](type_keys []string, objects ...T) []&Node[T] {
// mut nodes := []&Node[T]{cap: type_keys.len}
// mut data := T{}
// for i, key in type_keys {
// if objects.len > i {
// data = objects[i]
// }
// nodes << new_container_node[T](key, data)
// }
// return nodes
// }
//
// //------------------------------ 核心方法 ------------------------------
// pub fn (n &Node[T]) is_root() bool {
// return unsafe { n.parent == nil }
// }
//
// // pub fn (n &Node[T]) uuid() uuid.UUID {
// // return n.id
// // }
//
// pub fn (n &Node[T]) container() bool {
// return strings.has_suffix(n.typ, container_key_postfix)
// }
//
// pub fn (n &Node[T]) get_type() string {
// return n.typ
// }
//
// pub fn (mut n Node[T]) set_type(typ string) {
// n.typ = typ
// }
//
// pub fn (n &Node[T]) is_open() bool {
// return n.is_open && n.container()
// }
//
// pub fn (mut n Node[T]) set_open(open bool) {
// n.is_open = open && n.container()
// }
//
// pub fn (n &Node[T]) parent() &Node[T] {
// return n.parent
// }
//
// pub fn (mut n Node[T]) set_parent(parent &Node[T]) {
// n.parent = parent
// }
//
// //------------------------------ 子节点操作 ------------------------------
// pub fn (mut n Node[T]) reset_children() {
// n.children = []
// }
//
// pub fn (n &Node[T]) can_have_children() bool {
// return n.has_children()
// }
//
// pub fn (n &Node[T]) has_children() bool {
// return n.container() && n.children.len > 0
// }
//
// pub fn (mut n Node[T]) add_child(mut child &Node[T]) {
// child.parent = n
// n.children << child
// }
//
// pub fn (mut n Node[T]) add_child_by_data(data T) {
// n.add_child(mut new_node[T]("", false, data))
// }
//
// pub fn (mut n Node[T]) add_children_by_data(datas ...T) {
// for data in datas {
// n.add_child_by_data(data)
// }
// }
//
// pub fn (mut n Node[T]) add_container_by_data(typ string, data T) &Node[T] {
// container := new_container_node[T](typ, data)
// n.add_child(mut container)
// return container
// }
//
// //------------------------------ 树操作 ------------------------------
// pub fn (n &Node[T]) sum_children() string {
// mut k := strings.trim_suffix(n.typ, container_key_postfix)
// if n.children.len == 0 {
// return k
// }
// return '${k} (${n.children.len})'
// }
//
// pub fn (n &Node[T]) len_children() int {
// return n.children.len
// }
//
// pub fn (n &Node[T]) last_child() &Node[T] {
// if n.is_root() && n.can_have_children() {
// return n.children[n.children.len - 1]
// }
// return n.parent.children[n.parent.children.len - 1]
// }
//
// pub fn (n &Node[T]) is_last_child() bool {
// return n.last_child() == n
// }
//
// pub fn (mut n Node[T]) copy_from(from &Node[T]) &Node[T] {
// n.id = from.id
// n.typ = from.typ
// n.data = from.data
// n.is_open = from.is_open
// // 注意：children和parent需要特殊处理
// return n
// }
//
// pub fn (mut n Node[T]) apply_to(mut to &Node[T]) &Node[T] {
// to.copy_from(n)
// return n
// }
//
// //------------------------------ 迭代器实现 ------------------------------
// pub fn (n &Node[T]) walk() fn(yield fn(int, &Node[T]) bool) bool {
// return fn[mut n](yield fn(int, &Node[T]) bool) bool {
// return walk_impl(n, 0, yield)
// }
// }
//
// fn walk_impl[T](node &Node[T], idx int, yield fn(int, &Node[T]) bool) bool {
// // if !yield(idx, node) {
// // return false
// // }
// // for i, child in node.children {
// // if !walk_impl(child, i, yield) {
// // return false
// // }
// // }
// // return true
// // }
// //
// // pub fn (n &Node[T]) walk_containers() fn(yield fn(int, &Node[T]) bool) bool {
// // return fn[mut n](yield fn(int, &Node[T]) bool) bool {
// // if !n.container() {
// // return true
// // }
// // mut stack := []&Node[T]{cap: 8}
// // stack << n
// //
// // for stack.len > 0 {
// // current := stack.pop()
// // if !yield(stack.len, current) {
// // return false
// // }
// //
// // for i := current.children.len - 1; i >= 0; i-- {
// // if current.children[i].container() {
// // stack << current.children[i]
// // }
// // }
// // }
// // return true
// // }
// }
//
// //------------------------------ 其他方法 ------------------------------
// pub fn (n &Node[T]) depth() int {
// mut count := 0
// mut p := n.parent
// for p != unsafe { nil } {
// count++
// p = p.parent
// }
// return count
// }
//
// pub fn (mut n Node[T]) clone() &Node[T] {
// mut cloned := new_node[T](n.typ, n.container(), n.data)
// cloned.is_open = n.is_open
// for mut child in n.children {
// cloned.add_child(child.clone())
// }
// return cloned
// }
//
// pub fn (mut n Node[T]) open_all() {
// for _, node in n.walk_containers() {
// node.set_open(true)
// }
// }
//
// pub fn (mut n Node[T]) close_all() {
// for _, node in n.walk_containers() {
// node.set_open(false)
// }
// }
//
// //------------------------------ 行操作方法 ------------------------------
// pub fn (mut n Node[T]) copy_row(  widths []u8) string {
// mut g := strings.new_builder(128)
// g.write_string("var rowData = []string{ ")
// for i, cell in n.row_cells {
// // g.write_string("${cell.value:-${widths[i]}},")
// }
// g.write_string(" }")
// // clipboard.write(gtx, g.str())
// return g.str()
// }
//
// //------------------------------ 测试用例 ------------------------------
// fn test_node_operations() {
// mut root := new_root[string]("root_data")
// assert root.is_root()
//
// mut container := root.add_container_by_data("type1", "data1")
// assert container.container()
//
// container.add_child_by_data("child1")
// assert container.children.len == 1
//
// mut cloned := container.clone()
// assert cloned.data == "data1"
// assert cloned.children.len == 1
// }
//
// fn main() {
// //   mut tree := new_root[string]("Root")
// // tree.add_container_by_data("Documents", "doc_data")
// // .add_child_by_data("file1.txt")
// //
// // println("Tree structure:")
// // for  node in tree.walk() {
// // println("${'  '.repeat(node.depth())}${node.typ}: ${node.data}")
// // }
// }
