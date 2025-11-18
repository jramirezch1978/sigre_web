$PBExportHeader$w_ope307_proceso_facturacion.srw
forward
global type w_ope307_proceso_facturacion from w_abc
end type
type cbx_1 from checkbox within w_ope307_proceso_facturacion
end type
type cb_1 from commandbutton within w_ope307_proceso_facturacion
end type
type cb_2 from commandbutton within w_ope307_proceso_facturacion
end type
type sle_prov from singlelineedit within w_ope307_proceso_facturacion
end type
type st_prov from statictext within w_ope307_proceso_facturacion
end type
type st_1 from statictext within w_ope307_proceso_facturacion
end type
type cb_prov from commandbutton within w_ope307_proceso_facturacion
end type
type uo_1 from u_ingreso_rango_fechas within w_ope307_proceso_facturacion
end type
type dw_lista from u_dw_abc within w_ope307_proceso_facturacion
end type
type gb_1 from groupbox within w_ope307_proceso_facturacion
end type
end forward

global type w_ope307_proceso_facturacion from w_abc
integer width = 4343
integer height = 1336
string title = "Proceso de Faturación de Operaciones (ope307)"
string menuname = "m_cns"
cbx_1 cbx_1
cb_1 cb_1
cb_2 cb_2
sle_prov sle_prov
st_prov st_prov
st_1 st_1
cb_prov cb_prov
uo_1 uo_1
dw_lista dw_lista
gb_1 gb_1
end type
global w_ope307_proceso_facturacion w_ope307_proceso_facturacion

on w_ope307_proceso_facturacion.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.sle_prov=create sle_prov
this.st_prov=create st_prov
this.st_1=create st_1
this.cb_prov=create cb_prov
this.uo_1=create uo_1
this.dw_lista=create dw_lista
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.sle_prov
this.Control[iCurrent+5]=this.st_prov
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_prov
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.dw_lista
this.Control[iCurrent+10]=this.gb_1
end on

on w_ope307_proceso_facturacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.sle_prov)
destroy(this.st_prov)
destroy(this.st_1)
destroy(this.cb_prov)
destroy(this.uo_1)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_lista.Settransobject(sqlca)
idw_1 = dw_lista

of_position_window(0,0)       			// Posicionar la ventana en forma fija



end event

event resize;call super::resize;dw_lista.width  = newwidth  - dw_lista.x - 10
dw_lista.height = newheight - dw_lista.y - 10
end event

type cbx_1 from checkbox within w_ope307_proceso_facturacion
boolean visible = false
integer x = 2642
integer y = 40
integer width = 814
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Operaciones Para Sembradores"
end type

event clicked;cb_2.event clicked( )
end event

type cb_1 from commandbutton within w_ope307_proceso_facturacion
integer x = 3118
integer y = 152
integer width = 329
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String  ls_expresion,ls_oper_sec,ls_descripcion,ls_msj_err,ls_und,ls_flag
Long    ll_inicio,ll_row,ll_count
Integer li_item,li_opcion
Decimal {2} ldc_precio,ldc_cantidad

li_opcion = Messagebox('Aviso','Esta Seguro de Procesar Operaciones Para Facturar ',Question!,YesNo!,2)


IF li_opcion = 2 THEN RETURN

dw_lista.Accepttext()

//FILTRAR OPERACIONES MARCADAS PARA FACTURAR
ls_expresion = "flag = "+"'"+'1'+"'"
dw_lista.SetFilter(ls_expresion)
dw_lista.Filter()



For ll_inicio = 1 to dw_lista.Rowcount()
	 ls_oper_sec	 = dw_lista.object.oper_sec    [ll_inicio]
	 ldc_precio		 = dw_lista.object.precio      [ll_inicio]
	 ls_descripcion = dw_lista.object.descripcion [ll_inicio]
	 ldc_cantidad	 = dw_lista.object.cantidad    [ll_inicio]
	 ls_und			 = dw_lista.object.und		    [ll_inicio]
	 ls_flag			 = dw_lista.object.flag_fact   [ll_inicio]
	 
	 if ls_flag <> 'N' THEN //FACTURABLE
		 //buscar nro de item
		 select count(*) into :ll_count from facturacion_operacion where (oper_sec = :ls_oper_sec) ;
	 
		 IF ll_count > 0 THEN
			 select max(item) into :li_item from facturacion_operacion where (oper_sec = :ls_oper_sec) ;
			 //incementar
			 li_item = li_item + 1
		 
		 ELSE
		    li_item = 1 
		 END IF	
	 
		 
		 Insert into facturacion_operacion
		 (oper_sec,item,precio,descripcion,cantidad,und , flag_replicacion )
		 Values
		 (:ls_oper_sec,:li_item,:ldc_precio,:ls_descripcion,:ldc_cantidad,:ls_und, '1') ;
	 
		 IF SQLCA.SQLCode = -1 THEN 
			 ls_msj_err = SQLCA.SQLErrText
			 Rollback ;
			 MessageBox('SQL error 1',ls_msj_err)
			 Exit
		 END IF
		 
	 END IF	
Next






IF dw_lista.Rowcount() > 0 THEN
	Commit ;
END IF

dw_lista.SetFilter('')
dw_lista.Filter()

//NO FACTURABLE MARCARLOS EN OPERACIONES
ls_expresion = "flag_fact = "+"'"+'N'+"'"
dw_lista.SetFilter(ls_expresion)
dw_lista.Filter()

FOR ll_inicio = 1 TO dw_lista.Rowcount()
 	 ls_oper_sec	 = dw_lista.object.oper_sec    [ll_inicio]		
	  
	 UPDATE OPERACIONES
	    SET FLAG_FACTURACION = 'N' , FLAG_REPLICACION = '1'
	  WHERE (OPER_SEC = :ls_oper_sec) ;
	  
NEXT	

IF dw_lista.Rowcount() > 0 THEN
	Commit ;
END IF

dw_lista.SetFilter('')
dw_lista.Filter()

cb_2.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_ope307_proceso_facturacion
integer x = 2597
integer y = 152
integer width = 503
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar Operaciones"
end type

event clicked;String ls_codigo, ls_ejecutor, ls_fecha_inicio, ls_fecha_final

ls_codigo       = sle_prov.text
ls_fecha_inicio = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fecha_final  = String(uo_1.of_get_fecha2(),'yyyymmdd')
SELECT ejecutor_3ro INTO :ls_ejecutor FROM prod_param WHERE reckey='1' ;

IF Isnull(ls_codigo) or Trim(ls_codigo) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Trabajador , Verifique!')
	RETURN
END IF

//operaciones para sembradores
if cbx_1.checked then
	dw_lista.dataobject = 'd_abc_lista_ope_x_facturar_x_semb_tbl'
else //operaciones no facturadas
	dw_lista.dataobject = 'd_abc_lista_operaciones_x_fact_tbl'
end if

dw_lista.Settransobject(sqlca)
dw_lista.retrieve(ls_codigo, ls_ejecutor, ls_fecha_inicio, ls_fecha_final)

end event

type sle_prov from singlelineedit within w_ope307_proceso_facturacion
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

type st_prov from statictext within w_ope307_proceso_facturacion
integer x = 951
integer y = 64
integer width = 1170
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

type st_1 from statictext within w_ope307_proceso_facturacion
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

type cb_prov from commandbutton within w_ope307_proceso_facturacion
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

type uo_1 from u_ingreso_rango_fechas within w_ope307_proceso_facturacion
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

type dw_lista from u_dw_abc within w_ope307_proceso_facturacion
integer x = 37
integer y = 384
integer width = 4261
integer height = 704
string dataobject = "d_abc_lista_operaciones_x_fact_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_lista

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()


choose case dwo.name
		 case 'flag'
				
		
end choose

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event doubleclicked;call super::doubleclicked;Long ll_row_ins

IF row = 0 then return

choose case dwo.name
		 case 'b_duplicar'
			
				ll_row_ins = this.InsertRow(0)
				
				this.object.nro_orden 		    [ll_row_ins] = this.object.nro_orden 		     [row]
				this.object.cod_labor 		    [ll_row_ins] = this.object.cod_labor 		     [row]
				this.object.desc_operacion     [ll_row_ins] = this.object.desc_operacion     [row]
				this.object.cod_ejecutor	    [ll_row_ins] = this.object.cod_ejecutor	     [row]
				this.object.oper_sec			    [ll_row_ins] = this.object.oper_sec			  [row]
				this.object.cant_real		    [ll_row_ins] = this.object.cant_real		     [row]
				this.object.und					 [ll_row_ins] = this.object.und					  [row]
				this.object.val_venta_und_oper [ll_row_ins] = this.object.val_venta_und_oper [row]
				this.object.avance_actual      [ll_row_ins] = this.object.avance_actual      [row]
				this.object.und_has				 [ll_row_ins] = this.object.und_has				  [row]
				this.object.val_venta_avance	 [ll_row_ins] = this.object.val_venta_avance	  [row]
				this.object.fec_inicio			 [ll_row_ins] = this.object.fec_inicio			  [row]
				this.object.cantidad				 [ll_row_ins] = this.object.cantidad			  [row]
				this.object.precio				 [ll_row_ins] = this.object.precio				  [row]
				this.object.flag					 [ll_row_ins] = this.object.flag					  [row]
				this.object.flag_duplicar      [ll_row_ins] = '1'
				
				this.Scrolltorow(ll_row_ins)
end choose

end event

event retrieverow;call super::retrieverow;This.object.descripcion [row] = This.object.desc_operacion [row]
end event

type gb_1 from groupbox within w_ope307_proceso_facturacion
integer x = 37
integer width = 2194
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

