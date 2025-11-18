$PBExportHeader$w_sig798_costos_cuadrilla.srw
forward
global type w_sig798_costos_cuadrilla from w_report_smpl
end type
type st_1 from statictext within w_sig798_costos_cuadrilla
end type
type uo_rango from ou_rango_fechas within w_sig798_costos_cuadrilla
end type
type cbx_1 from checkbox within w_sig798_costos_cuadrilla
end type
type sle_cuadrilla from singlelineedit within w_sig798_costos_cuadrilla
end type
type st_desc_cuadrilla from statictext within w_sig798_costos_cuadrilla
end type
type cb_proc from commandbutton within w_sig798_costos_cuadrilla
end type
type sle_moneda from singlelineedit within w_sig798_costos_cuadrilla
end type
type st_2 from statictext within w_sig798_costos_cuadrilla
end type
end forward

global type w_sig798_costos_cuadrilla from w_report_smpl
integer width = 3995
integer height = 1740
string title = "[SIG797] Costos x Cuadrilla"
string menuname = "m_rpt_simple"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
cbx_1 cbx_1
sle_cuadrilla sle_cuadrilla
st_desc_cuadrilla st_desc_cuadrilla
cb_proc cb_proc
sle_moneda sle_moneda
st_2 st_2
end type
global w_sig798_costos_cuadrilla w_sig798_costos_cuadrilla

type variables
string is_soles
end variables

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_sig798_costos_cuadrilla.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.st_1=create st_1
this.uo_rango=create uo_rango
this.cbx_1=create cbx_1
this.sle_cuadrilla=create sle_cuadrilla
this.st_desc_cuadrilla=create st_desc_cuadrilla
this.cb_proc=create cb_proc
this.sle_moneda=create sle_moneda
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.sle_cuadrilla
this.Control[iCurrent+5]=this.st_desc_cuadrilla
this.Control[iCurrent+6]=this.cb_proc
this.Control[iCurrent+7]=this.sle_moneda
this.Control[iCurrent+8]=this.st_2
end on

on w_sig798_costos_cuadrilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.cbx_1)
destroy(this.sle_cuadrilla)
destroy(this.st_desc_cuadrilla)
destroy(this.cb_proc)
destroy(this.sle_moneda)
destroy(this.st_2)
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

event ue_retrieve;call super::ue_retrieve;String 	ls_cuadrilla, ls_titulo, ls_moneda
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

If cbx_1.Checked Then
	ls_cuadrilla = '%%'
Else
	ls_cuadrilla = sle_cuadrilla.text + "%"
End If 

If sle_moneda.text = '' Then
	MessageBox('Error', 'Debe elegir un tipo de moneda')
	sle_moneda.setFocus()
	return
End If 
ls_moneda = sle_moneda.text

if ld_fecha1 = ld_fecha2 then
	ls_titulo = 'RATIOS DE PRODUCCION DE ' + st_desc_cuadrilla.text + '. DÍA ' + string(ld_fecha1, 'dd/mm/yyyy')
else
	ls_titulo = 'RATIOS DE PRODUCCION DE ' + st_desc_cuadrilla.text + '. PERIODO ' + string(ld_fecha1, 'dd/mm/yyyy') + ' - ' + string(ld_fecha2, 'dd/mm/yyyy')
end if

//Papel A-4 Apaisado
dw_report.Object.DataWindow.Print.Paper.Size = 256 
dw_report.Object.DataWindow.Print.CustomPage.Width = 297 
dw_report.Object.DataWindow.Print.CustomPage.Length = 210

dw_report.Object.Datawindow.Print.Orientation = 2
//dw_report.Object.DataWindow.Print.Paper.Size	= 1

dw_report.settransobject( sqlca )
dw_report.retrieve(ld_fecha1, ld_fecha2, ls_moneda, ls_cuadrilla )

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

type dw_report from w_report_smpl`dw_report within w_sig798_costos_cuadrilla
event ue_display ( string as_columna,  long al_row )
event ue_leftbuttonclicked pbm_dwnlbuttonup
integer x = 0
integer y = 272
integer width = 3771
integer height = 1224
integer taborder = 10
string dataobject = "d_rpt_costos_cuadrilla_tbl"
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

type st_1 from statictext within w_sig798_costos_cuadrilla
integer x = 50
integer y = 60
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

type uo_rango from ou_rango_fechas within w_sig798_costos_cuadrilla
integer x = 535
integer y = 48
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cbx_1 from checkbox within w_sig798_costos_cuadrilla
integer x = 50
integer y = 176
integer width = 681
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todas Las Cuadrillas"
boolean checked = true
end type

event clicked;If cbx_1.Checked Then
	sle_cuadrilla.enabled = False
	sle_cuadrilla.text=''
Else
	sle_cuadrilla.enabled = true
	sle_cuadrilla.text=''
End If
end event

type sle_cuadrilla from singlelineedit within w_sig798_costos_cuadrilla
event dobleclick pbm_lbuttondblclk
integer x = 763
integer y = 176
integer width = 288
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select apb.cod_cuadrilla as codigo_cuadrilla, "&
			+"apb.desc_cuadrilla as descripcion_cuadrilla "&
  			+"from ap_cuadrilla apb Where apb.flag_estado = 1"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	st_desc_cuadrilla.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una cuadrilla')
	return
end if

SELECT desc_cuadrilla INTO :ls_desc
FROM ap_cuadrilla
WHERE cod_cuadrilla = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Cuadrilla no existe o no está activo')
	return
end if

st_desc_cuadrilla.text = ls_desc
end event

type st_desc_cuadrilla from statictext within w_sig798_costos_cuadrilla
integer x = 1070
integer y = 176
integer width = 1285
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_proc from commandbutton within w_sig798_costos_cuadrilla
integer x = 3150
integer y = 44
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

type sle_moneda from singlelineedit within w_sig798_costos_cuadrilla
event dobleclick pbm_lbuttondblclk
integer x = 1952
integer y = 52
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

type st_2 from statictext within w_sig798_costos_cuadrilla
integer x = 1687
integer y = 60
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

