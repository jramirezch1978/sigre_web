$PBExportHeader$w_al737_saldos_libres.srw
forward
global type w_al737_saldos_libres from w_report_smpl
end type
type cb_3 from commandbutton within w_al737_saldos_libres
end type
type rb_ot from radiobutton within w_al737_saldos_libres
end type
type rb_art from radiobutton within w_al737_saldos_libres
end type
type rb_cen from radiobutton within w_al737_saldos_libres
end type
type rb_ot_adm from radiobutton within w_al737_saldos_libres
end type
type gb_2 from groupbox within w_al737_saldos_libres
end type
end forward

global type w_al737_saldos_libres from w_report_smpl
integer width = 3529
integer height = 2300
boolean titlebar = false
string title = ""
string menuname = "m_impresion"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean border = false
windowstate windowstate = maximized!
cb_3 cb_3
rb_ot rb_ot
rb_art rb_art
rb_cen rb_cen
rb_ot_adm rb_ot_adm
gb_2 gb_2
end type
global w_al737_saldos_libres w_al737_saldos_libres

type variables
Integer ii_index
end variables

on w_al737_saldos_libres.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.rb_ot=create rb_ot
this.rb_art=create rb_art
this.rb_cen=create rb_cen
this.rb_ot_adm=create rb_ot_adm
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.rb_ot
this.Control[iCurrent+3]=this.rb_art
this.Control[iCurrent+4]=this.rb_cen
this.Control[iCurrent+5]=this.rb_ot_adm
this.Control[iCurrent+6]=this.gb_2
end on

on w_al737_saldos_libres.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.rb_ot)
destroy(this.rb_art)
destroy(this.rb_cen)
destroy(this.rb_ot_adm)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_doc_ot, ls_texto


SELECT doc_ot into :ls_doc_ot FROM logparam where reckey='1' ;

// Por orden de trabajo
IF rb_ot.checked = TRUE THEN
	dw_report.dataobject='d_rpt_saldo_libre_ot_tbl'
	dw_report.SetTransObject(SQLCA)		
	dw_report.retrieve(ls_doc_ot)
	ls_texto = 'Ordenado por orden de trabajo'

// Por articulo
ELSEIF rb_art.checked = TRUE THEN
	dw_report.dataobject='d_rpt_saldo_libre_art_tbl'
	dw_report.SetTransObject(SQLCA)	
	dw_report.retrieve()
	ls_texto = 'Ordenado por articulo'

// Por OT_ADM
ELSEIF rb_ot_adm.checked = TRUE THEN
	dw_report.dataobject='d_rpt_saldo_libre_ot_adm_tbl'
	dw_report.SetTransObject(SQLCA)		
	dw_report.retrieve(ls_doc_ot)
	ls_texto = 'Ordenado por ot_adm'

// Por centro de costo solicitante
ELSEIF rb_cen.checked = TRUE THEN
	dw_report.dataobject='d_rpt_saldo_libre_cencos_tbl'
	dw_report.SetTransObject(SQLCA)		
	dw_report.retrieve(ls_doc_ot)
	ls_texto = 'Ordenado por centro de costo solicitante'	
	
END IF 

dw_report.object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'AL737'
		
dw_report.object.t_texto.text = ls_texto

end event

type dw_report from w_report_smpl`dw_report within w_al737_saldos_libres
integer x = 37
integer y = 352
integer width = 3342
integer height = 1288
integer taborder = 0
string dataobject = "d_rpt_saldo_libre_art_tbl"
end type

type cb_3 from commandbutton within w_al737_saldos_libres
integer x = 1490
integer y = 128
integer width = 334
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type rb_ot from radiobutton within w_al737_saldos_libres
integer x = 722
integer y = 84
integer width = 626
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por orden de trabajo"
end type

type rb_art from radiobutton within w_al737_saldos_libres
integer x = 101
integer y = 88
integer width = 398
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por artículo"
boolean checked = true
end type

type rb_cen from radiobutton within w_al737_saldos_libres
integer x = 722
integer y = 172
integer width = 626
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por centro de costo"
end type

type rb_ot_adm from radiobutton within w_al737_saldos_libres
integer x = 101
integer y = 184
integer width = 398
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por OT Adm"
end type

type gb_2 from groupbox within w_al737_saldos_libres
integer x = 50
integer y = 20
integer width = 1339
integer height = 268
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Ordenado por "
end type

