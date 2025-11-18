$PBExportHeader$w_rh101_ctacte_registro_popup.srw
forward
global type w_rh101_ctacte_registro_popup from w_abc
end type
type cb_cancelar from commandbutton within w_rh101_ctacte_registro_popup
end type
type cb_aceptar from commandbutton within w_rh101_ctacte_registro_popup
end type
type st_master from statictext within w_rh101_ctacte_registro_popup
end type
type dw_master from u_dw_abc within w_rh101_ctacte_registro_popup
end type
end forward

global type w_rh101_ctacte_registro_popup from w_abc
integer width = 2752
integer height = 1392
string title = "[RH101] Registro de Cuenta Corriente"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_master st_master
dw_master dw_master
end type
global w_rh101_ctacte_registro_popup w_rh101_ctacte_registro_popup

type variables
str_parametros istr_param
boolean			ibo_saveok
end variables

on w_rh101_ctacte_registro_popup.create
int iCurrent
call super::create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_master=create st_master
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancelar
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.st_master
this.Control[iCurrent+4]=this.dw_master
end on

on w_rh101_ctacte_registro_popup.destroy
call super::destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_master)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  	= newwidth  - dw_master.x - 10
st_master.width 	= dw_master.width

end event

event ue_open_pre;call super::ue_open_pre;Long		ll_row

istr_param = Message.PowerObjectParm

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente


if istr_param.s_action = 'edit' then
	
	dw_master.retrieve(istr_param.string1, istr_param.string2, istr_param.string3)
	dw_master.ii_protect = 1
	dw_master.of_protect()         		
	
else
	
	ll_row = dw_master.event ue_insert()
	
	if ll_row > 0 then
		dw_master.object.cod_trabajador [ll_row] = istr_param.string1
	end if
	
end if



end event

event ue_aceptar;call super::ue_aceptar;str_parametros	lstr_param

this.event ue_update()

if not ibo_saveok then return

lstr_param.b_return = true

closeWithReturn(this, lstr_param)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ibo_saveok = false

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0

	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
	ibo_saveok = true
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_cancelar;call super::ue_cancelar;str_parametros	lstr_param

lstr_param.b_return = false

closeWithReturn(this, lstr_param)
end event

event ue_update_pre;call super::ue_update_pre;Integer 	li_nro_cuotas

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

if dw_master.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el registro", StopSign!)
	return
end if

li_nro_cuotas = Integer(dw_master.object.nro_cuotas [1])

if li_nro_cuotas <= 0 then
	messagebox( "Atencion", "El Nro de Cuotas debe ser Mayor que CERO", StopSign!)
	dw_master.setColumn("nro_cuotas")
	return
end if

ib_update_check = true

dw_master.of_set_flag_replicacion()

end event

type cb_cancelar from commandbutton within w_rh101_ctacte_registro_popup
integer x = 2263
integer y = 1176
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;
parent.event ue_cancelar()

end event

type cb_aceptar from commandbutton within w_rh101_ctacte_registro_popup
integer x = 1847
integer y = 1176
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()

end event

type st_master from statictext within w_rh101_ctacte_registro_popup
integer width = 2693
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "REGISTRO DE CUENTA CORRIENTE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_rh101_ctacte_registro_popup
integer y = 96
integer width = 2693
integer height = 1060
string dataobject = "d_abc_cnta_crrte_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF

end event

event itemchanged;call super::itemchanged;Integer 	li_nro_cuota
Decimal 	ldc_sldo_soles
Date		ld_fecha
String 	ls_cod_trabajador, ls_tipo_doc, ls_nro_doc, &
			ls_codigo, ls_descrip

This.AcceptText()

this.ii_update = 1

This.Object.cod_usr[row] = gs_user 

CHOOSE CASE dwo.name

	CASE 'fec_prestamo'
		This.Object.fec_inicio_descto[row] = date(data)

//	CASE 'tipo_doc'
//		
//		SELECT dt.desc_tipo_doc
//		  INTO :ls_descrip
//		  FROM doc_tipo dt, 
//				 doc_pendientes_cta_cte dp 
//	  	 where dp.tipo_doc 		= dt.tipo_doc 
//			and dp.cod_relacion 	= :ls_cod_trabajador
//		   and dp.tipo_doc 		= :ls_tipo_doc
//			and dp.nro_doc			= :data
//			and dp.flag_debhab 	= 'D'
//			and dt.flag_estado 	= '1';
//		
//		IF SQLCA.SQLCode = 100 THEN
//			MessageBox('Aviso', 'Documento no existe en cuenta corriente. por favor verifique')
//			setNull(ld_fecha)
//			This.Object.nro_doc			[row] = gnvo_app.is_null 
//			this.object.cod_moneda 		[row] = gnvo_app.is_null
//			this.object.monto_original [row] = 0.00
//			this.object.mont_cuota 		[row] = 0.00			
//			this.object.sldo_prestamo	[row] = 0.00
//			this.object.fec_prestamo	[row] = ld_fecha
//			this.SetColumn("nro_doc")
//         This.Setfocus()
//			Return 1
//		END IF
//		
//		this.object.monto_original [row] = ldc_sldo_soles
//		this.object.mont_cuota 		[row] = ldc_sldo_soles
//		this.object.sldo_prestamo	[row] = ldc_sldo_soles
//		this.object.cod_moneda		[row] = gnvo_app.is_soles
//		this.object.fec_prestamo	[row] = ld_fecha
		
//	CASE 'nro_doc'
//		ls_cod_trabajador = This.Object.cod_trabajador[row]
//		ls_tipo_doc 		= This.Object.tipo_doc[row]
//		
//		SELECT dp.sldo_sol, dp.fecha_doc
//		  INTO :ldc_sldo_soles, :ld_fecha
//		  FROM doc_tipo dt, 
//				 doc_pendientes_cta_cte dp 
//	  	 where dp.tipo_doc = dt.tipo_doc 
//			and dp.cod_relacion 	= :ls_cod_trabajador
//		   and dp.tipo_doc 		= :ls_tipo_doc
//			and dp.nro_doc			= :data
//			and dp.flag_debhab 	= 'D'
//			and dt.flag_estado 	= '1';
//		
//		IF SQLCA.SQLCode = 100 THEN
//			MessageBox('Aviso', 'Documento no existe en cuenta corriente. por favor verifique')
//			setNull(ld_fecha)
//			This.Object.nro_doc			[row] = gnvo_app.is_null 
//			this.object.cod_moneda 		[row] = gnvo_app.is_null
//			this.object.monto_original [row] = 0.00
//			this.object.fec_prestamo	[row] = ld_fecha
//			this.SetColumn("nro_doc")
//         This.Setfocus()
//			Return 1
//		END IF
//		
//		this.object.monto_original [row] = ldc_sldo_soles
//		this.object.mont_cuota 		[row] = ldc_sldo_soles
//		this.object.sldo_prestamo	[row] = ldc_sldo_soles
//		this.object.cod_moneda		[row] = gnvo_app.is_soles
//		this.object.fec_prestamo	[row] = ld_fecha
		
		
	CASE 'concep'
		SELECT desc_concep
		  INTO :ls_descrip
		  FROM concepto c 
		 WHERE c.concep=:data 
		   and c.flag_estado = '1';
		
		IF SQLCA.SQlCode = 100 THEN
        MessageBox("Aviso", 'Concepto no existe o no esta activo, por favor verifique') 
		  This.Object.concep				[row] = gnvo_app.is_null
		  this.object.desc_concepto 	[row] = gnvo_app.is_null
		  This.SetColumn("concep")
        This.Setfocus()
		  Return 1
		END IF 
		
		This.Object.desc_concepto		[row] = ls_descrip 

	CASE 'cod_moneda'
		SELECT descripcion
		  INTO :ls_descrip
		  FROM moneda c 
		 WHERE c.cod_moneda 	= :data
		   and c.flag_estado = '1';
		
		IF SQLCA.SQlCode = 100 THEN
        MessageBox("Aviso", 'Codigo de Moneda no existe o no esta activo, por favor verifique') 
		  This.Object.cod_moneda	[row] = gnvo_app.is_null
		  This.SetColumn("cod_moneda")
        This.Setfocus()
		  Return 1
		END IF 
		
	
	CASE 'monto_original'
		ldc_sldo_soles = Dec(data)
		li_nro_cuota 	= Long(This.Object.nro_cuotas[row])
		
		IF li_nro_cuota < 1 THEN
			MessageBox('Aviso', 'Nro de cuota debe ser mayor a 0', StopSign!)
			This.Object.nro_cuotas[row] = 1
			This.Object.mont_cuota[row] = ldc_sldo_soles
			Return 1
		END IF 
		
		This.Object.mont_cuota[row] = ROUND(ldc_sldo_soles / li_nro_cuota,2) 
		
	CASE 'nro_cuotas'
		
		li_nro_cuota = This.Object.nro_cuotas[row]
		
		IF li_nro_cuota < 1 THEN
			MessageBox('Aviso', 'Nro de cuota debe ser mayor a 0', StopSign!)
			This.Object.nro_cuotas[row] = 1
			This.Object.mont_cuota[row] = ldc_sldo_soles
			Return 1
		END IF 
		
		ldc_sldo_soles = Dec(This.Object.monto_original	[row])
		This.Object.mont_cuota[row] = ROUND(ldc_sldo_soles / li_nro_cuota,2) 
		
END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;Long 	ll_row_master
date 	ld_fec_prestamo

ld_fec_prestamo = Date(gnvo_app.of_fecha_actual())

THIS.object.cod_sit_prest		[al_row] = 'A'
THIS.object.flag_estado			[al_row] = '1'
THIS.object.cod_usr				[al_row] = gs_user
THIS.object.porc_normal			[al_row] = 100
THIS.object.porc_gratific		[al_row] = 0.00
this.object.sldo_prestamo		[al_row] = 0.00
THIS.object.porc_utilidad		[al_row] = 0.00
THIS.object.porc_liquidac		[al_row] = 0.00
THIS.object.porc_vacacion		[al_row] = 0.00
THIS.object.porc_otros			[al_row] = 0.00
THIS.object.porc_quincena		[al_row] = 0.00
THIS.object.fec_registro		[al_row] = gnvo_app.of_fecha_actual()
THIS.object.nro_cuotas			[al_row] = 1
THIS.object.fec_prestamo		[al_row] = ld_fec_prestamo
THIS.object.fec_inicio_descto	[al_row] = ld_fec_prestamo
THIS.object.cod_moneda			[al_row] = gnvo_app.is_soles

//Deasctivo los campos

if upper(gs_empresa) <> 'ARCOPA' then
	//Solo ARCOPA va a tener estos campos desactivados
	this.setTabOrder('tipo_doc', 0)
	this.setTabOrder('nro_doc', 0)
	this.setTabOrder('fec_prestamo', 0)
	this.setTabOrder('cod_moneda', 0)
	this.setTabOrder('monto_original', 0)
	this.setTabOrder('mont_cuota', 0)
end if


this.setColumn('tipo_doc')




end event

event ue_display;call super::ue_display;string 	ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, &
			ls_cod_trabajador, ls_tipo_doc, ls_nro_cuotas

choose case lower(as_columna)
	case 'tipo_doc'
		
		ls_cod_trabajador = this.object.cod_trabajador[al_row]
		
		ls_sql = "select distinct dt.tipo_doc as tipo_doc, " &
       		 + "to_char(dp.fecha_emision, 'dd/mm/yyyy') as fecha_documento, " &
       		 + "dp.nro_doc as numero_documento, " &
       		 + "trim(to_char(dp.saldo_sol, '999,990.00')) as saldo_soles, " &
       		 + "nvl(md.nro_cuotas, 1) as nro_cuotas " &
  				 + "from doc_tipo dt, " &
       		 + "vw_fin_pendiente_cobrar dp, " &
       		 + "fin_dpd_masivos_det     md " &
				 + "where dp.tipo_doc     = dt.tipo_doc " &
  				 + "  and dp.tipo_doc     = md.tipo_doc_cxp (+) " &
  				 + "	and dp.nro_doc      = md.nro_doc_cxp  (+) " &
  				 + "  and dp.cod_relacion = md.cod_relacion_cxp (+) " &
				 + "  and dp.cod_relacion = '" + ls_cod_trabajador + "'" 

					
		
		
		if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_nro_cuotas, '3') then
		
			this.object.tipo_doc			[al_row] = ls_return1
			this.object.fec_prestamo	[al_row] = Date(ls_return2)
			this.object.nro_doc			[al_row] = ls_return3
			this.object.cod_moneda		[al_row] = gnvo_app.is_soles
			this.object.monto_original [al_row] = dec(ls_return4)
			this.object.mont_cuota 		[al_row] = dec(ls_return4)
			this.object.sldo_prestamo	[al_row] = dec(ls_return4)
			this.object.nro_cuotas		[al_row] = Integer(ls_nro_cuotas)
			
			this.ii_update = 1
		end if

	case 'nro_doc'
		
		ls_cod_trabajador = this.object.cod_trabajador	[al_row]
		ls_tipo_doc			= this.object.tipo_doc			[al_row]
		
		if IsNull(ls_tipo_doc) then
			MessageBox('Error', 'Debe indicar primero un tipo de Documento, por favor verifique!')
			this.SetColumn('tipo_doc')
			return
		end if
		
		ls_sql = "select distinct dt.tipo_doc as tipo_doc, " &
       		 + "to_char(dp.fecha_emision, 'dd/mm/yyyy') as fecha_documento, " &
       		 + "dp.nro_doc as numero_documento, " &
       		 + "trim(to_char(dp.saldo_sol, '999,990.00')) as saldo_soles, " &
       		 + "nvl(md.nro_cuotas, 1) as nro_cuotas " &
  				 + "from doc_tipo dt, " &
       		 + "vw_fin_pendiente_cobrar dp, " &
       		 + "fin_dpd_masivos_det     md " &
				 + "where dp.tipo_doc     = dt.tipo_doc " &
  				 + "  and dp.tipo_doc     = md.tipo_doc_cxp (+) " &
  				 + "	and dp.nro_doc      = md.nro_doc_cxp  (+) " &
  				 + "  and dp.cod_relacion = md.cod_relacion_cxp (+) " &
				 + "  and dp.cod_relacion = '" + ls_cod_trabajador + "' " &
				 + "  and dp.tipo_doc 	  = '" + ls_tipo_doc + "'" 
					
		if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_nro_cuotas, '3') then
		
			this.object.fec_prestamo	[al_row] = Date(ls_return2)
			this.object.nro_doc			[al_row] = ls_return3
			this.object.cod_moneda		[al_row] = gnvo_app.is_soles
			this.object.monto_original [al_row] = dec(ls_return4)
			this.object.mont_cuota 		[al_row] = dec(ls_return4)
			this.object.sldo_prestamo	[al_row] = dec(ls_return4)
			this.object.nro_cuotas		[al_row] = Integer(ls_nro_cuotas)
			
			this.ii_update = 1
		end if

	case 'concep'
		ls_sql = "select gc.concepto_calc as concepto, " &
				 + "c.desc_breve as descripcion " &
				 + "from grupo_calculo_det gc, " &
				 + "concepto c, "&
				 + "rrhhparam_cconcep rh " &
				 + "where gc.concepto_calc = c.concep " &
				 + "  and rh.reckey = '1' "&
				 + "  and gc.grupo_calculo = rh.cnta_cnte " &
				 + "  and c.flag_estado = '1' "
					
		
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then return
		
		this.object.concep			[al_row] = ls_return1
		this.object.desc_concepto	[al_row] = ls_return2
		this.ii_update = 1
	
	case 'cod_moneda'
		ls_sql = "select cod_moneda as cod_moneda, " &
				 + "descripcion as desc_moneda " &
				 + "from moneda t " &
				 + "where t.flag_estado = '1'"
					
		
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then return
		
		this.object.cod_moneda			[al_row] = ls_return1
		this.ii_update = 1
		
end choose


end event

