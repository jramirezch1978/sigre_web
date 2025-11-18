$PBExportHeader$w_rh313_rpt_distribucion_contable.srw
forward
global type w_rh313_rpt_distribucion_contable from w_report_smpl
end type
type cb_3 from commandbutton within w_rh313_rpt_distribucion_contable
end type
type em_descripcion from editmask within w_rh313_rpt_distribucion_contable
end type
type em_origen from editmask within w_rh313_rpt_distribucion_contable
end type
type em_desc_tipo from editmask within w_rh313_rpt_distribucion_contable
end type
type em_tipo from editmask within w_rh313_rpt_distribucion_contable
end type
type cb_2 from commandbutton within w_rh313_rpt_distribucion_contable
end type
type cb_1 from commandbutton within w_rh313_rpt_distribucion_contable
end type
type em_fec_desde from editmask within w_rh313_rpt_distribucion_contable
end type
type em_fec_hasta from editmask within w_rh313_rpt_distribucion_contable
end type
type st_1 from statictext within w_rh313_rpt_distribucion_contable
end type
type st_3 from statictext within w_rh313_rpt_distribucion_contable
end type
type rb_1 from radiobutton within w_rh313_rpt_distribucion_contable
end type
type rb_2 from radiobutton within w_rh313_rpt_distribucion_contable
end type
type gb_1 from groupbox within w_rh313_rpt_distribucion_contable
end type
type gb_2 from groupbox within w_rh313_rpt_distribucion_contable
end type
type gb_3 from groupbox within w_rh313_rpt_distribucion_contable
end type
type gb_4 from groupbox within w_rh313_rpt_distribucion_contable
end type
end forward

global type w_rh313_rpt_distribucion_contable from w_report_smpl
integer width = 3387
integer height = 1500
string title = "(RH313) Consistencia de Distribución de Horas por Centros de Costos"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
em_fec_desde em_fec_desde
em_fec_hasta em_fec_hasta
st_1 st_1
st_3 st_3
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_rh313_rpt_distribucion_contable w_rh313_rpt_distribucion_contable

on w_rh313_rpt_distribucion_contable.create
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
this.em_fec_desde=create em_fec_desde
this.em_fec_hasta=create em_fec_hasta
this.st_1=create st_1
this.st_3=create st_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.em_fec_desde
this.Control[iCurrent+9]=this.em_fec_hasta
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.rb_1
this.Control[iCurrent+13]=this.rb_2
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.gb_4
end on

on w_rh313_rpt_distribucion_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_fec_desde)
destroy(this.em_fec_hasta)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra
date ld_fec_desde, ld_fec_hasta

ls_origen    = string(em_origen.text)
ls_tiptra    = string(em_tipo.text)
ld_fec_desde = date(em_fec_desde.text)
ld_fec_hasta = date(em_fec_hasta.text)

if isnull(ld_fec_desde) or ld_fec_desde = date(string('01/01/1900','dd/mm/yyyy')) then
	MessageBox('Aviso','Debe ingresar fecha de inicio')
	return
end if

if isnull(ld_fec_hasta) or ld_fec_hasta = date(string('01/01/1900','dd/mm/yyyy')) then
	MessageBox('Aviso','Debe ingresar fecha final')
	return
end if

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Aviso','Error al registrar rangos de fechas. Verificar')
	return
end if

if isnull(ls_origen) or trim(ls_origen) = '' then ls_origen = '%'
if isnull(ls_tiptra) or trim(ls_tiptra) = '' then ls_tiptra = '%'

DECLARE pb_usp_rh_rpt_dist_contable PROCEDURE FOR USP_RH_RPT_DIST_CONTABLE
        ( :ls_origen, :ls_tiptra, :ld_fec_desde, :ld_fec_hasta ) ;
EXECUTE pb_usp_rh_rpt_dist_contable ;

IF rb_1.checked = TRUE THEN
	idw_1.DataObject='d_rpt_dist_contable_con_tbl'
ELSEIF rb_2.checked = TRUE THEN
	idw_1.DataObject='d_rpt_dist_contable_det_tbl'
END IF

ib_preview = false
triggerevent('ue_preview')
idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rh313_rpt_distribucion_contable
integer y = 548
integer width = 3328
integer height = 720
integer taborder = 60
end type

type cb_3 from commandbutton within w_rh313_rpt_distribucion_contable
integer x = 969
integer y = 148
integer width = 82
integer height = 68
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

type em_descripcion from editmask within w_rh313_rpt_distribucion_contable
integer x = 1079
integer y = 144
integer width = 759
integer height = 80
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

type em_origen from editmask within w_rh313_rpt_distribucion_contable
integer x = 754
integer y = 144
integer width = 183
integer height = 80
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

type em_desc_tipo from editmask within w_rh313_rpt_distribucion_contable
integer x = 2391
integer y = 144
integer width = 667
integer height = 80
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

type em_tipo from editmask within w_rh313_rpt_distribucion_contable
integer x = 2039
integer y = 144
integer width = 206
integer height = 80
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

type cb_2 from commandbutton within w_rh313_rpt_distribucion_contable
integer x = 2277
integer y = 148
integer width = 87
integer height = 68
integer taborder = 20
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

type cb_1 from commandbutton within w_rh313_rpt_distribucion_contable
integer x = 2400
integer y = 396
integer width = 293
integer height = 76
integer taborder = 50
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

type em_fec_desde from editmask within w_rh313_rpt_distribucion_contable
integer x = 928
integer y = 396
integer width = 343
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_fec_hasta from editmask within w_rh313_rpt_distribucion_contable
integer x = 1486
integer y = 396
integer width = 343
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh313_rpt_distribucion_contable
integer x = 736
integer y = 400
integer width = 174
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh313_rpt_distribucion_contable
integer x = 1294
integer y = 400
integer width = 178
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_rh313_rpt_distribucion_contable
integer x = 155
integer y = 112
integer width = 393
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Consistencia"
end type

type rb_2 from radiobutton within w_rh313_rpt_distribucion_contable
integer x = 155
integer y = 184
integer width = 393
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Detalle"
end type

type gb_1 from groupbox within w_rh313_rpt_distribucion_contable
integer x = 695
integer y = 316
integer width = 1198
integer height = 212
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Rangos de Fechas "
end type

type gb_2 from groupbox within w_rh313_rpt_distribucion_contable
integer x = 695
integer y = 64
integer width = 1198
integer height = 212
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh313_rpt_distribucion_contable
integer x = 1979
integer y = 64
integer width = 1138
integer height = 212
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

type gb_4 from groupbox within w_rh313_rpt_distribucion_contable
integer x = 87
integer y = 44
integer width = 517
integer height = 244
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione "
end type

