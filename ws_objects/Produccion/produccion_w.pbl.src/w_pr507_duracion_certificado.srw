$PBExportHeader$w_pr507_duracion_certificado.srw
forward
global type w_pr507_duracion_certificado from w_rpt
end type
type st_3 from statictext within w_pr507_duracion_certificado
end type
type dw_plantas from u_dw_rpt within w_pr507_duracion_certificado
end type
type st_2 from statictext within w_pr507_duracion_certificado
end type
type dw_certificados from u_dw_rpt within w_pr507_duracion_certificado
end type
type dw_report from u_dw_rpt within w_pr507_duracion_certificado
end type
type st_1 from statictext within w_pr507_duracion_certificado
end type
end forward

global type w_pr507_duracion_certificado from w_rpt
integer width = 4677
integer height = 2084
string title = "Duración del Certificado de Calidad(w_pr507)"
string menuname = "m_mantto_consulta"
long backcolor = 67108864
st_3 st_3
dw_plantas dw_plantas
st_2 st_2
dw_certificados dw_certificados
dw_report dw_report
st_1 st_1
end type
global w_pr507_duracion_certificado w_pr507_duracion_certificado

type variables
Integer	ii_ss
dwobject	idwo_clicked
end variables

on w_pr507_duracion_certificado.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_3=create st_3
this.dw_plantas=create dw_plantas
this.st_2=create st_2
this.dw_certificados=create dw_certificados
this.dw_report=create dw_report
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.dw_plantas
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_certificados
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.st_1
end on

on w_pr507_duracion_certificado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.dw_plantas)
destroy(this.st_2)
destroy(this.dw_certificados)
destroy(this.dw_report)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_plantas.SetTransObject(sqlca)
dw_certificados.SetTransObject(sqlca)
dw_report.SetTransObject(sqlca)
dw_plantas.retrieve( )

end event

type st_3 from statictext within w_pr507_duracion_certificado
integer x = 37
integer y = 684
integer width = 4471
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Detalle del Certificado"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_plantas from u_dw_rpt within w_pr507_duracion_certificado
integer x = 37
integer y = 92
integer width = 1806
integer height = 496
integer taborder = 30
string dataobject = "d_plantas_produccion_tbl"
end type

event clicked;call super::clicked;IF row = 0 OR is_dwform = 'form' THEN RETURN

ii_ss = 1

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	idwo_clicked = dwo        // dwo corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	RETURN
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;dw_certificados.reset()
dw_report.reset()

if currentrow >= 1 then
	if dw_certificados.retrieve(this.object.cod_planta[currentrow]) >= 1 then
		dw_certificados.scrolltorow(1)
		dw_certificados.setrow(1)
		dw_certificados.selectrow( 1, true)
	end if
end if
end event

type st_2 from statictext within w_pr507_duracion_certificado
integer x = 1874
integer y = 28
integer width = 2606
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Plantas de Producción"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_certificados from u_dw_rpt within w_pr507_duracion_certificado
integer x = 1874
integer y = 92
integer width = 2606
integer height = 496
integer taborder = 20
string dataobject = "ds_certificado_calidad_ver_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;dw_report.reset()
dw_report.groupcalc( )
if currentrow >= 1 then
	if dw_report.retrieve(this.object.cod_certificado[currentrow]) >= 1 then
	end if
end if
end event

event clicked;call super::clicked;IF row = 0 OR is_dwform = 'form' THEN RETURN

ii_ss = 1

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	idwo_clicked = dwo        // dwo corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	RETURN
END IF

end event

type dw_report from u_dw_rpt within w_pr507_duracion_certificado
integer x = 37
integer y = 748
integer width = 4471
integer height = 1120
integer taborder = 20
string dataobject = "d_rpt_certificado_calidad_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type st_1 from statictext within w_pr507_duracion_certificado
integer x = 37
integer y = 28
integer width = 1797
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Plantas de Producción"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

