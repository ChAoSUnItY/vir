module repl

import readline
import vm { VM }

pub struct REPL {
pub mut:
	vm             VM       = VM{}
	command_buffer []string = []
}

pub fn (mut repl REPL) run() {
	println('Welcome to V Iridium! input instrcutions and have fun!')

	for {
		buf := readline.read_line('>>> ') or {
			continue
			''
		}.trim_space()

		repl.command_buffer << buf

		match buf {
			':history' {
				for cmd in repl.command_buffer {
					println(cmd)
				}
			}
			':reset' {
				repl.vm = VM{}
			}
			':register' {
				println(repl.vm.registers)
			}
			':exit' {
				break
			}
			':dump' {
				println(repl.vm.program)
			}
			':decompile' {
				println(repl.decompile())
			}
			else {
				bytecode := buf.split(' ').map(byte(it.i8()))

				repl.vm.program << bytecode

				repl.vm.run()
			}
		}
	}
}

fn (mut repl REPL) decompile() string {
	mut sb := ['==========================\n']

	repl.vm.pc = 0

	for {
		if repl.vm.pc >= repl.vm.program.len {
			break
		}

		opcode := repl.vm.decode_opcode() or {
			panic(err)
		}

		match opcode {
			.hlt {
				sb << '00\n'
				sb << 'HLT\n'
			}
			.ldc {
				target := repl.next_8_bits()
				v1 := repl.next_8_bits()
				v2 := repl.next_8_bits()
				value := u16((u16(v1 << 8) | u16(v2)))

				sb << '01\t${target.hex()}\t\t${v1.hex()}\t${v2.hex()}\n'
				sb << 'LDC\tindex: ${target.str()}\tvalue:${value.str()}\n'
			}
			else {}
		}
	}

	sb << '=========================='

	repl.vm.pc = 0

	return sb.join('')
}

fn (mut repl REPL) next_8_bits() u8 {
	return repl.vm.next_8_bits()
}
