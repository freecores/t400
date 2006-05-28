	;; *******************************************************************
	;; $Id: test.asm,v 1.2 2006-05-28 13:36:19 arniml Exp $
	;;
	;; Checks interrupt on JMP.
	;;

	;; the cpu type is defined on asl's command line

	include	"int_macros.inc"

	org	0x00
	clra

	lei	0x02
	jp	int_mark

	org	0x030
int_mark:
	nop
	nop
int_instr:
	jmp	+


	org	0x03d
	jmp	fail
	org	0x03f
+	aisc	0xf
ret_instr:
	jmp	pass


	org	0x0fd
	jmp	fail
int_routine:
	nop
	save_a_m_c
	check_sa	ret_instr
	restore_c_m_a
	ret


	org	0x200
	include	"int_pass_fail.asm"
