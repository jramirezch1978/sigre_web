$PBExportHeader$w_pt922_genera_prsp_obreros.srw
$PBExportComments$Adiciona articulos proyectados al presupuesto de materiales
forward
global type w_pt922_genera_prsp_obreros from w_abc
end type
type cb_1 from commandbutton within w_pt922_genera_prsp_obreros
end type
type cb_4 from commandbutton within w_pt922_genera_prsp_obreros
end type
type cb_2 from commandbutton within w_pt922_genera_prsp_obreros
end type
type sle_origen from singlelineedit within w_pt922_genera_prsp_obreros
end type
type st_4 from statictext within w_pt922_genera_prsp_obreros
end type
type cbx_rev from checkbox within w_pt922_genera_prsp_obreros
end type
type em_ano from editmask within w_pt922_genera_prsp_obreros
end type
type st_6 from statictext within w_pt922_genera_prsp_obreros
end type
type st_2 from statictext within w_pt922_genera_prsp_obreros
end type
type st_1 from statictext within w_pt922_genera_prsp_obreros
end type
end forward

global type w_pt922_genera_prsp_obreros from w_abc
integer width = 1906
integer height = 824
string title = "Generación de Presupuesto de Obreros (PT922)"
string menuname = "m_master"
boolean resizable = false
boolean toolbarvisible = false
boolean center = true
event ue_preliminar ( )
event ue_generar ( )
cb_1 cb_1
cb_4 cb_4
cb_2 cb_2
sle_origen sle_origen
st_4 st_4
cbx_rev cbx_rev
em_ano em_ano
st_6 st_6
st_2 st_2
st_1 st_1
end type
global w_pt922_genera_prsp_obreros w_pt922_genera_prsp_obreros

event ue_preliminar();Integer 			li_ano, li_count
String 			ls_revertir, ls_preview = '1', ls_origen, ls_mensaje
str_parametros 	sl_param
w_rpt_preview 	lw_1

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

if ISNULL( sle_origen.text) OR TRIM(sle_origen.text) = '' THEN
	Messagebox( "Error", "Ingrese Origen", exclamation!)
	sle_origen.SetFocus()
	return
end if

if cbx_rev.checked = true then
	ls_revertir = '1'
else
	ls_revertir = '0'
end if

li_ano = Integer(em_ano.text)
ls_origen = sle_origen.text

//create or replace procedure USP_PTO_GEN_PRSP_OBREROS(
//       ani_year         IN number,
//       asi_origen       IN origen.cod_origen%TYPE,
//       asi_revertir     IN VARCHAR2,
//       asi_preview      IN VARCHAR2,
//       asi_usuario      IN usuario.cod_usr%TYPE
//) is

DECLARE USP_PTO_GEN_PRSP_OBREROS PROCEDURE FOR 
	USP_PTO_GEN_PRSP_OBREROS (	:li_ano, 
										:ls_origen,
										:ls_revertir,
										:ls_preview,
										:gs_user);
										
EXECUTE USP_PTO_GEN_PRSP_OBREROS;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_PTO_GEN_PRSP_OBREROS", ls_mensaje, stopsign!)
	return 
end if

CLOSE USP_PTO_GEN_PRSP_OBREROS;

select count(*)
	into :li_count
from tt_pto_presupuesto_det;

if li_count = 0 then
	MessageBox('Aviso', 'No se ha procesado ningun registro')
else
	sl_param.dw1 = 'd_rpt_preview_prsp_planilla_tbl'	
	sl_param.opcion = 2
	sl_param.titulo  = 'Proyeccion de presupuesto de planilla'
	sl_param.titulo1 = 'Periodo: ' + string(li_ano)
	sl_param.titulo2 = 'Origen: ' + sle_origen.text
	sl_param.orientacion = '1'
	
	OpenSheetWithParm( lw_1, sl_param, w_main, 0, Layered!)
end if



end event

event ue_generar();Integer 	li_ano
String 	ls_revertir, ls_preview = '0', ls_origen, ls_mensaje

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

if ISNULL( sle_origen.text) OR TRIM(sle_origen.text) = '' THEN
	Messagebox( "Error", "Ingrese Origen", exclamation!)
	sle_origen.SetFocus()
	return
end if

if cbx_rev.checked = true then
	ls_revertir = '1'
else
	ls_revertir = '0'
end if

li_ano = Integer(em_ano.text)
ls_origen = sle_origen.text

//create or replace procedure USP_PTO_GEN_PRSP_OBREROS(
//       ani_year         IN number,
//       asi_origen       IN origen.cod_origen%TYPE,
//       asi_revertir     IN VARCHAR2,
//       asi_preview      IN VARCHAR2,
//       asi_usuario      IN usuario.cod_usr%TYPE
//) is

DECLARE USP_PTO_GEN_PRSP_OBREROS PROCEDURE FOR 
	USP_PTO_GEN_PRSP_OBREROS (	:li_ano, 
										:ls_origen,
										:ls_revertir,
										:ls_preview,
										:gs_user);
										
EXECUTE USP_PTO_GEN_PRSP_OBREROS;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_PTO_GEN_PRSP_OBREROS", ls_mensaje, stopsign!)
	return 
end if

CLOSE USP_PTO_GEN_PRSP_OBREROS;

MessageBox( 'Mensaje', "Proceso terminado" )


end event

on w_pt922_genera_prsp_obreros.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.cb_1=create cb_1
this.cb_4=create cb_4
this.cb_2=create cb_2
this.sle_origen=create sle_origen
this.st_4=create st_4
this.cbx_rev=create cbx_rev
this.em_ano=create em_ano
this.st_6=create st_6
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_4
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.sle_origen
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cbx_rev
this.Control[iCurrent+7]=this.em_ano
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
end on

on w_pt922_genera_prsp_obreros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.cb_2)
destroy(this.sle_origen)
destroy(this.st_4)
destroy(this.cbx_rev)
destroy(this.em_ano)
destroy(this.st_6)
destroy(this.st_2)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;sle_origen.text = gs_origen
end event

type cb_1 from commandbutton within w_pt922_genera_prsp_obreros
integer x = 919
integer y = 544
integer width = 293
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.dynamic event ue_generar()
end event

type cb_4 from commandbutton within w_pt922_genera_prsp_obreros
integer x = 608
integer y = 544
integer width = 293
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Preliminar"
end type

event clicked;parent.dynamic event ue_preliminar()
end event

type cb_2 from commandbutton within w_pt922_genera_prsp_obreros
integer x = 535
integer y = 412
integer width = 73
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year


ls_sql = "select cod_origen as codigo_origen, " &
		 + "nombre as descripcion_origen " &
		 + "from origen " &
		 + "where flag_estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_origen.text = ls_codigo
end if

end event

type sle_origen from singlelineedit within w_pt922_genera_prsp_obreros
integer x = 306
integer y = 416
integer width = 210
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_pt922_genera_prsp_obreros
integer x = 23
integer y = 420
integer width = 256
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen"
boolean focusrectangle = false
end type

type cbx_rev from checkbox within w_pt922_genera_prsp_obreros
integer x = 1266
integer y = 412
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revertir "
end type

type em_ano from editmask within w_pt922_genera_prsp_obreros
integer x = 896
integer y = 416
integer width = 315
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_6 from statictext within w_pt922_genera_prsp_obreros
integer x = 681
integer y = 420
integer width = 169
integer height = 64
integer textsize = -10
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

type st_2 from statictext within w_pt922_genera_prsp_obreros
integer x = 46
integer y = 120
integer width = 1769
integer height = 240
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Este proceso tiene como finalidad Generar Prespuesto a partir de las proyecciones de  horas del Personal Obrero"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt922_genera_prsp_obreros
integer x = 69
integer y = 16
integer width = 1774
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Generación de Presupuesto de Planilla de Obreros"
boolean focusrectangle = false
end type

