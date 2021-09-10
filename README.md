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

1. Addition
```
01 00 00 01 02 00 00 01 00
```
```
01      00          00      01 
LDC     index: 0    value: 1
02      00          00          01
ADD     index: 0    index: 0    index: 1
00
HLT
```

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
| JMP (06) | 1: index | Change current process byte loading index to providing index, notice that target index destination must be a opcode instruction. |
| JEQ (07) | `ditto` | Same as JMP, but conditionally changes current process byte loading index depends on VM's current eq flag. |
| JMPF (08) | 1: relative forward position | Increment current process byte loading index with providing value. |
| JMPB (09) | 1: relative backward position | Decrement current process byte loading index with providing value. |
| EQ (10) | 1, 2: index | Compare two value's equality and store result to VM's eq flag. |