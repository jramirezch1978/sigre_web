$PBExportHeader$w_rh212_cns_categorias_salariales.srw
forward
global type w_rh212_cns_categorias_salariales from w_cns
end type
type cb_4 from commandbutton within w_rh212_cns_categorias_salariales
end type
type em_tipo from editmask within w_rh212_cns_categorias_salariales
end type
type em_desc_tipo from editmask within w_rh212_cns_categorias_salariales
end type
type em_origen from editmask within w_rh212_cns_categorias_salariales
end type
type em_descripcion from editmask within w_rh212_cns_categorias_salariales
end type
type cb_3 from commandbutton within w_rh212_cns_categorias_salariales
end type
type dw_escala from u_dw_cns within w_rh212_cns_categorias_salariales
end type
type cb_1 from commandbutton within w_rh212_cns_categorias_salariales
end type
type cb_2 from commandbutton within w_rh212_cns_categorias_salariales
end type
type gb_2 from groupbox within w_rh212_cns_categorias_salariales
end type
type gb_3 from groupbox within w_rh212_cns_categorias_salariales
end type
end forward

global type w_rh212_cns_categorias_salariales from w_cns
integer width = 3323
integer height = 1664
string title = "(RH212) Categorías Salariales"
string menuname = "m_consulta"
cb_4 cb_4
em_tipo em_tipo
em_desc_tipo em_desc_tipo
em_origen em_origen
em_descripcion em_descripcion
cb_3 cb_3
dw_escala dw_escala
cb_1 cb_1
cb_2 cb_2
gb_2 gb_2
gb_3 gb_3
end type
global w_rh212_cns_categorias_salariales w_rh212_cns_categorias_salariales

on w_rh212_cns_categorias_salariales.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.cb_4=create cb_4
this.em_tipo=create em_tipo
this.em_desc_tipo=create em_desc_tipo
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.dw_escala=create dw_escala
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.em_tipo
this.Control[iCurrent+3]=this.em_desc_tipo
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.dw_escala
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_3
end on

on w_rh212_cns_categorias_salariales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.em_tipo)
destroy(this.em_desc_tipo)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.dw_escala)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
II_X = 1
idw_1 = dw_escala
//w_cons_escala_categoria_rh305.Event ue_retrieve_list()
end event

event ue_retrieve_list;call super::ue_retrieve_list;string ls_origen, ls_tiptra, ls_descripcion

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)

DECLARE pb_usp_rh_cons_categoria_salarial PROCEDURE FOR USP_RH_CONS_CATEGORIA_SALARIAL
   	  ( :ls_tiptra, :ls_origen ) ;

dw_escala.SetTransObject(sqlca)
EXECUTE pb_usp_rh_cons_categoria_salarial ;
dw_escala.retrieve()

end event

type cb_4 from commandbutton within w_rh212_cns_categorias_salariales
integer x = 1705
integer y = 124
integer width = 87
integer height = 68
integer taborder = 60
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

type em_tipo from editmask within w_rh212_cns_categorias_salariales
integer x = 1536
integer y = 132
integer width = 151
integer height = 60
integer taborder = 70
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

type em_desc_tipo from editmask within w_rh212_cns_categorias_salariales
integer x = 1833
integer y = 132
integer width = 667
integer height = 60
integer taborder = 70
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

type em_origen from editmask within w_rh212_cns_categorias_salariales
integer x = 379
integer y = 132
integer width = 96
integer height = 60
integer taborder = 60
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

type em_descripcion from editmask within w_rh212_cns_categorias_salariales
integer x = 617
integer y = 132
integer width = 759
integer height = 60
integer taborder = 60
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

type cb_3 from commandbutton within w_rh212_cns_categorias_salariales
integer x = 494
integer y = 124
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

type dw_escala from u_dw_cns within w_rh212_cns_categorias_salariales
integer x = 14
integer y = 300
integer width = 3259
integer height = 1164
boolean bringtotop = true
string dataobject = "d_cons_escala_categoria_1_crt"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;//Esta asignacion no tiene relevancia
ii_ck[1] = 1  //columna de lectura del dw
end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_area"  
		lstr_1.DataObject = 'd_cons_escala_categoria_2_crt'
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

type cb_1 from commandbutton within w_rh212_cns_categorias_salariales
boolean visible = false
integer x = 1408
integer y = 144
integer width = 320
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Aceptar"
end type

event clicked;//dw_escala.DataObject = "d_cons_escala_categoria_1_crt"
//Parent.Event ue_retrieve_list()
end event

type cb_2 from commandbutton within w_rh212_cns_categorias_salariales
integer x = 2619
integer y = 120
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
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve_list()
end event

type gb_2 from groupbox within w_rh212_cns_categorias_salariales
integer x = 329
integer y = 60
integer width = 1097
integer height = 172
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh212_cns_categorias_salariales
integer x = 1490
integer y = 60
integer width = 1056
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

