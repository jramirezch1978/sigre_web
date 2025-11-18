$PBExportHeader$w_ope308_proceso_correcion.srw
forward
global type w_ope308_proceso_correcion from w_abc
end type
type cb_3 from commandbutton within w_ope308_proceso_correcion
end type
type cb_2 from commandbutton within w_ope308_proceso_correcion
end type
type sle_prov from singlelineedit within w_ope308_proceso_correcion
end type
type st_prov from statictext within w_ope308_proceso_correcion
end type
type st_1 from statictext within w_ope308_proceso_correcion
end type
type cb_prov from commandbutton within w_ope308_proceso_correcion
end type
type uo_1 from u_ingreso_rango_fechas within w_ope308_proceso_correcion
end type
type dw_master from u_dw_abc within w_ope308_proceso_correcion
end type
type gb_1 from groupbox within w_ope308_proceso_correcion
end type
end forward

global type w_ope308_proceso_correcion from w_abc
integer width = 3758
integer height = 1504
string title = "Correción de Facturación de Operaciones (ope308)"
string menuname = "m_abc_master_limitado"
cb_3 cb_3
cb_2 cb_2
sle_prov sle_prov
st_prov st_prov
st_1 st_1
cb_prov cb_prov
uo_1 uo_1
dw_master dw_master
gb_1 gb_1
end type
global w_ope308_proceso_correcion w_ope308_proceso_correcion

on w_ope308_proceso_correcion.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_limitado" then this.MenuID = create m_abc_master_limitado
this.cb_3=create cb_3
this.cb_2=create cb_2
this.sle_prov=create sle_prov
this.st_prov=create st_prov
this.st_1=create st_1
this.cb_prov=create cb_prov
this.uo_1=create uo_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.sle_prov
this.Control[iCurrent+4]=this.st_prov
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_prov
this.Control[iCurrent+7]=this.uo_1
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_1
end on

on w_ope308_proceso_correcion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.sle_prov)
destroy(this.st_prov)
destroy(this.st_1)
destroy(this.cb_prov)
destroy(this.uo_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.Settransobject(sqlca)
idw_1 = dw_master

of_position_window(0,0)       			// Posicionar la ventana en forma fija



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

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
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

event ue_update_pre;call super::ue_update_pre;
dw_master.of_set_flag_replicacion()
end event

type cb_3 from commandbutton within w_ope308_proceso_correcion
integer x = 3200
integer y = 216
integer width = 503
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Duplicar"
end type

event clicked;Long    ll_row, ll_row_ins
Decimal {2} ldc_precio,ldc_cantidad
Integer li_item
String  ls_oper_sec , ls_tipo_doc      , ls_nro_doc     , ls_descripcion, &
		  ls_cod_labor, ls_desc_operacion, ls_cod_ejecutor


ll_row = dw_master.GetRow()

if ll_row = 0 then 
	messagebox('Aviso','Ubique registro a copiar')
	return
else
	ls_oper_sec       = dw_master.object.oper_sec       [ll_row]
	li_item           = dw_master.object.item           [ll_row]
	ls_tipo_doc       = dw_master.object.tipo_doc       [ll_row]
	ls_nro_doc        = dw_master.object.nro_doc        [ll_row]
	ldc_precio        = dw_master.object.precio         [ll_row]
	ldc_cantidad      = dw_master.object.cantidad       [ll_row]
	ls_descripcion    = dw_master.object.descripcion    [ll_row]
	ls_cod_labor      = dw_master.object.cod_labor      [ll_row]
	ls_desc_operacion = dw_master.object.desc_operacion [ll_row]
	ls_cod_ejecutor   = dw_master.object.cod_ejecutor   [ll_row]
	

	// Datos de registro insertado
	ll_row_ins = dw_master.Event ue_insert()
	
	dw_master.object.oper_sec       [ll_row_ins] = ls_oper_sec
	dw_master.object.item           [ll_row_ins] = li_item + 1
	dw_master.object.tipo_doc       [ll_row_ins] = ls_tipo_doc
	dw_master.object.nro_doc        [ll_row_ins] = ls_nro_doc
	dw_master.object.precio         [ll_row_ins] = ldc_precio
	dw_master.object.descripcion    [ll_row_ins] = ls_descripcion
	dw_master.object.cod_labor      [ll_row_ins] = ls_cod_labor
	dw_master.object.desc_operacion [ll_row_ins] = ls_desc_operacion
	dw_master.object.cod_ejecutor   [ll_row_ins] = ls_cod_ejecutor
	dw_master.object.cantidad       [ll_row_ins] = ldc_cantidad
	dw_master.object.precio         [ll_row_ins] = ldc_precio
	

end if

end event

type cb_2 from commandbutton within w_ope308_proceso_correcion
integer x = 3200
integer y = 84
integer width = 503
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar Operaciones"
end type

event clicked;String ls_codigo,ls_fecha_inicio,ls_fecha_final



ls_codigo       = sle_prov.text
ls_fecha_inicio = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fecha_final  = String(uo_1.of_get_fecha2(),'yyyymmdd')


IF Isnull(ls_codigo) or Trim(ls_codigo) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Trabajador , Verifique!')
	RETURN
END IF


dw_master.retrieve(ls_codigo,ls_fecha_inicio,ls_fecha_final)

end event

type sle_prov from singlelineedit within w_ope308_proceso_correcion
event ue_enter pbm_keydown
integer x = 402
integer y = 60
integer width = 343
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_enter;IF Key = KeyEnter! THEN
	Long   ll_count
	String ls_codigo,ls_descrip	

	ls_codigo = sle_prov.text

	select count(*) 
	  into :ll_count
	  from vw_ope_prov_x_operaciones 
	 where codigo = :ls_codigo ;
 
	IF ll_count = 0 THEN
		Messagebox('Aviso','Proveedor No Existe, Verifique! ')
		sle_prov.text = ''
		st_prov.text  = ''	
		Return
	ELSE
		select descripcion
	     into :ls_descrip
	     from vw_ope_prov_x_operaciones 
	    where codigo = :ls_codigo ;
   
		st_prov.text = ls_descrip
	END IF
	
	
	
END IF
end event

type st_prov from statictext within w_ope308_proceso_correcion
integer x = 951
integer y = 64
integer width = 1134
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ope308_proceso_correcion
integer x = 73
integer y = 60
integer width = 329
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor :"
boolean focusrectangle = false
end type

type cb_prov from commandbutton within w_ope308_proceso_correcion
integer x = 805
integer y = 60
integer width = 105
integer height = 68
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT VW_OPE_PROV_X_OPERACIONES.CODIGO      AS CODIGO_PROV     ,'& 
								       +'VW_OPE_PROV_X_OPERACIONES.DESCRIPCION AS DESCRIPCION_PROV '&
										 +'FROM VW_OPE_PROV_X_OPERACIONES '
										 
 
				
OpenWithParm(w_seleccionar,Lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN Lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_prov.text = lstr_seleccionar.param1[1]
	st_prov.text = lstr_seleccionar.param2[1]
END IF
				
end event

type uo_1 from u_ingreso_rango_fechas within w_ope308_proceso_correcion
integer x = 73
integer y = 192
integer width = 1317
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type dw_master from u_dw_abc within w_ope308_proceso_correcion
integer x = 37
integer y = 384
integer width = 3662
integer height = 896
string dataobject = "d_abc_lista_ope_facturacion_tbl"
boolean hscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

type gb_1 from groupbox within w_ope308_proceso_correcion
integer x = 37
integer y = 4
integer width = 2085
integer height = 352
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

