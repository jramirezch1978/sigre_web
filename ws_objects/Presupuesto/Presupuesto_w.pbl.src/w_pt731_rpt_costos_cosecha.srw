$PBExportHeader$w_pt731_rpt_costos_cosecha.srw
forward
global type w_pt731_rpt_costos_cosecha from w_report_smpl
end type
type cb_1 from commandbutton within w_pt731_rpt_costos_cosecha
end type
type rb_1 from radiobutton within w_pt731_rpt_costos_cosecha
end type
type rb_2 from radiobutton within w_pt731_rpt_costos_cosecha
end type
type rb_3 from radiobutton within w_pt731_rpt_costos_cosecha
end type
type em_ano from editmask within w_pt731_rpt_costos_cosecha
end type
type em_mes from editmask within w_pt731_rpt_costos_cosecha
end type
type st_1 from statictext within w_pt731_rpt_costos_cosecha
end type
type st_2 from statictext within w_pt731_rpt_costos_cosecha
end type
type gb_1 from groupbox within w_pt731_rpt_costos_cosecha
end type
type gb_2 from groupbox within w_pt731_rpt_costos_cosecha
end type
end forward

global type w_pt731_rpt_costos_cosecha from w_report_smpl
integer width = 3410
integer height = 1532
string title = "(PT731) Costos de Campos en Cosecha"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
em_ano em_ano
em_mes em_mes
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_pt731_rpt_costos_cosecha w_pt731_rpt_costos_cosecha

on w_pt731_rpt_costos_cosecha.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.em_ano
this.Control[iCurrent+6]=this.em_mes
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_pt731_rpt_costos_cosecha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes
string  ls_mensaje

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

DECLARE pb_usp_ptto_rpt_costos_cosecha PROCEDURE FOR USP_PTTO_RPT_COSTOS_COSECHA
        ( :li_ano, :li_mes ) ;
EXECUTE pb_usp_ptto_rpt_costos_cosecha ;

if rb_1.checked = true then
	idw_1.DataObject = 'd_rpt_costos_cosecha_adm_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()
elseif rb_2.checked = true then
	idw_1.DataObject = 'd_rpt_costos_cosecha_zon_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()
elseif rb_3.checked = true then
	idw_1.DataObject = 'd_rpt_costos_cosecha_cen_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()
end if

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
end if

end event

type dw_report from w_report_smpl`dw_report within w_pt731_rpt_costos_cosecha
integer x = 23
integer y = 296
integer width = 3328
integer height = 1040
integer taborder = 50
string dataobject = "d_cntbl_rpt_saldos_cuentas_tbl"
end type

type cb_1 from commandbutton within w_pt731_rpt_costos_cosecha
integer x = 2949
integer y = 112
integer width = 297
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_preview()
Parent.Event ue_retrieve()
Parent.Event ue_preview()

end event

type rb_1 from radiobutton within w_pt731_rpt_costos_cosecha
integer x = 430
integer y = 128
integer width = 480
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Administraciones"
end type

type rb_2 from radiobutton within w_pt731_rpt_costos_cosecha
integer x = 937
integer y = 128
integer width = 247
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Zonas"
end type

type rb_3 from radiobutton within w_pt731_rpt_costos_cosecha
integer x = 1221
integer y = 128
integer width = 507
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Centros de Costos"
end type

type em_ano from editmask within w_pt731_rpt_costos_cosecha
integer x = 2098
integer y = 124
integer width = 279
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_pt731_rpt_costos_cosecha
integer x = 2555
integer y = 124
integer width = 224
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xx"
end type

type st_1 from statictext within w_pt731_rpt_costos_cosecha
integer x = 1966
integer y = 140
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt731_rpt_costos_cosecha
integer x = 2423
integer y = 140
integer width = 119
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Mes"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pt731_rpt_costos_cosecha
integer x = 357
integer y = 56
integer width = 1440
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione Opción "
end type

type gb_2 from groupbox within w_pt731_rpt_costos_cosecha
integer x = 1883
integer y = 56
integer width = 983
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

