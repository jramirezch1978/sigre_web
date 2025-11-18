$PBExportHeader$w_fl505_emp_capt_rango.srw
forward
global type w_fl505_emp_capt_rango from w_report_smpl
end type
type st_1 from statictext within w_fl505_emp_capt_rango
end type
type ddlb_1 from dropdownlistbox within w_fl505_emp_capt_rango
end type
end forward

global type w_fl505_emp_capt_rango from w_report_smpl
integer width = 2117
integer height = 1324
string title = "Reportes"
string menuname = "m_rep_grf"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_copiar ( )
st_1 st_1
ddlb_1 ddlb_1
end type
global w_fl505_emp_capt_rango w_fl505_emp_capt_rango

event ue_copiar();dw_report.Clipboard("gr_1")

end event

on w_fl505_emp_capt_rango.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.st_1=create st_1
this.ddlb_1=create ddlb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_1
end on

on w_fl505_emp_capt_rango.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.ddlb_1)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()

// ii_help = 101           // help topic

dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

event ue_retrieve;call super::ue_retrieve;string ls_inicio, ls_fin
integer li_inicio, li_fin, li_periodo

li_periodo = integer(trim(ddlb_1.text))

li_inicio = year(today()) - li_periodo
li_fin = year(today())

ls_inicio = trim(string(li_inicio))
ls_fin = trim(string(li_fin))
idw_1.Retrieve(li_inicio, li_fin)

dw_report.object.gr_1.title = Upper('Captura por empresas, para el periodo comprendido entre '+ls_inicio+' y '+ls_fin)
dw_report.Object.p_1.filename = gs_logo
end event

event open;call super::open;ddlb_1.text = '05'
end event

type dw_report from w_report_smpl`dw_report within w_fl505_emp_capt_rango
integer x = 0
integer y = 200
integer width = 2016
integer height = 908
string dataobject = "d_empresa_periodo_grf"
end type

type st_1 from statictext within w_fl505_emp_capt_rango
integer x = 55
integer y = 52
integer width = 1408
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione cuantos años desea reflejar en la gráfica:"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_fl505_emp_capt_rango
integer x = 1477
integer y = 52
integer width = 210
integer height = 1056
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"01","02","03","04","05","06","07","08","09","10"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;parent.event ue_retrieve()
end event

