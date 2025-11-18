$PBExportHeader$w_pt506_var_prsp_prod.srw
$PBExportComments$Control presupuestario por cuenta presupuestal
forward
global type w_pt506_var_prsp_prod from w_report_smpl
end type
type cb_1 from commandbutton within w_pt506_var_prsp_prod
end type
type cb_2 from commandbutton within w_pt506_var_prsp_prod
end type
type rb_positivas from radiobutton within w_pt506_var_prsp_prod
end type
type rb_negativas from radiobutton within w_pt506_var_prsp_prod
end type
type rb_ambas from radiobutton within w_pt506_var_prsp_prod
end type
type sle_mes1 from singlelineedit within w_pt506_var_prsp_prod
end type
type sle_mes2 from singlelineedit within w_pt506_var_prsp_prod
end type
type st_1 from statictext within w_pt506_var_prsp_prod
end type
type st_2 from statictext within w_pt506_var_prsp_prod
end type
type gb_1 from groupbox within w_pt506_var_prsp_prod
end type
end forward

global type w_pt506_var_prsp_prod from w_report_smpl
integer width = 3182
integer height = 1644
string title = "Variaciones Presupuesto Prduccion (PT506)"
string menuname = "m_impresion"
boolean maxbox = false
long backcolor = 67108864
cb_1 cb_1
cb_2 cb_2
rb_positivas rb_positivas
rb_negativas rb_negativas
rb_ambas rb_ambas
sle_mes1 sle_mes1
sle_mes2 sle_mes2
st_1 st_1
st_2 st_2
gb_1 gb_1
end type
global w_pt506_var_prsp_prod w_pt506_var_prsp_prod

type variables
Long il_year
end variables

on w_pt506_var_prsp_prod.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.cb_2=create cb_2
this.rb_positivas=create rb_positivas
this.rb_negativas=create rb_negativas
this.rb_ambas=create rb_ambas
this.sle_mes1=create sle_mes1
this.sle_mes2=create sle_mes2
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.rb_positivas
this.Control[iCurrent+4]=this.rb_negativas
this.Control[iCurrent+5]=this.rb_ambas
this.Control[iCurrent+6]=this.sle_mes1
this.Control[iCurrent+7]=this.sle_mes2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_pt506_var_prsp_prod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.rb_positivas)
destroy(this.rb_negativas)
destroy(this.rb_ambas)
destroy(this.sle_mes1)
destroy(this.sle_mes2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_sel_ots, ls_null

select usf_pto_selecs_ots(:ls_null)
	into :ls_sel_ots
from dual;

idw_1.Visible = true
idw_1.object.Datawindow.print.Orientation = 1
idw_1.object.Datawindow.print.preview = 'No'
ib_preview=false
idw_1.Retrieve()
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_texto.text		= ls_sel_ots
end event

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_param

lstr_param = Message.PowerObjectParm

il_year = lstr_param.long1

this.event ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_pt506_var_prsp_prod
integer x = 0
integer y = 220
integer width = 2670
integer height = 1192
integer taborder = 90
string dataobject = "d_cns_prsp_variaciones"
end type

type cb_1 from commandbutton within w_pt506_var_prsp_prod
integer x = 2149
integer width = 530
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Generar Variacion"
end type

event clicked;string	ls_mensaje, ls_opcion = '2', ls_tipo_var
integer	li_mes1, li_mes2

if rb_positivas.checked = false and &
	rb_negativas.checked = false and &
	rb_ambas.checked	   = false then
	
	MessageBox('Aviso', 'Debe seleccionar el tipo de variacion')
	return
	
end if

if rb_positivas.checked = true then
	ls_tipo_var = '1'
elseif rb_negativas.checked = true then
	ls_tipo_var = '2'
elseif rb_ambas.checked = true then
	ls_tipo_var = '3'
end if

li_mes1 = integer(sle_mes1.text)
li_mes2 = integer(sle_mes2.text)

if li_mes1 = 0 or li_mes2 = 0 or li_mes1 > li_mes2 then
	MessageBox('Aviso', 'Debe Ingresar un periodo valido')
	return
	
end if

idw_1.Accepttext( )
idw_1.Update( )

if MessageBox('Aviso', 'Desea Generar Variaciones Presupuestales en forma automatica?' &
			+ '~r~nUna vez realizada la operacion no hay forma de deshacerla ', &
			Information!, YesNo!, 2) = 2 then return
	
//create or replace procedure USP_PTO_GEN_VAR_PRSP_PROD(
//       ani_year     in number,
//       asi_origen   in origen.cod_origen%TYPE,
//       asi_user     in usuario.cod_usr%TYPE,
//       ani_mes1      in number,
//       ani_mes2      in number,
//       asi_tipo_var in char,
//       asi_opcion   in char
//) is

DECLARE USP_PTO_GEN_VAR_PRSP_PROD PROCEDURE FOR
	USP_PTO_GEN_VAR_PRSP_PROD( :il_year,
							  			:gs_origen,
							  			:gs_user,
										:li_mes1,
										:li_mes2,
							  			:ls_tipo_var,
							  			:ls_opcion );

EXECUTE USP_PTO_GEN_VAR_PRSP_PROD;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PTO_GEN_VAR_PRSP_PROD: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_PTO_GEN_VAR_PRSP_PROD;

MessageBox('Aviso', 'Proceso a sido ejecutado satisfactoriamente', StopSign!)	

Close(Parent)

end event

type cb_2 from commandbutton within w_pt506_var_prsp_prod
integer x = 2149
integer y = 96
integer width = 530
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cerrar"
end type

event clicked;Close(parent)
end event

type rb_positivas from radiobutton within w_pt506_var_prsp_prod
integer x = 123
integer y = 76
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Positivas"
end type

type rb_negativas from radiobutton within w_pt506_var_prsp_prod
integer x = 425
integer y = 76
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Negativas"
end type

type rb_ambas from radiobutton within w_pt506_var_prsp_prod
integer x = 754
integer y = 76
integer width = 265
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambas"
end type

type sle_mes1 from singlelineedit within w_pt506_var_prsp_prod
integer x = 1303
integer y = 92
integer width = 169
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type sle_mes2 from singlelineedit within w_pt506_var_prsp_prod
integer x = 1605
integer y = 92
integer width = 169
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pt506_var_prsp_prod
integer x = 1321
integer y = 24
integer width = 453
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo (Meses)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt506_var_prsp_prod
integer x = 1499
integer y = 108
integer width = 101
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Al"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pt506_var_prsp_prod
integer x = 55
integer y = 4
integer width = 1152
integer height = 160
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generar solo Variaciones"
end type

