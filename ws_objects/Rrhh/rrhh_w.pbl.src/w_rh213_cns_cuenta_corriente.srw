$PBExportHeader$w_rh213_cns_cuenta_corriente.srw
forward
global type w_rh213_cns_cuenta_corriente from w_cns
end type
type st_2 from statictext within w_rh213_cns_cuenta_corriente
end type
type em_fecha_hasta from editmask within w_rh213_cns_cuenta_corriente
end type
type cb_2 from commandbutton within w_rh213_cns_cuenta_corriente
end type
type em_tipo from editmask within w_rh213_cns_cuenta_corriente
end type
type em_desc_tipo from editmask within w_rh213_cns_cuenta_corriente
end type
type em_origen from editmask within w_rh213_cns_cuenta_corriente
end type
type em_descripcion from editmask within w_rh213_cns_cuenta_corriente
end type
type cb_3 from commandbutton within w_rh213_cns_cuenta_corriente
end type
type em_fecha_desde from editmask within w_rh213_cns_cuenta_corriente
end type
type st_1 from statictext within w_rh213_cns_cuenta_corriente
end type
type dw_admin from u_dw_cns within w_rh213_cns_cuenta_corriente
end type
type cb_1 from commandbutton within w_rh213_cns_cuenta_corriente
end type
type gb_2 from groupbox within w_rh213_cns_cuenta_corriente
end type
type gb_3 from groupbox within w_rh213_cns_cuenta_corriente
end type
type gb_1 from groupbox within w_rh213_cns_cuenta_corriente
end type
end forward

global type w_rh213_cns_cuenta_corriente from w_cns
integer width = 3319
integer height = 1656
string title = "(RH213) Saldos de Cuentas Corrientes"
string menuname = "m_consulta"
st_2 st_2
em_fecha_hasta em_fecha_hasta
cb_2 cb_2
em_tipo em_tipo
em_desc_tipo em_desc_tipo
em_origen em_origen
em_descripcion em_descripcion
cb_3 cb_3
em_fecha_desde em_fecha_desde
st_1 st_1
dw_admin dw_admin
cb_1 cb_1
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_rh213_cns_cuenta_corriente w_rh213_cns_cuenta_corriente

on w_rh213_cns_cuenta_corriente.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.st_2=create st_2
this.em_fecha_hasta=create em_fecha_hasta
this.cb_2=create cb_2
this.em_tipo=create em_tipo
this.em_desc_tipo=create em_desc_tipo
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.em_fecha_desde=create em_fecha_desde
this.st_1=create st_1
this.dw_admin=create dw_admin
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_fecha_hasta
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.em_tipo
this.Control[iCurrent+5]=this.em_desc_tipo
this.Control[iCurrent+6]=this.em_origen
this.Control[iCurrent+7]=this.em_descripcion
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.em_fecha_desde
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.dw_admin
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_1
end on

on w_rh213_cns_cuenta_corriente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.em_fecha_hasta)
destroy(this.cb_2)
destroy(this.em_tipo)
destroy(this.em_desc_tipo)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.em_fecha_desde)
destroy(this.st_1)
destroy(this.dw_admin)
destroy(this.cb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve_list;call super::ue_retrieve_list;string ls_origen, ls_tiptra, ls_descripcion
date ld_fec_desde, ld_fec_hasta

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)
ld_fec_desde = date(em_fecha_desde.text)
ld_fec_hasta = date(em_fecha_hasta.text)

DECLARE pb_usp_rh_cons_cuenta_corriente PROCEDURE FOR USP_RH_CONS_CUENTA_CORRIENTE
         ( :ld_fec_desde, :ld_fec_hasta, :ls_tiptra, :ls_origen ) ;
 
dw_admin.SetTransObject(sqlca)
EXECUTE pb_usp_rh_cons_cuenta_corriente ;
dw_admin.of_set_split(dw_admin.of_get_column_end('desc_area'))
dw_admin.retrieve()

end event

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)        // Posicionar la ventana en forma fija
idw_1 = dw_admin              // asignar dw corriente
//dw_detail.BorderStyle = StyleRaised! // indicar dw_detail como no activado
// dw_master.ii_cn = 1             // indicar el campo key del master

// ii_help = 101           // help topic


end event

type st_2 from statictext within w_rh213_cns_cuenta_corriente
integer x = 1559
integer y = 312
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Hasta"
boolean focusrectangle = false
end type

type em_fecha_hasta from editmask within w_rh213_cns_cuenta_corriente
integer x = 1728
integer y = 316
integer width = 343
integer height = 72
integer taborder = 40
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

type cb_2 from commandbutton within w_rh213_cns_cuenta_corriente
integer x = 1947
integer y = 104
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

type em_tipo from editmask within w_rh213_cns_cuenta_corriente
integer x = 1778
integer y = 112
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

type em_desc_tipo from editmask within w_rh213_cns_cuenta_corriente
integer x = 2075
integer y = 112
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

type em_origen from editmask within w_rh213_cns_cuenta_corriente
integer x = 608
integer y = 112
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

type em_descripcion from editmask within w_rh213_cns_cuenta_corriente
integer x = 846
integer y = 112
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

type cb_3 from commandbutton within w_rh213_cns_cuenta_corriente
integer x = 722
integer y = 104
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

type em_fecha_desde from editmask within w_rh213_cns_cuenta_corriente
integer x = 1166
integer y = 316
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

type st_1 from statictext within w_rh213_cns_cuenta_corriente
integer x = 965
integer y = 312
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Desde"
boolean focusrectangle = false
end type

type dw_admin from u_dw_cns within w_rh213_cns_cuenta_corriente
integer x = 105
integer y = 476
integer width = 3081
integer height = 928
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_cons_cnta_crrte_admin_crt"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = false
end type

event doubleclicked;call super::doubleclicked;
IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_area"  
		lstr_1.DataObject = 'd_cons_cnta_crrte_seccion_crt'
		lstr_1.Width = 2500
		lstr_1.Height= 1300
		lstr_1.Title = 'Secciones por Administraciones'
		lstr_1.Arg[1] = GetItemString(row,'cod_area')
		lstr_1.Arg[2] = ''
		lstr_1.Arg[3] = ''
		lstr_1.Arg[4] = ''
		lstr_1.Arg[5] = ''
		lstr_1.Arg[6] = ''
		lstr_1.NextCol = 'cod_seccion'
		of_new_sheet(lstr_1)
	
END CHOOSE
end event

event constructor;call super::constructor;//Asignacion de variable sin efecto alguno
ii_ck[1] = 1 //Columna de lectura del dw.
end event

type cb_1 from commandbutton within w_rh213_cns_cuenta_corriente
integer x = 2222
integer y = 304
integer width = 261
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve_list()
end event

type gb_2 from groupbox within w_rh213_cns_cuenta_corriente
integer x = 558
integer y = 40
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

type gb_3 from groupbox within w_rh213_cns_cuenta_corriente
integer x = 1733
integer y = 40
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

type gb_1 from groupbox within w_rh213_cns_cuenta_corriente
integer x = 855
integer y = 244
integer width = 1294
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Rango de Fechas "
end type

