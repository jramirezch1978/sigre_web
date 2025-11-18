$PBExportHeader$w_pt762_ejec_servicios.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt762_ejec_servicios from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_pt762_ejec_servicios
end type
type cb_10 from commandbutton within w_pt762_ejec_servicios
end type
type cb_1 from commandbutton within w_pt762_ejec_servicios
end type
type cb_2 from commandbutton within w_pt762_ejec_servicios
end type
type cb_3 from commandbutton within w_pt762_ejec_servicios
end type
type gb_1 from groupbox within w_pt762_ejec_servicios
end type
end forward

global type w_pt762_ejec_servicios from w_report_smpl
integer width = 3474
integer height = 1776
string title = "Ejecución por Sevicios (PT762)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
cb_10 cb_10
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
gb_1 gb_1
end type
global w_pt762_ejec_servicios w_pt762_ejec_servicios

on w_pt762_ejec_servicios.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_10=create cb_10
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_10
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.gb_1
end on

on w_pt762_ejec_servicios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_10)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;//ii_help = 514       				// help topic

uo_fecha.event ue_output()
end event

event ue_retrieve;call super::ue_retrieve;Date ld_fecha1, ld_fecha2
Long	ll_count

select count(*)
	into :ll_count
from tt_pto_servicios;

if ll_count = 0 then
	MessageBox('Aviso', 'Debe seleccionar algun tipo de servicio')
	return
end if

select count(*)
	into :ll_count
from tt_pto_cencos;

if ll_count = 0 then
	MessageBox('Aviso', 'Debe seleccionar algun centro de costo')
	return
end if

select count(*)
	into :ll_count
from tt_pto_cnta_prsp;

if ll_count = 0 then
	MessageBox('Aviso', 'Debe seleccionar alguna Cuenta presupuestal')
	return
end if

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

dw_report.SetTransObject(sqlca)

ib_preview = false
this.Event ue_preview()
dw_report.object.Datawindow.print.orientation = 1
dw_report.retrieve(ld_fecha1, ld_fecha2)
dw_report.object.t_usuario.text = gs_user
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.p_logo.filename = gs_logo

dw_report.object.t_titulo1.text = "Del :" + STRING( ld_fecha1, 'DD/MM/YYYY') + &
      ' Al: ' + STRING( ld_fecha2, 'DD/MM/YYYY')


end event

type dw_report from w_report_smpl`dw_report within w_pt762_ejec_servicios
integer x = 0
integer y = 192
integer width = 3301
integer height = 1248
string dataobject = "d_rpt_ejec_tipo_servicio"
end type

type uo_fecha from u_ingreso_rango_fechas within w_pt762_ejec_servicios
integer x = 46
integer y = 68
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_10 from commandbutton within w_pt762_ejec_servicios
integer x = 2898
integer y = 24
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;parent.event ue_retrieve()

end event

type cb_1 from commandbutton within w_pt762_ejec_servicios
integer x = 1449
integer y = 20
integer width = 471
integer height = 96
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Tipo de Servicio"
end type

event clicked;str_parametros lstr_param

// Asigna valores a structura 
lstr_param.titulo = "Tipos de Servicios"
lstr_param.dw1 = "d_sel_tipos_servicio"
lstr_param.opcion = 7
lstr_param.tipo 	= '1D2D'
lstr_param.fecha1 = uo_fecha.of_get_fecha1( )
lstr_param.fecha2 = uo_fecha.of_get_fecha2( )

OpenWithParm( w_rpt_listas, lstr_param)
end event

type cb_2 from commandbutton within w_pt762_ejec_servicios
integer x = 1925
integer y = 20
integer width = 471
integer height = 96
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Centros de Costo"
end type

event clicked;str_parametros lstr_param

// Asigna valores a structura 
lstr_param.titulo = "Centros de costo"
lstr_param.dw1 = "d_sel_centros_costo"
lstr_param.opcion = 8
lstr_param.tipo 	= '1D2D'
lstr_param.fecha1 = uo_fecha.of_get_fecha1( )
lstr_param.fecha2 = uo_fecha.of_get_fecha2( )

OpenWithParm( w_rpt_listas, lstr_param)
end event

type cb_3 from commandbutton within w_pt762_ejec_servicios
integer x = 2400
integer y = 20
integer width = 475
integer height = 96
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cnta Presupuestal"
end type

event clicked;str_parametros lstr_param

// Asigna valores a structura 
lstr_param.titulo = "Partida Presupuestales"
lstr_param.dw1 	= "d_sel_cuentas_presupuestales"
lstr_param.opcion = 9
lstr_param.tipo 	= '1D2D'
lstr_param.fecha1 = uo_fecha.of_get_fecha1( )
lstr_param.fecha2 = uo_fecha.of_get_fecha2( )

OpenWithParm( w_rpt_listas, lstr_param)
end event

type gb_1 from groupbox within w_pt762_ejec_servicios
integer width = 1376
integer height = 188
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

