### Lua学习笔记2

### 空字符串

```lua
print("" ~= "\0") -- true
print(#"", #"\0") -- 0       1

print(string.byte("")) -- 
print(string.byte("\0")) -- 0
```

### 可变长参数与 ipairs、pairs、select

* ipairs：碰到 nil 就终止
* pairs：跳过 nil（key也跳过）
* select：包括 nil

### 用Luadoc和Ldoc给Lua生成文档