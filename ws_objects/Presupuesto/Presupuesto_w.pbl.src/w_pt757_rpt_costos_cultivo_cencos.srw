$PBExportHeader$w_pt757_rpt_costos_cultivo_cencos.srw
forward
global type w_pt757_rpt_costos_cultivo_cencos from w_report_smpl
end type
type cb_1 from commandbutton within w_pt757_rpt_costos_cultivo_cencos
end type
type em_ano from editmask within w_pt757_rpt_costos_cultivo_cencos
end type
type em_mes from editmask within w_pt757_rpt_costos_cultivo_cencos
end type
type st_1 from statictext within w_pt757_rpt_costos_cultivo_cencos
end type
type st_2 from statictext within w_pt757_rpt_costos_cultivo_cencos
end type
type sle_cencos from singlelineedit within w_pt757_rpt_costos_cultivo_cencos
end type
type sle_descripcion from singlelineedit within w_pt757_rpt_costos_cultivo_cencos
end type
type cb_2 from commandbutton within w_pt757_rpt_costos_cultivo_cencos
end type
type gb_2 from groupbox within w_pt757_rpt_costos_cultivo_cencos
end type
type gb_1 from groupbox within w_pt757_rpt_costos_cultivo_cencos
end type
end forward

global type w_pt757_rpt_costos_cultivo_cencos from w_report_smpl
integer width = 3410
integer height = 1532
string title = "(PT757) Costos de Campos en Cultivo por Centro de Costo"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_1 st_1
st_2 st_2
sle_cencos sle_cencos
sle_descripcion sle_descripcion
cb_2 cb_2
gb_2 gb_2
gb_1 gb_1
end type
global w_pt757_rpt_costos_cultivo_cencos w_pt757_rpt_costos_cultivo_cencos

on w_pt757_rpt_costos_cultivo_cencos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.sle_cencos=create sle_cencos
this.sle_descripcion=create sle_descripcion
this.cb_2=create cb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_cencos
this.Control[iCurrent+7]=this.sle_descripcion
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_pt757_rpt_costos_cultivo_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_cencos)
destroy(this.sle_descripcion)
destroy(this.cb_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes
string  ls_cencos, ls_mensaje

ls_cencos = string(sle_cencos.text)
li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

DECLARE pb_usp_ptto_rpt_costos_cultivo_cc PROCEDURE FOR USP_PTTO_RPT_COSTOS_CULTIVO_CC
        ( :ls_cencos, :li_ano, :li_mes ) ;
EXECUTE pb_usp_ptto_rpt_costos_cultivo_cc ;

idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
end if

end event

type dw_report from w_report_smpl`dw_report within w_pt757_rpt_costos_cultivo_cencos
integer x = 23
integer y = 296
integer width = 3328
integer height = 1040
integer taborder = 50
string dataobject = "d_rpt_costos_cultivo_cencos_tbl"
end type

type cb_1 from commandbutton within w_pt757_rpt_costos_cultivo_cencos
integer x = 3017
integer y = 120
integer width = 297
integer height = 72
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

event clicked;Parent.Event ue_retrieve()

end event

type em_ano from editmask within w_pt757_rpt_costos_cultivo_cencos
integer x = 2277
integer y = 120
integer width = 233
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_pt757_rpt_costos_cultivo_cencos
integer x = 2693
integer y = 120
integer width = 174
integer height = 72
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

type st_1 from statictext within w_pt757_rpt_costos_cultivo_cencos
integer x = 2130
integer y = 128
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt757_rpt_costos_cultivo_cencos
integer x = 2560
integer y = 128
integer width = 119
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type sle_cencos from singlelineedit within w_pt757_rpt_costos_cultivo_cencos
integer x = 370
integer y = 120
integer width = 270
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_descripcion from singlelineedit within w_pt757_rpt_costos_cultivo_cencos
integer x = 777
integer y = 120
integer width = 1157
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_pt757_rpt_costos_cultivo_cencos
integer x = 667
integer y = 120
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;
// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_cencos_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_cencos, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cencos.text      = sl_param.field_ret[1]
	sle_descripcion.text = sl_param.field_ret[2]
END IF

end event

type gb_2 from groupbox within w_pt757_rpt_costos_cultivo_cencos
integer x = 2062
integer y = 44
integer width = 878
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Periodo Contable "
end type

type gb_1 from groupbox within w_pt757_rpt_costos_cultivo_cencos
integer x = 306
integer y = 44
integer width = 1691
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione Centro de Costo "
end type

