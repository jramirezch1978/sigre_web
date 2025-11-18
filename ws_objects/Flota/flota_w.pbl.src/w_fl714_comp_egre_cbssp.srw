$PBExportHeader$w_fl714_comp_egre_cbssp.srw
forward
global type w_fl714_comp_egre_cbssp from w_rpt
end type
type cb_1 from commandbutton within w_fl714_comp_egre_cbssp
end type
type em_ano from editmask within w_fl714_comp_egre_cbssp
end type
type em_semana from editmask within w_fl714_comp_egre_cbssp
end type
type st_3 from statictext within w_fl714_comp_egre_cbssp
end type
type st_2 from statictext within w_fl714_comp_egre_cbssp
end type
type dw_report from u_dw_rpt within w_fl714_comp_egre_cbssp
end type
end forward

global type w_fl714_comp_egre_cbssp from w_rpt
integer width = 2816
integer height = 2032
string title = "Comprobante de Egreso CBSSP (FL714)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_generar_ce ( )
cb_1 cb_1
em_ano em_ano
em_semana em_semana
st_3 st_3
st_2 st_2
dw_report dw_report
end type
global w_fl714_comp_egre_cbssp w_fl714_comp_egre_cbssp

type variables
uo_parte_pesca iuo_parte
end variables

event ue_generar_ce();integer 	li_semana, li_ano
string	ls_mensaje

li_ano = integer(em_ano.text)
li_semana = integer(em_semana.text)

if MessageBox('Aviso', 'Desea generar el comprobante de Egreso?', &
	Information!, YesNo!, 2) = 2 then return

SetPointer(HourGlass!)
//create or replace procedure USP_FL_GEN_CE_CBSSP(
//       ani_year      in number,
//       ani_semana    in number,
//       asi_usuario   in usuario.cod_usr%TYPE,
//       asi_origen    in origen.cod_origen%TYPE
//) is
DECLARE USP_FL_GEN_CE_CBSSP PROCEDURE FOR
	USP_FL_GEN_CE_CBSSP( :li_ano,
								:li_semana,
								:gs_user,
								:gs_origen );

EXECUTE USP_FL_GEN_CE_CBSSP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_GEN_CE_CBSSP: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_GEN_CE_CBSSP;

MessageBox('Aviso', 'Proceso realizado satisfactoriamente')

SetPointer(Arrow!)	
end event

on w_fl714_comp_egre_cbssp.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_semana=create em_semana
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_semana
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_report
end on

on w_fl714_comp_egre_cbssp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_semana)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;integer li_semana, li_ano

li_ano = integer(em_ano.text)
li_semana = integer(em_semana.text)

idw_1.Retrieve(li_ano, li_semana)


end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.Datawindow.Print.Orientation = 2

THIS.Event ue_preview()

iuo_parte = CREATE uo_parte_pesca

em_ano.text = string( year( today() ) )

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

type cb_1 from commandbutton within w_fl714_comp_egre_cbssp
integer x = 1797
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

event clicked;Parent.event ue_retrieve( )
end event

type em_ano from editmask within w_fl714_comp_egre_cbssp
integer x = 338
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

type em_semana from editmask within w_fl714_comp_egre_cbssp
integer x = 1307
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

type st_3 from statictext within w_fl714_comp_egre_cbssp
integer x = 137
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

type st_2 from statictext within w_fl714_comp_egre_cbssp
integer x = 928
integer y = 48
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Semana:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_fl714_comp_egre_cbssp
integer y = 168
integer width = 2482
integer height = 1524
integer taborder = 70
string dataobject = "d_rpt_comprob_egreso_cbssp_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

