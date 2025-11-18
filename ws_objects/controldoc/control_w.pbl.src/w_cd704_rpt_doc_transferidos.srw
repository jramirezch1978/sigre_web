$PBExportHeader$w_cd704_rpt_doc_transferidos.srw
forward
global type w_cd704_rpt_doc_transferidos from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_cd704_rpt_doc_transferidos
end type
type cb_1 from commandbutton within w_cd704_rpt_doc_transferidos
end type
end forward

global type w_cd704_rpt_doc_transferidos from w_report_smpl
integer width = 2949
integer height = 2164
string title = "[CD704] Documentos Transferidos"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
cb_1 cb_1
end type
global w_cd704_rpt_doc_transferidos w_cd704_rpt_doc_transferidos

event ue_retrieve;call super::ue_retrieve;Date ld_fecha_desde, ld_fecha_hasta
//idw_query = dw_master

ld_fecha_desde = uo_fecha.of_get_fecha1()
ld_fecha_hasta = uo_fecha.of_get_fecha2()

If ld_fecha_hasta < ld_fecha_desde then
	MessageBox('Error: ' + this.ClassName(), &
		'Rango de fechas inválido, por favor ingrese nuevamente', &
		Information!)
	Return
End if

dw_report.SetTransObject(SQLCA)
dw_report.retrieve(ld_fecha_desde, ld_fecha_hasta)
dw_report.object.t_titulo1.text = 'DEL ' + STRING( ld_fecha_desde, 'dd/mm/yyyy') + &
	  ' AL ' + string( ld_fecha_hasta, 'dd/mm/yyyy')

end event

on w_cd704_rpt_doc_transferidos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
end on

on w_cd704_rpt_doc_transferidos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
end on

type dw_report from w_report_smpl`dw_report within w_cd704_rpt_doc_transferidos
integer x = 18
integer y = 252
integer width = 2834
integer height = 1612
string dataobject = "d_rpt_doc_transferidos"
boolean hscrollbar = false
end type

type uo_fecha from u_ingreso_rango_fechas within w_cd704_rpt_doc_transferidos
integer x = 64
integer y = 36
integer height = 96
integer taborder = 40
boolean bringtotop = true
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

type cb_1 from commandbutton within w_cd704_rpt_doc_transferidos
integer x = 2290
integer y = 36
integer width = 329
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_retrieve()
end event

