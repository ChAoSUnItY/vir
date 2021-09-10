/**
*	Visitor has been temporary deprecated due to chain method calling deprecation.
**/

module @asm

import inst { Instruction }

[deprecated: 'Chain method calling is not avaiable.']
pub struct Visitor {
pub mut:
	instructions []Instruction
}

pub fn visit() Visitor {
	return Visitor{
		instructions: []Instruction{}
	}
}

pub fn (mut v Visitor) ldc(index int, value int) Visitor {
	v.instructions << Instruction{
		opcode: .ldc
		bits: [index, (value >> 8) & 0xFF, value & 0xFF]
	}
	return v
}

pub fn (mut v Visitor) add(index1 int, index2 int, index3 int) Visitor {
	v.instructions << Instruction{
		opcode: .add
		bits: [index1, index2, index3]
	}

	return v
}

pub fn (v Visitor) emit() []byte {
	mut builder := []byte{}

	for inst in v.instructions {
		builder << byte(inst.opcode)
		builder << inst.bits.map(byte(it))
	}

	builder << 0x00 // HLT

	return builder
}
