;
;  This file is part of the Advance project.
;
;  Copyright (C) 1999, 2000, 2001 Andrea Mazzoleni
;
;  This program is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details. 
;
;  You should have received a copy of the GNU General Public License
;  along with this program; if not, write to the Free Software
;  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;

ideal
model tiny
P386

codeseg

; Calls to FTOL@ are generated by the compiler for code
; that needs to convert a floating point type to an integral type.
; Input: floating point number on the top of the '87.
; Output: a (signed or unsigned) long in AX, DX.

public pascal N_FTOL@

proc pascal N_FTOL@
	local temp2 : dword : 2
	fistp [qword ptr temp2]
	mov ax, [word ptr temp2]
	mov dx, [word ptr temp2+2]
	ret
endp

; in:
;       (dx:ax) - 32bit arg1
;       (cx:bx) - 32bit arg2
; out:
;       (dx:ax) - 32bit product
;
; reg use: bx,cx destroyed, all others preserved or contain result.

public pascal N_LXMUL@

proc pascal N_LXMUL@
	shl edx,16
	and eax,0FFFFh
	or eax,edx

	shl ecx,16
	and ebx,0FFFFh
	or ebx,ecx

	mul ebx

	shld edx,eax,16

	ret
endp

; in:
;       [bp+4]
;       [bp+8]
; out:
;       (dx:ax) - quotient

public pascal N_LDIV@

proc pascal N_LDIV@
	push bp
	mov bp,sp

	mov eax,[bp+4]
	mov edx,0

	idiv [dword ptr bp+8]

	shld edx,eax,16

	pop bp
	ret 8
endp

public pascal N_LUDIV@

proc pascal N_LUDIV@
	push bp
	mov bp,sp

	mov eax,[bp+4]
	mov edx,0

	div [dword ptr bp+8]

	shld edx,eax,16

	pop bp
	ret 8
endp

; in:
;   (cl) - shift
;   (dx:ax) - value
; out:
;   (dx:ax) - value

public pascal N_LXLSH@

proc pascal N_LXLSH@
	shl edx,16
	and eax,0FFFFh
	or eax,edx

	shl eax,cl

	shld edx,eax,16

	ret
endp

; in:
;   (cl) - shift
;   (dx:ax) - value
; out:
;   (dx:ax) - value

public pascal N_LXURSH@

proc pascal N_LXURSH@
	shl edx,16
	and eax,0FFFFh
	or eax,edx

	shr eax,cl

	shld edx,eax,16

	ret
endp

; in:
;   (cl) - shift
;   (dx:ax) - value
; out:
;   (dx:ax) - value

public pascal N_LXRSH@

proc pascal N_LXRSH@
	shl edx,16
	and eax,0FFFFh
	or eax,edx

	sar eax,cl

	shld edx,eax,16

	ret
endp

public pascal N_SCOPY@

proc pascal N_SCOPY@
	push bp
	mov  bp,sp
	push si
	push di
	push ds
	push es

	lds si,[dword ptr bp+4]
	les di,[dword ptr bp+8]
	cld
	rep movsb

	pop es
	pop ds
	pop di
	pop si
	pop bp
	ret 8
endp

end