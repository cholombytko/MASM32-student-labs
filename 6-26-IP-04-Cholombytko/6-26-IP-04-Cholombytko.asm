.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    A_data_array dq 1.5, 2.0, -1.8, 2.5, -1.0
    B_data_array dq -1.5, 1.7, 4.2, 2.1, -1.0
    C_data_array dq 2.0, 3.5, 2.7, 6.1, 5.1
    D_data_array dq 1.5, 1.8, -1.9, -2.4, -1.2
 
    const0 dq 0.
    const4 dq 4.
    const12 dq 12.
    const1 dq 1.
 
    formula db "Variant 5 formula: (tg(a + c/4)-12*d)/(a*b-1)",13, 13, 0
    formula_formatted db "a = %s, b = %s, c = %s, d = %s", 13,"(tg(%s + %s/4)-12*(%s))/((%s)*(%s)-1)", 13, 0
    answer_formatted db "Final answer is: %s", 13, 13, 0
    zero_exception_stdout db "Zero denominator exception", 13, 13, 0
    msg_box_header db "Cholombytko lab 6", 0

.data?

    std_buffer_output db 128 dup(?)
    msg_box_message db 1024 dup(?)
    my_data db 40 dup(?)

    calc_numerator dt 1 dup(?)
    calc_denominator dt 1 dup(?)
    calc_result dq 1 dup(?)

.code
data_output proc
    invoke FloatToStr2, A_data_array[ebp*8], addr my_data[0]
    invoke FloatToStr2, B_data_array[ebp*8], addr my_data[8]
    invoke FloatToStr2, C_data_array[ebp*8], addr my_data[16]
    invoke FloatToStr2, D_data_array[ebp*8], addr my_data[24]
    invoke FloatToStr2, calc_result, addr my_data[32]
    invoke wsprintf, addr std_buffer_output, 
        addr formula_formatted,
        addr my_data[0],
        addr my_data[8],
        addr my_data[16],
        addr my_data[24], 
        addr my_data[0], 
        addr my_data[16], 
        addr my_data[24], 
        addr my_data[0],
        addr my_data[8]
    invoke szCatStr, addr msg_box_message, addr std_buffer_output
    ret
data_output endp

answer_output proc
    call data_output
    invoke wsprintf, addr std_buffer_output, 
        addr answer_formatted, 
        addr my_data[32]
    invoke szCatStr, addr msg_box_message, addr std_buffer_output
    ret
answer_output endp

zero_denominator_exception proc
    call data_output
    invoke szCatStr, addr msg_box_message, addr zero_exception_stdout
    ret
zero_denominator_exception endp

calculation_process proc

    finit
    fld C_data_array[ebp * 8]
    fdiv const4
    fadd A_data_array[ebp * 8]
    ;(a + c/4)

    ;now calculating tg(a + c/4) part
    fptan
    fxch st(1)
    ;(tg(a + c/4) - 12*d)
    fld D_data_array[ebp*8]
    fmul const12
    fxch st(1)
    fsub st(0), st(1)

    fld A_data_array[ebp*8]
    fmul B_data_array[ebp*8]
    fsub const1
    fxch st(1)
    fdiv st(0), st(1)
    fnstsw ax
    shr ax, 3
    jc zero_exception
    fst calc_result
    call answer_output
    ret

    zero_exception:
    call zero_denominator_exception
    ret

calculation_process endp

main:
    invoke wsprintf, addr msg_box_message, addr formula
    
    mov ebp, 0
    
    .while ebp < 5
        call calculation_process
        add ebp, 1
    .endw

    invoke MessageBox, 0, addr msg_box_message, addr msg_box_header, MB_OK
    invoke ExitProcess,0
end main