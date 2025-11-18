$PBExportHeader$w_sg900_log_diario_limpieza.srw
forward
global type w_sg900_log_diario_limpieza from w_prc
end type
type cb_confirmar from commandbutton within w_sg900_log_diario_limpieza
end type
type dw_master from datawindow within w_sg900_log_diario_limpieza
end type
type uo_rango from u_ingreso_rango_fechas within w_sg900_log_diario_limpieza
end type
type ddlb_tabla from u_ddlb within w_sg900_log_diario_limpieza
end type
type st_3 from statictext within w_sg900_log_diario_limpieza
end type
type st_2 from statictext within w_sg900_log_diario_limpieza
end type
type cb_procesar from commandbutton within w_sg900_log_diario_limpieza
end type
end forward

global type w_sg900_log_diario_limpieza from w_prc
integer width = 1810
integer height = 1768
string title = "Log Diario - Limpieza (SG900)"
string menuname = "m_cns_simple"
long backcolor = 12632256
cb_confirmar cb_confirmar
dw_master dw_master
uo_rango uo_rango
ddlb_tabla ddlb_tabla
st_3 st_3
st_2 st_2
cb_procesar cb_procesar
end type
global w_sg900_log_diario_limpieza w_sg900_log_diario_limpieza

type variables
String is_tabla
end variables

on w_sg900_log_diario_limpieza.create
int iCurrent
call super::create
if this.MenuName = "m_cns_simple" then this.MenuID = create m_cns_simple
this.cb_confirmar=create cb_confirmar
this.dw_master=create dw_master
this.uo_rango=create uo_rango
this.ddlb_tabla=create ddlb_tabla
this.st_3=create st_3
this.st_2=create st_2
this.cb_procesar=create cb_procesar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_confirmar
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.uo_rango
this.Control[iCurrent+4]=this.ddlb_tabla
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_procesar
end on

on w_sg900_log_diario_limpieza.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_confirmar)
destroy(this.dw_master)
destroy(this.uo_rango)
destroy(this.ddlb_tabla)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_procesar)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)



of_center_window()
end event

type cb_confirmar from commandbutton within w_sg900_log_diario_limpieza
integer x = 1362
integer y = 1420
integer width = 370
integer height = 76
integer taborder = 30
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
DebugBreak()
DELETE FROM "LOG_DIARIO"  
    WHERE ( "LOG_DIARIO"."TABLA" = :is_tabla ) AND  
         ( trunc("LOG_DIARIO"."FECHA") between :ld_inicio and :ld_fin ) ;

IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK ;
	MessageBox(SQLCA.SQLErrText, 'No se puede Borrar Registros')
ELSE
//	n_cst_log_proceso		nv_1           // Grabar el log en Oper_Procesos
//	nv_1 = Create n_cst_log_proceso
//	ls_desc_proceso = 'Log Diario - Elim_Reg: ' + is_tabla +'/' + String(ld_inicio) + ' - ' + String(ld_fin)
//	ls_win = THIS.ClassName()
//	nv_1.of_set_log(ld_inicio, ld_fin,'LDER',ls_win,ls_desc_proceso,'0',gs_user)
	COMMIT ;
	dw_master.Reset()
END IF
end event

type dw_master from datawindow within w_sg900_log_diario_limpieza
integer x = 32
integer y = 412
integer width = 1691
integer height = 980
integer taborder = 30
string title = "none"
string dataobject = "d_tablas_modificaciones_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type uo_rango from u_ingreso_rango_fechas within w_sg900_log_diario_limpieza
event destroy ( )
integer x = 37
integer y = 312
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_rango.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; Date	ld_inicio
 
 ld_inicio = RelativeDate (Today(), -360)
 
 of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(ld_inicio, Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 


end event

type ddlb_tabla from u_ddlb within w_sg900_log_diario_limpieza
integer x = 375
integer y = 192
integer width = 878
integer height = 780
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_tablas_modificadas_lista'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 0                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 30                     // Longitud del campo 1
ii_lc2 = 0							// Longitud del campo 2

end event

event ue_output;call super::ue_output;is_tabla = aa_key
end event

type st_3 from statictext within w_sg900_log_diario_limpieza
integer x = 41
integer y = 192
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Tabla:"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_sg900_log_diario_limpieza
integer x = 37
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
string text = "LOG DIARIO - Limpieza de Registros"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_sg900_log_diario_limpieza
integer x = 1353
integer y = 320
integer width = 370
integer height = 76
integer taborder = 20
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

ll_rc = dw_master.Retrieve(is_tabla, ld_inicio, ld_fin )

end event

