// Example: TableGen operators and expressions
// This demonstrates the various built-in operators and value expressions

// Arithmetic operators
def IntAdd : int {
  int Value = !add(10, 20);        // 30
}

def IntSub : int {
  int Value = !sub(50, 15);        // 35
}

def IntMul : int {
  int Value = !mul(6, 7);          // 42
}

def IntDiv : int {
  int Value = !div(100, 4);        // 25
}

// Bitwise operators
def BitwiseAnd : int {
  int Value = !and(0xFF, 0x0F);    // 0x0F
}

def BitwiseOr : int {
  int Value = !or(0xF0, 0x0F);     // 0xFF
}

def BitwiseXor : int {
  int Value = !xor(0xFF, 0x55);    // 0xAA
}

def BitwiseNot : int {
  int Value = !not(0);              // -1
}

// Shift operators
def ShiftLeft : int {
  int Value = !shl(1, 8);          // 256
}

def ShiftRightArith : int {
  int Value = !sra(-16, 2);        // -4
}

def ShiftRightLogical : int {
  int Value = !srl(16, 2);         // 4
}

// Comparison operators
def IsEqual : bit {
  bit Value = !eq(42, 42);         // true
}

def NotEqual : bit {
  bit Value = !ne(10, 20);         // true
}

def LessThan : bit {
  bit Value = !lt(5, 10);          // true
}

def GreaterThan : bit {
  bit Value = !gt(10, 5);          // true
}

// List operators
def ListConcat : list<int> {
  list<int> Value = !listconcat([1, 2], [3, 4]);  // [1, 2, 3, 4]
}

def ListHead : int {
  int Value = !head([10, 20, 30]); // 10
}

def ListTail : list<int> {
  list<int> Value = !tail([10, 20, 30]);  // [20, 30]
}

def ListSize : int {
  int Value = !size([1, 2, 3, 4]); // 4
}

def ListRange : list<int> {
  list<int> Value = !range(10);    // [0, 1, 2, ..., 9]
}

// String operators
def StrConcat : string {
  string Value = !strconcat("Hello", " ", "World");  // "Hello World"
}

def ToUpper : string {
  string Value = !toupper("hello");  // "HELLO"
}

def ToLower : string {
  string Value = !tolower("WORLD");  // "world"
}

def SubStr : string {
  string Value = !substr("Hello World", 0, 5);  // "Hello"
}

// Conditional operators
def IfThenElse : int {
  int Value = !if(!eq(1, 1), 100, 200);  // 100
}

def Cond : string {
  string Value = !cond(
    !eq(0, 1) : "zero",
    !eq(1, 1) : "one",
    true      : "other"
  );  // "one"
}

// Type checking and casting
class Base;
class Derived : Base;

def DerivedInstance : Derived;

def IsA : bit {
  bit Value = !isa<Base>(DerivedInstance);  // true
}

def Cast : Base {
  Base Value = !cast<Base>(DerivedInstance);
}

// DAG operators
def DagNode : dag {
  dag Value = !dag(add, (ops i32:$lhs, i32:$rhs), (ops));
}

def GetDagOp : dag {
  dag d = (add i32:$a, i32:$b);
  dag Value = !getdagop(d);  // add
}

// Foreach and filter
def ForeachList : list<int> {
  list<int> Value = !foreach(x, [1, 2, 3], !mul(x, 2));  // [2, 4, 6]
}

def FilterList : list<int> {
  list<int> Value = !filter(x, [1, 2, 3, 4, 5], !gt(x, 2));  // [3, 4, 5]
}

// Foldl (fold left)
def FoldSum : int {
  int Value = !foldl(0, [1, 2, 3, 4], a, b, !add(a, b));  // 10
}

// Empty check
def IsEmpty : bit {
  bit Value = !empty([]);  // true
}

def IsNotEmpty : bit {
  bit Value = !empty([1, 2]);  // false
}

// Exists check
def ExistsCheck : bit {
  bit Value = !exists("SomeValue");  // checks if SomeValue is defined
}
