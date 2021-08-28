module vm

import inst { Opcode }

pub struct VM {
pub mut:
	registers [32]int = [32]int{init: 0}
	pc        u64
	program   []byte = []byte{}
	remainder u32
	eq_flag   bool
}

pub fn (mut vm VM) run() {
	for {
		if vm.pc >= vm.program.len {
			println('process exceeded, no hlt encountered.')
			break
		}

		opcode := vm.decode_opcode() or { panic(err) }

		match opcode {
			.hlt {
				println('process exited.')
				return
			}
			.ldc {
				register := int(vm.next_8_bits())
				number := int(vm.next_16_bits())
				vm.registers[register] = number
			}
			.add {
				a := vm.get_register()
				b := vm.get_register()
				vm.registers[int(vm.next_8_bits())] = a + b
			}
			.sub {
				a := vm.get_register()
				b := vm.get_register()
				vm.registers[int(vm.next_8_bits())] = a - b
			}
			.mul {
				a := vm.get_register()
				b := vm.get_register()
				vm.registers[int(vm.next_8_bits())] = a * b
			}
			.div {
				a := vm.get_register()
				b := vm.get_register()
				vm.registers[int(vm.next_8_bits())] = a / b
				vm.remainder = u32(a % b)
			}
			.jmp {
				target := vm.registers[int(vm.next_8_bits())]
				vm.pc = u64(target)
			}
			.jeq {
				target := vm.registers[int(vm.next_8_bits())]

				if vm.eq_flag {
					vm.pc = u64(target)
				}
			}
			.jmpf {
				n := vm.registers[int(vm.next_8_bits())]
				vm.pc += u64(n)
			}
			.jmpb {
				n := vm.registers[int(vm.next_8_bits())]
				vm.pc -= u64(n)
			}
			.eq {
				a := vm.get_register()
				b := vm.get_register()

				vm.eq_flag = a == b
			}
		}
	}
}

pub fn (mut vm VM) decode_opcode() ?Opcode {
	vm.pc += 1
	opcode := Opcode(vm.program[vm.pc - 1])

	return if opcode.str() != 'unknown enum value' {
		opcode
	} else {
		error('Unknown opcode. byte 0x${vm.program[vm.pc - 1].hex()}')
	}
}

pub fn (mut vm VM) get_register() int {
	return vm.registers[int(vm.next_8_bits())]
}

pub fn (mut vm VM) next_8_bits() u8 {
	vm.pc += 1
	return vm.program[vm.pc - 1]
}

pub fn (mut vm VM) next_16_bits() u16 {
	vm.pc += 2
	return u16((u16(vm.program[vm.pc - 2]) << 8) | u16(vm.program[vm.pc - 1]))
}
