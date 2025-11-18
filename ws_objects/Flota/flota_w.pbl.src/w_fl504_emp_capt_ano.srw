$PBExportHeader$w_fl504_emp_capt_ano.srw
forward
global type w_fl504_emp_capt_ano from w_report_smpl
end type
type ddlb_1 from u_ddlb within w_fl504_emp_capt_ano
end type
type st_1 from statictext within w_fl504_emp_capt_ano
end type
end forward

global type w_fl504_emp_capt_ano from w_report_smpl
integer width = 1765
integer height = 1124
string title = "Reportes"
string menuname = "m_rep_grf"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_copiar ( )
ddlb_1 ddlb_1
st_1 st_1
end type
global w_fl504_emp_capt_ano w_fl504_emp_capt_ano

event ue_copiar();dw_report.Clipboard("gr_1")

end event

on w_fl504_emp_capt_ano.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.ddlb_1=create ddlb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.st_1
end on

on w_fl504_emp_capt_ano.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()

// ii_help = 101           // help topic

dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

event ue_retrieve;call super::ue_retrieve;integer li_ano
string ls_ano

ls_ano = trim(ddlb_1.text)

li_ano = integer(ls_ano)

idw_1.Retrieve(li_ano)
dw_report.object.gr_1.title = UPPER('CAPTURA POR EMPRESAS PARA EL AÑO '+ls_ano)

dw_report.Object.p_1.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_fl504_emp_capt_ano
integer y = 164
integer width = 1714
string dataobject = "d_empresa_ano_grf"
end type

type ddlb_1 from u_ddlb within w_fl504_emp_capt_ano
integer x = 1358
integer y = 48
integer width = 352
integer height = 512
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_captura_empresa_ano_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1



end event

event ue_populate;call super::ue_populate;this.selectitem(this.totalitems())
end event

event selectionchanged;call super::selectionchanged;parent.event ue_retrieve()
end event

type st_1 from statictext within w_fl504_emp_capt_ano
integer x = 64
integer y = 52
integer width = 1275
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione el año para el cual desea visualizar la gráfica:"
alignment alignment = center!
boolean focusrectangle = false
end type

