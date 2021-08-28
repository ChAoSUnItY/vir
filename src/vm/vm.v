module vm

import inst

pub struct VM {
pub mut:
	registers [32]int = [32]int{init: 0}
	pc        u64
	program   []byte  = []byte{}
}

pub fn (mut vm VM) run() {
	for {
		if vm.pc >= vm.program.len {
			break
		}

		opcode := vm.decode_opcode() or {
			panic(err)
		}

		match opcode {
			.hlt {
				println('process exited.')
				return
			}
		}
	}
}

fn (mut vm VM) decode_opcode() ?inst.Opcode {
	vm.pc += 1
	match vm.program[vm.pc - 1] {
		0x00 {
			return .hlt
		}
		else {
			return error('Unknown opcode. byte 0x${vm.program[vm.pc - 1]:02x}')
		}
	}
}
