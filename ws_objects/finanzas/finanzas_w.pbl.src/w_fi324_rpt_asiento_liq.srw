$PBExportHeader$w_fi324_rpt_asiento_liq.srw
forward
global type w_fi324_rpt_asiento_liq from w_report_smpl
end type
type cb_1 from commandbutton within w_fi324_rpt_asiento_liq
end type
end forward

global type w_fi324_rpt_asiento_liq from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Emite Reporte de Asiento Contable (FI324)"
string menuname = "m_reporte"
long backcolor = 67108864
cb_1 cb_1
end type
global w_fi324_rpt_asiento_liq w_fi324_rpt_asiento_liq

type variables
String  is_origen
Integer ii_ano, ii_mes, ii_libro, ii_asiento

end variables

on w_fi324_rpt_asiento_liq.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_fi324_rpt_asiento_liq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event ue_retrieve;call super::ue_retrieve;
dw_report.retrieve(is_origen, ii_ano, ii_mes, ii_libro, ii_asiento)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user


end event

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_rep

If Not IsValid(Message) or IsNull(Message) then return

if Message.powerobjectparm.classname( ) <> 'str_parametros' then return

lstr_rep = message.powerobjectparm
	
if lstr_rep.string1 <> '' and not IsNull(lstr_rep.string1) then

	is_origen  = lstr_rep.string1
	ii_ano     = Integer(lstr_rep.string2)
	ii_mes	  = Integer(lstr_rep.string3)
	ii_libro   = Integer(lstr_rep.string4)
	ii_asiento = Integer(lstr_rep.string5)
	this.Event ue_retrieve()

end if

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event activate;call super::activate;//String  ls_origen, ls_ano, ls_mes, ls_libro, ls_asiento
//Integer ln_ano, ln_mes, ln_libro, ln_asiento
//
//
//str_parametros lstr_rep
//lstr_rep = message.powerobjectparm
//
//sle_origen.text =  lstr_rep.string1
//sle_ano.text    =  lstr_rep.string2
//sle_mes.text    =  lstr_rep.string3
//sle_libro.text  =  lstr_rep.string4
//sle_asiento.text=  lstr_rep.string5
//
//ls_origen  = String(sle_origen.text)
//ls_ano 	  = String(sle_ano.text)
//ls_mes     = String(sle_mes.text)
//ls_libro   = String(sle_libro.text)
//ls_asiento = String(sle_asiento.text)
//
//ln_ano 	  = Integer(ls_ano)
//ln_mes     = Integer(ls_mes)
//ln_libro   = Integer(ls_libro)
//ln_asiento = Integer(ls_asiento)
//
//DECLARE pb_usp_cntbl_rpt_nro_asiento PROCEDURE FOR USP_CNTBL_RPT_NRO_ASIENTO
//        ( :ls_origen, :ln_ano, :ln_mes, :ln_libro, :ln_asiento ) ;
//Execute pb_usp_cntbl_rpt_nro_asiento ;
//
//dw_report.retrieve()
//
//dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_nombre.text = gs_empresa
//dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_fi324_rpt_asiento_liq
integer x = 0
integer y = 0
integer width = 3291
integer height = 1092
integer taborder = 70
string dataobject = "d_rpt_nro_asiento_tbl"
end type

type cb_1 from commandbutton within w_fi324_rpt_asiento_liq
integer x = 2898
integer y = 128
integer width = 297
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()


end event

