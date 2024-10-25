%include "syscall.asm"
%include "terminal.asm"
%include "utils.asm"

global _start

section .text

_start:
    call unbuffer         ; unbuffer stdin

    call tile_randgen
poll_loop:
    call tile_randgen
    call draw_board

.read:
    call getchar
    
    cmp al, "w"
    je up
    cmp al, "a"
    je left
    cmp al, "s"
    je down
    cmp al, "d"
    je right
    cmp al, 10
    je .finish
    jmp .read
.finish:

    pop r12
    call restore_buffer
    mov rdi, 0

    jmp exit

up:
    jmp poll_loop

down:
    jmp poll_loop

right:
    xor rdi, rdi
.row_loop:
    mov rsi, 2
    mov r8, rdi
    shl r8, 3
.tile_loop:
    mov cx, word [board + r8 + 2*rsi]
    mov rdx, rsi
    inc rdx
.tile_tile_loop: 
    mov ax, word [board + r8 + 2*rdx]

    cmp ax, 0
    jz .reloop

    cmp ax, cx
    je .combine_tile

    mov word [board + r8 + 2*rsi], 0
    mov word [board + r8 + 2*rdx - 2], cx
    jmp .finish_tile

.reloop:
    inc rdx
    cmp rdx, 4        
    jl .tile_tile_loop
    mov word [board + r8 + 2*rsi], 0
    mov word [board + r8 + 6], cx

    jmp .finish_tile

.combine_tile:
    shl cx, 1
    mov word [board + r8 + 2*rsi], 0
    mov word [board + r8 + 2*rdx], cx

.finish_tile:

    dec rsi
    cmp rsi, 4      ; compare to 4, since if rsi is 4 or greater we know the counter has underflowed
    jb .tile_loop

    inc rdi
    cmp rdi, 4
    jl .row_loop
    jmp poll_loop

left:
    xor rdi, rdi
.row_loop:
    xor rsi, rsi
    inc rsi
    mov r8, rdi
    shl r8, 3
.tile_loop:
    mov cx, word [board + r8 + 2*rsi]
    mov rdx, rsi
    dec rdx
.tile_tile_loop: 
    mov ax, word [board + r8 + 2*rdx]

    cmp ax, 0
    jz .reloop

    cmp ax, cx
    je .combine_tile

    mov word [board + r8 + 2*rsi], 0
    mov word [board + r8 + 2*rdx + 2], cx
    jmp .finish_tile

.reloop:
    dec rdx
    cmp rdx, 4        ; compare to 4, since if rdx is 4 or greater we know the counter has underflowed
    jb .tile_tile_loop
    mov word [board + r8 + 2*rsi], 0
    mov word [board + r8], cx

    jmp .finish_tile

.combine_tile:
    shl cx, 1
    mov word [board + r8 + 2*rsi], 0
    mov word [board + r8 + 2*rdx], cx

.finish_tile:

    inc rsi
    cmp rsi, 4
    jl .tile_loop

    inc rdi
    cmp rdi, 4
    jl .row_loop

    jmp poll_loop

end_loss:
    push r12
    push r13
    mov r12, lose
    mov r13, lose_len
    jmp end
end_win:
    push r12
    push r13
    mov r12, win
    mov r13, win_len
end:
    mov rsi, you
    mov rdx, you_len
    call print

    mov rsi, r12
    mov rdx, r13
    call print

    mov rsi, exclaim
    mov rdx, exclaim_len
    call println

    pop r13
    pop r12
    ret

tile_randgen:
    xor rdi, rdi
    xor rsi, rsi
    mov rdx, 1
.zero_loop:
    cmp word [board + 2*rdi], 0
    cmove rsi, rdx

    inc rdi
    cmp rdi, 16
    jl .zero_loop

    cmp rsi, 0
    jz end_loss
.rand_loop:
    mov dil, 0    ; randint(
    mov sil, 15   ;     0, 15
    call randint  ; );

    cmp word [board + 2*rax], 0
    jnz .rand_loop

    mov word [board + 2*rax], 2

    ret

draw_board:
    call clear_term
    push r12
    push r13
    push r14
    push r15

    ; YES THIS IS THREE NESTED FOR LOOPS SHUT UP

    xor r12, r12
.row_loop:        ; for (r12 = 0; r12 < 16; r12 += 4) {
    xor r13, r13
.line_loop:       ;     for (r13 = 0; r13 < 5; r13++) {
    xor r14, r14
.column_loop:     ;         for (r14 = 0; r14 < 4; r14++) {
    mov rax, r12
    add rax, r14

    xor r15, r15
    mov r15w, [board + 2*rax] ; move the value of the current tile into rdi
    mov rdi, r15
    call ilog2         ; set_box_color(
    mov rdi, rax       ;   ilog2(tile)
    call set_box_color ; );

    cmp r13, 2
    je .value_line
.simple_line:
    mov rsi, tile_line
    mov rdx, tile_line_len
    jmp .line_done
.value_line:

    mov rdi, rewritable_tile_line
    mov rsi, tile_line
    mov rdx, tile_line_len
    call memcpy

    sub rsp, 8   ; reserve 8 bytes on the stack for the buffer
    mov rdi, r15
    mov rsi, rsp
    call itoa    ; convert the tile value to a string

    mov rdi, rewritable_tile_line
    add rdi, 3 ; center(ish) the output value
    mov rsi, rsp
    mov rdx, rax
    call memcpy  ; copy the value into the printed line
    add rsp, 8   ; restore stack

    mov rsi, rewritable_tile_line
    mov rdx, rewritable_tile_line_len
.line_done:
    call print

    call reset_color ; reset out terminal color
    mov rsi, space
    mov rdx, space_len
    call print       ; print a space between each box

    inc r14
    cmp r14, 4
    jl .column_loop ;       } column_loop

    mov rsi, 0
    mov rdx, 0
    call println  ; just print a newline

    inc r13
    cmp r13, 5
    jl .line_loop ;     } line_loop

    mov rsi, 0
    mov rdx, 0
    call println ; just print a newline

    add r12, 4
    cmp r12, 16
    jl .row_loop;    } row_loop

    pop r15
    pop r14
    pop r13
    pop r12
    ret

; rdi: log2(box value)
set_box_color:
    push r12
    mov r12, rdi

    mov rax, bg_color_0
    add rax, rdi
    add rax, rdi
    add rax, rdi
    mov rdi, rax

    mov rsi, bg_color_len
    call set_background

    cmp r12, 5
    jle .dark
.light:
    mov rdi, fg_color_light
    mov rsi, fg_color_light_len
    jmp .set
.dark:
    mov rdi, fg_color_dark
    mov rsi, fg_color_dark_len
.set:
    call set_foreground

    pop r12
    ret


section .data
    DEF_STR you, "You"
    DEF_STR win, "got 2048"
    DEF_STR lose, "lose"
    DEF_STR exclaim, "!"
    DEF_STR space, " "

    DEF_STR tile_line, "          "
    DEF_STR rewritable_tile_line, "          "

    board: times 16 dw 0

    bg_color_0: db "236"
    bg_color_2: db "231"
    bg_color_4: db "230"
    bg_color_8: db "227"
    bg_color_16: db "221"
    bg_color_32: db "214"
    bg_color_64: db "208"
    bg_color_128: db "202"
    bg_color_256: db "196"
    bg_color_512: db "124"
    bg_color_1024: db "052"
    bg_color_2048: db "053"
    bg_color_len: equ 3

    DEF_STR fg_color_dark, "0"
    DEF_STR fg_color_light, "15"
    