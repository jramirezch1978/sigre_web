$PBExportHeader$w_pt702_ppto_x_cnta_presup_anual.srw
forward
global type w_pt702_ppto_x_cnta_presup_anual from w_report_smpl
end type
type em_ano from editmask within w_pt702_ppto_x_cnta_presup_anual
end type
type cb_1 from commandbutton within w_pt702_ppto_x_cnta_presup_anual
end type
type ddlb_ingr_egr from dropdownlistbox within w_pt702_ppto_x_cnta_presup_anual
end type
type rb_1 from radiobutton within w_pt702_ppto_x_cnta_presup_anual
end type
type rb_2 from radiobutton within w_pt702_ppto_x_cnta_presup_anual
end type
type gb_3 from groupbox within w_pt702_ppto_x_cnta_presup_anual
end type
type gb_4 from groupbox within w_pt702_ppto_x_cnta_presup_anual
end type
type gb_2 from groupbox within w_pt702_ppto_x_cnta_presup_anual
end type
end forward

global type w_pt702_ppto_x_cnta_presup_anual from w_report_smpl
integer width = 2720
integer height = 1712
string title = "Cuentas Presupuestales (PT702)"
string menuname = "m_impresion"
long backcolor = 67108864
em_ano em_ano
cb_1 cb_1
ddlb_ingr_egr ddlb_ingr_egr
rb_1 rb_1
rb_2 rb_2
gb_3 gb_3
gb_4 gb_4
gb_2 gb_2
end type
global w_pt702_ppto_x_cnta_presup_anual w_pt702_ppto_x_cnta_presup_anual

type variables
Integer  ii_zoom_actual = 80, ii_zi = 10, ii_sort = 0, ii_index
String  	is_nivelcc, is_nivelcp

end variables

on w_pt702_ppto_x_cnta_presup_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_ano=create em_ano
this.cb_1=create cb_1
this.ddlb_ingr_egr=create ddlb_ingr_egr
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.ddlb_ingr_egr
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_4
this.Control[iCurrent+8]=this.gb_2
end on

on w_pt702_ppto_x_cnta_presup_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.ddlb_ingr_egr)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_2)
end on

type dw_report from w_report_smpl`dw_report within w_pt702_ppto_x_cnta_presup_anual
integer y = 228
integer width = 2427
integer height = 1064
string dataobject = "d_rpt_prueba"
end type

type em_ano from editmask within w_pt702_ppto_x_cnta_presup_anual
integer x = 55
integer y = 80
integer width = 206
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_pt702_ppto_x_cnta_presup_anual
integer x = 1865
integer y = 52
integer width = 306
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long 		ll_ano
String	ls_ingr_egr
str_parametros sl_param

ll_ano = Long( em_ano.text)
ls_ingr_egr = left(ddlb_ingr_egr.text,1)

if ls_ingr_egr = '' then
	MessageBox('Aviso', 'Debe Indicar si es Ingreso o Egreso')
	return
end if

Setpointer(hourglass!)

IF ls_ingr_egr = 'Z' then ls_ingr_egr = '%'

sl_param.dw1 = "d_sel_presup_partida_cencos_ano_all"		
sl_param.opcion = 1
sl_param.tipo = '1L1S'
sl_param.long1 = ll_ano
sl_param.string1 = ls_ingr_egr
sl_param.titulo = "Seleccione Centros de costo"

OpenWithParm( w_rpt_listas, sl_param)

dw_report.SetTransObject(sqlca)
dw_report.visible = true
dw_report.retrieve(ll_ano, ls_ingr_egr)

dw_report.object.t_titulo1.text = 'Año: ' + em_ano.text
dw_report.object.t_usuario.text = gs_user
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_window.text = Parent.ClassName( )

return 1
end event

type ddlb_ingr_egr from dropdownlistbox within w_pt702_ppto_x_cnta_presup_anual
integer x = 1047
integer y = 80
integer width = 686
integer height = 388
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"I - Ingreso","E - Egreso","Z - Todos"}
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_pt702_ppto_x_cnta_presup_anual
integer x = 347
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

Delete from TT_PTO_TIPO_PRTDA;

insert into TT_PTO_TIPO_PRTDA ( TIPO_PRTDA_PRSP ) 
SELECT DISTINCT TIPO_PRTDA_PRSP
	FROM TIPO_PRTDA_PRSP_DET;            

Commit;
end event

type rb_2 from radiobutton within w_pt702_ppto_x_cnta_presup_anual
integer x = 617
integer y = 100
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

event clicked;Long ll_count
str_parametros lstr_param

// Asigna valores a structura 
lstr_param.dw_master = 'd_lista_tipo_prtda_prsp_tbl'
lstr_param.dw1 	= "d_lista_tipo_prtda_prsp_det_tbl"
lstr_param.titulo = "Tipos de Partidas Presupuestales"
lstr_param.opcion = 1
lstr_param.tipo 	= ''

OpenWithParm( w_abc_seleccion_md, lstr_param)

select count(*)
  into :ll_count
  from tt_pto_tipo_prtda;

if ll_count = 0 then
	this.checked = false
	return
end if
end event

type gb_3 from groupbox within w_pt702_ppto_x_cnta_presup_anual
integer x = 9
integer y = 12
integer width = 302
integer height = 192
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
end type

type gb_4 from groupbox within w_pt702_ppto_x_cnta_presup_anual
integer x = 1024
integer y = 12
integer width = 754
integer height = 192
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Ingr/Egreso"
end type

type gb_2 from groupbox within w_pt702_ppto_x_cnta_presup_anual
integer x = 315
integer y = 12
integer width = 699
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Prtda Prsp"
end type

