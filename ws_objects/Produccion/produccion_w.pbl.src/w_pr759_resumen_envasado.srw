$PBExportHeader$w_pr759_resumen_envasado.srw
forward
global type w_pr759_resumen_envasado from w_report_smpl
end type
type st_1 from statictext within w_pr759_resumen_envasado
end type
type uo_rango from ou_rango_fechas within w_pr759_resumen_envasado
end type
type cb_proc from commandbutton within w_pr759_resumen_envasado
end type
end forward

global type w_pr759_resumen_envasado from w_report_smpl
integer width = 3995
integer height = 2052
string title = "[PR759] Resumen de envasado"
string menuname = "m_reporte"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
cb_proc cb_proc
end type
global w_pr759_resumen_envasado w_pr759_resumen_envasado

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr759_resumen_envasado.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_rango=create uo_rango
this.cb_proc=create cb_proc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.cb_proc
end on

on w_pr759_resumen_envasado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.cb_proc)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_titulo
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

if ld_fecha1 = ld_fecha2 then
	ls_titulo = 'RATIOS DE ENVASADO. DÍA ' + string(ld_fecha1, 'dd/mm/yyyy')
else
	ls_titulo = 'RATIOS DE ENVASADO. PERIODO ' + string(ld_fecha1, 'dd/mm/yyyy') + ' - ' + string(ld_fecha2, 'dd/mm/yyyy')
end if

dw_report.settransobject( sqlca )
dw_report.retrieve(ld_fecha1, ld_fecha2 )

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

type dw_report from w_report_smpl`dw_report within w_pr759_resumen_envasado
integer x = 0
integer y = 152
integer width = 3314
integer height = 836
integer taborder = 10
string dataobject = "d_rpt_resumen_envasado_crt"
string is_dwform = ""
end type

type st_1 from statictext within w_pr759_resumen_envasado
integer y = 16
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

type uo_rango from ou_rango_fechas within w_pr759_resumen_envasado
integer x = 485
integer y = 4
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cb_proc from commandbutton within w_pr759_resumen_envasado
integer x = 1765
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

