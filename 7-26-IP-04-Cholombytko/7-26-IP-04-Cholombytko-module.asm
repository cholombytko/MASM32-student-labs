.386
.model flat, stdcall
option casemap :none

public third_part_denominator
extern A_data_array:qword, B_data_array:qword, const1:qword

.code

third_part_denominator proc
	
    fld A_data_array[edi*8]
    fmul B_data_array[edi*8]
    fsub const1
    fxch st(1)
    fdiv st(0), st(1)
    ret
	
third_part_denominator endp

end