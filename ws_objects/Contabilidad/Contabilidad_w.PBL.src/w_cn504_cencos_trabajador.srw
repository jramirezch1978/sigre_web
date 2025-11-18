$PBExportHeader$w_cn504_cencos_trabajador.srw
forward
global type w_cn504_cencos_trabajador from w_cns
end type
type cb_reporte from commandbutton within w_cn504_cencos_trabajador
end type
type dw_master from u_dw_cns within w_cn504_cencos_trabajador
end type
end forward

global type w_cn504_cencos_trabajador from w_cns
integer width = 3063
integer height = 1588
string title = "[CN504] Centros de Costos de Trabajadores"
string menuname = "m_abc_report_smpl"
cb_reporte cb_reporte
dw_master dw_master
end type
global w_cn504_cencos_trabajador w_cn504_cencos_trabajador

on w_cn504_cencos_trabajador.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_reporte=create cb_reporte
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.dw_master
end on

on w_cn504_cencos_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_master          		// asignar dw corriente

dw_master.setTransObject( SQLCA )
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type cb_reporte from commandbutton within w_cn504_cencos_trabajador
integer width = 594
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;this.enabled = false
dw_master.Retrieve()
this.enabled = true
end event

type dw_master from u_dw_cns within w_cn504_cencos_trabajador
integer y = 88
integer width = 3003
integer height = 1080
integer taborder = 0
string dataobject = "d_cns_cencos_trabajador_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;// Asignacion de variable sin efecto alguno
ii_ck[1] = 1   //Columna de lectura del dw.

end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cnta_cntbl_2"  
		lstr_1.DataObject = 'd_cntbl_cns_balance2_tbl'
		lstr_1.Width = 3050
		lstr_1.Height= 1510
		lstr_1.Title = 'Detalle de las Cuentas de Dos Dígitos'
		lstr_1.Arg[1] = GetItemString(row,'cnta_cntbl_2')
		lstr_1.Arg[2] = ''
		lstr_1.Arg[3] = ''
		lstr_1.Arg[4] = ''
		lstr_1.Arg[5] = ''
		lstr_1.Arg[6] = ''
		lstr_1.NextCol = 'cnta_cntbl'
		of_new_sheet(lstr_1)
END CHOOSE
end event

