$PBExportHeader$w_asi300_asignacion_turnos.srw
forward
global type w_asi300_asignacion_turnos from w_abc_master_smpl
end type
type st_1 from statictext within w_asi300_asignacion_turnos
end type
type st_2 from statictext within w_asi300_asignacion_turnos
end type
type cb_origen from commandbutton within w_asi300_asignacion_turnos
end type
type cb_tipo_trabaj from commandbutton within w_asi300_asignacion_turnos
end type
type em_desc_tipo from editmask within w_asi300_asignacion_turnos
end type
type em_descripcion from editmask within w_asi300_asignacion_turnos
end type
type cb_1 from commandbutton within w_asi300_asignacion_turnos
end type
type sle_origen from singlelineedit within w_asi300_asignacion_turnos
end type
type sle_ttrab from singlelineedit within w_asi300_asignacion_turnos
end type
type cbx_origen from checkbox within w_asi300_asignacion_turnos
end type
type cbx_tipo_trabaj from checkbox within w_asi300_asignacion_turnos
end type
type gb_1 from groupbox within w_asi300_asignacion_turnos
end type
end forward

global type w_asi300_asignacion_turnos from w_abc_master_smpl
integer width = 3045
integer height = 2120
string title = "[ASI300] Asignacion de Turnos"
string menuname = "m_abc_master_smpl"
st_1 st_1
st_2 st_2
cb_origen cb_origen
cb_tipo_trabaj cb_tipo_trabaj
em_desc_tipo em_desc_tipo
em_descripcion em_descripcion
cb_1 cb_1
sle_origen sle_origen
sle_ttrab sle_ttrab
cbx_origen cbx_origen
cbx_tipo_trabaj cbx_tipo_trabaj
gb_1 gb_1
end type
global w_asi300_asignacion_turnos w_asi300_asignacion_turnos

on w_asi300_asignacion_turnos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.st_2=create st_2
this.cb_origen=create cb_origen
this.cb_tipo_trabaj=create cb_tipo_trabaj
this.em_desc_tipo=create em_desc_tipo
this.em_descripcion=create em_descripcion
this.cb_1=create cb_1
this.sle_origen=create sle_origen
this.sle_ttrab=create sle_ttrab
this.cbx_origen=create cbx_origen
this.cbx_tipo_trabaj=create cbx_tipo_trabaj
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_origen
this.Control[iCurrent+4]=this.cb_tipo_trabaj
this.Control[iCurrent+5]=this.em_desc_tipo
this.Control[iCurrent+6]=this.em_descripcion
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.sle_origen
this.Control[iCurrent+9]=this.sle_ttrab
this.Control[iCurrent+10]=this.cbx_origen
this.Control[iCurrent+11]=this.cbx_tipo_trabaj
this.Control[iCurrent+12]=this.gb_1
end on

on w_asi300_asignacion_turnos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_origen)
destroy(this.cb_tipo_trabaj)
destroy(this.em_desc_tipo)
destroy(this.em_descripcion)
destroy(this.cb_1)
destroy(this.sle_origen)
destroy(this.sle_ttrab)
destroy(this.cbx_origen)
destroy(this.cbx_tipo_trabaj)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0  
end event

type dw_master from w_abc_master_smpl`dw_master within w_asi300_asignacion_turnos
integer y = 284
integer width = 2921
integer height = 1544
string dataobject = "d_abc_asignacion_turnos_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "turno"

		ls_sql = "select t.turno as turno, " &
				 + "t.descripcion as desc_turno " &
				 + "from turno t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.turno			[al_row] = ls_codigo
			this.object.desc_turno	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_turno'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from turno
		 Where cod_turno = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de Turno " + data + " o no se encuentra activo, por favor verifique")
			this.object.turno			[row] = gnvo_app.is_null
			this.object.desc_turno	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_turno		[row] = ls_desc

END CHOOSE
end event

type st_1 from statictext within w_asi300_asignacion_turnos
integer x = 14
integer y = 80
integer width = 215
integer height = 80
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_asi300_asignacion_turnos
integer x = 14
integer y = 164
integer width = 215
integer height = 80
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trab. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_origen from commandbutton within w_asi300_asignacion_turnos
integer x = 507
integer y = 68
integer width = 73
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -7
integer weight = 700
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
	sle_origen.text     = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type cb_tipo_trabaj from commandbutton within w_asi300_asignacion_turnos
integer x = 507
integer y = 164
integer width = 73
integer height = 80
integer taborder = 190
boolean bringtotop = true
integer textsize = -7
integer weight = 700
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
	sle_ttrab.text    = sl_param.field_ret[1]
	em_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type em_desc_tipo from editmask within w_asi300_asignacion_turnos
integer x = 599
integer y = 164
integer width = 1129
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_asi300_asignacion_turnos
integer x = 599
integer y = 68
integer width = 1129
integer height = 80
integer taborder = 100
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_asi300_asignacion_turnos
integer x = 2400
integer y = 44
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_origen,ls_tip_trab

if cbx_origen.checked then
	ls_origen	= '%%'
else
	if trim(sle_origen.text) = '' then
		MessageBox('Error', 'Debe ingresar un origen valido', StopSign!)
		sle_origen.setFocus( )
		return
	end if
	
	ls_origen	= trim(sle_origen.text) + '%'
end if

if cbx_tipo_trabaj.checked then
	ls_tip_trab	= '%%'
else
	if trim(sle_ttrab.text) = '' then
		MessageBox('Error', 'Debe ingresar un Tipo de Trabajador valido', StopSign!)
		sle_ttrab.setFocus( )
		return
	end if
	
	ls_tip_trab	= trim(sle_ttrab.text) + '%'
end if

dw_master.retrieve(ls_origen,ls_tip_trab)
end event

type sle_origen from singlelineedit within w_asi300_asignacion_turnos
integer x = 265
integer y = 68
integer width = 233
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type sle_ttrab from singlelineedit within w_asi300_asignacion_turnos
integer x = 265
integer y = 164
integer width = 233
integer height = 80
integer taborder = 160
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type cbx_origen from checkbox within w_asi300_asignacion_turnos
integer x = 1751
integer y = 80
integer width = 288
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;if this.checked then
	sle_origen.enabled 	= false
	cb_origen.enabled 	= false
else
	sle_origen.enabled 	= true
	cb_origen.enabled 	= true
end if
end event

type cbx_tipo_trabaj from checkbox within w_asi300_asignacion_turnos
integer x = 1751
integer y = 176
integer width = 288
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;if this.checked then
	sle_ttrab.enabled 		= false
	cb_tipo_trabaj.enabled 	= false
else
	sle_ttrab.enabled 		= true
	cb_tipo_trabaj.enabled 	= true
end if
end event

type gb_1 from groupbox within w_asi300_asignacion_turnos
integer width = 2784
integer height = 268
integer taborder = 10
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Busqueda"
end type

