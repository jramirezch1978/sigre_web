$PBExportHeader$w_fi743_compras_proveedores.srw
forward
global type w_fi743_compras_proveedores from w_report_smpl
end type
type cb_1 from commandbutton within w_fi743_compras_proveedores
end type
type em_fec_desde from editmask within w_fi743_compras_proveedores
end type
type em_fec_hasta from editmask within w_fi743_compras_proveedores
end type
type st_1 from statictext within w_fi743_compras_proveedores
end type
type st_2 from statictext within w_fi743_compras_proveedores
end type
type gb_1 from groupbox within w_fi743_compras_proveedores
end type
type gb_2 from groupbox within w_fi743_compras_proveedores
end type
type dw_origen from datawindow within w_fi743_compras_proveedores
end type
end forward

global type w_fi743_compras_proveedores from w_report_smpl
integer width = 3035
integer height = 1108
string title = "(FI743) Compra a Proveedores"
string menuname = "m_reporte"
long backcolor = 67108864
cb_1 cb_1
em_fec_desde em_fec_desde
em_fec_hasta em_fec_hasta
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
dw_origen dw_origen
end type
global w_fi743_compras_proveedores w_fi743_compras_proveedores

on w_fi743_compras_proveedores.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.em_fec_desde=create em_fec_desde
this.em_fec_hasta=create em_fec_hasta
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_origen=create dw_origen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_fec_desde
this.Control[iCurrent+3]=this.em_fec_hasta
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.dw_origen
end on

on w_fi743_compras_proveedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_fec_desde)
destroy(this.em_fec_hasta)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_origen)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_desc_origen, ls_desc_origen_rpt, ls_sol, ls_dol
date ld_fec_desde, ld_fec_hasta

if dw_origen.GetItemString(1,'flag') = '1'  then
	ls_origen = '%'
	ls_desc_origen  = ' Todos los Origenes'
	ls_desc_origen_rpt = ls_desc_origen
else
	ls_origen =  dw_origen.GetItemString(dw_origen.getrow(),'cod_origen')
	select r.nombre into :ls_desc_origen from origen r where r.cod_origen = : ls_origen ; 	
	ls_desc_origen_rpt = ls_origen+' - '+ls_desc_origen
end if

f_monedas(ls_sol, ls_dol)

ld_fec_desde = date(em_fec_desde.text)
ld_fec_hasta = date(em_fec_hasta.text)

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Aviso','Verificar Rangos de Fechas')
	return
end if

dw_report.retrieve(ld_fec_desde, ld_fec_hasta, ls_origen, ls_sol, ls_dol, gs_empresa, gs_user)

dw_report.object.p_logo.filename = gs_logo

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

dw_origen.SetTransObject(sqlca)
dw_origen.retrieve()
dw_origen.insertrow(0)

//Event ue_preview()

end event

type dw_report from w_report_smpl`dw_report within w_fi743_compras_proveedores
integer x = 37
integer y = 256
integer width = 2894
integer height = 580
integer taborder = 40
string dataobject = "d_rpt_compra_proveedores"
end type

type cb_1 from commandbutton within w_fi743_compras_proveedores
integer x = 2633
integer y = 128
integer width = 297
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_fec_desde from editmask within w_fi743_compras_proveedores
integer x = 1751
integer y = 108
integer width = 315
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_fec_hasta from editmask within w_fi743_compras_proveedores
integer x = 2245
integer y = 108
integer width = 315
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_fi743_compras_proveedores
integer x = 1582
integer y = 108
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi743_compras_proveedores
integer x = 2094
integer y = 108
integer width = 142
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_fi743_compras_proveedores
integer x = 1536
integer y = 32
integer width = 1065
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_fi743_compras_proveedores
integer x = 37
integer y = 32
integer width = 1467
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Opciones"
end type

type dw_origen from datawindow within w_fi743_compras_proveedores
integer x = 87
integer y = 100
integer width = 1399
integer height = 84
boolean bringtotop = true
string dataobject = "d_ext_origen"
boolean border = false
boolean livescroll = true
end type

event itemchanged;CHOOSE CASE GetColumnName()
	CASE 'flag'
		IF data = '1' THEN
			SetItem(1,'cod_origen','')
		END IF
END CHOOSE
end event

