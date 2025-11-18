$PBExportHeader$w_ope748_rpt_consumo_x_ot_adm.srw
forward
global type w_ope748_rpt_consumo_x_ot_adm from w_report_smpl
end type
type cb_1 from commandbutton within w_ope748_rpt_consumo_x_ot_adm
end type
type cbx_consumos from checkbox within w_ope748_rpt_consumo_x_ot_adm
end type
type cbx_servicios from checkbox within w_ope748_rpt_consumo_x_ot_adm
end type
type rb_res from radiobutton within w_ope748_rpt_consumo_x_ot_adm
end type
type rb_cnt_prs from radiobutton within w_ope748_rpt_consumo_x_ot_adm
end type
type rb_det from radiobutton within w_ope748_rpt_consumo_x_ot_adm
end type
type st_2 from statictext within w_ope748_rpt_consumo_x_ot_adm
end type
type sle_ano from singlelineedit within w_ope748_rpt_consumo_x_ot_adm
end type
type st_1 from statictext within w_ope748_rpt_consumo_x_ot_adm
end type
type em_reposicion from editmask within w_ope748_rpt_consumo_x_ot_adm
end type
type gb_1 from groupbox within w_ope748_rpt_consumo_x_ot_adm
end type
type gb_2 from groupbox within w_ope748_rpt_consumo_x_ot_adm
end type
end forward

global type w_ope748_rpt_consumo_x_ot_adm from w_report_smpl
integer width = 3474
integer height = 2396
string title = "(OPE748)  Consumos de materiales o servicios por ot_amm"
string menuname = "m_rpt_smpl"
cb_1 cb_1
cbx_consumos cbx_consumos
cbx_servicios cbx_servicios
rb_res rb_res
rb_cnt_prs rb_cnt_prs
rb_det rb_det
st_2 st_2
sle_ano sle_ano
st_1 st_1
em_reposicion em_reposicion
gb_1 gb_1
gb_2 gb_2
end type
global w_ope748_rpt_consumo_x_ot_adm w_ope748_rpt_consumo_x_ot_adm

on w_ope748_rpt_consumo_x_ot_adm.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.cbx_consumos=create cbx_consumos
this.cbx_servicios=create cbx_servicios
this.rb_res=create rb_res
this.rb_cnt_prs=create rb_cnt_prs
this.rb_det=create rb_det
this.st_2=create st_2
this.sle_ano=create sle_ano
this.st_1=create st_1
this.em_reposicion=create em_reposicion
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_consumos
this.Control[iCurrent+3]=this.cbx_servicios
this.Control[iCurrent+4]=this.rb_res
this.Control[iCurrent+5]=this.rb_cnt_prs
this.Control[iCurrent+6]=this.rb_det
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_ano
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.em_reposicion
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_ope748_rpt_consumo_x_ot_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_consumos)
destroy(this.cbx_servicios)
destroy(this.rb_res)
destroy(this.rb_cnt_prs)
destroy(this.rb_det)
destroy(this.st_2)
destroy(this.sle_ano)
destroy(this.st_1)
destroy(this.em_reposicion)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_reposicion, ls_texto, ls_oper_cons_int

SELECT NVL(l.oper_cons_interno,' ') 
	INTO :ls_oper_cons_int 
FROM logparam l 
WHERE l.reckey='1' ;

IF ls_oper_cons_int = ' ' or IsNull(ls_oper_cons_int) THEN
	MESSAGEBOX('Aviso', 'Defina consumo interno en LogParam')
	RETURN
END IF

ls_ano = sle_ano.text
ls_reposicion = em_reposicion.text
IF ls_reposicion = 'N' THEN
	ls_reposicion = '0'
ELSEIF ls_reposicion='S' THEN
	ls_reposicion = '1'
ELSEIF ls_reposicion='T' THEN
	ls_reposicion = '%'	
END IF 

IF cbx_consumos.checked = TRUE THEN
	IF em_reposicion.text ='N' THEN
		ls_texto = 'NO CONSIDERA ARTICULOS DE REP. STOCK - '
	ELSEIF em_reposicion.text ='S' THEN
		ls_texto = 'CONSIDERA SOLO ARTICULOS DE REP. STOCK - '	
	ELSE
		ls_texto = ''
	END IF
else
	ls_texto = ''
end if

IF cbx_consumos.checked = TRUE THEN
	IF rb_res.checked = TRUE THEN
		idw_1.DataObject='d_rpt_consumo_res_x_ot_adm_tbl'
		ls_texto = ls_texto + 'RESUMEN - '
	ELSEIF rb_cnt_prs.checked = TRUE THEN
		idw_1.DataObject='d_rpt_consumo_cnta_prsp_x_ot_adm_tbl'
		ls_texto = ls_texto + 'POR CUENTA PRESUPUESTAL - '
	ELSEIF rb_det.checked = TRUE THEN
		idw_1.DataObject='d_rpt_consumo_det_x_ot_adm_tbl'
		ls_texto = ls_texto + 'DETALLADO - '		
	END IF
ELSE
	IF rb_res.checked = TRUE THEN
		idw_1.DataObject='d_rpt_servicios_res_x_ot_adm_tbl'
		ls_texto = ls_texto + 'RESUMEN - '
	ELSEIF rb_cnt_prs.checked = TRUE THEN
		idw_1.DataObject='d_rpt_servicios_cnta_prsp_x_ot_adm_tbl'
		ls_texto = ls_texto + 'POR CUENTA PRESUPUESTAL - '
	ELSEIF rb_res.checked = TRUE THEN
		idw_1.DataObject='d_prog_labor_cc_rsp_tbl'
		ls_texto = ls_texto + 'DETALLADO - '		
	END IF
END IF

idw_1.SetTransObject(sqlca)
IF cbx_consumos.checked = TRUE then
	idw_1.retrieve( ls_ano, ls_reposicion)
else
	idw_1.retrieve( ls_ano)
end if
	
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto + 'Año :' + ls_ano
idw_1.Object.p_logo.filename = gs_logo

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100

Event ue_preview()

end event

type dw_report from w_report_smpl`dw_report within w_ope748_rpt_consumo_x_ot_adm
integer x = 32
integer y = 356
integer width = 2286
integer height = 1084
integer taborder = 0
string dataobject = "d_rpt_consumo_det_x_ot_adm_tbl"
end type

type cb_1 from commandbutton within w_ope748_rpt_consumo_x_ot_adm
integer x = 2651
integer y = 100
integer width = 311
integer height = 152
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
boolean default = true
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type cbx_consumos from checkbox within w_ope748_rpt_consumo_x_ot_adm
integer x = 87
integer y = 116
integer width = 571
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Consumo almacen"
boolean checked = true
end type

event clicked;IF cbx_servicios.checked = true then
	cbx_servicios.checked = false
	cbx_consumos.checked = true
ELSE
	cbx_servicios.checked = true
	cbx_consumos.checked = false
END IF
end event

type cbx_servicios from checkbox within w_ope748_rpt_consumo_x_ot_adm
integer x = 87
integer y = 196
integer width = 562
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Servicios"
end type

event clicked;IF cbx_consumos.checked = true then
	cbx_consumos.checked = false
	cbx_servicios.checked = true
	em_reposicion.enabled = true
ELSE
	cbx_consumos.checked = true
	cbx_servicios.checked = false
	em_reposicion.enabled = false
END IF
end event

type rb_res from radiobutton within w_ope748_rpt_consumo_x_ot_adm
integer x = 736
integer y = 68
integer width = 466
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

type rb_cnt_prs from radiobutton within w_ope748_rpt_consumo_x_ot_adm
integer x = 736
integer y = 148
integer width = 466
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por cnta.presup."
end type

type rb_det from radiobutton within w_ope748_rpt_consumo_x_ot_adm
integer x = 736
integer y = 228
integer width = 466
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Detalle"
end type

type st_2 from statictext within w_ope748_rpt_consumo_x_ot_adm
integer x = 1335
integer y = 104
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "AÑO :"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_ope748_rpt_consumo_x_ot_adm
integer x = 1499
integer y = 96
integer width = 215
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ope748_rpt_consumo_x_ot_adm
integer x = 1349
integer y = 224
integer width = 1115
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
string text = "ART. REPOSICION STOCK [N=No, S=Si, T=Todos] :"
boolean focusrectangle = false
end type

type em_reposicion from editmask within w_ope748_rpt_consumo_x_ot_adm
integer x = 2469
integer y = 208
integer width = 73
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "N"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!"
string displaydata = "No~tN/Si~tD/Todos~tT/"
end type

type gb_1 from groupbox within w_ope748_rpt_consumo_x_ot_adm
integer x = 37
integer y = 28
integer width = 1234
integer height = 308
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "OPCIONES"
end type

type gb_2 from groupbox within w_ope748_rpt_consumo_x_ot_adm
integer x = 1312
integer y = 32
integer width = 1285
integer height = 304
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "PARAMETRO"
end type

