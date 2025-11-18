$PBExportHeader$w_fi908_ppagos_txt.srw
forward
global type w_fi908_ppagos_txt from w_prc
end type
type cb_1 from commandbutton within w_fi908_ppagos_txt
end type
type vpb_1 from vprogressbar within w_fi908_ppagos_txt
end type
type st_2 from statictext within w_fi908_ppagos_txt
end type
type st_1 from statictext within w_fi908_ppagos_txt
end type
type sle_2 from singlelineedit within w_fi908_ppagos_txt
end type
type sle_1 from singlelineedit within w_fi908_ppagos_txt
end type
type cb_5 from commandbutton within w_fi908_ppagos_txt
end type
type cb_4 from commandbutton within w_fi908_ppagos_txt
end type
type dw_2 from datawindow within w_fi908_ppagos_txt
end type
type dw_report from datawindow within w_fi908_ppagos_txt
end type
end forward

global type w_fi908_ppagos_txt from w_prc
integer width = 4297
integer height = 2224
string title = "Generacion de Programa de Pago (FI908)"
string menuname = "m_proceso_salida"
cb_1 cb_1
vpb_1 vpb_1
st_2 st_2
st_1 st_1
sle_2 sle_2
sle_1 sle_1
cb_5 cb_5
cb_4 cb_4
dw_2 dw_2
dw_report dw_report
end type
global w_fi908_ppagos_txt w_fi908_ppagos_txt

type variables
Long il_count
end variables

event open;call super::open;Long ll_count

dw_2.settransobject(sqlca)


dw_2.Modify("DataWindow.Print.Preview=Yes")
dw_2.Modify("datawindow.print.preview.zoom = " + String('100'))
dw_2.title = "Reporte " + " (Zoom: " + String('100') + "%)"
SetPointer(hourglass!)



end event

on w_fi908_ppagos_txt.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_salida" then this.MenuID = create m_proceso_salida
this.cb_1=create cb_1
this.vpb_1=create vpb_1
this.st_2=create st_2
this.st_1=create st_1
this.sle_2=create sle_2
this.sle_1=create sle_1
this.cb_5=create cb_5
this.cb_4=create cb_4
this.dw_2=create dw_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.vpb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_2
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.cb_5
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.dw_2
this.Control[iCurrent+10]=this.dw_report
end on

on w_fi908_ppagos_txt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.vpb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.dw_2)
destroy(this.dw_report)
end on

event resize;call super::resize;
vpb_1.height	= newheight  - vpb_1.Y - 50
dw_2.height = newheight - dw_2.y - 50
end event

type cb_1 from commandbutton within w_fi908_ppagos_txt
integer x = 978
integer y = 28
integer width = 91
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROGRAMACION_PAGOS.NRO_PROG_PAGO   AS NRO_PROGRAMA , '&
								       +'PROGRAMACION_PAGOS.FECHA_REGISTRO  AS FECHA_REGISTRO, '&
								       +'PROGRAMACION_PAGOS.FECHA_PROG_PAGO AS FECHA_PROGRAMA, '&
									    +'PROGRAMACION_PAGOS.FLAG_ESTADO 	  AS ESTADO	 '&
									    +'FROM PROGRAMACION_PAGOS '


														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_1.text = lstr_seleccionar.param1[1]
END IF														 

end event

type vpb_1 from vprogressbar within w_fi908_ppagos_txt
integer x = 23
integer y = 288
integer width = 78
integer height = 1128
integer setstep = 1
end type

type st_2 from statictext within w_fi908_ppagos_txt
integer x = 32
integer y = 164
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi908_ppagos_txt
integer x = 32
integer y = 40
integer width = 430
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. Prog Pago :"
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_fi908_ppagos_txt
integer x = 471
integer y = 140
integer width = 192
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_fi908_ppagos_txt
integer x = 471
integer y = 24
integer width = 471
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_5 from commandbutton within w_fi908_ppagos_txt
integer x = 2446
integer y = 8
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_msj_err,ls_nro_programa
Long	 ll_item,ll_count


ls_nro_programa = sle_1.text
ll_item			 = Long(sle_2.text)

DECLARE PB_USP_FIN_GEN_ARCH_TXT_PAG PROCEDURE FOR USP_FIN_GEN_ARCH_TXT_PAG
(:ls_nro_programa,:ll_item);
EXECUTE PB_USP_FIN_GEN_ARCH_TXT_PAG ;

IF SQLCA.SQLCode = -1 THEN
    ls_msj_err = SQLCA.SQLErrText
    MessageBox('SQL error', ls_msj_err)
END IF

CLOSE PB_USP_FIN_GEN_ARCH_TXT_PAG;

/**/
select count(*) into :il_count from tt_fin_exp_file;
/**/

dw_2.retrieve()





end event

type cb_4 from commandbutton within w_fi908_ppagos_txt
integer x = 2889
integer y = 8
integer width = 421
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grabar Archivo"
end type

event clicked;dw_2.saveas()
end event

type dw_2 from datawindow within w_fi908_ppagos_txt
integer x = 123
integer y = 288
integer width = 3177
integer height = 1128
integer taborder = 50
string title = "none"
string dataobject = "d_abc_exp_p_masprov_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieverow;Long ll_inicio,ll_count,ll_inicio_count



ll_count = (100 / il_count )
ll_inicio_count = (il_count / 100 )



for ll_inicio = ll_inicio_count to ll_count
	 vpb_1.stepit()
next



end event

event retrievestart;Long ll_count 



vpb_1.minposition = (il_count / 100)
vpb_1.maxposition = il_count
end event

type dw_report from datawindow within w_fi908_ppagos_txt
boolean visible = false
integer x = 91
integer y = 1448
integer width = 1957
integer height = 568
integer taborder = 50
boolean titlebar = true
string title = "Reporte de Verificacion"
string dataobject = "d_rpt058_coa_verificacion_tbl"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

