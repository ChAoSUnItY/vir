# vir
Iridium (VM) written in V.

Mainly for VM learning purpose.

------
## Usage

### Prerequisites
- with V Lang installed

### Summary
To run vir, run the following command:

```cmd
v run src/main.v
```

Now you should see welcome message and last line with `>>>`, to evaluate opcodes in Iridium VM REPL, please refer to [Opcode](#Opcodes), here are some basic examples:

1. Addition: 1 + 1 = 2

Bytecode
```
01 00 00 01 02 00 00 01 00
```
Decompiled human readable code
```
01      00          00      01 
LDC     index: 0    value: 1
02      00          00          01
ADD     index: 0    index: 0    index: 1
00
HLT
```
Result
```
Registers:
[ 1, 2 ... ]
```
2. Factorial: 5!

Bytecode
```
01 00 00 01 01 01 00 01 01 02 00 06 01 03 00 16 04 00 01 01 06 00 12 00 02 13 09 03 00
```
Decompiled human readable code
```
01      00          00      01
LDC     index: 0    value: 1
01      01          00      01
LDC     index: 1    value: 2
01      02          00      06
LDC     index: 2    value: 6
01      03          00      16
LDC     index: 3    value: 16
04      00          01          01
MUL     index: 0    index: 1    index: 1
06      00
INC     index: 1
12      00          02
EQ      index: 0    index: 2
13
INV
09      03
JEQ     index: 3
00
HLT
```
Result
```
Registers:
[ 6, 120, 6, 16 ... ]
```
Detail:
First, we load four values, 1, 2, 6, and 16 into register. The first value indicates loop index (i + 1); while the second value is where evaluator put result to; and the third and forth values refer to times to loop and byte position where loop starts. Then we starts to multiply the first and the second value and then store result to index 2. To loop, we check value at index 1 equals to value at index 2, which is 6 constantly, and invert boolean result. If it's true, then jump to byte index 16 (where the multiplication instruction is), else terminate the process. The final result 120 should store at index 2.

------
## Opcodes
| Instruction (Opcode) | Inputs | description |
|--|--|--|
| HLT (00) | N/A | Terminate program |
| LDC (01) | 1: index <br/>2, 3: i32 value in hex | Load an integer value to register |
| ADD (02) | 1, 2, 3: index | Add two values from register and store result to register |
| SUB (03) | `ditto` | Subtract two values from register and store result to register |
| MUL (04) | `ditto` | Multiply two values from register and store result to register |
| DIV (05) | `ditto` | Divide two values from register and store result to register |
| INC (06) | 1: index | Increment value |
| DEC (07) | 1: index | Decrement value |
| JMP (08) | 1: index | Change current process byte loading index to providing index, notice that target index destination must be a opcode instruction. |
| JEQ (09) | `ditto` | Same as JMP, but conditionally changes current process byte loading index depends on VM's current eq flag. |
| JMPF (10) | 1: relative forward position | Increment current process byte loading index with providing value. |
| JMPB (11) | 1: relative backward position | Decrement current process byte loading index with providing value. |
| EQ (12) | 1, 2: index | Compare two value's equality and store result to VM's eq flag. |
| INV (13) | N/A | Invert current VM's eq flag. |