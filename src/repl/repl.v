module repl

import readline
import vm { VM }

pub struct REPL {
pub mut:
	vm VM = VM {}
	command_buffer []string = []
}

pub fn (mut repl REPL) run() {
	println("Welcome to V Iridium! input instrcutions and have fun!")

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
				repl.vm = VM {}
			}
			':register' {
				println(repl.vm.registers)
			}
			':exit' {
				break
			}
			else {
				bytecode := buf.split(' ').map(byte(it.i8()))

				repl.vm.program << bytecode

				repl.vm.run()
			}
		}

		
	}
}
