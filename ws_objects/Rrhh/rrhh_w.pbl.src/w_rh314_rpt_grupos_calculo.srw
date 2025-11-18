$PBExportHeader$w_rh314_rpt_grupos_calculo.srw
forward
global type w_rh314_rpt_grupos_calculo from w_report_smpl
end type
type cb_1 from commandbutton within w_rh314_rpt_grupos_calculo
end type
type em_fecha from editmask within w_rh314_rpt_grupos_calculo
end type
type gb_1 from groupbox within w_rh314_rpt_grupos_calculo
end type
end forward

global type w_rh314_rpt_grupos_calculo from w_report_smpl
integer width = 3589
integer height = 1696
string title = "(RH314) Reporte de Grupos de Cálculo de Planilla"
string menuname = "m_impresion"
cb_1 cb_1
em_fecha em_fecha
gb_1 gb_1
end type
global w_rh314_rpt_grupos_calculo w_rh314_rpt_grupos_calculo

on w_rh314_rpt_grupos_calculo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_fecha=create em_fecha
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_fecha
this.Control[iCurrent+3]=this.gb_1
end on

on w_rh314_rpt_grupos_calculo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_fecha)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_mensaje
date   ld_fecha

ld_fecha = date(em_fecha.text)

if isnull(ld_fecha) or ld_fecha = date(string('01/01/1900','dd/mm/yyyy')) then
	MessageBox('Aviso','Debe ingresar fecha de proceso')
	return
end if

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_fecha.text = string(ld_fecha,'dd/mm/yyyy')

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de reporte de grupos de cálculo, Falló', Exclamation! )
END IF

end event

type dw_report from w_report_smpl`dw_report within w_rh314_rpt_grupos_calculo
integer x = 0
integer y = 216
integer width = 3511
integer height = 1204
integer taborder = 30
string dataobject = "d_rpt_grupos_calculo_tbl"
end type

type cb_1 from commandbutton within w_rh314_rpt_grupos_calculo
integer x = 608
integer y = 72
integer width = 293
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_fecha from editmask within w_rh314_rpt_grupos_calculo
integer x = 91
integer y = 76
integer width = 343
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type gb_1 from groupbox within w_rh314_rpt_grupos_calculo
integer width = 521
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Proceso "
end type

