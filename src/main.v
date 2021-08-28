import vm

fn main() {
	mut vm := vm.VM{
		program: [byte(77), 0x00, 0x00, 0x00]
	}

	vm.run()
}