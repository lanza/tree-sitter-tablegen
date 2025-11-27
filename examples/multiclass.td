// Example: Multiclass definitions and usage
// This demonstrates the power of multiclass for code generation

// Basic multiclass with template arguments
multiclass BasicMulticlass<string name, int value> {
  def _A : Record {
    string Name = name # "_A";
    int Value = value;
  }

  def _B : Record {
    string Name = name # "_B";
    int Value = !add(value, 1);
  }
}

// Instantiate the multiclass
defm MY_BASIC : BasicMulticlass<"MyBasic", 100>;
// Creates: MY_BASIC_A with Name="MyBasic_A", Value=100
//          MY_BASIC_B with Name="MyBasic_B", Value=101

// Multiclass with parent classes
class InstructionBase;
class RType : InstructionBase;
class IType : InstructionBase;

multiclass BinaryOp<bits<7> opcode, string mnemonic> {
  def _rr : RType {
    bits<7> Opcode = opcode;
    string Mnemonic = mnemonic;
    string AsmString = mnemonic # " $rd, $rs1, $rs2";
  }

  def _ri : IType {
    bits<7> Opcode = !add(opcode, 1);
    string Mnemonic = mnemonic # "i";
    string AsmString = mnemonic # "i $rd, $rs1, $imm";
  }
}

defm ADD : BinaryOp<0b0110011, "add">;
defm SUB : BinaryOp<0b0110111, "sub">;

// Multiclass with nested foreach
multiclass VectorOps<int width> {
  foreach op = ["add", "sub", "mul", "div"] in {
    def _#op#width : Instruction {
      string Operation = op;
      int VectorWidth = width;
      string Name = "v" # op # width;
    }
  }
}

defm VEC128 : VectorOps<128>;
defm VEC256 : VectorOps<256>;

// Multiclass with conditional definitions
multiclass ConditionalOps<bit hasExtension> {
  def _BASE : Instruction {
    string Category = "base";
  }

  if hasExtension then {
    def _EXT : Instruction {
      string Category = "extension";
    }
  }
}

defm STANDARD : ConditionalOps<0>;  // Only creates STANDARD_BASE
defm EXTENDED : ConditionalOps<1>;  // Creates both EXTENDED_BASE and EXTENDED_EXT

// Multiclass with parent class list
class Feature;
def FeatureSSE : Feature;
def FeatureAVX : Feature;

multiclass FPOps<list<Feature> features> {
  let Predicates = features in {
    def _PS : Instruction {
      string Type = "packed single";
    }

    def _PD : Instruction {
      string Type = "packed double";
    }
  }
}

defm FADD : FPOps<[FeatureSSE]>;
defm VFADD : FPOps<[FeatureAVX]>;

// Multiclass inheriting from another multiclass
multiclass ExtendedBinaryOp<bits<7> opcode, string mnemonic>
  : BinaryOp<opcode, mnemonic> {
  def _rm : Instruction {
    string AsmString = mnemonic # " $rd, ($rs1)";
    bit mayLoad = 1;
  }
}

defm LOAD_ADD : ExtendedBinaryOp<0b0001111, "ladd">;

// Complex multiclass with multiple features
multiclass MemoryOp<
  bits<7> opcode,
  string mnemonic,
  list<int> sizes = [8, 16, 32, 64],
  bit isSigned = 0
> {
  foreach size = sizes in {
    def _#size : Instruction {
      bits<7> Opcode = opcode;
      int Size = size;
      string Name = mnemonic # size;
      bit IsSigned = isSigned;

      assert !or(!eq(size, 8), !eq(size, 16), !eq(size, 32), !eq(size, 64)),
             "Invalid size for memory operation";
    }
  }
}

defm LOAD : MemoryOp<0b0000011, "load", [8, 16, 32], 0>;
defm LOADS : MemoryOp<0b0000111, "loads", [8, 16, 32], 1>;
defm STORE : MemoryOp<0b0100011, "store">;

// Multiclass with defvar inside
multiclass RegisterPair<int baseNum> {
  defvar highNum = !add(baseNum, 1);

  def _LO : Register {
    int Number = baseNum;
    string Name = "r" # baseNum;
  }

  def _HI : Register {
    int Number = highNum;
    string Name = "r" # highNum;
  }

  def _PAIR : RegisterPair {
    Register Low = !cast<Register>(NAME # "_LO");
    Register High = !cast<Register>(NAME # "_HI");
  }
}

defm R0 : RegisterPair<0>;  // Creates R0_LO, R0_HI, R0_PAIR
defm R2 : RegisterPair<2>;  // Creates R2_LO, R2_HI, R2_PAIR

// Multiclass with nested multiclass instantiation
multiclass ALU<string prefix> {
  defm prefix#_ADD : BinaryOp<0b0000000, "add">;
  defm prefix#_SUB : BinaryOp<0b0000001, "sub">;
  defm prefix#_MUL : BinaryOp<0b0000010, "mul">;
}

defm INTEGER : ALU<"INT">;
defm FLOAT : ALU<"FP">;

// Multiclass with let statements
multiclass PredicatedOps<Predicate pred> {
  let Predicates = [pred] in {
    def _V : Instruction {
      string Variant = "vector";
    }

    let isCodeGenOnly = 1 in {
      def _PSEUDO : Instruction {
        string Variant = "pseudo";
      }
    }
  }
}

// Anonymous record in multiclass
multiclass CountedOps<int count> {
  foreach i = 0-!sub(count, 1) in {
    def _#i : Instruction {
      int Index = i;
    }
  }

  // Anonymous def for metadata
  def {
    list<Instruction> AllOps = !filter(
      x, [!cast<Instruction>(NAME#_0), !cast<Instruction>(NAME#_1)],
      true
    );
  }
}

defm SEQUENCE : CountedOps<4>;
