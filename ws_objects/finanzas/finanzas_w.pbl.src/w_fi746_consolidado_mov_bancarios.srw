$PBExportHeader$w_fi746_consolidado_mov_bancarios.srw
forward
global type w_fi746_consolidado_mov_bancarios from w_rpt
end type
type dw_origen from datawindow within w_fi746_consolidado_mov_bancarios
end type
type st_1 from statictext within w_fi746_consolidado_mov_bancarios
end type
type uo_1 from u_ingreso_rango_fechas within w_fi746_consolidado_mov_bancarios
end type
type cb_1 from commandbutton within w_fi746_consolidado_mov_bancarios
end type
type dw_report from u_dw_rpt within w_fi746_consolidado_mov_bancarios
end type
type gb_1 from groupbox within w_fi746_consolidado_mov_bancarios
end type
end forward

global type w_fi746_consolidado_mov_bancarios from w_rpt
integer width = 3008
integer height = 1948
string title = "Reporte de Consolidados de Movimientos Bancarios (FI746)"
string menuname = "m_reporte_filter"
long backcolor = 12632256
dw_origen dw_origen
st_1 st_1
uo_1 uo_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi746_consolidado_mov_bancarios w_fi746_consolidado_mov_bancarios

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_fi746_consolidado_mov_bancarios.create
int iCurrent
call super::create
if this.MenuName = "m_reporte_filter" then this.MenuID = create m_reporte_filter
this.dw_origen=create dw_origen
this.st_1=create st_1
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_origen
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.gb_1
end on

on w_fi746_consolidado_mov_bancarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_origen)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = true
THIS.Event ue_preview()


end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;String ls_origen,ls_mensaje,ls_flag
Date ld_fecha_inicio,ld_fecha_final

dw_origen.Accepttext()


ls_flag   = dw_origen.object.flag		 [1]

if ls_flag = '1' then
	ls_origen = '%'	
else
	ls_origen = dw_origen.object.cod_origen [1]
	
	if isnull(ls_origen) or trim(ls_origen) = '' then
		Messagebox('Aviso','Dbe Ingresar Codigo de Origen,Verifique!')
		Return
	end if
end if



ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()


DECLARE PB_USP_FIN_RPT_FLUJO_CAJA_EST PROCEDURE FOR USP_FIN_RPT_FLUJO_CAJA (:ld_fecha_inicio,:ld_fecha_final, :ls_origen);
EXECUTE PB_USP_FIN_RPT_FLUJO_CAJA_EST ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	SetPointer(Arrow!)
	Messagebox('Aviso',ls_mensaje)
	Return
END IF


idw_1.Retrieve()

//idw_1.Object.p_logo.filename = gs_logo


//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_nombre.text = gs_empresa
//idw_1.object.t_user.text = gs_user
end event

type dw_origen from datawindow within w_fi746_consolidado_mov_bancarios
integer x = 334
integer y = 280
integer width = 1399
integer height = 84
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ext_origen"
boolean border = false
boolean livescroll = true
end type

event itemchanged;CHOOSE CASE GetColumnName()
	CASE 'flag'
		IF data = '1' THEN
			SetItem(1,'cod_origen','')
		END IF
END CHOOSE
end event

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

type st_1 from statictext within w_fi746_consolidado_mov_bancarios
integer x = 96
integer y = 292
integer width = 229
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Origen :"
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_fi746_consolidado_mov_bancarios
integer x = 101
integer y = 108
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_fi746_consolidado_mov_bancarios
integer x = 2496
integer y = 212
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_fi746_consolidado_mov_bancarios
integer x = 27
integer y = 544
integer width = 2926
integer height = 1208
string dataobject = "d_rpt_consolidado_mov_bancario_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_fi746_consolidado_mov_bancarios
integer x = 32
integer y = 32
integer width = 1737
integer height = 396
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Ingrese Datos"
end type

