// Example: Instruction definitions
// This demonstrates classes with complex template arguments, parent classes,
// and multiclass usage

// Base instruction class
class Instruction<dag outs, dag ins, string asmstr, list<dag> pattern> {
  dag OutOperandList = outs;
  dag InOperandList = ins;
  string AsmString = asmstr;
  list<dag> Pattern = pattern;
  bits<32> Encoding = 0;
}

// Format class for different instruction formats
class Format<bits<5> val> {
  bits<5> Value = val;
}

def FormatR : Format<0>;
def FormatI : Format<1>;
def FormatS : Format<2>;

// R-type instruction (register-register)
class RType<bits<7> opcode, bits<3> funct3, bits<7> funct7,
            dag outs, dag ins, string asmstr, list<dag> pattern>
  : Instruction<outs, ins, asmstr, pattern> {
  bits<5> rd;
  bits<5> rs1;
  bits<5> rs2;

  let Encoding{6-0}   = opcode;
  let Encoding{11-7}  = rd;
  let Encoding{14-12} = funct3;
  let Encoding{19-15} = rs1;
  let Encoding{24-20} = rs2;
  let Encoding{31-25} = funct7;
}

// I-type instruction (immediate)
class IType<bits<7> opcode, bits<3> funct3,
            dag outs, dag ins, string asmstr, list<dag> pattern>
  : Instruction<outs, ins, asmstr, pattern> {
  bits<5> rd;
  bits<5> rs1;
  bits<12> imm;

  let Encoding{6-0}   = opcode;
  let Encoding{11-7}  = rd;
  let Encoding{14-12} = funct3;
  let Encoding{19-15} = rs1;
  let Encoding{31-20} = imm;
}

// Multiclass for arithmetic operations
multiclass ALU_rr<bits<7> opcode, bits<3> funct3, bits<7> funct7,
                  string mnemonic> {
  def _rr : RType<opcode, funct3, funct7,
                  (outs GPR32:$rd), (ins GPR32:$rs1, GPR32:$rs2),
                  mnemonic # " $rd, $rs1, $rs2",
                  []>;
}

multiclass ALU_ri<bits<7> opcode, bits<3> funct3,
                  string mnemonic> {
  def _ri : IType<opcode, funct3,
                  (outs GPR32:$rd), (ins GPR32:$rs1, i32imm:$imm),
                  mnemonic # " $rd, $rs1, $imm",
                  []>;
}

// Define specific instructions using multiclass
defm ADD : ALU_rr<0b0110011, 0b000, 0b0000000, "add">;
defm SUB : ALU_rr<0b0110011, 0b000, 0b0100000, "sub">;
defm AND : ALU_rr<0b0110011, 0b111, 0b0000000, "and">;
defm OR  : ALU_rr<0b0110011, 0b110, 0b0000000, "or">;
defm XOR : ALU_rr<0b0110011, 0b100, 0b0000000, "xor">;

defm ADDI : ALU_ri<0b0010011, 0b000, "addi">;
defm ANDI : ALU_ri<0b0010011, 0b111, "andi">;
defm ORI  : ALU_ri<0b0010011, 0b110, "ori">;
defm XORI : ALU_ri<0b0010011, 0b100, "xori">;

// Single instruction definition without multiclass
def NOP : IType<0b0010011, 0b000,
                (outs), (ins),
                "nop",
                []> {
  let rd = 0;
  let rs1 = 0;
  let imm = 0;
}
