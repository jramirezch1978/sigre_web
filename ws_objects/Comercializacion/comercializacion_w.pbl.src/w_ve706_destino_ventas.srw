$PBExportHeader$w_ve706_destino_ventas.srw
forward
global type w_ve706_destino_ventas from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ve706_destino_ventas
end type
type cb_1 from commandbutton within w_ve706_destino_ventas
end type
type gb_fechas from groupbox within w_ve706_destino_ventas
end type
end forward

global type w_ve706_destino_ventas from w_report_smpl
integer width = 3250
integer height = 2068
string title = "Destino de Ventas (VE706)"
string menuname = "m_reporte"
long backcolor = 67108864
uo_fecha uo_fecha
cb_1 cb_1
gb_fechas gb_fechas
end type
global w_ve706_destino_ventas w_ve706_destino_ventas

type variables
string is_doc_ov
end variables

on w_ve706_destino_ventas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.gb_fechas=create gb_fechas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.gb_fechas
end on

on w_ve706_destino_ventas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.gb_fechas)
end on

event ue_retrieve;//Ancestor Overriding
date 		ld_fecha1, ld_fecha2
str_parametros lstr_param

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

//Tiene que seleccionar los grupos a partir del super_grupo

// Asigna valores a structura 
lstr_param.dw_master = 'd_sel_art_spr_grupo'      
lstr_param.dw1       = 'd_sel_articulo_grupo'  
lstr_param.opcion    = 12
lstr_param.tipo		 =''
lstr_param.titulo    = 'Seleccion de Super Grupos y Grupos de Artículos'

OpenWithParm( w_abc_seleccion_md, lstr_param)

idw_1.Visible = True

idw_1.Retrieve(ld_fecha1, ld_Fecha2)

idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_ventana.text 	= this.ClassName()
idw_1.Object.t_user.text 		= gs_user
idw_1.Object.t_stitulo1.text 	= 'Desde ' + string(ld_Fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')


end event

event ue_open_pre;call super::ue_open_pre;select doc_ov
	into :is_doc_ov
from logparam
where reckey = '1';

idw_1.object.datawindow.print.orientation = 2
end event

type dw_report from w_report_smpl`dw_report within w_ve706_destino_ventas
integer x = 0
integer y = 328
integer width = 2089
integer height = 992
string dataobject = "d_rpt_ventas_destino"
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_ve706_destino_ventas
event destroy ( )
integer x = 50
integer y = 72
integer taborder = 20
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

event ue_output;call super::ue_output;//cb_seleccionar.enabled = true
end event

type cb_1 from commandbutton within w_ve706_destino_ventas
integer x = 709
integer y = 40
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_retrieve( )
end event

type gb_fechas from groupbox within w_ve706_destino_ventas
integer x = 23
integer y = 4
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

