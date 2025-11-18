$PBExportHeader$w_rh210_cns_ganancias_fijas.srw
forward
global type w_rh210_cns_ganancias_fijas from w_cns
end type
type cb_2 from commandbutton within w_rh210_cns_ganancias_fijas
end type
type em_tipo from editmask within w_rh210_cns_ganancias_fijas
end type
type em_desc_tipo from editmask within w_rh210_cns_ganancias_fijas
end type
type em_origen from editmask within w_rh210_cns_ganancias_fijas
end type
type em_descripcion from editmask within w_rh210_cns_ganancias_fijas
end type
type cb_3 from commandbutton within w_rh210_cns_ganancias_fijas
end type
type dw_ganancias from u_dw_cns within w_rh210_cns_ganancias_fijas
end type
type cb_aceptar from commandbutton within w_rh210_cns_ganancias_fijas
end type
type gb_2 from groupbox within w_rh210_cns_ganancias_fijas
end type
type gb_3 from groupbox within w_rh210_cns_ganancias_fijas
end type
end forward

global type w_rh210_cns_ganancias_fijas from w_cns
integer width = 3086
integer height = 1568
string title = "(RH210) Ganancias Fijas por Conceptos"
string menuname = "m_consulta"
cb_2 cb_2
em_tipo em_tipo
em_desc_tipo em_desc_tipo
em_origen em_origen
em_descripcion em_descripcion
cb_3 cb_3
dw_ganancias dw_ganancias
cb_aceptar cb_aceptar
gb_2 gb_2
gb_3 gb_3
end type
global w_rh210_cns_ganancias_fijas w_rh210_cns_ganancias_fijas

on w_rh210_cns_ganancias_fijas.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.cb_2=create cb_2
this.em_tipo=create em_tipo
this.em_desc_tipo=create em_desc_tipo
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.dw_ganancias=create dw_ganancias
this.cb_aceptar=create cb_aceptar
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_tipo
this.Control[iCurrent+3]=this.em_desc_tipo
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.dw_ganancias
this.Control[iCurrent+8]=this.cb_aceptar
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
end on

on w_rh210_cns_ganancias_fijas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.em_tipo)
destroy(this.em_desc_tipo)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.dw_ganancias)
destroy(this.cb_aceptar)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
II_X = 1
idw_1 = dw_ganancias

end event

event ue_retrieve_list;call super::ue_retrieve_list;string ls_origen, ls_tiptra, ls_descripcion

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)

DECLARE pb_usp_rh_cons_ganancias_fijas PROCEDURE FOR USP_RH_CONS_GANANCIAS_FIJAS 
        ( :ls_tiptra, :ls_origen ) ;

dw_ganancias.SetTransObject(sqlca)
EXECUTE pb_usp_rh_cons_ganancias_fijas ;
dw_ganancias.retrieve()

end event

type cb_2 from commandbutton within w_rh210_cns_ganancias_fijas
integer x = 1623
integer y = 124
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

type em_tipo from editmask within w_rh210_cns_ganancias_fijas
integer x = 1454
integer y = 132
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

type em_desc_tipo from editmask within w_rh210_cns_ganancias_fijas
integer x = 1751
integer y = 132
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

type em_origen from editmask within w_rh210_cns_ganancias_fijas
integer x = 274
integer y = 132
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

type em_descripcion from editmask within w_rh210_cns_ganancias_fijas
integer x = 512
integer y = 132
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

type cb_3 from commandbutton within w_rh210_cns_ganancias_fijas
integer x = 389
integer y = 124
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

type dw_ganancias from u_dw_cns within w_rh210_cns_ganancias_fijas
integer x = 9
integer y = 324
integer width = 3031
integer height = 1048
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_cons_ganancias_fijas_1_crt"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_area"  
		lstr_1.DataObject = 'd_cons_ganancias_fijas_2_crt'
		lstr_1.Width = 3050
		lstr_1.Height= 1510
		lstr_1.title = 'Secciones'
		lstr_1.Arg[1] = String(GetItemstring(row,'cod_area'))
		lstr_1.Arg[2] = ''
		lstr_1.Arg[3] = ''
		lstr_1.Arg[4] = ''
		lstr_1.Arg[5] = ''
		lstr_1.Arg[6] = ''
		lstr_1.nextcol = 'cod_seccion'
		of_new_sheet(lstr_1)
  	
END CHOOSE
end event

event constructor;call super::constructor;//No tiene efecto alguno debido a que los 
//dw se asignan dinamicamente 
ii_ck[1] = 1
end event

type cb_aceptar from commandbutton within w_rh210_cns_ganancias_fijas
integer x = 2542
integer y = 116
integer width = 288
integer height = 80
integer taborder = 30
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

type gb_2 from groupbox within w_rh210_cns_ganancias_fijas
integer x = 224
integer y = 60
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

type gb_3 from groupbox within w_rh210_cns_ganancias_fijas
integer x = 1408
integer y = 60
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

