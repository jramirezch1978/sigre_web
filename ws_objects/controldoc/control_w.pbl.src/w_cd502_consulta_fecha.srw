$PBExportHeader$w_cd502_consulta_fecha.srw
forward
global type w_cd502_consulta_fecha from w_abc
end type
type st_status from statictext within w_cd502_consulta_fecha
end type
type cb_1 from commandbutton within w_cd502_consulta_fecha
end type
type uo_fecha from u_ingreso_rango_fechas within w_cd502_consulta_fecha
end type
type dw_master from u_dw_abc within w_cd502_consulta_fecha
end type
end forward

global type w_cd502_consulta_fecha from w_abc
integer width = 3150
integer height = 2316
string title = "[CD502] Consulta de documentos por fecha "
string menuname = "m_consulta"
st_status st_status
cb_1 cb_1
uo_fecha uo_fecha
dw_master dw_master
end type
global w_cd502_consulta_fecha w_cd502_consulta_fecha

on w_cd502_consulta_fecha.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.st_status=create st_status
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_status
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.dw_master
end on

on w_cd502_consulta_fecha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_status)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(50,50)
end event

type st_status from statictext within w_cd502_consulta_fecha
integer x = 1595
integer y = 140
integer width = 969
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cd502_consulta_fecha
integer x = 2610
integer y = 36
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;Date ld_fecha_desde, ld_fecha_hasta

ld_fecha_desde = uo_fecha.of_get_fecha1()
ld_fecha_hasta = uo_fecha.of_get_fecha2()

If ld_fecha_hasta < ld_fecha_desde then
	MessageBox('Error: ' + this.ClassName(), &
		'Rango de fechas inválido, por favor ingrese nuevamente', &
		Information!)
	Return
End if

dw_master.SetTransObject(SQLCA)
dw_master.retrieve(ld_fecha_desde, ld_fecha_hasta)
st_status.text = "Se han recibido: " + string( dw_master.RowCount() ) + " documentos"

end event

type uo_fecha from u_ingreso_rango_fechas within w_cd502_consulta_fecha
integer x = 46
integer y = 32
integer taborder = 40
end type

event constructor;call super::constructor;date ld_fecha_desde, ld_fecha_hasta

ld_fecha_desde = date('01/' + string(Today(), 'mm/yyyy') )
ld_fecha_hasta = RelativeDate( date('01/' &
		+ string(Month(Today()) + 1,'00') &
		+ string(Today(), '/yyyy') ), -1 )

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(ld_fecha_desde, ld_fecha_hasta ) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_master from u_dw_abc within w_cd502_consulta_fecha
integer x = 27
integer y = 220
integer width = 3022
integer height = 1788
string dataobject = "d_grid_cns_doc_recibidos"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1]=1
is_dwform = "grid"
end event

