$PBExportHeader$w_pr777_ratios_x_empacadora.srw
forward
global type w_pr777_ratios_x_empacadora from w_report_smpl
end type
type st_1 from statictext within w_pr777_ratios_x_empacadora
end type
type uo_rango from ou_rango_fechas within w_pr777_ratios_x_empacadora
end type
type cbx_1 from checkbox within w_pr777_ratios_x_empacadora
end type
type sle_empacadora from singlelineedit within w_pr777_ratios_x_empacadora
end type
type st_empacadora from statictext within w_pr777_ratios_x_empacadora
end type
type cb_proc from commandbutton within w_pr777_ratios_x_empacadora
end type
end forward

global type w_pr777_ratios_x_empacadora from w_report_smpl
integer width = 3995
integer height = 1356
string title = "[PR777] Ratios de Producción por Empacadora"
string menuname = "m_reporte"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
cbx_1 cbx_1
sle_empacadora sle_empacadora
st_empacadora st_empacadora
cb_proc cb_proc
end type
global w_pr777_ratios_x_empacadora w_pr777_ratios_x_empacadora

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr777_ratios_x_empacadora.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_rango=create uo_rango
this.cbx_1=create cbx_1
this.sle_empacadora=create sle_empacadora
this.st_empacadora=create st_empacadora
this.cb_proc=create cb_proc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.sle_empacadora
this.Control[iCurrent+5]=this.st_empacadora
this.Control[iCurrent+6]=this.cb_proc
end on

on w_pr777_ratios_x_empacadora.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.cbx_1)
destroy(this.sle_empacadora)
destroy(this.st_empacadora)
destroy(this.cb_proc)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_empacadora, ls_titulo
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

If cbx_1.Checked Then
	ls_empacadora = '%%'
Else
	ls_empacadora = sle_empacadora.text + "%"
End If 

if ld_fecha1 = ld_fecha2 then
	ls_titulo = 'RATIOS DE PRODUCCION DE ' + st_empacadora.text + '. DÍA ' + string(ld_fecha1, 'dd/mm/yyyy')
else
	ls_titulo = 'RATIOS DE PRODUCCION DE ' + st_empacadora.text + '. PERIODO ' + string(ld_fecha1, 'dd/mm/yyyy') + ' - ' + string(ld_fecha2, 'dd/mm/yyyy')
end if

//Papel A-4 Apaisado
	this.dw_report.Object.DataWindow.Print.Paper.Size = 256 
	this.dw_report.Object.DataWindow.Print.CustomPage.Width = 297
	this.dw_report.Object.DataWindow.Print.CustomPage.Length = 210

dw_report.settransobject( sqlca )
dw_report.retrieve(ld_fecha1, ld_fecha2, ls_empacadora )

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

type dw_report from w_report_smpl`dw_report within w_pr777_ratios_x_empacadora
integer x = 0
integer y = 272
integer width = 3314
integer height = 836
integer taborder = 10
string dataobject = "d_rpt_ratios_x_empacadora"
string is_dwform = ""
end type

type st_1 from statictext within w_pr777_ratios_x_empacadora
integer x = 50
integer y = 60
integer width = 494
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

type uo_rango from ou_rango_fechas within w_pr777_ratios_x_empacadora
integer x = 535
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cbx_1 from checkbox within w_pr777_ratios_x_empacadora
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
string text = "Todas Las Empacadoras"
boolean checked = true
end type

event clicked;If cbx_1.Checked Then
	sle_empacadora.enabled = False
	sle_empacadora.text=''
Else
	sle_empacadora.enabled = true
	sle_empacadora.text=''
End If
end event

type sle_empacadora from singlelineedit within w_pr777_ratios_x_empacadora
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
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select ae.cod_empacadora as codigo, "&
			+"ae.desc_empacadora as empacadora "&
  			+"from ap_empacadora ae Where ae.flag_estado = 1"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	st_empacadora.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una Empacadora')
	return
end if

SELECT desc_empacadora INTO :ls_desc
FROM ap_empacadora
WHERE cod_empacadora = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Empacadora no existe o no está activo')
	return
end if

st_empacadora.text = ls_desc
end event

type st_empacadora from statictext within w_pr777_ratios_x_empacadora
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

type cb_proc from commandbutton within w_pr777_ratios_x_empacadora
integer x = 2400
integer y = 64
integer width = 343
integer height = 100
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

