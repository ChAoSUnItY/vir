module cintf

#flag -I @VROOT/cintf
#flag @VROOT/cintf/str.o
#include "str.h"

fn C.isprint(c byte) int

pub fn isprint(c string) bool {
	return C.isprint(c.bytes()[0]) != 0
}
