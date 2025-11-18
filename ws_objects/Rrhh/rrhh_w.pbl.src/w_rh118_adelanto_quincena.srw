$PBExportHeader$w_rh118_adelanto_quincena.srw
forward
global type w_rh118_adelanto_quincena from w_abc_master_smpl
end type
type st_3 from statictext within w_rh118_adelanto_quincena
end type
type sle_year from singlelineedit within w_rh118_adelanto_quincena
end type
type sle_mes from singlelineedit within w_rh118_adelanto_quincena
end type
type st_2 from statictext within w_rh118_adelanto_quincena
end type
type st_1 from statictext within w_rh118_adelanto_quincena
end type
type cb_reporte from commandbutton within w_rh118_adelanto_quincena
end type
type em_descripcion from editmask within w_rh118_adelanto_quincena
end type
type em_origen from editmask within w_rh118_adelanto_quincena
end type
type em_tipo from editmask within w_rh118_adelanto_quincena
end type
type cb_2 from commandbutton within w_rh118_adelanto_quincena
end type
type cb_3 from commandbutton within w_rh118_adelanto_quincena
end type
type em_desc_tipo from editmask within w_rh118_adelanto_quincena
end type
type cb_recalculo from commandbutton within w_rh118_adelanto_quincena
end type
type gb_1 from groupbox within w_rh118_adelanto_quincena
end type
end forward

global type w_rh118_adelanto_quincena from w_abc_master_smpl
integer width = 3186
integer height = 1996
string title = "[RH118] Modificar Adelanto Quincena"
string menuname = "m_master_simple"
st_3 st_3
sle_year sle_year
sle_mes sle_mes
st_2 st_2
st_1 st_1
cb_reporte cb_reporte
em_descripcion em_descripcion
em_origen em_origen
em_tipo em_tipo
cb_2 cb_2
cb_3 cb_3
em_desc_tipo em_desc_tipo
cb_recalculo cb_recalculo
gb_1 gb_1
end type
global w_rh118_adelanto_quincena w_rh118_adelanto_quincena

on w_rh118_adelanto_quincena.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.st_3=create st_3
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.st_2=create st_2
this.st_1=create st_1
this.cb_reporte=create cb_reporte
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_3=create cb_3
this.em_desc_tipo=create em_desc_tipo
this.cb_recalculo=create cb_recalculo
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.sle_year
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_reporte
this.Control[iCurrent+7]=this.em_descripcion
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.em_tipo
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.em_desc_tipo
this.Control[iCurrent+13]=this.cb_recalculo
this.Control[iCurrent+14]=this.gb_1
end on

on w_rh118_adelanto_quincena.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_reporte)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.em_desc_tipo)
destroy(this.cb_recalculo)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date ld_fecha

ld_fecha = date(gnvo_app.of_fecha_Actual())

sle_year.text = string(ld_fecha, 'yyyy')
sle_mes.text = string(ld_fecha, 'mm')

ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

event ue_insert;call super::ue_insert;//Override

MessageBox('Aviso', 'No esta permitido el ingreso de registros en esta ventana', Information!)
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh118_adelanto_quincena
integer y = 376
integer width = 3131
integer height = 1188
string dataobject = "d_abc_adelanto_quincena_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type st_3 from statictext within w_rh118_adelanto_quincena
integer x = 87
integer y = 276
integer width = 251
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_rh118_adelanto_quincena
integer x = 347
integer y = 272
integer width = 229
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_rh118_adelanto_quincena
integer x = 594
integer y = 272
integer width = 155
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_rh118_adelanto_quincena
integer x = 101
integer y = 172
integer width = 238
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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

type st_1 from statictext within w_rh118_adelanto_quincena
integer x = 91
integer y = 84
integer width = 238
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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

type cb_reporte from commandbutton within w_rh118_adelanto_quincena
integer x = 1925
integer y = 68
integer width = 754
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;String 	ls_origen, ls_tipo, ls_mensaje,ls_veda
Long	 	ll_count
Integer	li_year, li_mes

try 
	
	SetPointer(HourGlass!)
	
	ls_origen	= String (em_origen.text)
	ls_tipo     = String (em_tipo.text)
	li_year		= Integer(sle_year.text)
	li_mes		= Integer(sle_mes.text)
	
	If Isnull(ls_origen) or ls_origen = '' Then
		Messagebox('Aviso','Debe Ingresar Algun Origen ,Verifique!')
		Return
	else
		select count(*) into :ll_count from origen
		 where (cod_origen  = :ls_origen ) and
				 (flag_estado = '1'        ) ;
				  
		if ll_count = 0 then
			Messagebox('Aviso','Origen No Existe ,Verifique!')
			SetPointer(Arrow!)		
			Return
		end if
	end if 
	
	If Isnull(ls_tipo) or ls_tipo = '' Then
		Messagebox('Aviso','Debe Ingresar Algun Tipo de Trabajador ,Verifique!')
		Return
	else
		select count(*) into :ll_count from tipo_trabajador 
		 where (tipo_trabajador = :ls_tipo ) and
				 (flag_estado		= '1'      ) ;
				  
		if ll_count = 0 then
			Messagebox('Aviso','Tipo de Trabajador No Existe ,Verifique!')
			Return
		end if
	end if 
	
	if ISNull(li_year) or li_year= 0 then
		Messagebox('Aviso','Debe ingresar primero el año, por favor verifique!')
		
		Return
	end if
	
	dw_master.Retrieve(ls_origen, ls_tipo, li_year, li_mes)
	
	if dw_master.RowCount() > 0 then
		cb_recalculo.enabled = true
	end if


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion, mensaje de error: ' + ex.getMessage() + ', por favor verifique!', StopSign!)
finally
	SetPointer(Arrow!)
end try






end event

type em_descripcion from editmask within w_rh118_adelanto_quincena
integer x = 622
integer y = 84
integer width = 1143
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh118_adelanto_quincena
integer x = 347
integer y = 84
integer width = 151
integer height = 80
integer taborder = 90
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
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh118_adelanto_quincena
integer x = 347
integer y = 172
integer width = 151
integer height = 80
integer taborder = 50
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
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh118_adelanto_quincena
integer x = 517
integer y = 84
integer width = 87
integer height = 80
integer taborder = 90
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

type cb_3 from commandbutton within w_rh118_adelanto_quincena
integer x = 517
integer y = 172
integer width = 87
integer height = 80
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

type em_desc_tipo from editmask within w_rh118_adelanto_quincena
integer x = 622
integer y = 172
integer width = 1143
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_recalculo from commandbutton within w_rh118_adelanto_quincena
integer x = 1925
integer y = 176
integer width = 754
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Recalcular documento PQU"
end type

event clicked;String 	ls_origen, ls_tipo, ls_mensaje,ls_veda
Long	 	ll_count
Integer	li_year, li_mes

try 
	
	SetPointer(HourGlass!)
	
	ls_origen	= String (em_origen.text)
	ls_tipo     = String (em_tipo.text)
	li_year		= Integer(sle_year.text)
	li_mes		= Integer(sle_mes.text)
	
	If Isnull(ls_origen) or ls_origen = '' Then
		Messagebox('Aviso','Debe Ingresar Algun Origen ,Verifique!')
		Return
	else
		select count(*) into :ll_count from origen
		 where (cod_origen  = :ls_origen ) and
				 (flag_estado = '1'        ) ;
				  
		if ll_count = 0 then
			Messagebox('Aviso','Origen No Existe ,Verifique!')
			SetPointer(Arrow!)		
			Return
		end if
	end if 
	
	If Isnull(ls_tipo) or ls_tipo = '' Then
		Messagebox('Aviso','Debe Ingresar Algun Tipo de Trabajador ,Verifique!')
		Return
	else
		select count(*) into :ll_count from tipo_trabajador 
		 where (tipo_trabajador = :ls_tipo ) and
				 (flag_estado		= '1'      ) ;
				  
		if ll_count = 0 then
			Messagebox('Aviso','Tipo de Trabajador No Existe ,Verifique!')
			Return
		end if
	end if 
	
	if ISNull(li_year) or li_year= 0 then
		Messagebox('Aviso','Debe ingresar primero el año, por favor verifique!')
		
		Return
	end if
	
	dw_master.Retrieve(ls_origen, ls_tipo, li_year, li_mes)
	
	


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion, mensaje de error: ' + ex.getMessage() + ', por favor verifique!', StopSign!)
finally
	SetPointer(Arrow!)
end try






end event

type gb_1 from groupbox within w_rh118_adelanto_quincena
integer width = 3113
integer height = 360
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Ingrese Datos "
end type

