$PBExportHeader$w_cn955_act_doc_pendientes.srw
forward
global type w_cn955_act_doc_pendientes from w_abc_master_smpl
end type
type sle_mes from singlelineedit within w_cn955_act_doc_pendientes
end type
type st_1 from statictext within w_cn955_act_doc_pendientes
end type
type cb_1 from commandbutton within w_cn955_act_doc_pendientes
end type
type sle_ano from singlelineedit within w_cn955_act_doc_pendientes
end type
type cb_generar from commandbutton within w_cn955_act_doc_pendientes
end type
type st_2 from statictext within w_cn955_act_doc_pendientes
end type
type gb_1 from groupbox within w_cn955_act_doc_pendientes
end type
end forward

global type w_cn955_act_doc_pendientes from w_abc_master_smpl
integer width = 3067
integer height = 1068
string title = "[CN955] Actualiza cuenta corriente financiera en funcion a contable"
string menuname = "m_abc_modifica"
sle_mes sle_mes
st_1 st_1
cb_1 cb_1
sle_ano sle_ano
cb_generar cb_generar
st_2 st_2
gb_1 gb_1
end type
global w_cn955_act_doc_pendientes w_cn955_act_doc_pendientes

on w_cn955_act_doc_pendientes.create
int iCurrent
call super::create
if this.MenuName = "m_abc_modifica" then this.MenuID = create m_abc_modifica
this.sle_mes=create sle_mes
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.cb_generar=create cb_generar
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mes
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.cb_generar
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_cn955_act_doc_pendientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_mes)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.cb_generar)
destroy(this.st_2)
destroy(this.gb_1)
end on

event open;call super::open;//of_center_window(this)

String ls_ano, ls_mes 

ls_ano = string( today(), 'yyyy' )
ls_mes = string( today(),'mm' ) 
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes

DELETE FROM tt_cnt_error_cnta_cte_bak;
COMMIT ;

dw_master.retrieve()
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn955_act_doc_pendientes
integer y = 272
integer width = 2981
integer height = 600
string dataobject = "d_rpt_diferencia_ctacte_tbl"
end type

type sle_mes from singlelineedit within w_cn955_act_doc_pendientes
integer x = 690
integer y = 108
integer width = 187
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn955_act_doc_pendientes
integer x = 539
integer y = 112
integer width = 133
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn955_act_doc_pendientes
integer x = 946
integer y = 92
integer width = 635
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar Datos a Procesar"
end type

event clicked;Long ll_ano, ll_mes
String ls_mens

if sle_ano.text = '' or isnull(sle_ano.text) then
	messagebox('Aviso','Debe de ingresar año de proceso')
	return
end if

ll_ano = Long(sle_ano.text)
ll_mes = Long(sle_mes.text)

// Parametro 'A', significa que actualiza información, 'C' indica captura de información.

DECLARE PB_USP_PROC PROCEDURE FOR usp_cntbl_act_saldo_doc_pend('C', :ll_ano, :ll_mes) ;
EXECUTE PB_USP_PROC;

IF sqlca.sqlcode = -1 THEN
	ls_mens = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error usp_cntbl_act_saldo_doc_pend', ls_mens, StopSign! )
	return
ELSE
	COMMIT ;
END IF

dw_master.retrieve()

CLOSE PB_USP_PROC ;
end event

type sle_ano from singlelineedit within w_cn955_act_doc_pendientes
integer x = 233
integer y = 112
integer width = 187
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_generar from commandbutton within w_cn955_act_doc_pendientes
integer x = 1646
integer y = 88
integer width = 302
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_error

Long ll_ano, ll_mes 

ll_ano = LONG(sle_ano.text)
ll_mes = LONG(sle_mes.text)


parent.event ue_update()


// Parametro 'A', significa que actualiza información, 'C' indica captura de información.

DECLARE PB_USP_PROC PROCEDURE FOR usp_cntbl_act_saldo_doc_pend('A', :ll_ano, :ll_mes) ;
EXECUTE PB_USP_PROC;

IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	ROLLBACK ;	
	MessageBox( 'Error', ls_error, StopSign! )
	MessageBox ('Error',"Store Procedure usp_cntbl_act_saldo_doc_pend Falló", StopSign!)
	RETURN
ELSE
	COMMIT ;
	MessageBox ('Aviso',"Proceso ha concluído satisfactoriamente")
END IF

CLOSE PB_USP_PROC;

end event

type st_2 from statictext within w_cn955_act_doc_pendientes
integer x = 78
integer y = 116
integer width = 146
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn955_act_doc_pendientes
integer x = 37
integer y = 32
integer width = 873
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Opciones"
end type

