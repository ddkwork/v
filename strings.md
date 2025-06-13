### V 语言字符串修剪方法对照表

| 功能描述                | 方法名                           | 示例                                        | 输出        |
|---------------------|-------------------------------|-------------------------------------------|-----------|
| **删除指定前缀（完整字符串）**   | `s.trim_string_left(prefix)`  | `"HelloWorld".trim_string_left("Hello")`  | `"World"` |
| **删除指定后缀（完整字符串）**   | `s.trim_string_right(suffix)` | `"image.jpg".trim_string_right(".jpg")`   | `"image"` |
| **删除左侧特定字符（任意顺序）**  | `s.trim_left_chars(chars)`    | `"xxtest".trim_left_chars("x")`           | `"test"`  |
| **删除右侧特定字符（任意顺序）**  | `s.trim_right_chars(chars)`   | `"testxx".trim_right_chars("x")`          | `"test"`  |
| **删除两侧特定字符（任意顺序）**  | `s.trim_chars(chars)`         | `"**text**".trim_chars("*")`              | `"text"`  |
| **删除左侧空白**          | `s.trim_left()`               | `"   text".trim_left()`                   | `"text"`  |
| **删除右侧空白**          | `s.trim_right()`              | `"text   ".trim_right()`                  | `"text"`  |
| **删除两侧空白**          | `s.trim_space()`              | `"  text  ".trim_space()`                 | `"text"`  |
| **删除左侧特定字符集（任意顺序）** | `s.trim_left_chars(chars)`    | `"123test".trim_left_chars("0123456789")` | `"test"`  |
| **删除右侧特定字符集（任意顺序）** | `s.trim_right_chars(chars)`   | `"test###".trim_right_chars("#")`         | `"test"`  |
| **删除两侧特定字符集（任意顺序）** | `s.trim_chars(chars)`         | `"!!text!$".trim_chars("!#$")`            | `"text"`  |

#### 特殊用法

| **删除文件扩展名** | `s.trim_string_right(ext)` | `"document.pdf".trim_string_right(".pdf")` | `"document"` |
| **删除URL协议** | `s.trim_string_left(prefix)` | `"https://vlang.io".trim_string_left("https://")` | `"vlang.io"` |
| **删除数字前缀** | `s.trim_left_chars(chars)` | `"2023_report".trim_left_chars("0123456789")` | `"_report"` |
| **删除多字符前缀** | `s.trim_string_left(prefix)` | `"+++Warning: text".trim_string_left("+++Warning: ")` | `"text"` |
| **删除多字符后缀** | `s.trim_string_right(suffix)` | `"archive.tar.gz".trim_string_right(".gz")` | `"archive.tar"` |
| **删除日期前缀** | `s.trim_string_left(prefix)` | `"20231201_report.txt".trim_string_left("20231201_")` |
`"report.txt"` |

#### 通用方法说明

1. **trim_string_left(prefix) 与 trim_string_right(suffix)**
    - 删除完整匹配的前缀/后缀字符串
    - 只删除第一次出现的匹配
    - 前缀/后缀不匹配时返回原字符串

2. **trim_left_chars(chars) 与 trim_right_chars(chars)**
    - `chars` 参数是一个字符集
    - 删除属于字符集的连续字符直到遇到不在字符集中的字符
    - 删除顺序与字符集定义无关

3. **trim_chars(chars)**
    - 相当于 `s.trim_left_chars(chars).trim_right_chars(chars)`
    - 适用于清理分隔符或特殊字符

4. **空白处理方法**
    - 处理所有空白字符，包括：
        - 空格 (`' '`)
        - 制表符 (`'\t'`)
        - 回车符 (`'\r'`)
        - 换行符 (`'\n'`)
        - 垂直制表符 (`'\v'`)
        - 换页符 (`'\f'`)