$PBExportHeader$w_rh610_rpt_adelanto_utildades.srw
forward
global type w_rh610_rpt_adelanto_utildades from w_report_smpl
end type
type cb_3 from commandbutton within w_rh610_rpt_adelanto_utildades
end type
type em_descripcion from editmask within w_rh610_rpt_adelanto_utildades
end type
type em_origen from editmask within w_rh610_rpt_adelanto_utildades
end type
type em_desc_tipo from editmask within w_rh610_rpt_adelanto_utildades
end type
type em_tipo from editmask within w_rh610_rpt_adelanto_utildades
end type
type cb_2 from commandbutton within w_rh610_rpt_adelanto_utildades
end type
type cb_1 from commandbutton within w_rh610_rpt_adelanto_utildades
end type
type em_periodo from editmask within w_rh610_rpt_adelanto_utildades
end type
type em_fec_desde from editmask within w_rh610_rpt_adelanto_utildades
end type
type em_fec_hasta from editmask within w_rh610_rpt_adelanto_utildades
end type
type st_1 from statictext within w_rh610_rpt_adelanto_utildades
end type
type st_2 from statictext within w_rh610_rpt_adelanto_utildades
end type
type st_3 from statictext within w_rh610_rpt_adelanto_utildades
end type
type gb_2 from groupbox within w_rh610_rpt_adelanto_utildades
end type
type gb_3 from groupbox within w_rh610_rpt_adelanto_utildades
end type
type gb_1 from groupbox within w_rh610_rpt_adelanto_utildades
end type
end forward

global type w_rh610_rpt_adelanto_utildades from w_report_smpl
integer width = 3429
integer height = 1500
string title = "(RH610) Adelantos a Cuenta de Utilidades"
string menuname = "m_impresion"
long backcolor = 12632256
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
em_periodo em_periodo
em_fec_desde em_fec_desde
em_fec_hasta em_fec_hasta
st_1 st_1
st_2 st_2
st_3 st_3
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_rh610_rpt_adelanto_utildades w_rh610_rpt_adelanto_utildades

on w_rh610_rpt_adelanto_utildades.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_periodo=create em_periodo
this.em_fec_desde=create em_fec_desde
this.em_fec_hasta=create em_fec_hasta
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.em_periodo
this.Control[iCurrent+9]=this.em_fec_desde
this.Control[iCurrent+10]=this.em_fec_hasta
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
this.Control[iCurrent+16]=this.gb_1
end on

on w_rh610_rpt_adelanto_utildades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_periodo)
destroy(this.em_fec_desde)
destroy(this.em_fec_hasta)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;integer li_periodo
string  ls_origen, ls_tiptra
date    ld_fec_desde, ld_fec_hasta

li_periodo   = integer(em_periodo.text)
ls_origen    = string(em_origen.text)
ls_tiptra    = string(em_tipo.text)
ld_fec_desde = date(em_fec_desde.text)
ld_fec_hasta = date(em_fec_hasta.text)

if isnull(li_periodo) or li_periodo = 0 then
	MessageBox('Aviso','Debe ingresar periodo')
	return
end if

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Aviso','Verifique el rango de fecha')
	return
end if

if isnull(ls_origen) or trim(ls_origen) = '' then ls_origen = '%'
if isnull(ls_tiptra) or trim(ls_tiptra) = '' then ls_tiptra = '%'

DECLARE pb_usp_rh_utl_rpt_adelantos PROCEDURE FOR USP_RH_UTL_RPT_ADELANTOS
        ( :li_periodo, :ld_fec_desde, :ld_fec_hasta, :ls_origen, :ls_tiptra ) ;
EXECUTE pb_usp_rh_utl_rpt_adelantos ;

IF ld_fec_desde = ld_fec_hasta THEN
	idw_1.DataObject='d_rpt_utl_adelanto_tbl'
ELSE
	idw_1.DataObject='d_rpt_utl_adelanto_det_tbl'
END IF

ib_preview = false
triggerevent('ue_preview')
idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rh610_rpt_adelanto_utildades
integer x = 0
integer y = 444
integer width = 3369
integer height = 768
integer taborder = 70
end type

type cb_3 from commandbutton within w_rh610_rpt_adelanto_utildades
integer x = 210
integer y = 316
integer width = 87
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_descripcion from editmask within w_rh610_rpt_adelanto_utildades
integer x = 325
integer y = 312
integer width = 791
integer height = 76
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
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh610_rpt_adelanto_utildades
integer x = 50
integer y = 312
integer width = 128
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh610_rpt_adelanto_utildades
integer x = 1632
integer y = 312
integer width = 750
integer height = 76
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
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh610_rpt_adelanto_utildades
integer x = 1317
integer y = 312
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh610_rpt_adelanto_utildades
integer x = 1522
integer y = 316
integer width = 87
integer height = 68
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_tipo.text      = sl_param.field_ret[1]
	em_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type cb_1 from commandbutton within w_rh610_rpt_adelanto_utildades
integer x = 2057
integer y = 88
integer width = 293
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_periodo from editmask within w_rh610_rpt_adelanto_utildades
integer x = 329
integer y = 72
integer width = 297
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_fec_desde from editmask within w_rh610_rpt_adelanto_utildades
integer x = 987
integer y = 72
integer width = 343
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_fec_hasta from editmask within w_rh610_rpt_adelanto_utildades
integer x = 1559
integer y = 72
integer width = 343
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh610_rpt_adelanto_utildades
integer x = 82
integer y = 84
integer width = 206
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Periodo"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh610_rpt_adelanto_utildades
integer x = 782
integer y = 84
integer width = 183
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Desde"
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh610_rpt_adelanto_utildades
integer x = 1376
integer y = 84
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Hasta"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh610_rpt_adelanto_utildades
integer y = 240
integer width = 1166
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh610_rpt_adelanto_utildades
integer x = 1271
integer y = 240
integer width = 1166
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Tipo de Trabajador "
end type

type gb_1 from groupbox within w_rh610_rpt_adelanto_utildades
integer x = 699
integer width = 1271
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Rango de Fechas "
end type

