; __chkstk for the CRT-free build: newer MSVC versions emit a stack probe for functions whose frame passes one page
; (Init holds several 1 KB Buf locals). Touches each page between the current stack limit and the new frame, in order,
; so that the guard page moves down as Windows expects. RAX = frame size; preserves every other register.
.code
__chkstk PROC
    sub     rsp, 10h
    mov     [rsp], r10
    mov     [rsp + 8], r11
    xor     r11, r11
    lea     r10, [rsp + 18h]
    sub     r10, rax
    cmovb   r10, r11
    mov     r11, gs:[10h]
    cmp     r10, r11
    jae     done
    and     r10w, 0F000h
probe:
    lea     r11, [r11 - 1000h]
    mov     byte ptr [r11], 0
    cmp     r10, r11
    jne     probe
done:
    mov     r10, [rsp]
    mov     r11, [rsp + 8]
    add     rsp, 10h
    ret
__chkstk ENDP
END
