module repl

import readline { read_line }
import math { ceil }

import cintf { isprint }
import vm { VM }

// import chaosunity.colored
pub struct REPL {
pub mut:
	vm             VM       = VM{}
	command_buffer []string = []
}

pub fn (mut repl REPL) run() {
	println('Welcome to V Iridium! input instrcutions and have fun!')

	for {
		mut buf := ''
		print('>>> ')

		reprompt:
		unsafe {
			buf = read_line('') or {
				goto reprompt
			}.trim_space()
		}
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
			':bytecode' {
				println(repl.vm.program)
			}
			':dump' {
				repl.hex_dump()
			}
			':decompile' {
				repl.decompile()
			}
			else {
				if buf.starts_with(':') {
					eprintln('Unknown command ${buf}.')
					continue
				}

				bytecode := buf.split(' ').map(byte('0x$it'.i8()))

				repl.vm.program << bytecode

				repl.vm.run()
			}
		}
	}
}

fn (repl REPL) hex_dump() {
	mut hex_chunks := [][]byte{cap: int(repl.vm.program.len / 16)}

	for i := 0; true; {
		if repl.vm.program.len <= i {
			break
		}

		if repl.vm.program.len < i + 16 {
			hex_chunks << repl.vm.program[i..]

			break
		}

		hex_chunks << repl.vm.program[i..i + 16]
		i += 16
	}

	mut ascii_chunks := [][]string{len: hex_chunks.len, init: []string{cap: 16, init: ''}}

	for i, c in hex_chunks {
		for h in c {
			ascii_chunks[i] << h.ascii_str()
		}
	}

	println('          Offset Bytes                                           Ascii')
	println('                 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F')
	println('          ------ ----------------------------------------------- -----')

	for i, c in hex_chunks {
		print('${i:015}0 ')

		for h in c {
			print('$h.hex() ')
		}

		if c.len < 16 {
			for _ in 0 .. 16 - c.len {
				print('   ')
			}
		}

		for a in ascii_chunks[i] {
			if isprint(a) {
				print(a)
			} else {
				print('.')
			}
		}

		println('')
	}
}

fn (mut repl REPL) decompile() {
	println('=======================================')

	repl.vm.pc = 0

	for {
		if repl.vm.pc >= repl.vm.program.len {
			break
		}

		opcode := repl.vm.decode_opcode() or { panic(err) }

		match opcode {
			.hlt {
				println('00')

				// colorize.magenta()
				println('HLT')

				// colorize.reset()
			}
			.ldc {
				i := repl.next_8_bits()
				v1 := repl.next_8_bits()
				v2 := repl.next_8_bits()
				value := u16((u16(v1 << 8) | u16(v2)))

				println('01\t$i.hex()\t\t$v1.hex()\t$v2.hex()')

				// colorize.magenta()
				print('LDC\t')

				// colorize.yellow()
				print('index: $i.str()\t')

				// colorize.green()
				println('value: $value.str()')

				// colorize.reset()
			}
			.add, .sub, .mul, .div {
				i1 := repl.next_8_bits()
				i2 := repl.next_8_bits()
				i3 := repl.next_8_bits()

				println('${int(opcode).hex()}\t$i1.hex()\t\t$i2.hex()\t\t$i3.hex()')

				// colorize.magenta()
				print('$opcode.str().to_upper()\t')

				// colorize.yellow()
				println('index 0: $i1.str()\tindex 1: $i2.str()\tindex 2: $i3.str()')
			}
			.inc, .dec, .jmp, .jeq, .jmpf, .jmpb {
				i := repl.next_8_bits()

				println('${int(opcode).hex()}\t$i.hex()')

				// colorize.magenta()
				print('$opcode.str().to_upper()\t')

				// colorize.yellow()
				println('index: $i.str()')
			}
			.eq, .neq, .gt, .gte, .lt, .lte {
				i1 := repl.next_8_bits()
				i2 := repl.next_8_bits()

				println('${int(opcode).hex()}\t$i1.hex()\t\t$i2.hex()')

				// colorize.magenta()
				print('$opcode.str().to_upper()\t')

				// colorize.yellow()
				println('index 0: $i1.str()\tindex 1: $i2.str()')
			}
			.inv {
				println('${int(opcode).hex()}')

				// colorize.magenta()
				println('$opcode.str().to_upper()')
			}
		}
	}

	println('=======================================')

	repl.vm.pc = 0
}

fn (mut repl REPL) next_8_bits() u8 {
	return repl.vm.next_8_bits()
}
