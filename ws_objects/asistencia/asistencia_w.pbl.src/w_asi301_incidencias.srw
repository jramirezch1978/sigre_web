$PBExportHeader$w_asi301_incidencias.srw
forward
global type w_asi301_incidencias from w_abc
end type
type cbx_todos_ttrab from checkbox within w_asi301_incidencias
end type
type cbx_todos_origenes from checkbox within w_asi301_incidencias
end type
type cbx_todos_trabajador from checkbox within w_asi301_incidencias
end type
type st_3 from statictext within w_asi301_incidencias
end type
type st_2 from statictext within w_asi301_incidencias
end type
type st_1 from statictext within w_asi301_incidencias
end type
type em_desc_ttrab from editmask within w_asi301_incidencias
end type
type em_desc_origen from editmask within w_asi301_incidencias
end type
type cb_4 from commandbutton within w_asi301_incidencias
end type
type cb_3 from commandbutton within w_asi301_incidencias
end type
type em_ttrab from editmask within w_asi301_incidencias
end type
type em_origen from editmask within w_asi301_incidencias
end type
type cb_2 from commandbutton within w_asi301_incidencias
end type
type em_codigo from editmask within w_asi301_incidencias
end type
type em_nombres from editmask within w_asi301_incidencias
end type
type uo_1 from u_ingreso_rango_fechas within w_asi301_incidencias
end type
type cb_1 from commandbutton within w_asi301_incidencias
end type
type dw_master from u_dw_abc within w_asi301_incidencias
end type
type gb_1 from groupbox within w_asi301_incidencias
end type
end forward

global type w_asi301_incidencias from w_abc
integer width = 3511
integer height = 2416
string title = "Incidencias (ASI301)"
string menuname = "m_proceso_save"
cbx_todos_ttrab cbx_todos_ttrab
cbx_todos_origenes cbx_todos_origenes
cbx_todos_trabajador cbx_todos_trabajador
st_3 st_3
st_2 st_2
st_1 st_1
em_desc_ttrab em_desc_ttrab
em_desc_origen em_desc_origen
cb_4 cb_4
cb_3 cb_3
em_ttrab em_ttrab
em_origen em_origen
cb_2 cb_2
em_codigo em_codigo
em_nombres em_nombres
uo_1 uo_1
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
global w_asi301_incidencias w_asi301_incidencias

on w_asi301_incidencias.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_save" then this.MenuID = create m_proceso_save
this.cbx_todos_ttrab=create cbx_todos_ttrab
this.cbx_todos_origenes=create cbx_todos_origenes
this.cbx_todos_trabajador=create cbx_todos_trabajador
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.em_desc_ttrab=create em_desc_ttrab
this.em_desc_origen=create em_desc_origen
this.cb_4=create cb_4
this.cb_3=create cb_3
this.em_ttrab=create em_ttrab
this.em_origen=create em_origen
this.cb_2=create cb_2
this.em_codigo=create em_codigo
this.em_nombres=create em_nombres
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_todos_ttrab
this.Control[iCurrent+2]=this.cbx_todos_origenes
this.Control[iCurrent+3]=this.cbx_todos_trabajador
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.em_desc_ttrab
this.Control[iCurrent+8]=this.em_desc_origen
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.em_ttrab
this.Control[iCurrent+12]=this.em_origen
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.em_codigo
this.Control[iCurrent+15]=this.em_nombres
this.Control[iCurrent+16]=this.uo_1
this.Control[iCurrent+17]=this.cb_1
this.Control[iCurrent+18]=this.dw_master
this.Control[iCurrent+19]=this.gb_1
end on

on w_asi301_incidencias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_todos_ttrab)
destroy(this.cbx_todos_origenes)
destroy(this.cbx_todos_trabajador)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_desc_ttrab)
destroy(this.em_desc_origen)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.em_ttrab)
destroy(this.em_origen)
destroy(this.cb_2)
destroy(this.em_codigo)
destroy(this.em_nombres)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query


of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN



IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0

END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0

	END IF
END IF

end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type cbx_todos_ttrab from checkbox within w_asi301_incidencias
integer x = 2167
integer y = 388
integer width = 343
integer height = 72
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

event clicked;
if this.checked then
	em_ttrab.enabled = false
else
	em_ttrab.enabled = true
end if
end event

type cbx_todos_origenes from checkbox within w_asi301_incidencias
integer x = 2167
integer y = 304
integer width = 343
integer height = 72
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

event clicked;
if this.checked then
	em_origen.enabled = false
else
	em_origen.enabled = true
end if
end event

type cbx_todos_trabajador from checkbox within w_asi301_incidencias
integer x = 2167
integer y = 220
integer width = 343
integer height = 72
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
	em_codigo.enabled = false
else
	em_codigo.enabled = true
end if
end event

type st_3 from statictext within w_asi301_incidencias
integer x = 46
integer y = 396
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_asi301_incidencias
integer x = 46
integer y = 312
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_asi301_incidencias
integer x = 46
integer y = 220
integer width = 384
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "C.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_desc_ttrab from editmask within w_asi301_incidencias
integer x = 891
integer y = 388
integer width = 1202
integer height = 72
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

type em_desc_origen from editmask within w_asi301_incidencias
integer x = 891
integer y = 304
integer width = 1202
integer height = 72
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

type cb_4 from commandbutton within w_asi301_incidencias
integer x = 795
integer y = 388
integer width = 87
integer height = 72
integer taborder = 70
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

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text      = sl_param.field_ret[1]
	em_desc_ttrab.text = sl_param.field_ret[2]
END IF

end event

type cb_3 from commandbutton within w_asi301_incidencias
integer x = 795
integer y = 304
integer width = 87
integer height = 72
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

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_desc_origen.text = sl_param.field_ret[2]
END IF

end event

type em_ttrab from editmask within w_asi301_incidencias
integer x = 439
integer y = 388
integer width = 338
integer height = 72
integer taborder = 60
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

type em_origen from editmask within w_asi301_incidencias
integer x = 439
integer y = 304
integer width = 338
integer height = 72
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

type cb_2 from commandbutton within w_asi301_incidencias
integer x = 795
integer y = 220
integer width = 87
integer height = 72
integer taborder = 40
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

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF

end event

type em_codigo from editmask within w_asi301_incidencias
integer x = 434
integer y = 220
integer width = 338
integer height = 72
integer taborder = 30
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

type em_nombres from editmask within w_asi301_incidencias
integer x = 891
integer y = 220
integer width = 1202
integer height = 72
integer taborder = 30
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

type uo_1 from u_ingreso_rango_fechas within w_asi301_incidencias
integer x = 50
integer y = 96
integer taborder = 20
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today())  //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_1 from commandbutton within w_asi301_incidencias
integer x = 2126
integer y = 64
integer width = 370
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;Date   ld_fecha_inicial,ld_fecha_final
String ls_cod_trabajador,ls_origen,ls_ttrab				


ld_fecha_inicial = uo_1.of_get_fecha1()
ld_fecha_final	  = uo_1.of_get_fecha2()


ls_cod_trabajador = em_codigo.text
ls_origen			= em_origen.text
ls_ttrab				= em_ttrab.text


if cbx_todos_origenes.checked then //todos
	ls_origen  = '%'
else
	If Isnull(ls_origen) Or Trim(ls_origen) = '' Then
		Messagebox('Aviso','Debe Ingresar Un Codigo de Origen,Verifique!')	
		Return
	End if
end if


if cbx_todos_trabajador.checked then //todos
	ls_cod_trabajador = '%'
else
	If Isnull(ls_cod_trabajador) Or Trim(ls_cod_trabajador) = '' Then
		Messagebox('Aviso','Debe Ingresar Un Codigo de Trabajador,Verifique!')	
		Return
	End if

end if

if cbx_todos_ttrab.checked then //todos
	ls_ttrab = '%'
	
else
	If Isnull(ls_ttrab) Or Trim(ls_ttrab) = '' Then
		Messagebox('Aviso','Debe Ingresar Un Tipo de Trabajador ,Verifique!')	
		Return
	End if
	
end if





dw_master.Retrieve(ls_origen,ls_ttrab,ls_cod_trabajador,ld_fecha_inicial,ld_fecha_final)
end event

type dw_master from u_dw_abc within w_asi301_incidencias
integer x = 9
integer y = 504
integer width = 3438
integer height = 1708
string dataobject = "d_abc_incidencias_trabajador_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'	

is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2



idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_null

accepttext()

Setnull(ls_null)

choose case dwo.name
		 case 'cod_tipo_mov'
				select count(*) into :ll_count from tipo_mov_asistencia
				 where (cod_tipo_mov = :data) ;
				
			
				if ll_count = 0 then
					This.object.cod_tipo_mov [row] = ls_null
					Messagebox('Aviso','Tipo de Asistencia No Existe ,Verifique!')
					Return 1
				end if
				
				
end choose

end event

event doubleclicked;call super::doubleclicked;String ls_name,ls_prot
IF Getrow() = 0 THEN Return


Str_seleccionar lstr_seleccionar
Datawindow		 ldw	

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name

				
		 CASE 'cod_tipo_mov'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT TIPO_MOV_ASISTENCIA.COD_TIPO_MOV AS CODIGO , '&
								   					 +'TIPO_MOV_ASISTENCIA.DESC_MOVIMI  AS DESCRIPCION '&
									   				 +'FROM TIPO_MOV_ASISTENCIA '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_tipo_mov',lstr_seleccionar.param1[1])
					Setitem(row,'desc_movimi',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
				
							
END CHOOSE


end event

event ue_insert_pre;call super::ue_insert_pre;This.object.cod_usr [al_row] = gs_user
end event

event itemerror;call super::itemerror;RETURN 1
end event

type gb_1 from groupbox within w_asi301_incidencias
integer x = 14
integer y = 20
integer width = 2537
integer height = 476
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Buscar"
end type

