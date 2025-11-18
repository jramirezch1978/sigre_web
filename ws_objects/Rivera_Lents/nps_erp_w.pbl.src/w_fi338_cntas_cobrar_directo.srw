$PBExportHeader$w_fi338_cntas_cobrar_directo.srw
forward
global type w_fi338_cntas_cobrar_directo from w_abc
end type
type cb_1 from commandbutton within w_fi338_cntas_cobrar_directo
end type
type tab_1 from tab within w_fi338_cntas_cobrar_directo
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_referencia from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_referencia dw_referencia
end type
type tab_1 from tab within w_fi338_cntas_cobrar_directo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_fi338_cntas_cobrar_directo
end type
end forward

global type w_fi338_cntas_cobrar_directo from w_abc
integer width = 3438
integer height = 1872
string title = "Cuentas x Cobrar Directo (FI338)"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
end type
global w_fi338_cntas_cobrar_directo w_fi338_cntas_cobrar_directo

type variables
String is_accion
DatawindowChild idw_forma_pago
end variables

forward prototypes
public function decimal wf_total ()
public function boolean wf_asigna_registro ()
end prototypes

event ue_anular();Long   ll_inicio,ll_row_master
String ls_flag_estado

ll_row_master = dw_master.getrow()
IF ll_row_master = 0.00 THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row_master] 

IF ls_flag_estado <> '1' THEN 
   Messagebox('Aviso','No se Puede Anular Documento Revise En que estado se Encuentra')
	Return
END IF

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF

dw_master.object.flag_estado [ll_row_master] = '0' 
dw_master.object.importe_doc [ll_row_master] = 0.00
dw_master.object.saldo_sol   [ll_row_master] = 0.00
dw_master.object.saldo_dol   [ll_row_master] = 0.00


FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 tab_1.tabpage_1.dw_detail.object.precio_unitario [ll_inicio] = 0.00
NEXT	

dw_master.ii_update = 1
tab_1.tabpage_1.dw_detail.ii_update = 1

is_accion = 'delete'
end event

public function decimal wf_total ();Long    ll_inicio
Decimal {2} ldc_importe = 0.00,ldc_total_importe = 0.00

For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ldc_importe = tab_1.tabpage_1.dw_detail.object.precio_unitario [ll_inicio]
	 IF Isnull(ldc_importe) THEN ldc_importe = 0.00
	 ldc_total_importe = ldc_total_importe + ldc_importe 
Next	


Return ldc_total_importe
end function

public function boolean wf_asigna_registro ();Long   ll_nro_ce = 0
String ls_lock_table,ls_tipo_doc


ls_tipo_doc = dw_master.object.tipo_doc [1]

ls_lock_table = 'LOCK TABLE NUM_DOC_TIPO IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;


SELECT ultimo_numero
  INTO :ll_nro_ce
  FROM num_doc_tipo
 WHERE tipo_doc = :ls_tipo_doc ;

  
IF Isnull(ll_nro_ce) OR ll_nro_ce = 0 THEN
	Messagebox('Aviso','Verificar Información En Tabla NUM_DOC_TIPO, Comuniquese Con Sistemas')	
	Rollback ;
	Return FALSE
ELSE
	UPDATE num_doc_tipo
	   SET ultimo_numero = ultimo_numero + 1
	 WHERE tipo_doc = :ls_tipo_doc ;
	 
	IF SQLCA.SQLCode = -1 THEN 
		MessageBox("SQL error", SQLCA.SQLErrText)
		Rollback ;
		Return FALSE
	END IF	 
	 
END IF

dw_master.object.nro_doc [1] = gnvo_app.is_origen+f_llena_caracteres('0',Trim(String(ll_nro_ce)),8)

Return TRUE
end function

on w_fi338_cntas_cobrar_directo.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi338_cntas_cobrar_directo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_2.dw_referencia.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija


//** Insertamos GetChild de Forma de Pago **//
dw_master.Getchild('forma_pago',idw_forma_pago)
idw_forma_pago.settransobject(sqlca)
idw_forma_pago.Retrieve()
//** **//
end event

event ue_update_pre;call super::ue_update_pre;String  ls_soles,ls_dolares,ls_cod_relacion,ls_tipo_doc,ls_nro_doc,&
		  ls_cod_moneda,ls_flag,ls_flag_estado,ls_flag_llave_num
Long    ll_inicio		  
Decimal {2} ldc_importe_doc,ldc_saldo_sol,ldc_saldo_dol
Decimal {3} ldc_tasa_cambio

IF dw_master.Rowcount() = 0 THEN RETURN

f_monedas(ls_soles,ls_dolares)

//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF


//Verificación de Data en Cabecera de Documento
IF f_row_Processing( tab_1.tabpage_1.dw_detail, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

ls_cod_relacion = dw_master.Object.cod_relacion [1] 
ls_tipo_doc     = dw_master.Object.tipo_doc		[1] 
ls_nro_doc      = dw_master.Object.nro_doc  	   [1] 
ldc_importe_doc = dw_master.Object.importe_doc  [1] 
ls_cod_moneda	 = dw_master.Object.cod_moneda   [1] 
ldc_tasa_cambio = dw_master.Object.tasa_cambio  [1] 
ls_flag_estado	 = dw_master.Object.flag_estado  [1] 

IF is_accion = 'new' THEN 
	//asignar nro de documento de acuerado a flag
	ls_flag = f_tdoc_fnum(ls_tipo_doc)
	
	IF ls_flag = '1' THEN
		/*Asigna Nro de Doc*/
		IF wf_asigna_registro () = FALSE THEN
			ib_update_check = False	
			return		
		END IF	
	END IF

	ls_nro_doc = dw_master.Object.nro_doc [1] 
END IF

//nro de docuemnto no puede ser nulo
IF Isnull(ls_nro_doc) OR Trim(ls_nro_doc) = '' THEN
	Messagebox('Aviso','Nro de Documento No Puede Ser Nulo , Verifique')
	ib_update_check = False	
	Return
END IF


IF (Isnull(ldc_importe_doc) OR ldc_importe_doc = 0.00 ) AND ls_flag_estado <> '0' THEN
	Messagebox('Aviso','Debe Ingresar Detalle del Documento , Verifique!')
	ib_update_check = False	
	Return
END IF


IF ls_cod_moneda = ls_soles THEN 
	ldc_saldo_sol = ldc_importe_doc
	ldc_saldo_dol = Round(ldc_importe_doc / ldc_tasa_cambio ,2)
ELSEIF ls_cod_moneda = ls_dolares THEN
	ldc_saldo_sol = Round(ldc_importe_doc *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_importe_doc
END IF

//saldos
dw_master.object.saldo_sol [1] = ldc_saldo_sol 
dw_master.object.saldo_dol [1] = ldc_saldo_dol

//detalle
For ll_inicio = 1  TO tab_1.tabpage_1.dw_detail.Rowcount()

	 tab_1.tabpage_1.dw_detail.object.tipo_doc [ll_inicio] =	ls_tipo_doc
	 tab_1.tabpage_1.dw_detail.object.nro_doc	 [ll_inicio] = ls_nro_doc
Next	

//referencia
For ll_inicio = 1  TO tab_1.tabpage_2.dw_referencia.Rowcount()
    tab_1.tabpage_2.dw_referencia.object.cod_relacion [ll_inicio] = ls_cod_relacion
	 tab_1.tabpage_2.dw_referencia.object.tipo_doc 	   [ll_inicio] = ls_tipo_doc
	 tab_1.tabpage_2.dw_referencia.object.nro_doc	 	[ll_inicio] = ls_nro_doc
Next	



select flag_llave_num into :ls_flag_llave_num from doc_tipo where (tipo_doc = :ls_tipo_doc ) ;


IF ls_flag_llave_num = '0' AND tab_1.tabpage_2.dw_referencia.Rowcount() > 0 THEN
	Messagebox('Aviso','Documento no pide Referencia ,Verifique!')
	ib_update_check = False	
	return
ELSEIF ls_flag_llave_num = '1' AND tab_1.tabpage_2.dw_referencia.Rowcount() = 0 THEN
	Messagebox('Aviso','Documento pide Referencia ,Verifique!')
	ib_update_check = False	
	return	
END IF




/*REPLICACION*/
dw_master.of_set_flag_replicacion ()
tab_1.tabpage_1.dw_detail.of_set_flag_replicacion ()
tab_1.tabpage_2.dw_referencia.of_set_flag_replicacion ()
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = tab_1.tabpage_2.dw_referencia THEN RETURN

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF



IF idw_1 = dw_master THEN
	TriggerEvent('ue_update_request')
	IF ib_update_check = FALSE THEN RETURN
	idw_1.Reset ()
	tab_1.tabpage_1.dw_detail.Reset ()
	is_accion = 'new'
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	 tab_1.tabpage_2.dw_referencia.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update = 0
		tab_1.tabpage_2.dw_referencia.ii_update = 0
	END IF
END IF

end event

event ue_delete;//override
Long   ll_row,ll_row_master
String ls_flag_estado

IF idw_1 = dw_master then return

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN RETURN
ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

IF ls_flag_estado <> '1' THEN RETURN

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 50

dw_master.width  = newwidth  - dw_master.x - 10
tab_1.tabpage_1.dw_detail.height 	 = newheight - tab_1.tabpage_1.dw_detail.y     - 750
tab_1.tabpage_1.dw_detail.width  	 = newwidth  - tab_1.tabpage_1.dw_detail.x     - 50
tab_1.tabpage_2.dw_referencia.width  = newwidth  - tab_1.tabpage_2.dw_referencia.x - 50
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF	

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_1.dw_detail.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF tab_1.tabpage_2.dw_referencia.ii_update = 1 THEN
	IF tab_1.tabpage_2.dw_referencia.Update() = -1 then		// Grabacion de Referencia
		lbo_ok = FALSE
		messagebox("Error en Grabacion Referencia","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_referencia.ii_update = 0
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_insert_pos;call super::ue_insert_pos;if idw_1 = dw_master then
	dw_master.setcolumn('cod_relacion')
	dw_master.setfocus()
end if
end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio
String ls_cencos,ls_cnta_prsp
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_doc_cobrar_dir_tbl'
sl_param.titulo = 'Cuentas x Cobrar Directo'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc



OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_1.dw_detail.Retrieve(sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_2.dw_referencia.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	dw_master.il_row = dw_master.getrow()
	TriggerEvent('ue_modify')
	is_accion = 'fileopen'	
END IF


end event

event ue_modify;call super::ue_modify;Long    ll_row_master
Integer li_protect
String  ls_flag_estado,ls_tipo_doc,ls_flag

ll_row_master = dw_master.Getrow()

ls_flag_estado = dw_master.Object.flag_estado [ll_row_master] 
ls_tipo_doc    = dw_master.Object.tipo_doc    [ll_row_master] 

dw_master.of_protect()
tab_1.tabpage_1.dw_detail.of_protect()

IF ls_flag_estado <> '1' THEN
	dw_master.ii_protect  = 0
	tab_1.tabpage_1.dw_detail.ii_protect	 = 0
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	
	
ELSE
	IF is_accion = 'fileopen' THEN
		li_protect = integer(dw_master.Object.tipo_doc.Protect)
		IF li_protect = 0	THEN
			dw_master.object.tipo_doc.Protect 	  = 1
			dw_master.object.cod_relacion.Protect = 1
			dw_master.object.nro_doc.Protect      = 1
		END IF
		
	END IF		
END IF	
end event

event ue_delete_pos;call super::ue_delete_pos;dw_master.object.importe_doc [1] = wf_total ()
dw_master.ii_update = 1
end event

event ue_print;call super::ue_print;String  ls_tip_doc ,ls_nro_doc
Str_cns_pop lstr_cns_pop
Long ll_row_master

ll_row_master = dw_master.Getrow ()
IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 THEN 
	Messagebox('Aviso','Debe Grabar el Documento , Tiene Modificaciones , Verifique!')
	Return
END IF	


//Verificacion de comprobante de Egreso
ls_tip_doc      = dw_master.object.tipo_doc		[ll_row_master]
ls_nro_doc       = dw_master.object.nro_doc		[ll_row_master]


lstr_cns_pop.arg[1] = trim(ls_tip_doc)
lstr_cns_pop.arg[2] = trim(ls_nro_doc)



OpenSheetWithParm(w_fi724_rpt_cobrar_directo, lstr_cns_pop, this, 2, Original!)
end event

type cb_1 from commandbutton within w_fi338_cntas_cobrar_directo
integer x = 2999
integer y = 32
integer width = 384
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Referencias"
end type

event clicked;Long    ll_row_master
String  ls_cod_relacion,ls_flag_estado,ls_tipo_doc,ls_flag_llave_num
str_parametros sl_param

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN Return



ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_tipo_doc		 = dw_master.object.tipo_doc	   [ll_row_master]




IF tab_1.tabpage_2.dw_referencia.Rowcount() > 1 THEN
	Messagebox('Aviso','Ya Existe Referencia..Verifique!')
END IF

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Relacion ,Verifique!')
	Return
END IF

IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Documento ,Verifique!')
	Return
END IF



IF ls_flag_estado = '0' THEN
	Messagebox('Aviso','Documento se encuentra Anulado ,Verifique!')
	Return
END IF

select flag_llave_num into :ls_flag_llave_num from doc_tipo where (tipo_doc = :ls_tipo_doc ) ;

IF ls_flag_llave_num = '0' THEN
	Messagebox('Aviso','Documento no pide Referencia ,Verifique!')
	Return
END IF


sl_param.string1 = ls_cod_relacion


sl_param.dw1		= 'd_lista_orden_venta_pendientes_tbl'
sl_param.titulo	= 'Ordenes de Venta Pendientes x Proveedor '
sl_param.tipo 		= '1OV'
sl_param.opcion   = 19  //ORDENES DE VENTA
sl_param.db1 		= 1350
sl_param.dw_m		= tab_1.tabpage_2.dw_referencia


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	tab_1.tabpage_2.dw_referencia.ii_update = 1
END IF

end event

type tab_1 from tab within w_fi338_cntas_cobrar_directo
integer x = 14
integer y = 612
integer width = 3351
integer height = 1036
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3314
integer height = 916
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer x = 18
integer y = 8
integer width = 3291
integer height = 892
integer taborder = 20
string dataobject = "d_abc_cntas_cobrar_det_dir_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event itemchanged;call super::itemchanged;String ls_null
Long   ll_count

SetNull(ls_null)

Accepttext()

choose case dwo.name
		 case 'precio_unitario'
				dw_master.object.importe_doc [1] = wf_total ()
				dw_master.ii_update = 1

		 case	'centro_benef'	
				select count (*) into :ll_count
					  from centro_beneficio cb,centro_benef_usuario cbu
				    where (cb.centro_benef = cbu.centro_benef ) AND
       					 (cbu.cod_usr     = :gnvo_app.is_user			 ) AND
							 (cb.centro_benef	= :data				 ) ;
						 
			   if ll_count = 0 then
					Messagebox('Aviso','Centro Beneficio No Existe ,Verifique!')
					This.Object.centro_benef [row] = ls_null
					Return 1
				end if				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Long    ll_row
Integer li_item

ll_row = This.RowCount()

IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = Getitemnumber(ll_row - 1,"item")
END IF


   
This.SetItem(al_row, "item", li_item + 1)  
this.object.cantidad [al_row] = 1

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String 		  ls_name,ls_prot

str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = dw_detail.Describe( ls_name + ".Protect")


if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'centro_benef'
				lstr_seleccionar.s_seleccion = 'S'
										 
				lstr_seleccionar.s_sql = 'SELECT CB.CENTRO_BENEF AS CODIGO,CB.DESC_CENTRO AS DESCRIPCION '&
												    +'FROM CENTRO_BENEFICIO CB,CENTRO_BENEF_USUARIO CBU '&
											       +'WHERE (CB.CENTRO_BENEF = CBU.CENTRO_BENEF) AND '&
													 +' 		(CBU.COD_USR     = '+"'"+ gnvo_app.is_user +"')"
												 
												 
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
   			IF lstr_seleccionar.s_action = "aceptar" THEN
	   	   	Setitem(row,'centro_benef',lstr_seleccionar.param1[1])
		    		ii_update = 1
				
		    	END IF
				
				
END CHOOSE



end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3314
integer height = 916
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_referencia dw_referencia
end type

on tabpage_2.create
this.dw_referencia=create dw_referencia
this.Control[]={this.dw_referencia}
end on

on tabpage_2.destroy
destroy(this.dw_referencia)
end on

type dw_referencia from u_dw_abc within tabpage_2
integer x = 18
integer y = 20
integer width = 1650
integer height = 892
integer taborder = 20
string dataobject = "d_abc_referencias_x_cobrar_directo_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1		// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7

idw_mst = tab_1.tabpage_2.dw_referencia
//idw_det  =  				// dw_detail

end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;RETURN 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_fi338_cntas_cobrar_directo
integer x = 27
integer y = 16
integer width = 2944
integer height = 572
string dataobject = "d_abc_cntas_cobrar_cab_dir_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                      	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)




ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event itemchanged;call super::itemchanged;String      ls_nom_proveedor, ls_forma_pago ,ls_codigo,ls_flag
Date        ld_fecha_emision, ld_fecha_vencimiento,ld_fecha_emision_old
Decimal {3} ldc_tasa_cambio
Integer		li_dias_venc , li_opcion
Long        ll_count,ll_inicio


ld_fecha_emision_old = Date(This.Object.fecha_documento [row])			
Accepttext()

CHOOSE CASE dwo.name
		 CASE 'tipo_doc'
				select Count(*) into :ll_count
				  from doc_grupo dg, doc_grupo_relacion dgr, finparam fp ,doc_tipo dt
				 where (dg.grupo     = dgr.grupo             ) and
				       (dg.grupo     = fp.doc_grp_cob_directo) and
						 (dgr.tipo_doc	= dt.tipo_doc				) and
						 (dt.factor		= 1							) and
						 (dgr.tipo_doc = :data                 ) ;
						 
				if ll_count = 0 then
					SetNull(ls_flag)
					This.object.tipo_doc [row] = ls_flag
					Messagebox('Aviso','Documento No Existe en Grupo de Documento x Pagar , Verifique!')
					Return 1
				end if
			
			
				ls_flag = f_tdoc_fnum(data)
				
				IF ls_flag = '1' THEN
					dw_master.object.nro_doc.Protect      = 1	
					dw_master.object.nro_doc.Background.Color = rgb(155,155,155)
				ELSE
					dw_master.object.nro_doc.Protect      = 0		
					dw_master.object.nro_doc.Background.Color = rgb(255,255,255)
				END IF
				
				//setear a nulo nro de doc
				setnull(ls_flag)
				This.Object.nro_doc [row] = ls_flag
				
		 CASE 'cod_relacion'

				SELECT pr.nom_proveedor
				  INTO :ls_nom_proveedor
				  FROM proveedor pr
				 WHERE (pr.proveedor   = :data ) and
				 		 (pr.flag_estado = '1'   ) ; 
						 
				
				IF Isnull(ls_nom_proveedor) OR Trim(ls_nom_proveedor) = '' THEN
					Messagebox('Aviso','Proveedor No Existe , Verifique!')
					setnull(ls_flag)
					This.Object.cod_relacion [row] = ls_flag
					Return 1
				ELSE
					This.Object.nombre [row] = ls_nom_proveedor
				END IF

		 CASE	'fecha_documento'
				
				ld_fecha_emision     = Date(This.Object.fecha_documento   [row])			
				ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
				ls_forma_pago			= This.Object.forma_pago [row]	
				
				IF ld_fecha_emision > ld_fecha_vencimiento THEN
					This.Object.fecha_documento [row] = ld_fecha_emision_old
					Messagebox('Aviso','Fecha de Emisión del Documento No '&
											+'Puede Ser Mayor a la Fecha de Vencimiento')
					Return 1
				END IF

				
				This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)
				
				IF Not (Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
					li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
				
					IF li_dias_venc > 0 THEN
						li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
						
						IF li_opcion = 1 THEN
							ld_fecha_emision = Date(This.object.fecha_documento[row])
							ld_fecha_vencimiento = Relativedate(ld_fecha_emision,li_dias_venc)
							This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
						END IF
					END IF	
				END IF
				
				

		 CASE 'fecha_vencimiento'	
				ld_fecha_emision     = Date(This.Object.fecha_documento   [row])			
				ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
				
				IF ld_fecha_vencimiento < ld_fecha_emision THEN
					This.Object.fecha_vencimiento [row] = ld_fecha_emision
					Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
											+'Puede Ser Menor a la Fecha de Emisión')
					Return 1
				END IF
				
				
		 CASE	'forma_pago'
			
				li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
				
				
					
				IF li_dias_venc > 0 THEN
					
					li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
					IF li_opcion = 1 THEN
						ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_documento[row]),li_dias_venc)
						This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
					END IF
				ELSE
					This.Object.fecha_vencimiento [row] = This.object.fecha_documento[row]
				END IF
				

END CHOOSE

				
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String      ls_name ,ls_prot ,ls_flag
Date		   ld_fecha_emision ,ld_fecha_vencimiento	
Decimal {3} ldc_tasa_cambio

Str_seleccionar lstr_seleccionar
Datawindow		 ldw	

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'tipo_doc'
			   lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_X_GRUPO_COBRAR.TIPO_DOC AS CODIGO_DOC,'&
			  											+'VW_FIN_DOC_X_GRUPO_COBRAR.DESC_TIPO_DOC AS DESCRIPCION '&
			   										+'FROM VW_FIN_DOC_X_GRUPO_COBRAR '  
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
				   ii_update = 1
					//
					ls_flag = f_tdoc_fnum(lstr_seleccionar.param1[1])
				
					IF ls_flag = '1' THEN
						dw_master.object.nro_doc.Protect      = 1	
						dw_master.object.nro_doc.Background.Color = rgb(155,155,155)
					ELSE
						dw_master.object.nro_doc.Protect      = 0		
						dw_master.object.nro_doc.Background.Color = rgb(255,255,255)
					END IF
				
					//setear a nulo nro de doc
					setnull(ls_flag)
					This.Object.nro_doc [row] = ls_flag					
					
			   END IF	

		 CASE 'cod_relacion'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CODIGO_RELACION.COD_RELACION AS PROVEEDOR , '&
								   					 +'CODIGO_RELACION.NOMBRE AS NOM_PROVEEDOR '&
									   				 +'FROM CODIGO_RELACION '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'nombre',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE	'fecha_documento'
				ld_fecha_emision = Date(This.Object.fecha_documento [row])				
				ldw = This
				
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
				IF ld_fecha_emision <> Date(This.Object.fecha_documento [row]) THEN
					
					ld_fecha_emision     = Date(This.Object.fecha_documento   [row])				
					ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
					
					
					IF ld_fecha_emision > ld_fecha_vencimiento THEN
						This.Object.fecha_documento [row] = ld_fecha_vencimiento
						
						Messagebox('Aviso','Fecha de Emisión del Documento No '&
												+'Puede Ser Mayor a la Fecha de Vencimiento')
					END IF
					
					ld_fecha_emision     = Date(This.Object.fecha_documento [row])									
					This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)	
					
					This.ii_update = 1
			   END IF			
				
		 CASE 'fecha_vencimiento'	
				ld_fecha_vencimiento = Date(This.Object.fecha_vencimiento [row])				
				
				ldw = This
				
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
				IF ld_fecha_vencimiento <> Date(This.Object.vencimiento [row])	THEN
					ld_fecha_emision     = Date(This.Object.fecha_emision     [row])			
					ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
				
					IF ld_fecha_vencimiento < ld_fecha_emision THEN
						This.Object.fecha_vencimiento [row] = ld_fecha_emision
						
						Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
												+'Puede Ser Menor a la Fecha de Emisión')
												
					END IF					
					This.ii_update = 1
				END IF		
			
							
END CHOOSE


end event

event ue_insert_pre;call super::ue_insert_pre;This.object.flag_estado       [al_row] = '1'
This.object.flag_provisionado [al_row] = 'D'
This.object.cod_usr           [al_row] = gnvo_app.is_user
This.object.origen            [al_row] = gnvo_app.is_origen
This.object.fecha_registro    [al_row] = DateTime(gnvo_app.id_fecha, now())
This.object.fecha_documento   [al_row] = DateTime(gnvo_app.id_fecha, now())

This.object.tasa_cambio       [al_row] = f_tasa_cambio()
This.object.flag_caja_bancos  [al_row] = '0'


//BLOQUEAR NRO DE DOCUMENTO...SE HABILITARA DE ACUERDO A DOCUMENTO
dw_master.object.nro_doc.Protect = 1
dw_master.object.nro_doc.Background.Color = rgb(155,155,155)
end event

event itemerror;call super::itemerror;Return 1
end event

