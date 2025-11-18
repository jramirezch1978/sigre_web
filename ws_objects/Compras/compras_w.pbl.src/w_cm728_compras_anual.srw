$PBExportHeader$w_cm728_compras_anual.srw
forward
global type w_cm728_compras_anual from w_rpt
end type
type cb_1 from commandbutton within w_cm728_compras_anual
end type
type dw_report from u_dw_rpt within w_cm728_compras_anual
end type
type em_year from editmask within w_cm728_compras_anual
end type
type st_1 from statictext within w_cm728_compras_anual
end type
end forward

global type w_cm728_compras_anual from w_rpt
integer width = 3246
integer height = 1984
string title = "[CM728] Compras Anual por Prov y Articulo"
string menuname = "m_impresion"
cb_1 cb_1
dw_report dw_report
em_year em_year
st_1 st_1
end type
global w_cm728_compras_anual w_cm728_compras_anual

type variables
String 	is_almacen, is_ot_adm, is_cod_art, &
			is_nro_ot, is_estado, is_func
long		il_year			
end variables

event ue_retrieve;call super::ue_retrieve;Integer li_year 

li_year = Integer(em_year.Text)



idw_1.Retrieve(li_year)
idw_1.Visible = True
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_user.text 		= gs_user
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.object.t_objeto.text		= this.ClassName( )



end event

on w_cm728_compras_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.dw_report=create dw_report
this.em_year=create em_year
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.em_year
this.Control[iCurrent+4]=this.st_1
end on

on w_cm728_compras_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.em_year)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;em_year.text = string( year( today() ) )
idw_1 = dw_report
idw_1.SetTransObject(sqlca)
event ue_preview()
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cb_1 from commandbutton within w_cm728_compras_anual
integer x = 558
integer y = 28
integer width = 283
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_cm728_compras_anual
integer y = 136
integer width = 2930
integer height = 1316
integer taborder = 20
string dataobject = "d_rpt_plan_anual_compras_ot_tbl"
end type

event doubleclicked;call super::doubleclicked;string 			ls_cod_art
str_parametros  lstr_param
w_rpt_preview	lw_1

if this.RowCount() = 0 or row = 0 then return

//CHOOSE CASE dwo.Name
	    
	IF dwo.Name = 'cod_art' THEN  //Nota de Ingreso 

		ls_cod_art	 = this.object.cod_art [row]

			lstr_param.dw1     = 'd_plan_anual_detalle_articulo'
			lstr_param.titulo  = "Detalle de Artículo"
			lstr_param.tipo 	 = '6S1I'
			lstr_param.string1 = ls_cod_art
			lstr_param.string2 = is_almacen
			lstr_param.string3 = is_ot_adm
			lstr_param.string4 = is_nro_ot
			lstr_param.string5 = is_estado
			lstr_param.string6 = is_func
			lstr_param.int1 	 = il_year
			OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
	End IF
end event

type em_year from editmask within w_cm728_compras_anual
integer x = 261
integer y = 32
integer width = 261
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_cm728_compras_anual
integer x = 41
integer y = 44
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

