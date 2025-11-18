$PBExportHeader$w_cm716_prec_pact_venc.srw
forward
global type w_cm716_prec_pact_venc from w_report_smpl
end type
type cb_1 from commandbutton within w_cm716_prec_pact_venc
end type
type sle_dias from singlelineedit within w_cm716_prec_pact_venc
end type
type st_1 from statictext within w_cm716_prec_pact_venc
end type
end forward

global type w_cm716_prec_pact_venc from w_report_smpl
integer width = 2455
integer height = 1644
string title = "Vencimiento de Precios Pactados(AL716)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
sle_dias sle_dias
st_1 st_1
end type
global w_cm716_prec_pact_venc w_cm716_prec_pact_venc

type variables
String	is_dw = 'D'
end variables

on w_cm716_prec_pact_venc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_dias=create sle_dias
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_dias
this.Control[iCurrent+3]=this.st_1
end on

on w_cm716_prec_pact_venc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_dias)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;Long ll_dias
Date ld_fecha

ld_fecha = Date(f_fecha_actual())

ll_dias = Long(sle_dias.text)

if ll_dias < 0 then ll_dias = 9999999
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

idw_1.Retrieve(ll_dias)

idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_empresa.text 	= gs_empresa
idw_1.object.t_user.text 		= gs_user
idw_1.object.t_detalle.text 	= 'Fec Vencimiento:' + string(RelativeDate(ld_fecha, ll_dias), 'dd/mm/yyyy') 

end event

event ue_open_pre;call super::ue_open_pre;idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Object.DataWindow.Print.Paper.Size = 9


end event

type dw_report from w_report_smpl`dw_report within w_cm716_prec_pact_venc
integer x = 0
integer y = 192
integer width = 2016
integer height = 1196
integer taborder = 60
string dataobject = "d_rpt_precio_pactado_venc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_labor" 
		lstr_1.DataObject = 'd_labor_ff'
		lstr_1.Width = 2500
		lstr_1.Height= 650
		lstr_1.Arg[1] = GetItemString(row,'cod_labor')
		lstr_1.Title = 'Labor'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type cb_1 from commandbutton within w_cm716_prec_pact_venc
integer x = 681
integer y = 68
integer width = 402
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()

end event

type sle_dias from singlelineedit within w_cm716_prec_pact_venc
integer x = 325
integer y = 68
integer width = 315
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cm716_prec_pact_venc
integer x = 146
integer y = 68
integer width = 169
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dias:"
boolean focusrectangle = false
end type

