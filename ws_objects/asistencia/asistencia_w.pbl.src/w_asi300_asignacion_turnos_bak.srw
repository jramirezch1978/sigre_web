$PBExportHeader$w_asi300_asignacion_turnos_bak.srw
forward
global type w_asi300_asignacion_turnos_bak from w_abc_list
end type
type st_1 from statictext within w_asi300_asignacion_turnos_bak
end type
type st_2 from statictext within w_asi300_asignacion_turnos_bak
end type
type cb_2 from commandbutton within w_asi300_asignacion_turnos_bak
end type
type cb_3 from commandbutton within w_asi300_asignacion_turnos_bak
end type
type em_desc_tipo from editmask within w_asi300_asignacion_turnos_bak
end type
type em_descripcion from editmask within w_asi300_asignacion_turnos_bak
end type
type cb_1 from commandbutton within w_asi300_asignacion_turnos_bak
end type
type cb_4 from commandbutton within w_asi300_asignacion_turnos_bak
end type
type uo_1 from u_ingreso_rango_fechas within w_asi300_asignacion_turnos_bak
end type
type st_3 from statictext within w_asi300_asignacion_turnos_bak
end type
type sle_turno from singlelineedit within w_asi300_asignacion_turnos_bak
end type
type cb_5 from commandbutton within w_asi300_asignacion_turnos_bak
end type
type sle_origen from singlelineedit within w_asi300_asignacion_turnos_bak
end type
type sle_ttrab from singlelineedit within w_asi300_asignacion_turnos_bak
end type
type gb_1 from groupbox within w_asi300_asignacion_turnos_bak
end type
type gb_2 from groupbox within w_asi300_asignacion_turnos_bak
end type
end forward

global type w_asi300_asignacion_turnos_bak from w_abc_list
integer width = 3739
integer height = 2708
string title = "Asignacion de Turnos (ASI300)"
string menuname = "m_proceso"
st_1 st_1
st_2 st_2
cb_2 cb_2
cb_3 cb_3
em_desc_tipo em_desc_tipo
em_descripcion em_descripcion
cb_1 cb_1
cb_4 cb_4
uo_1 uo_1
st_3 st_3
sle_turno sle_turno
cb_5 cb_5
sle_origen sle_origen
sle_ttrab sle_ttrab
gb_1 gb_1
gb_2 gb_2
end type
global w_asi300_asignacion_turnos_bak w_asi300_asignacion_turnos_bak

event ue_open_pre;call super::ue_open_pre;dw_1.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_2.SetTransObject(sqlca)

of_position_window(0,0)       			// Posicionar la ventana en forma fija


end event

on w_asi300_asignacion_turnos_bak.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.st_1=create st_1
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_3=create cb_3
this.em_desc_tipo=create em_desc_tipo
this.em_descripcion=create em_descripcion
this.cb_1=create cb_1
this.cb_4=create cb_4
this.uo_1=create uo_1
this.st_3=create st_3
this.sle_turno=create sle_turno
this.cb_5=create cb_5
this.sle_origen=create sle_origen
this.sle_ttrab=create sle_ttrab
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.em_desc_tipo
this.Control[iCurrent+6]=this.em_descripcion
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.uo_1
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.sle_turno
this.Control[iCurrent+12]=this.cb_5
this.Control[iCurrent+13]=this.sle_origen
this.Control[iCurrent+14]=this.sle_ttrab
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_asi300_asignacion_turnos_bak.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.em_desc_tipo)
destroy(this.em_descripcion)
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.uo_1)
destroy(this.st_3)
destroy(this.sle_turno)
destroy(this.cb_5)
destroy(this.sle_origen)
destroy(this.sle_ttrab)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;dw_1.height  = newheight  - dw_1.Y - 10
dw_2.height  = newheight  - dw_2.Y - 10

end event

type dw_1 from w_abc_list`dw_1 within w_asi300_asignacion_turnos_bak
integer width = 1627
integer height = 1664
string dataobject = "d_amestro_asig_tur_tbl"
end type

event dw_1::constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1          // columna, que juega como key

ii_rk[1]  = 1		
ii_rk[2]  = 2
ii_rk[3]  = 3
ii_rk[4]  = 4
ii_rk[5]  = 5
ii_rk[6]  = 6
ii_rk[7]  = 7
ii_rk[8]  = 8
ii_rk[9]  = 9
ii_rk[10] = 10

ii_dk[1]  = 1		
ii_dk[2]  = 2
ii_dk[3]  = 3
ii_dk[4]  = 4
ii_dk[5]  = 5
ii_dk[6]  = 6
ii_dk[7]  = 7
ii_dk[8]  = 8
ii_dk[9]  = 9
ii_dk[10] = 10
						

end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y


ll_row = THIS.GetSelectedRow(0)




Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x


ll_row = dw_2.EVENT ue_insert()


FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

type dw_2 from w_abc_list`dw_2 within w_asi300_asignacion_turnos_bak
integer x = 1879
integer y = 388
integer width = 1627
integer height = 1664
integer taborder = 130
string dataobject = "d_amestro_asig_tur_tbl"
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1          // columna, que juega como key

ii_rk[1]  = 1		
ii_rk[2]  = 2
ii_rk[3]  = 3
ii_rk[4]  = 4
ii_rk[5]  = 5
ii_rk[6]  = 6
ii_rk[7]  = 7
ii_rk[8]  = 8
ii_rk[9]  = 9
ii_rk[10] = 10

ii_dk[1]  = 1		
ii_dk[2]  = 2
ii_dk[3]  = 3
ii_dk[4]  = 4
ii_dk[5]  = 5
ii_dk[6]  = 6
ii_dk[7]  = 7
ii_dk[8]  = 8
ii_dk[9]  = 9
ii_dk[10] = 10
end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)

Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

type pb_1 from w_abc_list`pb_1 within w_asi300_asignacion_turnos_bak
integer x = 1701
integer y = 652
integer taborder = 60
end type

event pb_1::clicked;

dw_1.EVENT ue_selected_row()

// ordenar ventana derecha
//of_sort_dw_2()
dw_1.SetSort("cod_origen ,tipo_trabajador,cod_area,cod_seccion")
dw_1.groupcalc()
dw_2.SetSort("cod_origen ,tipo_trabajador,cod_area,cod_seccion")
dw_2.groupcalc()

end event

type pb_2 from w_abc_list`pb_2 within w_asi300_asignacion_turnos_bak
integer x = 1701
integer y = 900
integer taborder = 70
end type

event pb_2::clicked;

dw_2.EVENT ue_selected_row()

// ordenar ventana izquierda
dw_1.SetSort("cod_origen ,tipo_trabajador,cod_area,cod_seccion")
dw_1.groupcalc()
dw_2.SetSort("cod_origen ,tipo_trabajador,cod_area,cod_seccion")
dw_2.groupcalc()

end event

type st_1 from statictext within w_asi300_asignacion_turnos_bak
integer x = 37
integer y = 96
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

type st_2 from statictext within w_asi300_asignacion_turnos_bak
integer x = 37
integer y = 208
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

type cb_2 from commandbutton within w_asi300_asignacion_turnos_bak
integer x = 530
integer y = 84
integer width = 73
integer height = 80
integer taborder = 40
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

type cb_3 from commandbutton within w_asi300_asignacion_turnos_bak
integer x = 535
integer y = 204
integer width = 73
integer height = 80
integer taborder = 180
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

type em_desc_tipo from editmask within w_asi300_asignacion_turnos_bak
integer x = 622
integer y = 208
integer width = 1129
integer height = 80
integer taborder = 80
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

type em_descripcion from editmask within w_asi300_asignacion_turnos_bak
integer x = 622
integer y = 96
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

type cb_1 from commandbutton within w_asi300_asignacion_turnos_bak
integer x = 1778
integer y = 84
integer width = 343
integer height = 100
integer taborder = 100
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

ls_origen	= sle_origen.text
ls_tip_trab = sle_ttrab.text


IF Isnull(ls_origen) or Trim(ls_origen) = '' THEN
	Messagebox('Aviso','Debe Ingresar Origen ,Verifique!')
	RETURN
	
END IF


IF Isnull(ls_tip_trab) or Trim(ls_tip_trab) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Trabajador ,Verifique!')
	RETURN
		
END IF


dw_1.retrieve(ls_origen,ls_tip_trab)
end event

type cb_4 from commandbutton within w_asi300_asignacion_turnos_bak
integer x = 3131
integer y = 204
integer width = 343
integer height = 100
integer taborder = 110
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String  ls_turno,ls_cod_trabajador,ls_msj_err
Date    ld_fecha_inicio,ld_fecha_final
Long    ll_inicio
Boolean lb_ret = TRUE

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()
ls_turno			 = TRIM(sle_turno.text)

IF Isnull(ls_turno) OR Trim(ls_turno) = '' THEN
	Messagebox('Aviso','Debe Seleccionar Un Turno ,Verifique')
	Return
END IF


dw_2.accepttext()

//llena tabla temporal
DECLARE PB_usp_rrhh_dias_trans PROCEDURE FOR usp_rrhh_dias_trans
(:ld_fecha_inicio,:ld_fecha_final);
EXECUTE PB_usp_rrhh_dias_trans ;



IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
   GOTO SALIDA
END IF




For ll_inicio = 1 to dw_2.rowcount ()
	 ls_cod_trabajador = dw_2.object.cod_trabajador [ll_inicio]
	 
	 //actualiza informacion
	 delete from rrhh_asignacion_turnos
	  where (cod_trabajador = :ls_cod_trabajador               ) and
	  		  (fecha				in (select fecha from tt_rrhh_dias)) ;
	
	  IF SQLCA.SQLCode = -1 THEN 
        ls_msj_err = SQLCA.SQLErrText
		  lb_ret = FALSE
		  GOTO SALIDA
	 END IF
	 
	 Insert Into rrhh_asignacion_turnos
	 (cod_trabajador,fecha,turno)
	 select :ls_cod_trabajador,fecha,:ls_turno from tt_rrhh_dias ;

	  IF SQLCA.SQLCode = -1 THEN 
        ls_msj_err = SQLCA.SQLErrText
		  lb_ret = FALSE
		  GOTO SALIDA
	 END IF
	 
	 
	 
Next

SALIDA:

IF lb_ret THEN
	Commit ;
	Messagebox('Aviso','Proceso se Culmino Satisfactoriamente')
ELSE
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
END IF	

Commit ;

CLOSE PB_usp_rrhh_dias_trans ;
end event

type uo_1 from u_ingreso_rango_fechas within w_asi300_asignacion_turnos_bak
event destroy ( )
integer x = 2203
integer y = 80
integer height = 96
integer taborder = 140
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type st_3 from statictext within w_asi300_asignacion_turnos_bak
integer x = 2240
integer y = 224
integer width = 219
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Turno :"
boolean focusrectangle = false
end type

type sle_turno from singlelineedit within w_asi300_asignacion_turnos_bak
integer x = 2450
integer y = 212
integer width = 297
integer height = 84
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_5 from commandbutton within w_asi300_asignacion_turnos_bak
integer x = 2775
integer y = 208
integer width = 110
integer height = 88
integer taborder = 170
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_turno_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_turno.text    = sl_param.field_ret[1]
END IF

end event

type sle_origen from singlelineedit within w_asi300_asignacion_turnos_bak
integer x = 288
integer y = 88
integer width = 233
integer height = 84
integer taborder = 60
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

type sle_ttrab from singlelineedit within w_asi300_asignacion_turnos_bak
integer x = 288
integer y = 196
integer width = 233
integer height = 84
integer taborder = 150
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

type gb_1 from groupbox within w_asi300_asignacion_turnos_bak
integer x = 23
integer y = 16
integer width = 2135
integer height = 308
integer taborder = 50
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

type gb_2 from groupbox within w_asi300_asignacion_turnos_bak
integer x = 2167
integer y = 16
integer width = 1358
integer height = 308
integer taborder = 120
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Proceso"
end type

