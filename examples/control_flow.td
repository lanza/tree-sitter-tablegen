// Example: Control flow and advanced features
// This demonstrates let, foreach, if/then/else, defvar, defset, and assertions

// ===== Let statements =====

// Let with single binding
let isCommutable = 1 in {
  def ADD_COMM : Instruction;
  def MUL_COMM : Instruction;
}

// Let with multiple bindings
let Namespace = "MyTarget",
    isCodeGenOnly = 1 in {
  def PSEUDO_1 : Instruction;
  def PSEUDO_2 : Instruction;
}

// Nested let statements
let Predicates = [HasFeatureA] in {
  let isAsCheapAsAMove = 1 in {
    def CHEAP_A : Instruction;
  }

  let mayLoad = 1 in {
    def LOAD_A : Instruction;
  }
}

// ===== Foreach loops =====

// Simple foreach with range
foreach i = 0-7 in {
  def REG#i : Register<"r"#i, i>;
}

// Foreach with list
foreach size = [8, 16, 32, 64] in {
  def LOAD#size : Instruction {
    int Width = size;
    string Name = "load" # size;
  }
}

// Nested foreach
foreach prefix = ["I", "F"] in {
  foreach width = [32, 64] in {
    def prefix#width#"_TYPE" : Type {
      string Category = prefix;
      int BitWidth = width;
    }
  }
}

// Foreach with list expressions
defvar RegList = [R0, R1, R2, R3];
foreach reg = RegList in {
  def USE_#reg : Instruction;
}

// ===== If/Then/Else statements =====

// Simple if/then
if !eq(TARGET_64BIT, 1) then {
  def PTR64 : Type;
}

// If/then/else
if !eq(ENDIAN, "little") then {
  def LITTLE_ENDIAN_INST : Instruction {
    let Encoding{0} = 1;
  }
} else {
  def BIG_ENDIAN_INST : Instruction {
    let Encoding{31} = 1;
  }
}

// Nested if statements
if !eq(ARCH, "x86") then {
  if !eq(MODE, 64) then {
    def X86_64_INST : Instruction;
  } else {
    def X86_32_INST : Instruction;
  }
}

// ===== Defvar (variables) =====

defvar NumRegs = 16;
defvar RegPrefix = "r";
defvar EnableOptimization = true;

// Using defvar in expressions
foreach i = 0-!sub(NumRegs, 1) in {
  def !strconcat(RegPrefix, !cast<string>(i)) : Register;
}

// ===== Defset (collecting definitions) =====

// Collect all instructions that match a pattern
defset list<Instruction> AllInstructions = {
  def INST_A : Instruction;
  def INST_B : Instruction;
  def INST_C : Instruction;
}

// Defset with conditional inclusion
defset list<Register> SpecialRegs = {
  foreach i = 0-7 in {
    if !eq(!and(i, 1), 0) then {
      def EVEN_REG#i : Register;
    }
  }
}

// ===== Deftype (type aliases) =====

deftype IntType = int;
deftype RegisterList = list<Register>;
deftype InstructionDAG = dag;

class TypedInstruction<IntType opcode> {
  IntType Opcode = opcode;
}

// ===== Assertions =====

// Simple assertion
assert !eq(1, 1), "Math is broken!";

// Assertion with expression
assert !ge(NumRegs, 8), "Need at least 8 registers";

// Assertion checking list size
defvar MyList = [1, 2, 3, 4, 5];
assert !eq(!size(MyList), 5), "List should have 5 elements";

// Assertion in class
class ValidatedInstruction<int opcode> {
  int Opcode = opcode;
  // Assert opcode is in valid range
  assert !and(!ge(opcode, 0), !lt(opcode, 256)),
         "Opcode must be between 0 and 255";
}

// ===== Complex combinations =====

// Combining let, foreach, and if
let Namespace = "MyTarget" in {
  foreach width = [8, 16, 32, 64] in {
    if !ge(width, 32) then {
      def WIDE_OP#width : Instruction {
        int BitWidth = width;
        let mayLoad = 1;
      }
    } else {
      def NARROW_OP#width : Instruction {
        int BitWidth = width;
        let mayLoad = 0;
      }
    }
  }
}

// Using defvar with multiclass
defvar BaseOpcode = 0x1000;

multiclass OpcodeSequence<int start, int count> {
  foreach i = 0-!sub(count, 1) in {
    def OP#i : Instruction {
      int Opcode = !add(start, i);
    }
  }
}

defm MY_OPS : OpcodeSequence<BaseOpcode, 16>;

// Dump for debugging
dump !add(10, 20);
dump !strconcat("Hello", " ", "World");
