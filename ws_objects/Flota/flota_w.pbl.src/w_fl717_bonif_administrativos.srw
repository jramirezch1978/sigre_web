$PBExportHeader$w_fl717_bonif_administrativos.srw
forward
global type w_fl717_bonif_administrativos from w_rpt
end type
type rb_2 from radiobutton within w_fl717_bonif_administrativos
end type
type rb_1 from radiobutton within w_fl717_bonif_administrativos
end type
type cb_3 from commandbutton within w_fl717_bonif_administrativos
end type
type cb_2 from commandbutton within w_fl717_bonif_administrativos
end type
type cb_1 from commandbutton within w_fl717_bonif_administrativos
end type
type em_ano from editmask within w_fl717_bonif_administrativos
end type
type em_mes from editmask within w_fl717_bonif_administrativos
end type
type st_3 from statictext within w_fl717_bonif_administrativos
end type
type st_2 from statictext within w_fl717_bonif_administrativos
end type
type dw_report from u_dw_rpt within w_fl717_bonif_administrativos
end type
end forward

global type w_fl717_bonif_administrativos from w_rpt
integer width = 3163
integer height = 3472
string title = "Incentivos Personal Administrativo (FL717)"
string menuname = "m_rpt"
long backcolor = 67108864
rb_2 rb_2
rb_1 rb_1
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_3 st_3
st_2 st_2
dw_report dw_report
end type
global w_fl717_bonif_administrativos w_fl717_bonif_administrativos

type variables
uo_parte_pesca iuo_parte
end variables

on w_fl717_bonif_administrativos.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.em_ano
this.Control[iCurrent+7]=this.em_mes
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.dw_report
end on

on w_fl717_bonif_administrativos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_mes, li_ano, li_count
string 	ls_mensaje, ls_nnave, ls_tipo_flota

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

if rb_1.checked = true then
	ls_tipo_flota = 'P'
elseif rb_2.checked = true then
	ls_tipo_flota = 'T'
else
	MessageBox('Aviso','Debe seleccionar un tipo de Flota')
	return
end if

//create or replace procedure USP_FL_INCENT_PERS_ADM(
//       ani_year             in number,
//       ani_mes              in number,
//       asi_tipo_flota       IN tg_naves.flag_tipo_flota%TYPE
//) is

DECLARE USP_FL_INCENT_PERS_ADM PROCEDURE FOR
	USP_FL_INCENT_PERS_ADM( :li_ano, 
									:li_mes,
									:ls_tipo_flota );

EXECUTE USP_FL_INCENT_PERS_ADM;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_INCENT_PERS_ADM: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_INCENT_PERS_ADM;

idw_1.Retrieve()
idw_1.Visible = True

if idw_1.Rowcount( ) > 0 then
	cb_2.enabled = true
else
	cb_2.enabled = false
end if

select count(*)
  into :li_count
 from fl_consist_incent_trab a,
		TT_FL_INCENT_PERS_ADM  b
WHERE a.cod_relacion = b.cod_trabajador
  AND a.ano = :li_ano
  AND a.mes = :li_mes
  AND a.nro_asiento IS NULL;

if li_count > 0 then
	cb_3.enabled = true
else
	cb_3.enabled = false
end if


end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.Datawindow.Print.Orientation = 1

iuo_parte = create uo_parte_pesca

em_ano.text = string( year( Date(f_fecha_actual()) ) )
em_mes.text = string( month( Date(f_fecha_actual()) ) )

idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_empresa.text 	= gs_empresa
idw_1.object.t_usuario.text	= gs_user
idw_1.object.t_objeto.text		= this.classname()
end event

event resize;call super::resize;this.SetRedraw(false)
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
this.SetRedraw(true)
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type rb_2 from radiobutton within w_fl717_bonif_administrativos
integer x = 1266
integer y = 92
integer width = 425
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Flota Terceros"
end type

type rb_1 from radiobutton within w_fl717_bonif_administrativos
integer x = 1266
integer y = 20
integer width = 425
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Flota Propia"
end type

type cb_3 from commandbutton within w_fl717_bonif_administrativos
integer x = 2729
integer y = 28
integer width = 343
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Anular CE"
end type

event clicked;string 	ls_soles, ls_mensaje
Integer	li_year, li_mes, li_count

if MessageBox('Aviso', 'Desea Anular los comprobantes de egreso del Mes?', &
	Information!, YesNo!, 2) = 2 then return
	
select cod_soles
	into :ls_soles
from logparam
where reckey = '1';

li_year 	= integer(em_ano.text)
li_mes	= integer(em_mes.text)

//create or replace procedure USP_FL_ANULAR_CE_INCET_ADM(
//       ani_year      in number,
//       ani_mes       in NUMBER
//) is

DECLARE USP_FL_ANULAR_CE_INCET_ADM PROCEDURE FOR
	USP_FL_ANULAR_CE_INCET_ADM( :li_year,
									 	 :li_mes);

EXECUTE USP_FL_ANULAR_CE_INCET_ADM;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_ANULAR_CE_INCET_ADM: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_ANULAR_CE_INCET_ADM;

MessageBox('AViso', 'Proceso a sido ejecutado')

this.enabled = false
end event

type cb_2 from commandbutton within w_fl717_bonif_administrativos
integer x = 2149
integer y = 28
integer width = 576
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Comprobante de Egreso"
end type

event clicked;string 	ls_soles, ls_mensaje
Integer	li_year, li_mes, li_count

if idw_1.RowCount() = 0 then
	MessageBox('Aviso', 'No puede generar comprobante de egreso, porque no hay datos')
end if

select cod_soles
	into :ls_soles
from logparam
where reckey = '1';

li_year 	= integer(em_ano.text)
li_mes	= integer(em_mes.text)

//create or replace procedure USP_FL_GEN_CE_INCET_ADM(
//       ani_year      in number,
//       ani_mes       in number,
//       asi_usuario   in usuario.cod_usr%TYPE,
//       asi_origen    in origen.cod_origen%TYPE
//) is

DECLARE USP_FL_GEN_CE_INCET_ADM PROCEDURE FOR
	USP_FL_GEN_CE_INCET_ADM( :li_year,
									 :li_mes,
									 :gs_user,
									 :gs_origen);

EXECUTE USP_FL_GEN_CE_INCET_ADM;

IF SQLCA.sqlcode <> 0 and ls_mensaje <> '' THEN
	ls_mensaje = "PROCEDURE USP_FL_GEN_CE_INCET_ADM: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_GEN_CE_INCET_ADM;

MessageBox('AViso', 'Proceso a sido satisfactorio')

this.enabled = false
end event

type cb_1 from commandbutton within w_fl717_bonif_administrativos
integer x = 1751
integer y = 28
integer width = 393
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve( )
SetPointer(Arrow!)
end event

type em_ano from editmask within w_fl717_bonif_administrativos
integer x = 251
integer y = 28
integer width = 375
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

event modified;cb_2.enabled = false
end event

type em_mes from editmask within w_fl717_bonif_administrativos
integer x = 864
integer y = 28
integer width = 370
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

event modified;cb_2.enabled = false
dw_report.Reset()
end event

type st_3 from statictext within w_fl717_bonif_administrativos
integer x = 50
integer y = 48
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl717_bonif_administrativos
integer x = 631
integer y = 48
integer width = 197
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_fl717_bonif_administrativos
integer y = 188
integer width = 2482
integer height = 1524
integer taborder = 70
string dataobject = "d_rpt_bonif_administrativos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

