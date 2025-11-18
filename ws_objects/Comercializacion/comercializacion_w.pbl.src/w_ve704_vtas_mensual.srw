$PBExportHeader$w_ve704_vtas_mensual.srw
forward
global type w_ve704_vtas_mensual from w_report_smpl
end type
type cb_1 from commandbutton within w_ve704_vtas_mensual
end type
type rb_1 from radiobutton within w_ve704_vtas_mensual
end type
type rb_2 from radiobutton within w_ve704_vtas_mensual
end type
type em_ano from editmask within w_ve704_vtas_mensual
end type
type st_3 from statictext within w_ve704_vtas_mensual
end type
type gb_2 from groupbox within w_ve704_vtas_mensual
end type
type gb_1 from groupbox within w_ve704_vtas_mensual
end type
end forward

global type w_ve704_vtas_mensual from w_report_smpl
integer width = 3360
integer height = 2608
string title = "Ventas Mensual x Grupo de Articulos(VE704)"
string menuname = "m_reporte"
long backcolor = 67108864
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
em_ano em_ano
st_3 st_3
gb_2 gb_2
gb_1 gb_1
end type
global w_ve704_vtas_mensual w_ve704_vtas_mensual

type variables
string is_doc_ov
end variables

on w_ve704_vtas_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.em_ano=create em_ano
this.st_3=create st_3
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_ve704_vtas_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;//Ancestor Overriding
Integer	li_year
str_parametros lstr_param

li_year = Integer(em_ano.text)

//Tiene que seleccionar los grupos a partir del super_grupo

// Asigna valores a structura 
lstr_param.dw_master = 'd_sel_art_spr_grupo'      
lstr_param.dw1       = 'd_sel_articulo_grupo'  
lstr_param.opcion    = 12
lstr_param.tipo		 =''
lstr_param.titulo    = 'Seleccion de Super Grupos y Grupos de Artículos'

OpenWithParm( w_abc_seleccion_md, lstr_param)

idw_1.Visible = True

idw_1.Retrieve(li_year)

idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_ventana.text 	= this.ClassName()
idw_1.Object.t_user.text 		= gs_user
idw_1.Object.t_stitulo1.text 	= 'Año ' + string(li_year)


end event

event ue_open_pre;call super::ue_open_pre;select doc_ov
	into :is_doc_ov
from logparam
where reckey = '1';

idw_1.object.datawindow.print.orientation = 2
end event

type dw_report from w_report_smpl`dw_report within w_ve704_vtas_mensual
integer x = 0
integer y = 244
integer width = 2089
integer height = 992
string dataobject = "d_rpt_ventas_mensual_x_grp_art"
end type

type cb_1 from commandbutton within w_ve704_vtas_mensual
integer x = 1376
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

type rb_1 from radiobutton within w_ve704_vtas_mensual
integer x = 581
integer y = 92
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

type rb_2 from radiobutton within w_ve704_vtas_mensual
integer x = 887
integer y = 92
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

event clicked;Integer 	li_year
String 	ls_ingr_egr, ls_tipo
str_parametros sl_param

li_year = Integer(em_ano.text)

// Asigna valores a structura 
sl_param.dw1 = "d_sel_cencos_amp_ov_anual"	
sl_param.tipo = '1I'	
sl_param.int1 = li_year
sl_param.titulo = "Centros de costo"
sl_param.opcion = 1

OpenWithParm( w_rpt_listas, sl_param)
end event

type em_ano from editmask within w_ve704_vtas_mensual
integer x = 265
integer y = 72
integer width = 247
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_3 from statictext within w_ve704_vtas_mensual
integer x = 55
integer y = 88
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_ve704_vtas_mensual
integer x = 558
integer y = 8
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

type gb_1 from groupbox within w_ve704_vtas_mensual
integer width = 544
integer height = 192
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

