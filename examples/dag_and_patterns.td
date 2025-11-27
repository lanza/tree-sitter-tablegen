// Example: DAG (Directed Acyclic Graph) values and pattern matching
// This demonstrates DAG construction and manipulation

// ===== Basic DAG syntax =====

// DAG with operator and operands
class SimpleDAGClass {
  dag Value = (add i32:$lhs, i32:$rhs);
}

// DAG with nested structure
class NestedDAGClass {
  dag Value = (add (mul i32:$a, i32:$b), (sub i32:$c, i32:$d));
}

// DAG with named arguments
class NamedDAGClass {
  dag Value = (store i32:$val, addr:$ptr);
}

// DAG with unnamed arguments
class UnnamedDAGClass {
  dag Value = (add i32, i32);
}

// ===== Pattern matching with DAGs =====

class Pattern<dag pattern, dag result> {
  dag PatternToMatch = pattern;
  dag ResultInstruction = result;
}

// Simple pattern
def AddPattern : Pattern<
  (add GPR32:$lhs, GPR32:$rhs),
  (ADD_rr GPR32:$lhs, GPR32:$rhs)
>;

// Pattern with immediate
def AddImmPattern : Pattern<
  (add GPR32:$src, imm:$val),
  (ADDI_ri GPR32:$src, imm:$val)
>;

// Nested pattern
def ComplexPattern : Pattern<
  (add (mul GPR32:$a, GPR32:$b), GPR32:$c),
  (ADD_rr (MUL_rr GPR32:$a, GPR32:$b), GPR32:$c)
>;

// ===== Complex DAG examples =====

// Load/Store patterns
def LoadPattern : Pattern<
  (load addr:$ptr),
  (LOAD addr:$ptr)
>;

def StorePattern : Pattern<
  (store GPR32:$val, addr:$ptr),
  (STORE GPR32:$val, addr:$ptr)
>;

// Pattern with transformation
def ShiftAddPattern : Pattern<
  (add (shl GPR32:$src, 2), GPR32:$base),
  (LEA GPR32:$base, GPR32:$src, 4)
>;

// DAG with variadic arguments
class VariadicDAGClass {
  dag Value = (build_vector
    i32:$e0, i32:$e1, i32:$e2, i32:$e3,
    i32:$e4, i32:$e5, i32:$e6, i32:$e7
  );
}

// ===== Using DAGs in instruction definitions =====

class Instruction {
  dag OutOperandList = (outs);
  dag InOperandList = (ins);
  list<dag> Pattern = [];
}

def ADD_RR : Instruction {
  let OutOperandList = (outs GPR32:$dst);
  let InOperandList = (ins GPR32:$src1, GPR32:$src2);
  let Pattern = [(set GPR32:$dst, (add GPR32:$src1, GPR32:$src2))];
}

def MUL_RI : Instruction {
  let OutOperandList = (outs GPR32:$dst);
  let InOperandList = (ins GPR32:$src, i32imm:$imm);
  let Pattern = [(set GPR32:$dst, (mul GPR32:$src, imm:$imm))];
}

// Instruction with multiple patterns
def SELECT : Instruction {
  let OutOperandList = (outs GPR32:$dst);
  let InOperandList = (ins GPR32:$cond, GPR32:$true, GPR32:$false);
  let Pattern = [(set GPR32:$dst, (select GPR32:$cond, GPR32:$true, GPR32:$false))];
}

// ===== DAG in multiclass =====

multiclass LoadStore<string prefix, dag addrMode> {
  def _LOAD : Instruction {
    let OutOperandList = (outs GPR32:$dst);
    let InOperandList = addrMode;
    string Name = prefix # "_load";
  }

  def _STORE : Instruction {
    let OutOperandList = (outs);
    let InOperandList = !listconcat([(ins GPR32:$src)], [addrMode]);
    string Name = prefix # "_store";
  }
}

defm BASE : LoadStore<"base", (ins GPR32:$ptr)>;
defm OFFSET : LoadStore<"offset", (ins GPR32:$base, i32imm:$offset)>;

// ===== Complex pattern matching =====

// Pattern with condition
class CondPattern<dag pattern, dag result, bit enabled> {
  dag PatternToMatch = pattern;
  dag ResultInstruction = result;
  bit IsEnabled = enabled;
}

// Commutative pattern (matches both operand orders)
def CommutativeAdd : Pattern<
  (add GPR32:$a, GPR32:$b),
  (ADD_rr GPR32:$a, GPR32:$b)
> {
  let isCommutable = 1;
}

// Pattern fragments for reuse
class PatternFrag<dag pattern> {
  dag Fragment = pattern;
}

def AddrPattern : PatternFrag<(add GPR32:$base, i32imm:$offset)>;

