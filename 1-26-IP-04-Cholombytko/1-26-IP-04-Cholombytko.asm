.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc
.data?
    MsgBoxText db 512 dup(?)
    MsgBoxSecondText db 512 dup(?)
    buffPosD db 256 dup(?)
    buffPosE db 256 dup(?)
    buffPosF db 256 dup(?)
    buffNegD db 256 dup(?)
    buffNegE db 256 dup(?)
    buffNegF db 256 dup(?)
.data
    MsgBoxCaption db "First lab - Cholombytko", 0
    MsgBoxTextPattern db "Birthday = %s", 10, "Positives:", 10, "A = %d", 10, "B = %d", 10, "C = %d", 10, "D = %s", 10, "E = %s", 10, "F = %s",
    10, "Negatives:", 10,"-A = %d", 10, "-B = %d", 10, "-C = %d", 10, "-D = %s", 10, "-E = %s", 10, "-F = %s", 0

    MyBirthdayDate db "24062003", 0

    posA db 24
    posA1 dw 24
    posA2 dd 24
    posA3 dq 24

    negA db -24
    negA1 dw -24
    negA2 dd -24
    negA3 dq -24

    posB dw 2406
    posB1 dd 2406
    posB2 dq 2406

    negB dw -2406
    negB1 dd -2406
    negB2 dq -2406

    posC dd 24062003
    posC1 dq 24062003

    negC dd -24062003
    negC1 dq -24062003

    posD dq 0.056
    negD dq -0.056

    posD1 dd 0.056
    negD1 dd -0.056

    posE dq 5.621
    negE dq -5.621

    posF dq 56219.633
    negF dq -56219.633

    posF1 dt 56219.633
    negF1 dt -56219.633

.code
Main:
    invoke FloatToStr2, posD, addr buffPosD
    invoke FloatToStr2, posE, addr buffPosE
    invoke FloatToStr2, posF, addr buffPosF
    invoke FloatToStr2, negD, addr buffNegD
    invoke FloatToStr2, negE, addr buffNegE
    invoke FloatToStr2, negF, addr buffNegF
    invoke wsprintf, addr MsgBoxText, addr MsgBoxTextPattern, addr MyBirthdayDate, posA2, posB1, posC, offset buffPosD, offset buffPosE, offset buffPosF,
    negA2, negB1, negC, offset buffNegD, offset buffNegE, offset buffNegF
    invoke MessageBox, 0, addr MsgBoxText, addr MsgBoxCaption, 0
    invoke ExitProcess, 0
end Main
