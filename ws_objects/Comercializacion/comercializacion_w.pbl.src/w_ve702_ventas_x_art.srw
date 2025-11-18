$PBExportHeader$w_ve702_ventas_x_art.srw
forward
global type w_ve702_ventas_x_art from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ve702_ventas_x_art
end type
type cb_1 from commandbutton within w_ve702_ventas_x_art
end type
type rb_1 from radiobutton within w_ve702_ventas_x_art
end type
type rb_2 from radiobutton within w_ve702_ventas_x_art
end type
type gb_fechas from groupbox within w_ve702_ventas_x_art
end type
type gb_2 from groupbox within w_ve702_ventas_x_art
end type
end forward

global type w_ve702_ventas_x_art from w_report_smpl
integer width = 3250
integer height = 2068
string title = "Ventas x Articulo(VE702)"
string menuname = "m_reporte"
long backcolor = 67108864
uo_fecha uo_fecha
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
gb_fechas gb_fechas
gb_2 gb_2
end type
global w_ve702_ventas_x_art w_ve702_ventas_x_art

type variables
string is_doc_ov
end variables

on w_ve702_ventas_x_art.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_fechas=create gb_fechas
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.gb_fechas
this.Control[iCurrent+6]=this.gb_2
end on

on w_ve702_ventas_x_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_fechas)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

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

type dw_report from w_report_smpl`dw_report within w_ve702_ventas_x_art
integer x = 0
integer y = 328
integer width = 2089
integer height = 992
string dataobject = "d_rpt_ventas_x_art"
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_ve702_ventas_x_art
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

type cb_1 from commandbutton within w_ve702_ventas_x_art
integer x = 1449
integer y = 32
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

type rb_1 from radiobutton within w_ve702_ventas_x_art
integer x = 718
integer y = 96
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2

ld_fecha1 = uo_Fecha.of_get_fecha1( )
ld_fecha2 = uo_Fecha.of_get_fecha2( )

Delete from tt_exp_cencos;

insert into tt_exp_cencos ( cencos) 
	SELECT DISTINCT amp.CENCOS
	FROM orden_venta ov,
		  articulo_mov_proy amp
	WHERE ov.nro_ov = amp.nro_doc
	  and amp.tipo_doc = (select doc_ov from logparam where reckey = '1')
	  and ov.flag_estado <> '0'
	  and amp.flag_estado <> '0'
	  and amp.cencos is not null;

Commit;
end event

type rb_2 from radiobutton within w_ve702_ventas_x_art
integer x = 1024
integer y = 96
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String 	ls_ingr_egr, ls_tipo

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

str_parametros sl_param

// Asigna valores a structura 
sl_param.dw1 = "d_sel_cencos_amp_ov"	
sl_param.tipo = '1F2F'	
sl_param.fecha1 = ld_fecha1
sl_param.fecha2 = ld_fecha2
sl_param.titulo = "Centros de costo"
sl_param.opcion = 1

OpenWithParm( w_rpt_listas, sl_param)
end event

type gb_fechas from groupbox within w_ve702_ventas_x_art
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

type gb_2 from groupbox within w_ve702_ventas_x_art
integer x = 695
integer y = 12
integer width = 736
integer height = 192
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo"
end type

