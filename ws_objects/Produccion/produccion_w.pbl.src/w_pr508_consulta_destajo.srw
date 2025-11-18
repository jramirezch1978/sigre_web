$PBExportHeader$w_pr508_consulta_destajo.srw
forward
global type w_pr508_consulta_destajo from w_abc_master_smpl
end type
type uo_rango from ou_rango_fechas within w_pr508_consulta_destajo
end type
type st_1 from statictext within w_pr508_consulta_destajo
end type
type cb_proc from commandbutton within w_pr508_consulta_destajo
end type
end forward

global type w_pr508_consulta_destajo from w_abc_master_smpl
integer width = 3803
integer height = 2080
string title = "[PR508] Consultas Parte de Destajo"
string menuname = "m_reporte"
windowstate windowstate = maximized!
uo_rango uo_rango
st_1 st_1
cb_proc cb_proc
end type
global w_pr508_consulta_destajo w_pr508_consulta_destajo

on w_pr508_consulta_destajo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_rango=create uo_rango
this.st_1=create st_1
this.cb_proc=create cb_proc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_proc
end on

on w_pr508_consulta_destajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.st_1)
destroy(this.cb_proc)
end on

event ue_retrieve;call super::ue_retrieve;//override
string ls_nro_parte
date	ld_Fecha1, ld_fecha2

ld_fecha1 = uo_rango.of_get_fecha1( )
ld_Fecha2 = uo_rango.of_get_fecha2()

idw_1.Retrieve(gs_user, ld_fecha1, ld_Fecha2)

end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0 
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr508_consulta_destajo
integer y = 192
integer width = 3474
integer height = 1608
string dataobject = "d_cns_prod_parte_destajo_tbl"
end type

type uo_rango from ou_rango_fechas within w_pr508_consulta_destajo
event destroy ( )
integer x = 535
integer y = 48
integer taborder = 30
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type st_1 from statictext within w_pr508_consulta_destajo
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

type cb_proc from commandbutton within w_pr508_consulta_destajo
integer x = 1870
integer width = 343
integer height = 164
integer taborder = 40
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

