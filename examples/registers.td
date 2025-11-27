// Example: Register definitions
// This demonstrates basic classes, template arguments, and record definitions

// Base class for all registers
class Register<string n, bits<16> num = 0> {
  string Name = n;
  bits<16> HWEncoding = num;
  string Namespace = "MyTarget";
}

// Sub-register index
class SubRegIndex<int size, int offset = 0> {
  int Size = size;
  int Offset = offset;
}

// 32-bit general purpose registers
class GPR<bits<16> num, string n> : Register<n, num> {
  let Namespace = "MyTarget";
}

// Define specific registers
def R0 : GPR<0, "r0">;
def R1 : GPR<1, "r1">;
def R2 : GPR<2, "r2">;
def R3 : GPR<3, "r3">;
def R4 : GPR<4, "r4">;
def R5 : GPR<5, "r5">;
def R6 : GPR<6, "r6">;
def R7 : GPR<7, "r7">;

// Sub-register indices
def sub_32bit : SubRegIndex<32>;
def sub_16bit : SubRegIndex<16>;
def sub_8bit_lo : SubRegIndex<8, 0>;
def sub_8bit_hi : SubRegIndex<8, 8>;

// Register class
def GPR32 : RegisterClass<"MyTarget", [i32], 32, (add
  R0, R1, R2, R3, R4, R5, R6, R7
)>;

// 64-bit registers composed of pairs
class GPR64<bits<16> num, string n, list<Register> subregs>
  : Register<n, num> {
  let SubRegs = subregs;
  let SubRegIndices = [sub_32bit];
}

def R0_R1 : GPR64<0, "r0_r1", [R0, R1]>;
def R2_R3 : GPR64<1, "r2_r3", [R2, R3]>;
