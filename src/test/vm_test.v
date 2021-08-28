module test

import vm

pub fn test_hlt() {
	mut vm := vm.VM{
		program: [byte(0x00), 0x00, 0x00, 0x00]
	}

	vm.run()
	assert vm.pc == 1
}
