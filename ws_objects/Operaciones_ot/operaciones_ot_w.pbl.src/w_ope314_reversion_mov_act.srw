$PBExportHeader$w_ope314_reversion_mov_act.srw
forward
global type w_ope314_reversion_mov_act from w_ope746_presp_art_activos_pend
end type
type cb_1 from commandbutton within w_ope314_reversion_mov_act
end type
type cb_4 from commandbutton within w_ope314_reversion_mov_act
end type
type sle_1 from singlelineedit within w_ope314_reversion_mov_act
end type
type st_4 from statictext within w_ope314_reversion_mov_act
end type
type dw_report_det from datawindow within w_ope314_reversion_mov_act
end type
type rb_local from radiobutton within w_ope314_reversion_mov_act
end type
type rb_terminal from radiobutton within w_ope314_reversion_mov_act
end type
type gb_1 from groupbox within w_ope314_reversion_mov_act
end type
end forward

global type w_ope314_reversion_mov_act from w_ope746_presp_art_activos_pend
event ue_enviar_email ( )
event ue_reversion ( )
cb_1 cb_1
cb_4 cb_4
sle_1 sle_1
st_4 st_4
dw_report_det dw_report_det
rb_local rb_local
rb_terminal rb_terminal
gb_1 gb_1
end type
global w_ope314_reversion_mov_act w_ope314_reversion_mov_act

event ue_reversion();String ls_flag_ctrl,ls_cencos,ls_cnta_prsp,ls_msj_err
Long   ll_row,ll_ano,ll_mes
Decimal {2} ldc_monto_disp

ll_row = dw_report.getrow()

if ll_row > 0 then 
	ls_flag_ctrl	= dw_report.object.flag_control [ll_row]
	ls_cencos		= dw_report.object.cencos       [ll_row]
	ls_cnta_prsp	= dw_report.object.cnta_prsp    [ll_row]
	ll_ano			= dw_report.object.ano          [ll_row]
	ll_mes			= dw_report.object.mes          [ll_row]
	ldc_monto_disp	= dw_report.object.monto_real   [ll_row]
	//usuario actual


	SetPointer(hourglass!)


	DECLARE PB_usp_ope_reversion_presup PROCEDURE FOR usp_ope_reversion_presup
	(:ls_flag_ctrl,:ls_cencos,:ls_cnta_prsp,:ll_ano,:ll_mes,:ldc_monto_disp,:gs_user);
	EXECUTE PB_usp_ope_reversion_presup ;

	
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		Rollback ;
	   MessageBox('SQL error', ls_msj_err)
		Return
	END IF

	commit ;

	Close PB_usp_ope_reversion_presup ;

	SetPointer(Arrow!)
   
	

	
end if 	
end event

on w_ope314_reversion_mov_act.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_4=create cb_4
this.sle_1=create sle_1
this.st_4=create st_4
this.dw_report_det=create dw_report_det
this.rb_local=create rb_local
this.rb_terminal=create rb_terminal
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_4
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.dw_report_det
this.Control[iCurrent+6]=this.rb_local
this.Control[iCurrent+7]=this.rb_terminal
this.Control[iCurrent+8]=this.gb_1
end on

on w_ope314_reversion_mov_act.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.sle_1)
destroy(this.st_4)
destroy(this.dw_report_det)
destroy(this.rb_local)
destroy(this.rb_terminal)
destroy(this.gb_1)
end on

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_report from w_ope746_presp_art_activos_pend`dw_report within w_ope314_reversion_mov_act
integer y = 596
integer height = 1928
end type

type cb_1 from commandbutton within w_ope314_reversion_mov_act
integer x = 41
integer y = 36
integer width = 937
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reversion Movimientos Aprobados"
end type

event clicked;Parent.TRIggerevent( 'ue_reversion')
end event

type cb_4 from commandbutton within w_ope314_reversion_mov_act
integer x = 96
integer y = 272
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Envio Email"
end type

event clicked;String ls_file,ls_print,ls_flag_control,ls_flag_trim,ls_cencos,ls_cnta_prsp,ls_monto_disp
Long   ll_ano,ll_mes    



SetPointer(hourglass!)

if dw_report.getrow() = 0 then return

ls_flag_control = dw_report.object.flag_control      [dw_report.getrow()]
ls_flag_trim	 = dw_report.object.flag_trim	        [dw_report.getrow()]
ls_cencos		 = dw_report.object.cencos		        [dw_report.getrow()]
ls_cnta_prsp	 = dw_report.object.cnta_prsp 	     [dw_report.getrow()]
ll_ano			 = dw_report.object.ano 			     [dw_report.getrow()]
ll_mes			 = dw_report.object.mes 			     [dw_report.getrow()]
ls_monto_disp	 = String(dw_report.object.monto_real [dw_report.getrow()])


choose case ls_flag_control
		 case '0' //partida no existe
				dw_report_det.DataObject = 'd_rpt_art_requeridos_sin_ctrl_tbl' 
				dw_report_det.SettransObject(sqlca)
				dw_report_det.retrieve(ls_cencos,ls_cnta_prsp,Trim(String(ll_ano)),Trim(String(ll_mes)),ls_flag_control )
	 	 case '1' //control anual
				dw_report_det.DataObject = 'd_rpt_art_requeridos_x_ctrl_anual_tbl'
				dw_report_det.SettransObject(sqlca)
				dw_report_det.retrieve(ls_cencos,ls_cnta_prsp,Trim(String(ll_ano)),ls_flag_control,ls_monto_disp )				
		 case '2' //acumulado ala fecha
				dw_report_det.DataObject = 'd_rpt_art_requeridos_x_ctrl_afecha_tbl'
				dw_report_det.SettransObject(sqlca)
				dw_report_det.retrieve(ls_cencos,ls_cnta_prsp,Trim(String(ll_ano)),ls_flag_control,ls_monto_disp )								
		 case '3' //control mensual
				dw_report_det.DataObject = 'd_rpt_art_requeridos_x_ctrl_mensual_tbl'
				dw_report_det.SettransObject(sqlca)
				dw_report_det.retrieve(ls_cencos,ls_cnta_prsp,Trim(String(ll_ano)),Trim(String(ll_mes)),ls_flag_control,ls_monto_disp )												
		 case '4' //trimestre fijo	
				dw_report_det.DataObject = 'd_rpt_art_requerido_x_ctrl_trim_tbl'
				dw_report_det.SettransObject(sqlca)
				dw_report_det.retrieve(ls_cencos,ls_cnta_prsp,Trim(String(ll_ano)),ls_flag_trim,ls_flag_control,ls_monto_disp )												
end choose



dw_report_det.object.p_logo.filename = gs_logo
dw_report_det.object.t_nombre.text   = gs_empresa
dw_report_det.object.t_user.text     = gs_user




ls_file	= 'c:\informe_tit.pdf'
ls_print = sle_1.text

 if rb_terminal.checked then
	 dw_report_det.Object.DataWindow.Export.PDF.Method = Distill!
	 dw_report_det.Object.DataWindow.Printer           = ls_print
	 dw_report_det.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
	 
 end if
 
 dw_report_det.saveAs(ls_file, PDF!, true) 


Open(w_ope315_envio_email)

SetPointer(Arrow!)




end event

type sle_1 from singlelineedit within w_ope314_reversion_mov_act
integer x = 585
integer y = 288
integer width = 407
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Adobe PDF"
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_ope314_reversion_mov_act
integer x = 581
integer y = 220
integer width = 416
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217739
string text = "Impresora PDF"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_report_det from datawindow within w_ope314_reversion_mov_act
boolean visible = false
integer x = 3406
integer y = 732
integer width = 311
integer height = 380
integer taborder = 70
boolean bringtotop = true
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_local from radiobutton within w_ope314_reversion_mov_act
integer x = 105
integer y = 408
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Local"
end type

type rb_terminal from radiobutton within w_ope314_reversion_mov_act
integer x = 105
integer y = 480
integer width = 293
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Terminal"
boolean checked = true
end type

type gb_1 from groupbox within w_ope314_reversion_mov_act
integer x = 50
integer y = 164
integer width = 1019
integer height = 408
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Envio de Correo"
end type

