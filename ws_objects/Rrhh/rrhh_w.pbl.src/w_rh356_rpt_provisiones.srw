$PBExportHeader$w_rh356_rpt_provisiones.srw
forward
global type w_rh356_rpt_provisiones from w_report_smpl
end type
type cb_3 from commandbutton within w_rh356_rpt_provisiones
end type
type em_descripcion from editmask within w_rh356_rpt_provisiones
end type
type em_origen from editmask within w_rh356_rpt_provisiones
end type
type em_desc_tipo from editmask within w_rh356_rpt_provisiones
end type
type em_tipo from editmask within w_rh356_rpt_provisiones
end type
type cb_2 from commandbutton within w_rh356_rpt_provisiones
end type
type cb_1 from commandbutton within w_rh356_rpt_provisiones
end type
type uo_1 from u_ingreso_fecha within w_rh356_rpt_provisiones
end type
type gb_2 from groupbox within w_rh356_rpt_provisiones
end type
type gb_3 from groupbox within w_rh356_rpt_provisiones
end type
type gb_1 from groupbox within w_rh356_rpt_provisiones
end type
end forward

global type w_rh356_rpt_provisiones from w_report_smpl
integer width = 3429
integer height = 1500
string title = "(RH356) Provisiones de C.T.S. y Gratificaciones"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
uo_1 uo_1
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_rh356_rpt_provisiones w_rh356_rpt_provisiones

on w_rh356_rpt_provisiones.create
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
this.uo_1=create uo_1
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
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_1
end on

on w_rh356_rpt_provisiones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_descripcion, ls_mensaje
date ld_fecha

ls_origen = string(em_origen.text)
//ld_fecha = date(em_fecha.text)
ld_fecha = uo_1.of_get_fecha()  

ls_tiptra = string(em_tipo.text)
IF ISNULL(ls_tiptra) THEN
	ls_tiptra = '%'
END IF 
	
ls_descripcion = string(em_desc_tipo.text)

DECLARE pb_usp_rh_rpt_provision_cts_gra PROCEDURE FOR USP_RH_RPT_PROVISION_CTS_GRA
 	     ( :ls_tiptra, :ls_origen, :ld_fecha ) ;
EXECUTE pb_usp_rh_rpt_provision_cts_gra ;

IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "USP_RH_RPT_PROVISION_CTS_GRA: " + SQLCA.SQLErrText
	 Rollback ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 RETURN
END IF


dw_report.retrieve(ls_origen, ls_tiptra, ld_fecha)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_nombre.text = 'PROVISIONES DEL PERSONAL AL ' + string(ld_fecha, 'dd/mm/yyyy') 

end event

type dw_report from w_report_smpl`dw_report within w_rh356_rpt_provisiones
integer x = 0
integer y = 180
integer width = 3369
integer height = 1020
integer taborder = 50
string dataobject = "d_rpt_provision_tbl"
end type

type cb_3 from commandbutton within w_rh356_rpt_provisiones
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

type em_descripcion from editmask within w_rh356_rpt_provisiones
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

type em_origen from editmask within w_rh356_rpt_provisiones
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

type em_desc_tipo from editmask within w_rh356_rpt_provisiones
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

type em_tipo from editmask within w_rh356_rpt_provisiones
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

type cb_2 from commandbutton within w_rh356_rpt_provisiones
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

type cb_1 from commandbutton within w_rh356_rpt_provisiones
integer x = 3031
integer y = 60
integer width = 293
integer height = 76
integer taborder = 40
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

type uo_1 from u_ingreso_fecha within w_rh356_rpt_provisiones
integer x = 2203
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:') // para seatear el titulo del boton
 of_set_fecha(today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

type gb_2 from groupbox within w_rh356_rpt_provisiones
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

type gb_3 from groupbox within w_rh356_rpt_provisiones
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

type gb_1 from groupbox within w_rh356_rpt_provisiones
integer x = 2185
integer width = 754
integer height = 176
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha de proceso"
end type

