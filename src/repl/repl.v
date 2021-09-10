module repl

import readline
import vm { VM }
//import chaosunity.colored

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
				repl.decompile()
			}
			else {
				if buf.starts_with(':') {
					eprintln('Unknown command ${buf}.')
					continue
				}

				bytecode := buf.split(' ').map(byte(it.i8()))

				repl.vm.program << bytecode

				repl.vm.run()
			}
		}
	}
}

fn (mut repl REPL) decompile() {
	println('=======================================')

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
				println('00')
				//colorize.magenta()
				println("HLT")
				//colorize.reset()
			}
			.ldc {
				target := repl.next_8_bits()
				v1 := repl.next_8_bits()
				v2 := repl.next_8_bits()
				value := u16((u16(v1 << 8) | u16(v2)))

				println('01\t${target.hex()}\t\t${v1.hex()}\t${v2.hex()}')

				//colorize.magenta()
				print('LDC\t')
				//colorize.yellow()
				print('index: ${target.str()}\t')
				//colorize.green()
				println('value: ${value.str()}')
				//colorize.reset()
			}
			.add, .sub, .mul, .div {
				i1 := repl.next_8_bits()
				i2 := repl.next_8_bits()
				i3 := repl.next_8_bits()

				println('${int(opcode).hex()}\t\t${i1.hex()}\t${i2.hex()}\t\t${i3.hex()}')

				//colorize.magenta()
				print('${opcode.str().to_upper()}\t')
				//colorize.yellow()
				println('index 0: ${i1.str()}\tindex 1: ${i2.str()}\tindex 2: ${i3.str()}')
			}
			else {}
		}
	}

	println('=======================================')

	repl.vm.pc = 0
}

fn (mut repl REPL) next_8_bits() u8 {
	return repl.vm.next_8_bits()
}
