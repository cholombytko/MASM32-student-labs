.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32rt.inc

.data
    ;data arrays
    A_array dd 8, 12, 8, 12, 20
    C_array dd 2, 2, -50, -90, 2
    D_array dd 2, 3, -1, -1, 2

    calc_format db "a = %i, c = %i, d = %i", 13, "(-2 * %i + %i * 82)/(%i/4 -1) = %i/%i = %i", 13, 
    "Value after formatting: %i", 13, 13, 0

    MessageTitle db "Lab 5 - Cholombytko", 0
    MessageFormula db "6 Variant formula: (-2*ñ + d*82)/(a/4 - 1)", 13, 13, 0
    ZeroDenominatorException db "(-2 * %i + %i * 82)/(%i/4 -1) = %i/%i", 13, "Exception: Denomitator equals zero", 13, 13, 0

.data?
    calc_result dd 5 dup(?)
    modif_result dd 5 dup(?)
    calc_numerator dd 1 dup(?)
    calc_denominator dd 1 dup(?)
    str_buffer db 512 dup(?)
    str_text db 512 dup(?)
.code
start:
    INVOKE wsprintf, ADDR str_text, ADDR MessageFormula, 0
    MOV esi, 0 ; counter
.while esi < 5
    MOV eax, A_array[esi * 4]
    MOV ecx, 4
    CDQ
    IDIV ecx
    SUB eax, 1; a/4 - 1

    MOV calc_denominator, eax

    MOV ebx, C_array[esi * 4]
    MOV ecx, -2
    IMUL ebx, ecx; -2 * c

    MOV edx, D_array[esi * 4]
    MOV ecx, 82
    IMUL edx, ecx; 82 * d

    ADD ebx, edx
    MOV calc_numerator, ebx

    .if calc_denominator == 0
        INVOKE wsprintf, ADDR str_buffer, ADDR ZeroDenominatorException, C_array[esi * 4], D_array[esi * 4], A_array[esi * 4], 
        calc_numerator, calc_denominator
    .else
        MOV eax, calc_numerator
        MOV ebx, calc_denominator
        CDQ
        IDIV ebx

        MOV calc_result[esi * 4], eax
        TEST eax, 1
        JNZ is_odd
        JZ is_even
    is_even:
        MOV ecx, 2
        CDQ
        XOR edx, edx
        IDIV ecx
        MOV modif_result[esi * 4], eax
        JMP buffer_filling
    is_odd:
        IMUL eax, 5
        MOV modif_result[esi * 4], eax
        JMP buffer_filling

    buffer_filling:
        INVOKE wsprintf, ADDR str_buffer, ADDR calc_format, A_array[esi * 4], C_array[esi * 4], D_array[esi * 4], 
        C_array[esi * 4], D_array[esi * 4], A_array[esi * 4], 
        calc_numerator, calc_denominator, calc_result[esi * 4], modif_result[esi * 4]
    INVOKE szCatStr, addr str_text, addr str_buffer
    INC esi
    .endif
.endw
    INVOKE MessageBox, 0, addr str_text, addr MessageTitle, 0
end start
     