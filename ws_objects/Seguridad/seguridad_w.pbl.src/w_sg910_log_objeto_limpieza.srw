$PBExportHeader$w_sg910_log_objeto_limpieza.srw
forward
global type w_sg910_log_objeto_limpieza from w_prc
end type
type em_total from editmask within w_sg910_log_objeto_limpieza
end type
type st_1 from statictext within w_sg910_log_objeto_limpieza
end type
type cb_confirmar from commandbutton within w_sg910_log_objeto_limpieza
end type
type dw_master from datawindow within w_sg910_log_objeto_limpieza
end type
type uo_rango from u_ingreso_rango_fechas within w_sg910_log_objeto_limpieza
end type
type st_2 from statictext within w_sg910_log_objeto_limpieza
end type
type cb_procesar from commandbutton within w_sg910_log_objeto_limpieza
end type
end forward

global type w_sg910_log_objeto_limpieza from w_prc
integer width = 2386
integer height = 2152
string title = "Log Objeto - Limpieza (SG910)"
string menuname = "m_cns_simple"
long backcolor = 12632256
em_total em_total
st_1 st_1
cb_confirmar cb_confirmar
dw_master dw_master
uo_rango uo_rango
st_2 st_2
cb_procesar cb_procesar
end type
global w_sg910_log_objeto_limpieza w_sg910_log_objeto_limpieza

type variables

end variables

on w_sg910_log_objeto_limpieza.create
int iCurrent
call super::create
if this.MenuName = "m_cns_simple" then this.MenuID = create m_cns_simple
this.em_total=create em_total
this.st_1=create st_1
this.cb_confirmar=create cb_confirmar
this.dw_master=create dw_master
this.uo_rango=create uo_rango
this.st_2=create st_2
this.cb_procesar=create cb_procesar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_total
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_confirmar
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.uo_rango
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_procesar
end on

on w_sg910_log_objeto_limpieza.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_total)
destroy(this.st_1)
destroy(this.cb_confirmar)
destroy(this.dw_master)
destroy(this.uo_rango)
destroy(this.st_2)
destroy(this.cb_procesar)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)



of_center_window()
end event

type em_total from editmask within w_sg910_log_objeto_limpieza
integer x = 485
integer y = 1828
integer width = 311
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "#,###,###"
end type

type st_1 from statictext within w_sg910_log_objeto_limpieza
integer x = 27
integer y = 1840
integer width = 425
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Registros:"
borderstyle borderstyle = StyleLowered!
boolean focusrectangle = false
end type

type cb_confirmar from commandbutton within w_sg910_log_objeto_limpieza
integer x = 1957
integer y = 1848
integer width = 370
integer height = 76
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Confirmar"
end type

event clicked;Date		ld_inicio, ld_fin
String	ls_desc_proceso, ls_win

ld_inicio = uo_rango.of_get_fecha1()
ld_fin = uo_rango.of_get_fecha2()

DELETE FROM "LOG_OBJETO"  
    WHERE ( trunc("LOG_OBJETO"."FECHA") between :ld_inicio and :ld_fin ) ;

IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK ;
	MessageBox(SQLCA.SQLErrText, 'No se puede Borrar Registros')
ELSE
//	n_cst_log_proceso		nv_1           // Grabar el log en Oper_Procesos
//	nv_1 = Create n_cst_log_proceso
//	ls_desc_proceso = 'Log Objeto - Elim_Reg: ' +'/' + String(ld_inicio) + ' - ' + String(ld_fin)
//	ls_win = THIS.ClassName()
//	DebugBreak()
//	nv_1.of_set_log(ld_inicio, ld_fin,'LOER',ls_win,ls_desc_proceso,'0',gs_user)
	COMMIT ;
	dw_master.Reset()
END IF
end event

type dw_master from datawindow within w_sg910_log_objeto_limpieza
integer x = 9
integer y = 276
integer width = 2322
integer height = 1540
integer taborder = 30
string title = "none"
string dataobject = "d_lob_objeto_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type uo_rango from u_ingreso_rango_fechas within w_sg910_log_objeto_limpieza
event destroy ( )
integer x = 315
integer y = 176
integer taborder = 50
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_rango.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; Date	ld_inicio
 
 ld_inicio = RelativeDate (Today(), -30)
 
 of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(ld_inicio, Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 


end event

type st_2 from statictext within w_sg910_log_objeto_limpieza
integer x = 315
integer y = 24
integer width = 1696
integer height = 116
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "LOG OBJETO - Limpieza de Registros"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_sg910_log_objeto_limpieza
integer x = 1957
integer y = 184
integer width = 370
integer height = 76
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;Date	ld_inicio, ld_fin
Long	ll_rc


ld_inicio = uo_rango.of_get_fecha1()
ld_fin = uo_rango.of_get_fecha2()

ll_rc = dw_master.Retrieve( ld_inicio, ld_fin )

em_total.text = String(dw_master.RowCount())
end event

