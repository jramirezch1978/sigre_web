$PBExportHeader$w_ma501_prog_mntt_prev.srw
forward
global type w_ma501_prog_mntt_prev from w_report_smpl
end type
type cb_1 from commandbutton within w_ma501_prog_mntt_prev
end type
end forward

global type w_ma501_prog_mntt_prev from w_report_smpl
integer width = 3497
integer height = 1484
string title = "Programación de mantenimiento preventivo (MA501)"
string menuname = "m_rpt_smpl"
cb_1 cb_1
end type
global w_ma501_prog_mntt_prev w_ma501_prog_mntt_prev

on w_ma501_prog_mntt_prev.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_ma501_prog_mntt_prev.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;//Help
string ls_mensaje
idw_1.ii_zoom_actual = 100
Trigger Event ue_preview()

of_position(0,0)
ROLLBACK;

DECLARE pb_usp_ctrl_man_pre_maq PROCEDURE FOR 
	USP_CTRL_MAN_PRE_MAQ ( 'nada' ) ;
EXECUTE pb_usp_ctrl_man_pre_maq ;

IF sqlca.sqlcode < 0 THEN
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Falló USP_CTRL_MAN_PRE_MAQ', ls_mensaje)
	return
END IF

dw_report.retrieve(gs_empresa, gs_user)
dw_report.Object.p_logo.filename = gs_logo

cb_1.Hide()
dw_report.Show()

ii_help = 501
end event

type dw_report from w_report_smpl`dw_report within w_ma501_prog_mntt_prev
integer width = 3374
integer height = 1196
string dataobject = "d_cons_ctrl_man_pre_maq"
end type

type cb_1 from commandbutton within w_ma501_prog_mntt_prev
integer x = 466
integer y = 232
integer width = 2519
integer height = 852
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
string text = "<<< Se está realizando la recuperación de información >>>"
end type

