$PBExportHeader$w_rh216_cns_proyeccion_quinquenio.srw
forward
global type w_rh216_cns_proyeccion_quinquenio from w_cns
end type
type cb_3 from commandbutton within w_rh216_cns_proyeccion_quinquenio
end type
type em_descripcion from editmask within w_rh216_cns_proyeccion_quinquenio
end type
type em_origen from editmask within w_rh216_cns_proyeccion_quinquenio
end type
type em_desc_tipo from editmask within w_rh216_cns_proyeccion_quinquenio
end type
type em_tipo from editmask within w_rh216_cns_proyeccion_quinquenio
end type
type cb_2 from commandbutton within w_rh216_cns_proyeccion_quinquenio
end type
type st_1 from statictext within w_rh216_cns_proyeccion_quinquenio
end type
type em_fecha from editmask within w_rh216_cns_proyeccion_quinquenio
end type
type dw_cns from u_dw_cns within w_rh216_cns_proyeccion_quinquenio
end type
type cb_1 from commandbutton within w_rh216_cns_proyeccion_quinquenio
end type
type gb_2 from groupbox within w_rh216_cns_proyeccion_quinquenio
end type
type gb_3 from groupbox within w_rh216_cns_proyeccion_quinquenio
end type
end forward

global type w_rh216_cns_proyeccion_quinquenio from w_cns
integer width = 3653
integer height = 2032
string title = "(RH216) Proyección de Pagos de Quinquenios"
string menuname = "m_consulta"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
st_1 st_1
em_fecha em_fecha
dw_cns dw_cns
cb_1 cb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_rh216_cns_proyeccion_quinquenio w_rh216_cns_proyeccion_quinquenio

type variables
string is_tipo_trabaj
end variables

on w_rh216_cns_proyeccion_quinquenio.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.st_1=create st_1
this.em_fecha=create em_fecha
this.dw_cns=create dw_cns
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.em_fecha
this.Control[iCurrent+9]=this.dw_cns
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
end on

on w_rh216_cns_proyeccion_quinquenio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.em_fecha)
destroy(this.dw_cns)
destroy(this.cb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve_list;call super::ue_retrieve_list;string ls_origen, ls_tiptra, ls_descripcion
date ld_fecha

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)
ld_fecha = date(em_fecha.text)

DECLARE pb_usp_rh_cons_quinquenios PROCEDURE FOR USP_RH_CONS_QUINQUENIOS
        ( :ls_tiptra, :ls_origen, :ld_fecha ) ;

dw_cns.SetTransObject(sqlca)
EXECUTE pb_usp_rh_cons_quinquenios ;
dw_cns.retrieve()

end event

event ue_retrieve_list_pos;call super::ue_retrieve_list_pos;//dw_cns.Object.DataWindow.Crosstab.StaticMode = 'Yes'

//dw_cns.SetRedraw(false)
//dw_cns.SetSort("val_t A")
//dw_cns.Sort()
//dw_cns.SetRedraw(true)
//


//dw_employee.SetSort("emp_status A, emp_salary D")


end event

type cb_3 from commandbutton within w_rh216_cns_proyeccion_quinquenio
integer x = 475
integer y = 112
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

type em_descripcion from editmask within w_rh216_cns_proyeccion_quinquenio
integer x = 599
integer y = 120
integer width = 759
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

type em_origen from editmask within w_rh216_cns_proyeccion_quinquenio
integer x = 361
integer y = 120
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

type em_desc_tipo from editmask within w_rh216_cns_proyeccion_quinquenio
integer x = 1778
integer y = 120
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

type em_tipo from editmask within w_rh216_cns_proyeccion_quinquenio
integer x = 1481
integer y = 120
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

type cb_2 from commandbutton within w_rh216_cns_proyeccion_quinquenio
integer x = 1650
integer y = 112
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

type st_1 from statictext within w_rh216_cns_proyeccion_quinquenio
integer x = 2533
integer y = 72
integer width = 503
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

type em_fecha from editmask within w_rh216_cns_proyeccion_quinquenio
integer x = 2615
integer y = 144
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

type dw_cns from u_dw_cns within w_rh216_cns_proyeccion_quinquenio
integer x = 5
integer y = 284
integer width = 3593
integer height = 1548
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_cons_proy_quinq_crt"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw
end event

type cb_1 from commandbutton within w_rh216_cns_proyeccion_quinquenio
integer x = 3104
integer y = 108
integer width = 288
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Proyectar"
end type

event clicked;Parent.Event ue_retrieve_list()
end event

type gb_2 from groupbox within w_rh216_cns_proyeccion_quinquenio
integer x = 311
integer y = 48
integer width = 1097
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

type gb_3 from groupbox within w_rh216_cns_proyeccion_quinquenio
integer x = 1435
integer y = 48
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

