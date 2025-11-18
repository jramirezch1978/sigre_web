$PBExportHeader$w_rh217_cns_evaluaciones.srw
forward
global type w_rh217_cns_evaluaciones from w_cns
end type
type st_2 from statictext within w_rh217_cns_evaluaciones
end type
type st_1 from statictext within w_rh217_cns_evaluaciones
end type
type em_mes from editmask within w_rh217_cns_evaluaciones
end type
type em_ano from editmask within w_rh217_cns_evaluaciones
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh217_cns_evaluaciones
end type
type em_origen from editmask within w_rh217_cns_evaluaciones
end type
type em_descripcion from editmask within w_rh217_cns_evaluaciones
end type
type cb_3 from commandbutton within w_rh217_cns_evaluaciones
end type
type dw_evaluaciones from u_dw_cns within w_rh217_cns_evaluaciones
end type
type cb_aceptar from commandbutton within w_rh217_cns_evaluaciones
end type
type gb_2 from groupbox within w_rh217_cns_evaluaciones
end type
type gb_1 from groupbox within w_rh217_cns_evaluaciones
end type
end forward

global type w_rh217_cns_evaluaciones from w_cns
integer width = 3086
integer height = 1568
string title = "(RH217) Compensación Variable - Evaluaciones"
string menuname = "m_consulta"
st_2 st_2
st_1 st_1
em_mes em_mes
em_ano em_ano
uo_1 uo_1
em_origen em_origen
em_descripcion em_descripcion
cb_3 cb_3
dw_evaluaciones dw_evaluaciones
cb_aceptar cb_aceptar
gb_2 gb_2
gb_1 gb_1
end type
global w_rh217_cns_evaluaciones w_rh217_cns_evaluaciones

on w_rh217_cns_evaluaciones.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.st_2=create st_2
this.st_1=create st_1
this.em_mes=create em_mes
this.em_ano=create em_ano
this.uo_1=create uo_1
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.dw_evaluaciones=create dw_evaluaciones
this.cb_aceptar=create cb_aceptar
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.em_origen
this.Control[iCurrent+7]=this.em_descripcion
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.dw_evaluaciones
this.Control[iCurrent+10]=this.cb_aceptar
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh217_cns_evaluaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_mes)
destroy(this.em_ano)
destroy(this.uo_1)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.dw_evaluaciones)
destroy(this.cb_aceptar)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
II_X = 1
idw_1 = dw_evaluaciones

end event

event ue_retrieve_list;call super::ue_retrieve_list;string  ls_origen, ls_tiptra
integer li_ano, li_mes

ls_origen = string(em_origen.text)
li_ano	 = integer(em_ano.text)
li_mes    = integer(em_mes.text)

ls_tiptra = uo_1.of_get_value()

if isnull(ls_origen) or trim(ls_origen) = '' then MessageBox('Atención','Debe Ingresar el Origen')
if isnull(ls_tiptra) or trim(ls_tiptra) = '' then ls_tiptra  = '%'

if isnull(li_ano) or li_ano = 0 then MessageBox('Atención','Debe Ingresar el Año de Proceso')
if isnull(li_mes) or li_mes = 0 then MessageBox('Atención','Debe Ingresar el Mes de Proceso')
if li_mes < 1 or li_mes > 12 then MessageBox('Atención','Debe Ingresar el Mes Correcto')

DECLARE pb_usp_rh_av_cns_evaluaciones PROCEDURE FOR USP_RH_AV_CNS_EVALUACIONES
        ( :ls_origen, :ls_tiptra, :li_ano, :li_mes ) ;
EXECUTE pb_usp_rh_av_cns_evaluaciones ;

dw_evaluaciones.SetTransObject(sqlca)
dw_evaluaciones.of_set_split(dw_evaluaciones.of_get_column_end('desc_area'))
dw_evaluaciones.retrieve()

end event

type st_2 from statictext within w_rh217_cns_evaluaciones
integer x = 1083
integer y = 356
integer width = 105
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh217_cns_evaluaciones
integer x = 667
integer y = 356
integer width = 110
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type em_mes from editmask within w_rh217_cns_evaluaciones
integer x = 1230
integer y = 352
integer width = 165
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_ano from editmask within w_rh217_cns_evaluaciones
integer x = 809
integer y = 352
integer width = 229
integer height = 76
integer taborder = 20
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh217_cns_evaluaciones
integer x = 1650
integer y = 36
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type em_origen from editmask within w_rh217_cns_evaluaciones
integer x = 521
integer y = 116
integer width = 96
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

type em_descripcion from editmask within w_rh217_cns_evaluaciones
integer x = 777
integer y = 116
integer width = 759
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

type cb_3 from commandbutton within w_rh217_cns_evaluaciones
integer x = 654
integer y = 120
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

type dw_evaluaciones from u_dw_cns within w_rh217_cns_evaluaciones
integer x = 9
integer y = 536
integer width = 3031
integer height = 836
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_cns_evaluaciones_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_area"  
		lstr_1.DataObject = 'd_cns_evaluaciones_sec_tbl'
		lstr_1.Width = 3050
		lstr_1.Height= 1510
		lstr_1.title = 'Secciones por Administraciones'
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

type cb_aceptar from commandbutton within w_rh217_cns_evaluaciones
integer x = 1966
integer y = 348
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

type gb_2 from groupbox within w_rh217_cns_evaluaciones
integer x = 462
integer y = 40
integer width = 1134
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_rh217_cns_evaluaciones
integer x = 594
integer y = 276
integer width = 873
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Proceso "
end type

