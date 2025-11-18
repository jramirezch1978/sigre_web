$PBExportHeader$w_pt769_partida_presup_x_tipo.srw
$PBExportComments$Detalle de ejecucion mensual
forward
global type w_pt769_partida_presup_x_tipo from w_report_smpl
end type
type em_ano from editmask within w_pt769_partida_presup_x_tipo
end type
type st_3 from statictext within w_pt769_partida_presup_x_tipo
end type
type cb_1 from commandbutton within w_pt769_partida_presup_x_tipo
end type
type rb_1 from radiobutton within w_pt769_partida_presup_x_tipo
end type
type rb_2 from radiobutton within w_pt769_partida_presup_x_tipo
end type
type gb_1 from groupbox within w_pt769_partida_presup_x_tipo
end type
type gb_2 from groupbox within w_pt769_partida_presup_x_tipo
end type
end forward

global type w_pt769_partida_presup_x_tipo from w_report_smpl
integer width = 2866
integer height = 2372
string title = "Ejecucion presupuestal - Anual (PT769)"
string menuname = "m_impresion"
long backcolor = 67108864
em_ano em_ano
st_3 st_3
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
end type
global w_pt769_partida_presup_x_tipo w_pt769_partida_presup_x_tipo

type variables
Integer   ii_zoom_actual = 80, ii_zi = 10, ii_sort = 0
String is_nivelcc, is_nivelcp

end variables

on w_pt769_partida_presup_x_tipo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_ano=create em_ano
this.st_3=create st_3
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_pt769_partida_presup_x_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type dw_report from w_report_smpl`dw_report within w_pt769_partida_presup_x_tipo
integer x = 0
integer y = 196
integer width = 2674
integer height = 1748
string dataobject = "d_rpt_partidas_ppto_x_tipo_tbl"
end type

type em_ano from editmask within w_pt769_partida_presup_x_tipo
integer x = 265
integer y = 72
integer width = 247
integer height = 88
integer taborder = 10
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

type st_3 from statictext within w_pt769_partida_presup_x_tipo
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

type cb_1 from commandbutton within w_pt769_partida_presup_x_tipo
integer x = 1321
integer y = 56
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

event clicked;Int li_ano
string ls_mensaje
str_parametros sl_param

li_ano = INTEGER( em_ano.text)
			
dw_report.SetTransObject(sqlca)
dw_report.retrieve(li_ano)
//dw_report.object.datawindow.print.orientation = 1
dw_report.visible = true

dw_report.object.t_texto.text = 'Año: ' + em_ano.text + ' - '
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_objeto.text = 'PT769'
dw_report.Object.p_logo.filename = gs_logo
end event

type rb_1 from radiobutton within w_pt769_partida_presup_x_tipo
integer x = 585
integer y = 84
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

type rb_2 from radiobutton within w_pt769_partida_presup_x_tipo
integer x = 855
integer y = 88
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

event clicked;str_parametros lstr_param
Long	ll_count

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

type gb_1 from groupbox within w_pt769_partida_presup_x_tipo
integer width = 544
integer height = 192
integer taborder = 90
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

type gb_2 from groupbox within w_pt769_partida_presup_x_tipo
integer x = 553
integer width = 699
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
string text = "Tipo Prtda Prsp"
end type

