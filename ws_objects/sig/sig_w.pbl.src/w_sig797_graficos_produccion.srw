$PBExportHeader$w_sig797_graficos_produccion.srw
forward
global type w_sig797_graficos_produccion from w_report_smpl
end type
type st_1 from statictext within w_sig797_graficos_produccion
end type
type uo_rango from ou_rango_fechas within w_sig797_graficos_produccion
end type
type cb_proc from commandbutton within w_sig797_graficos_produccion
end type
type sle_moneda from singlelineedit within w_sig797_graficos_produccion
end type
type st_2 from statictext within w_sig797_graficos_produccion
end type
type ddlb_1 from dropdownlistbox within w_sig797_graficos_produccion
end type
type st_3 from statictext within w_sig797_graficos_produccion
end type
end forward

global type w_sig797_graficos_produccion from w_report_smpl
integer width = 3995
integer height = 1740
string title = "[PR748] Costos x Empacadora"
string menuname = "m_rpt_simple"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
cb_proc cb_proc
sle_moneda sle_moneda
st_2 st_2
ddlb_1 ddlb_1
st_3 st_3
end type
global w_sig797_graficos_produccion w_sig797_graficos_produccion

type variables
string 	is_soles
Integer	ii_opcion
end variables

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_sig797_graficos_produccion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.st_1=create st_1
this.uo_rango=create uo_rango
this.cb_proc=create cb_proc
this.sle_moneda=create sle_moneda
this.st_2=create st_2
this.ddlb_1=create ddlb_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.cb_proc
this.Control[iCurrent+4]=this.sle_moneda
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.ddlb_1
this.Control[iCurrent+7]=this.st_3
end on

on w_sig797_graficos_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.cb_proc)
destroy(this.sle_moneda)
destroy(this.st_2)
destroy(this.ddlb_1)
destroy(this.st_3)
end on

event ue_open_pre;//ii_lec_mst = 0

select cod_soles
	into :is_soles
from logparam
where reckey = '1';

sle_moneda.text = is_soles

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
idw_1.Visible = False
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_titulo, ls_moneda
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

ls_moneda = sle_moneda.text

//Papel A-4 Apaisado
//dw_report.Object.DataWindow.Print.Paper.Size = 256 
//dw_report.Object.DataWindow.Print.CustomPage.Width = 297 
//dw_report.Object.DataWindow.Print.CustomPage.Length = 210

dw_report.Object.Datawindow.Print.Orientation = 2
//dw_report.Object.DataWindow.Print.Paper.Size	= 1

dw_report.settransobject( sqlca )
dw_report.retrieve(ld_fecha1, ld_fecha2, ls_moneda )

dw_report.object.p_logo.filename = gs_logo
dw_report.object.st_usuario.text = gs_user
dw_report.object.st_empresa.text = gs_empresa
dw_report.object.st_comentario.text 	= ls_titulo
dw_report.object.st_desde.text 	= string(ld_fecha1, 'dd/mm/yyyy')
dw_report.object.st_hasta.text 	= string(ld_fecha2, 'dd/mm/yyyy')


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If


end event

type dw_report from w_report_smpl`dw_report within w_sig797_graficos_produccion
event ue_display ( string as_columna,  long al_row )
event ue_leftbuttonclicked pbm_dwnlbuttonup
integer x = 0
integer y = 208
integer width = 3771
integer height = 1204
integer taborder = 10
string dataobject = "d_rpt_produccion_cmp"
string is_dwform = ""
end type

event dw_report::ue_leftbuttonclicked;//cbx_PowerFilter.event post ue_buttonclicked(dwo.type, dwo.name)
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;SelectRow(0, false)
SelectRow(currentRow, true)
end event

event dw_report::constructor;call super::constructor;//cbx_PowerFilter.of_setdw(this)

end event

event dw_report::resize;call super::resize;//cbx_PowerFilter.event ue_positionbuttons()
end event

type st_1 from statictext within w_sig797_graficos_produccion
integer x = 1157
integer y = 28
integer width = 475
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas:"
boolean focusrectangle = false
end type

type uo_rango from ou_rango_fechas within w_sig797_graficos_produccion
integer x = 1641
integer y = 16
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cb_proc from commandbutton within w_sig797_graficos_produccion
integer x = 2770
integer y = 16
integer width = 343
integer height = 164
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type sle_moneda from singlelineedit within w_sig797_graficos_produccion
event dobleclick pbm_lbuttondblclk
integer x = 1458
integer y = 112
integer width = 288
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 8
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select m.cod_moneda as codigo_moneda, "&
			+"m.descripcion as descripcion_moneda "&
  			+"from moneda m Where m.flag_estado = 1"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type st_2 from statictext within w_sig797_graficos_produccion
integer x = 1179
integer y = 120
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Moneda:"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_sig797_graficos_produccion
integer y = 100
integer width = 1088
integer height = 400
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"Graficos de Produccion"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_colname
ls_colname = ddlb_1.Text(index)
ii_opcion = index

IF index < 0 then return

CHOOSE CASE index
	CASE 1 
		idw_1.Dataobject = "d_rpt_produccion_cmp"
end CHOOSE

idw_1.SetTransObject(sqlca)



end event

type st_3 from statictext within w_sig797_graficos_produccion
integer y = 16
integer width = 960
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Tipo de reporte:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

