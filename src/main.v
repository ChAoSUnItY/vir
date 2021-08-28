import vm

fn main() {
	mut vm := vm.VM{
		program: [byte(0x01), 0x01, 0x01, 244, 0x00]
	}

	vm.run()

	println(vm.registers)
}
