$PBExportHeader$w_rh377_rpt_edades_jubilacion.srw
forward
global type w_rh377_rpt_edades_jubilacion from w_report_smpl
end type
type cb_3 from commandbutton within w_rh377_rpt_edades_jubilacion
end type
type em_descripcion from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_origen from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_desc_tipo from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_tipo from editmask within w_rh377_rpt_edades_jubilacion
end type
type cb_2 from commandbutton within w_rh377_rpt_edades_jubilacion
end type
type cb_1 from commandbutton within w_rh377_rpt_edades_jubilacion
end type
type em_fecha from editmask within w_rh377_rpt_edades_jubilacion
end type
type st_1 from statictext within w_rh377_rpt_edades_jubilacion
end type
type st_2 from statictext within w_rh377_rpt_edades_jubilacion
end type
type st_3 from statictext within w_rh377_rpt_edades_jubilacion
end type
type st_4 from statictext within w_rh377_rpt_edades_jubilacion
end type
type st_5 from statictext within w_rh377_rpt_edades_jubilacion
end type
type st_6 from statictext within w_rh377_rpt_edades_jubilacion
end type
type st_7 from statictext within w_rh377_rpt_edades_jubilacion
end type
type em_aservf from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_aservm from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_edadf_desde from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_edadf_hasta from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_edadm_desde from editmask within w_rh377_rpt_edades_jubilacion
end type
type em_edadm_hasta from editmask within w_rh377_rpt_edades_jubilacion
end type
type gb_2 from groupbox within w_rh377_rpt_edades_jubilacion
end type
type gb_3 from groupbox within w_rh377_rpt_edades_jubilacion
end type
type gb_1 from groupbox within w_rh377_rpt_edades_jubilacion
end type
end forward

global type w_rh377_rpt_edades_jubilacion from w_report_smpl
integer width = 3429
integer height = 1500
string title = "(RH377) Trabajadores en Edades de Jubilación"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
em_fecha em_fecha
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
em_aservf em_aservf
em_aservm em_aservm
em_edadf_desde em_edadf_desde
em_edadf_hasta em_edadf_hasta
em_edadm_desde em_edadm_desde
em_edadm_hasta em_edadm_hasta
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_rh377_rpt_edades_jubilacion w_rh377_rpt_edades_jubilacion

on w_rh377_rpt_edades_jubilacion.create
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
this.em_fecha=create em_fecha
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.em_aservf=create em_aservf
this.em_aservm=create em_aservm
this.em_edadf_desde=create em_edadf_desde
this.em_edadf_hasta=create em_edadf_hasta
this.em_edadm_desde=create em_edadm_desde
this.em_edadm_hasta=create em_edadm_hasta
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
this.Control[iCurrent+8]=this.em_fecha
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.st_7
this.Control[iCurrent+16]=this.em_aservf
this.Control[iCurrent+17]=this.em_aservm
this.Control[iCurrent+18]=this.em_edadf_desde
this.Control[iCurrent+19]=this.em_edadf_hasta
this.Control[iCurrent+20]=this.em_edadm_desde
this.Control[iCurrent+21]=this.em_edadm_hasta
this.Control[iCurrent+22]=this.gb_2
this.Control[iCurrent+23]=this.gb_3
this.Control[iCurrent+24]=this.gb_1
end on

on w_rh377_rpt_edades_jubilacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_fecha)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.em_aservf)
destroy(this.em_aservm)
destroy(this.em_edadf_desde)
destroy(this.em_edadf_hasta)
destroy(this.em_edadm_desde)
destroy(this.em_edadm_hasta)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_descripcion
date ld_fecha
Long ll_aservf, ll_aservm
Long ll_edadf_desde, ll_edadf_hasta
Long ll_edadm_desde, ll_edadm_hasta

ls_origen = string(em_origen.text)
ld_fecha = date(em_fecha.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)

ll_aservf = Long(em_aservf.text)
ll_aservm = Long(em_aservm.text)
ll_edadf_desde = Long(em_edadf_desde.text)
ll_edadf_hasta = Long(em_edadf_hasta.text)
ll_edadm_desde = Long(em_edadm_desde.text)
ll_edadm_hasta = Long(em_edadm_hasta.text) 

DECLARE pb_usp_rh_rpt_edades_jubilacion PROCEDURE FOR USP_RH_RPT_EDADES_JUBILACION
        ( :ll_aservf, :ll_aservm, :ll_edadf_desde, :ll_edadf_hasta,
		    :ll_edadm_desde, :ll_edadm_hasta, :ld_fecha, :ls_tiptra, :ls_origen ) ;
EXECUTE pb_usp_rh_rpt_edades_jubilacion ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_sit.text = ls_descripcion
dw_report.object.st_fecha.text = string(ld_fecha,"dd/mm/yyyy")

end event

type dw_report from w_report_smpl`dw_report within w_rh377_rpt_edades_jubilacion
integer x = 0
integer y = 560
integer width = 3369
integer height = 676
integer taborder = 110
string dataobject = "d_rpt_edad_jubilacion_tbl"
end type

type cb_3 from commandbutton within w_rh377_rpt_edades_jubilacion
integer x = 165
integer y = 64
integer width = 87
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

type em_descripcion from editmask within w_rh377_rpt_edades_jubilacion
integer x = 288
integer y = 72
integer width = 718
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh377_rpt_edades_jubilacion
integer x = 50
integer y = 72
integer width = 96
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh377_rpt_edades_jubilacion
integer x = 1454
integer y = 72
integer width = 667
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh377_rpt_edades_jubilacion
integer x = 1157
integer y = 72
integer width = 151
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh377_rpt_edades_jubilacion
integer x = 1326
integer y = 64
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

type cb_1 from commandbutton within w_rh377_rpt_edades_jubilacion
integer x = 2213
integer y = 340
integer width = 293
integer height = 76
integer taborder = 100
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

type em_fecha from editmask within w_rh377_rpt_edades_jubilacion
integer x = 2281
integer y = 92
integer width = 343
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh377_rpt_edades_jubilacion
integer x = 2231
integer y = 20
integer width = 475
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Fecha de Proyección"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh377_rpt_edades_jubilacion
integer x = 695
integer y = 332
integer width = 238
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
boolean enabled = false
string text = "Mujeres"
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh377_rpt_edades_jubilacion
integer x = 686
integer y = 416
integer width = 238
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
boolean enabled = false
string text = "Hombres"
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh377_rpt_edades_jubilacion
integer x = 265
integer y = 332
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
boolean enabled = false
string text = "AÑO SERVICIO"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_rh377_rpt_edades_jubilacion
integer x = 1225
integer y = 332
integer width = 270
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
boolean enabled = false
string text = "EDADES"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_rh377_rpt_edades_jubilacion
integer x = 1527
integer y = 256
integer width = 251
integer height = 64
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
boolean enabled = false
string text = "Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_rh377_rpt_edades_jubilacion
integer x = 1829
integer y = 256
integer width = 201
integer height = 64
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
boolean enabled = false
string text = "Hasta"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_aservf from editmask within w_rh377_rpt_edades_jubilacion
integer x = 978
integer y = 336
integer width = 174
integer height = 60
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
string mask = "##"
end type

type em_aservm from editmask within w_rh377_rpt_edades_jubilacion
integer x = 978
integer y = 420
integer width = 174
integer height = 60
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
string mask = "##"
end type

type em_edadf_desde from editmask within w_rh377_rpt_edades_jubilacion
integer x = 1563
integer y = 336
integer width = 174
integer height = 60
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
string mask = "##"
end type

type em_edadf_hasta from editmask within w_rh377_rpt_edades_jubilacion
integer x = 1842
integer y = 336
integer width = 174
integer height = 60
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
string mask = "##"
end type

type em_edadm_desde from editmask within w_rh377_rpt_edades_jubilacion
integer x = 1563
integer y = 420
integer width = 174
integer height = 60
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
string mask = "##"
end type

type em_edadm_hasta from editmask within w_rh377_rpt_edades_jubilacion
integer x = 1842
integer y = 420
integer width = 174
integer height = 60
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
string mask = "##"
end type

type gb_2 from groupbox within w_rh377_rpt_edades_jubilacion
integer width = 1056
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh377_rpt_edades_jubilacion
integer x = 1111
integer width = 1056
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

type gb_1 from groupbox within w_rh377_rpt_edades_jubilacion
integer x = 210
integer y = 192
integer width = 1929
integer height = 344
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
borderstyle borderstyle = stylebox!
end type

