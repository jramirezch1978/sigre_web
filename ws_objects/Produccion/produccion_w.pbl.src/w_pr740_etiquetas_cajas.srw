$PBExportHeader$w_pr740_etiquetas_cajas.srw
forward
global type w_pr740_etiquetas_cajas from w_report_smpl
end type
type cb_reporte from commandbutton within w_pr740_etiquetas_cajas
end type
type st_1 from statictext within w_pr740_etiquetas_cajas
end type
type st_2 from statictext within w_pr740_etiquetas_cajas
end type
type cbx_todos from checkbox within w_pr740_etiquetas_cajas
end type
type sle_jabas from singlelineedit within w_pr740_etiquetas_cajas
end type
type sle_desde from singlelineedit within w_pr740_etiquetas_cajas
end type
type sle_hasta from singlelineedit within w_pr740_etiquetas_cajas
end type
type cb_1 from commandbutton within w_pr740_etiquetas_cajas
end type
type gb_5 from groupbox within w_pr740_etiquetas_cajas
end type
type gb_3 from groupbox within w_pr740_etiquetas_cajas
end type
end forward

global type w_pr740_etiquetas_cajas from w_report_smpl
integer width = 3506
integer height = 1636
string title = "(PR740) Etiquetas para Cajas de Productos Terminados"
string menuname = "m_reporte"
long backcolor = 79741120
event ue_crear_cajas ( )
cb_reporte cb_reporte
st_1 st_1
st_2 st_2
cbx_todos cbx_todos
sle_jabas sle_jabas
sle_desde sle_desde
sle_hasta sle_hasta
cb_1 cb_1
gb_5 gb_5
gb_3 gb_3
end type
global w_pr740_etiquetas_cajas w_pr740_etiquetas_cajas

type variables
string is_codigo
end variables

forward prototypes
public subroutine of_limites ()
end prototypes

event ue_crear_cajas();//create or replace procedure USP_PROD_CREAR_CAJAS(
//       asi_origen   in origen.cod_origen%TYPE,
//       ani_numero   in number
//) is

integer li_jabas
string ls_mensaje

li_jabas = Integer(sle_jabas.text)

if li_jabas <= 0 then
	MessageBox('Error', 'Debe indicar un numero de cajas positivo')
	return
end if

DECLARE USP_PROD_CREAR_CAJAS PROCEDURE FOR
	USP_PROD_CREAR_CAJAS( :gs_origen, 
								 :li_jabas );
								 
EXECUTE USP_PROD_CREAR_CAJAS;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_CREAR_CAJAS: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PROD_CREAR_CAJAS;

MessageBox('Producción', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Information!)	

end event

public subroutine of_limites ();string ls_desde, ls_hasta

select min(nro_caja), max(nro_caja)
  into :ls_desde, :ls_hasta
from pck_produccion
where cod_origen = :gs_origen
  and fec_produccion is null;

if SQLca.SQLCode = 100 then return

sle_desde.text = ls_desde
sle_hasta.text = ls_hasta
end subroutine

on w_pr740_etiquetas_cajas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_reporte=create cb_reporte
this.st_1=create st_1
this.st_2=create st_2
this.cbx_todos=create cbx_todos
this.sle_jabas=create sle_jabas
this.sle_desde=create sle_desde
this.sle_hasta=create sle_hasta
this.cb_1=create cb_1
this.gb_5=create gb_5
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cbx_todos
this.Control[iCurrent+5]=this.sle_jabas
this.Control[iCurrent+6]=this.sle_desde
this.Control[iCurrent+7]=this.sle_hasta
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_5
this.Control[iCurrent+10]=this.gb_3
end on

on w_pr740_etiquetas_cajas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cbx_todos)
destroy(this.sle_jabas)
destroy(this.sle_desde)
destroy(this.sle_hasta)
destroy(this.cb_1)
destroy(this.gb_5)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string  	ls_desde, ls_hasta

if cbx_todos.checked then
	of_limites( )
end if

ls_desde = sle_desde.text
ls_hasta = sle_hasta.text

if isnull(ls_desde) or (ls_desde > ls_hasta) then
	MessageBox('Aviso','rango es incorrecto. Verifique')
	return
end if

dw_report.retrieve(ls_desde, ls_hasta)



end event

event open;call super::open;String ls_Dir = "C:\WINDOWS\Fonts\", ls_fileFont = "IDAutomationHC39M_Free.ttf"


if not FileExists(ls_dir + ls_FileFont) then
	FileCopy(ls_fileFont, ls_dir + ls_FileFont, false)
	MessageBox('Error', 'No tiene instalado la fuente ' + ls_dir + ls_FileFont &
				+ "~r~nLa aplicación está copiando la fuente en " + ls_dir &
				+ "~r~nLa Aplicación se cerrará, debe volverla a cargar nuevamente ")
	Halt Close
end if
end event

event ue_open_pre;call super::ue_open_pre;of_limites( )
end event

type dw_report from w_report_smpl`dw_report within w_pr740_etiquetas_cajas
integer x = 9
integer y = 220
integer width = 3451
integer height = 1216
integer taborder = 70
string dataobject = "d_label_caja_pptt_lbl"
end type

type cb_reporte from commandbutton within w_pr740_etiquetas_cajas
integer x = 2496
integer y = 68
integer width = 494
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_1 from statictext within w_pr740_etiquetas_cajas
integer x = 402
integer y = 84
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr740_etiquetas_cajas
integer x = 955
integer y = 84
integer width = 146
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type cbx_todos from checkbox within w_pr740_etiquetas_cajas
integer x = 46
integer y = 80
integer width = 256
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todas"
boolean checked = true
end type

event clicked;if not this.checked then
	sle_Desde.enabled = true
	sle_hasta.enabled = true
else
	sle_desde.enabled = false
	sle_hasta.enabled = false
end if
end event

type sle_jabas from singlelineedit within w_pr740_etiquetas_cajas
integer x = 1577
integer y = 68
integer width = 279
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type sle_desde from singlelineedit within w_pr740_etiquetas_cajas
integer x = 631
integer y = 76
integer width = 311
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 10
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type sle_hasta from singlelineedit within w_pr740_etiquetas_cajas
integer x = 1120
integer y = 76
integer width = 311
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 10
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type cb_1 from commandbutton within w_pr740_etiquetas_cajas
integer x = 1893
integer y = 68
integer width = 329
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_crear_cajas()
of_limites( )

end event

type gb_5 from groupbox within w_pr740_etiquetas_cajas
integer width = 1536
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Rango de Cajas"
end type

type gb_3 from groupbox within w_pr740_etiquetas_cajas
integer x = 1554
integer width = 759
integer height = 208
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Generar Nuevas Cajas"
end type

