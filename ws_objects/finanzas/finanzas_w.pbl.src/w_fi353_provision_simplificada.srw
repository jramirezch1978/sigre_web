$PBExportHeader$w_fi353_provision_simplificada.srw
forward
global type w_fi353_provision_simplificada from w_abc
end type
type rb_all from radiobutton within w_fi353_provision_simplificada
end type
type rb_mios from radiobutton within w_fi353_provision_simplificada
end type
type cb_buscar from commandbutton within w_fi353_provision_simplificada
end type
type sle_mes from singlelineedit within w_fi353_provision_simplificada
end type
type st_3 from statictext within w_fi353_provision_simplificada
end type
type sle_year from singlelineedit within w_fi353_provision_simplificada
end type
type st_4 from statictext within w_fi353_provision_simplificada
end type
type dw_master from u_dw_abc within w_fi353_provision_simplificada
end type
type gb_3 from groupbox within w_fi353_provision_simplificada
end type
end forward

global type w_fi353_provision_simplificada from w_abc
integer width = 3291
integer height = 2372
string title = "[FI353] Provision Simplificada Cntas x Pagar"
string menuname = "m_mantenimiento_sl"
rb_all rb_all
rb_mios rb_mios
cb_buscar cb_buscar
sle_mes sle_mes
st_3 st_3
sle_year sle_year
st_4 st_4
dw_master dw_master
gb_3 gb_3
end type
global w_fi353_provision_simplificada w_fi353_provision_simplificada

type variables
String is_desc_pcon
n_cst_asiento_contable 	invo_asiento_cntbl
end variables

on w_fi353_provision_simplificada.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.rb_all=create rb_all
this.rb_mios=create rb_mios
this.cb_buscar=create cb_buscar
this.sle_mes=create sle_mes
this.st_3=create st_3
this.sle_year=create sle_year
this.st_4=create st_4
this.dw_master=create dw_master
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_all
this.Control[iCurrent+2]=this.rb_mios
this.Control[iCurrent+3]=this.cb_buscar
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_year
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_3
end on

on w_fi353_provision_simplificada.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_all)
destroy(this.rb_mios)
destroy(this.cb_buscar)
destroy(this.sle_mes)
destroy(this.st_3)
destroy(this.sle_year)
destroy(this.st_4)
destroy(this.dw_master)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;Date ld_hoy

invo_asiento_cntbl 	= create n_cst_asiento_contable

ld_hoy = Date(gnvo_App.of_fecha_actual())

dw_master.SetTransObject(sqlca)	// Relacionar el dw con la base de datos
idw_1 = dw_master              	// asignar dw corriente


sle_year.text 	= string(ld_hoy, 'yyyy')
sle_mes.text 	= string(ld_hoy, 'mm')

//Descripcion de la forma de pago PCON
select desc_forma_pago
	into :is_desc_pcon
from forma_pago fp
where fp.forma_pago = :gnvo_app.finparam.is_pcon;

event ue_refresh()



end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
Long		ll_find, ll_row 
String	ls_tipo_doc, ls_serie_cp, ls_numero_cp, ls_proveedor

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

//Obtengo los datos del registro actual
if dw_master.RowCount() > 0 then
	ll_row = dw_master.GetRow()
	ls_tipo_doc 	= dw_master.object.tipo_doc 	[ll_row]
	ls_serie_cp 	= dw_master.object.serie_cp 	[ll_row]
	ls_numero_cp	= dw_master.object.numero_cp 	[ll_row]
	ls_proveedor 	= dw_master.object.proveedor 	[ll_row]
end if

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF not lbo_ok THEN
	ROLLBACK USING SQLCA;
	return
end if

COMMIT using SQLCA;
dw_master.ii_update = 0
dw_master.il_totdel = 0
dw_master.ResetUpdate()

this.event ue_refresh()

if dw_master.RowCount() > 0 then
	ll_find = dw_master.Find("tipo_doc='" + ls_tipo_doc + " and serie_cp='" + ls_serie_cp &
								  + "' and numero_cp='" + ls_numero_cp + "' and proveedor='" &
								  + ls_proveedor, 1, dw_master.RowCount())
	
	if ll_find > 0 then
		dw_master.ScrolltoRow(ll_find)
		dw_master.setRow(ll_find)
		dw_master.SelectRow(0, false)
		dw_master.SelectRow(ll_find, true)
	else
		if dw_master.RowCount() < ll_row then
			ll_row = dw_master.RowCount()
		end if
		dw_master.ScrolltoRow(ll_row)
		dw_master.setRow(ll_row)
		dw_master.SelectRow(0, false)
		dw_master.SelectRow(ll_row, true)
	end if
end if

f_mensaje('Grabación realizada satisfactoriamente', '')


end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

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

event ue_update_pre;call super::ue_update_pre;Long 		ll_row
Integer	li_year, li_mes

ib_update_check = False	
//--VERIFICACION Y ASIGNACION 
IF gnvo_app.of_row_Processing( dw_master) <> true then return

for ll_row = 1 to dw_master.RowCount()
	if dw_master.is_row_new(ll_row) then
		li_year 	= Integer(dw_master.object.ano	[ll_row])
		li_mes	= Integer(dw_master.object.mes	[ll_row])
		
		if invo_asiento_cntbl.of_mes_cerrado( li_year, li_mes, "R") then
			MessageBox('Error', 'El periodo ' + string(li_year) + '-' + string(li_mes) + ' esta cerrado, por favor verifica!', StopSign!)
			dw_master.ScrollToRow(ll_row)
			dw_master.SelectRow(0, false)
			dw_master.SelectRow(ll_row, true)
			return
		end if
	end if
next

ib_update_check = True

dw_master.of_set_flag_replicacion()

end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()

li_protect = integer(dw_master.Object.grupo.Protect)

IF li_protect = 0 THEN
   dw_master.Object.grupo.Protect = 1
END IF 


end event

event ue_insert;//Overriding
Long  ll_row

if trim(sle_year.text) = '' then
	MessageBox('Error', 'Debe indicar un año antes de insertar un registro, por favor verifique!')
	sle_year.setFocus()
	return
end if

if trim(sle_mes.text) = '' then
	MessageBox('Error', 'Debe indicar un mes antes de insertar un registro, por favor verifique!')
	sle_mes.setFocus()
	return
end if

if not (integer(sle_mes.text) >= 1 and integer(sle_mes.text) <= 12) then
	MessageBox('Error', 'Debe indicar un mes VALIDO de insertar un registro, por favor verifique!')
	sle_mes.setFocus()
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_refresh;call super::ue_refresh;String 	ls_usuario
Integer	li_year, li_mes

li_year 	= Integer(sle_year.text)
li_mes 	= Integer(sle_mes.text)

if rb_mios.checked then
	ls_usuario = trim(gs_user) + '%'
else
	ls_usuario = '%%'
end if

dw_master.Retrieve(li_year, li_mes, ls_usuario)
end event

event close;call super::close;Destroy invo_asiento_cntbl
end event

type rb_all from radiobutton within w_fi353_provision_simplificada
integer x = 837
integer y = 108
integer width = 667
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los registros"
end type

type rb_mios from radiobutton within w_fi353_provision_simplificada
integer x = 837
integer y = 36
integer width = 667
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Registros con mi usuario"
boolean checked = true
end type

type cb_buscar from commandbutton within w_fi353_provision_simplificada
integer x = 1902
integer y = 44
integer width = 485
integer height = 140
integer taborder = 30
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;SetPointer(hourglass!)
Parent.Event ue_refresh()
SetPointer(Arrow!)
end event

type sle_mes from singlelineedit within w_fi353_provision_simplificada
integer x = 649
integer y = 76
integer width = 119
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_fi353_provision_simplificada
integer x = 443
integer y = 84
integer width = 192
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_fi353_provision_simplificada
integer x = 233
integer y = 76
integer width = 192
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_fi353_provision_simplificada
integer x = 64
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_fi353_provision_simplificada
integer y = 220
integer width = 3109
integer height = 1760
string dataobject = "d_abc_provision_simpl_tbl"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss     = 1  			// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1]  = 1				// columnas de lectrua de este dw
idw_mst   = dw_master 	// dw_master

end event

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_hoy

ldt_hoy = gnvo_app.of_fecha_actual()

this.object.fec_registro 	[al_row] = ldt_hoy
this.object.fec_emision 	[al_row] = Date(ldt_hoy)

this.object.ano 				[al_row] = Integer(sle_year.text)
this.object.mes 				[al_row] = Integer(sle_mes.text)
this.object.cod_usr 			[al_row] = gs_user
this.object.cod_origen 		[al_row] = gs_origen
this.object.flag_estado		[al_row] = '3'
this.object.flag_pago		[al_row] = '0'
this.object.cod_moneda		[al_row] = gnvo_app.is_soles

this.object.fec_emision 	[al_row] = Date(ldt_hoy)

this.object.tasa_cambio 	[al_row] = gnvo_app.of_tasa_cambio(Date(ldt_hoy))

this.object.base_imponible	[al_row] = 0.00
this.object.impuesto_igv	[al_row] = 0.00
this.object.adq_no_grav		[al_row] = 0.00

this.object.forma_pago		[al_row] = gnvo_app.finparam.is_pcon
this.object.desc_forma_pago[al_row] = is_desc_pcon
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event ue_display;call super::ue_display;boolean 				lb_ret
string 				ls_codigo, ls_data, ls_sql, ls_data2, ls_cencos
Integer				li_year
str_parametros		lstr_param
choose case lower(as_columna)
	case "cod_ctabco"
		ls_sql = "select bc.cod_ctabco as codigo_ctabco, " &
				 + "       bc.descripcion as desc_cnta_bco " &
				 + "from banco_cnta bc " &
				 + "where bc.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_ctabco			[al_row] = ls_codigo
			this.object.desc_banco_cnta	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "proveedor"
		ls_sql = "SELECT p.proveedor AS CODIGO_proveedor, " &
				  + "p.nom_proveedor AS nombre_proveedor, " &
				  + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
				  + "FROM proveedor p " &
				  + "WHERE FLAG_ESTADO = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.ruc_dni			[al_row] = ls_data2
			this.ii_update = 1
		end if
		
	case "forma_pago"
		ls_sql = "select fp.forma_pago as forma_pago, " &
				 + "       fp.desc_forma_pago as desc_forma_pago " &
				 + "  from forma_pago fp " &
				 + " where fp.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.forma_pago			[al_row] = ls_codigo
			this.object.desc_forma_pago	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cencos"
		li_year	= Integer(this.object.ano [al_row])
		
		ls_sql = "select distinct " &
				 + "       cc.cencos as cencos, " &
				 + "       cc.desc_cencos as descripcion_cencos " &
				 + "  from centros_costo cc, " &
				 + "       presupuesto_partida pp " &
				 + " where cc.cencos = pp.cencos " &
				 + "   and pp.ano    = " + string(li_year) &
				 + "   and cc.flag_estado = '1'"


		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cencos		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cnta_prsp"
		li_year		= Integer(this.object.ano 	[al_row])
		ls_Cencos	= this.object.cencos			[al_row]
		
		ls_sql = "select distinct " &
				 + "       pc.cnta_prsp as cnta_prsp, " &
				 + "       pc.descripcion as desc_cuenta_prsp " &
				 + "  from presupuesto_cuenta pc, " &
				 + "        presupuesto_partida pp " &
				 + " where pc.cnta_prsp = pp.cnta_prsp " &
				 + "   and pp.ano    = " + string(li_year) &
				 + "   and pp.cencos = '" + ls_cencos + "'" &
				 + "   and pc.flag_estado = '1'"


		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "centro_benef"
		
		ls_sql = "select cb.centro_benef as centro_benef, " &
				 + "       cb.desc_centro as descripcion_Centro " &
				 + "  from centro_beneficio cb " &
				 + " where cb.flag_estado = '1'"


		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.centro_benef	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cod_moneda"
		
		ls_sql = "select m.cod_moneda as codigo_moneda, " &
				 + "       m.descripcion as descripcion_moneda " &
				 + "  from moneda m " &
				 + " where m.flag_estado = '1'"


		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	CASE 'confin'
		
		/*
			1	Cntas x Cobrar
			2	Cnas x Pagar
			3	Tesoreria
			4	Todos
			5	Letras
			6	Liquidacion de Beneficios
			7	Devengados OS
		*/
		lstr_param.tipo			= 'ARRAY'
		lstr_param.opcion			= 3	
		lstr_param.str_array[1] = '2'		//Cntas x Pagar
		lstr_param.str_array[2] = '4'		//Todos
		lstr_param.titulo 		= 'Selección de Concepto Financiero'
		lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
		lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
		lstr_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			this.ii_update = 1
		END IF
end choose
end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_ruc_dni, ls_Cencos
Integer	li_year, li_mes, li_count
date		ld_fec_emision

this.Accepttext()

CHOOSE CASE dwo.name
	case "base_imponible"
		
		this.object.impuesto_igv			[row] = Dec(data) * gnvo_app.logistica.idc_porc_igv
		
		return 1
		
	case "tipo_doc"
		
		select count(*)
			into :li_count
		from 	doc_tipo dt
		where dt.tipo_doc = :data
		  and dt.flag_estado = '1';

		// Verifica que articulo solo sea de reposicion		
		if li_count = 0 then
			MessageBox('Error', 'TIPO DE DOCUMENTO ' + trim(data) + ' no existe, no esta activo, ' &
									+ ', por favor verifique')
			this.object.tipo_doc			[row] = gnvo_app.is_null
			this.setColumn('tipo_doc')
			return 1
		end if
		
	CASE 'confin'
		SELECT descripcion
		  INTO :ls_data
		  FROM concepto_financiero
		 WHERE confin = :data
		   and flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Concepto Financiero ' + data + ' No Existe o no esta ACTIVO, Verifique!',StopSign!)
			This.Object.confin 		 	[row] = gnvo_app.is_null
			This.Object.desc_confin 	[row] = gnvo_app.is_null
			Return 1
		end if
		
		This.Object.desc_confin 	[row] = ls_data
		
	case "flag_pago"
		IF data = '1' then
			this.object.fec_pago [row] = this.object.fec_emision [row]
		else
			this.object.fec_pago [row] = gnvo_app.id_null
		end if
		
	case "cod_ctabco"
		select bc.descripcion 
			into :ls_data
		from banco_cnta bc 
		where bc.flag_estado = '1'
		  and bc.cod_ctabco  = :data;

		// Verifica que Cnta del banco exista
		if SQLCA.SQLCode = 100 then
			this.object.cod_ctabco			[row] = gnvo_app.is_null
			this.object.desc_banco_cnta	[row] = gnvo_app.is_null
			this.setColumn('cod_ctabco')
			MessageBox('Error', 'Codigo DE CAJA / BANCO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_banco_cnta	[row] = ls_data	
		
	case "fec_emision"
		if IsNull(this.object.ano [row]) or integer(this.object.ano [row]) = 0 then
			MessageBox('Error', 'Debe elegir un AÑO antes de elegir la fecha de emision, por favor verifique!', StopSign!)
			this.object.ano [row] = gnvo_app.il_null
			this.setColumn("ano")
			return 1
		end if
		
		if IsNull(this.object.mes [row]) or integer(this.object.mes [row]) = 0 then
			MessageBox('Error', 'Debe elegir un MES antes de elegir la fecha de emision, por favor verifique!', StopSign!)
			this.object.mes [row] = gnvo_app.il_null
			this.setColumn("mes")
			return 1
		end if
		
		li_year 	= integer(this.object.ano [row])
		li_mes	= integer(this.object.mes [row])
		
		ld_fec_emision = Date(this.object.fec_emision [row])
		
		if string(ld_fec_emision, 'yyyymm') > trim(string(li_year, '00')) + trim(string(li_mes, '00')) then
			MessageBox('Error', 'La Fecha de emisión no puede ser mayor al periodo ' &
									+ trim(string(li_year, '00')) + trim(string(li_mes, '00')) + ', por favor verifique!', StopSign!)
			this.object.fec_emision [row] = gnvo_app.id_null
			this.setColumn("mes")
			return 1
		end if
		
		//Obteniendo la tasa de cambio
		This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fec_emision)
		
	case "proveedor"
		
		SELECT nom_proveedor, decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident)
			into :ls_data, :ls_ruc_dni
		FROM proveedor 
		WHERE FLAG_ESTADO = '1'
		  and proveedor	= :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.proveedor		[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			this.object.ruc_dni			[row] = gnvo_app.is_null
			this.setColumn('proveedor')
			MessageBox('Error', 'Codigo de Proveedor ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_proveedor	[row] = ls_data		  
		this.object.ruc_dni			[row] = ls_ruc_dni		  

	case "forma_pago"
		select fp.desc_forma_pago
			into :ls_data
		from forma_pago fp 
		where fp.flag_estado = '1'
		  and fp.forma_pago	= :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.forma_pago			[row] = gnvo_app.is_null
			this.object.desc_forma_pago	[row] = gnvo_app.is_null
			this.setColumn('forma_pago')
			MessageBox('Error', 'Codigo de FORMA DE PAGO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_forma_pago	[row] = ls_data		  

	case "cencos"
		li_year	= Integer(this.object.ano [row])
		
		select distinct cc.desc_cencos
			into :ls_data
		from 	centros_costo cc, 
				presupuesto_partida pp 
		where cc.cencos 	= pp.cencos 
		  and pp.ano    	= :li_year
		  and pp.cencos	= :data
		  and cc.flag_estado = '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cencos			[row] = gnvo_app.is_null
			this.setColumn('cencos')
			MessageBox('Error', 'CENTRO DE COSTOS ' + trim(data) + ' no existe, no esta activo, '&
									+ 'o no tiene presupuesto activo para el AÑO ' + string(li_year) &
									+ ', por favor verifique')
			return 1
		end if

		
	case "cnta_prsp"
		li_year		= Integer(this.object.ano 	[row])
		ls_Cencos	= this.object.cencos			[row]
		
		select distinct pc.descripcion
			into :ls_data
		from presupuesto_cuenta pc, 
			  presupuesto_partida pp 
		 where pc.cnta_prsp 	= pp.cnta_prsp 
		   and pp.ano    		= :li_year
		   and pp.cencos 		= :ls_Cencos
			and pc.cnta_prsp	= :data
		   and pc.flag_estado = '1';


		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cnta_prsp			[row] = gnvo_app.is_null
			this.setColumn('cnta_prsp')
			MessageBox('Error', 'CUENTA PRESUPUESTAL ' + trim(data) + ' no existe, no esta activo, '&
									+ 'o no tiene presupuesto activo para el AÑO ' + string(li_year) &
									+ ', por favor verifique')
			return 1
		end if

	case "centro_benef"
		
		select cb.desc_centro
			into :ls_data
		  from centro_beneficio cb 
		 where cb.flag_estado 	= '1'
		   and cb.centro_benef 	= :data;


		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.centro_benef			[row] = gnvo_app.is_null
			this.setColumn('centro_benef')
			MessageBox('Error', 'CENTRO DE BENEFICIO ' + trim(data) + ' no existe o no esta activo, ' &
									+ 'por favor verifique')
			return 1
		end if
		
	case "cod_moneda"
		
		select m.descripcion 
			into :ls_Data
		  from moneda m 
		 where m.flag_estado = '1'
		   and m.cod_moneda	= :data;


		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_moneda			[row] = gnvo_app.is_null
			this.setColumn('cod_moneda')
			MessageBox('Error', 'MONEDA' + trim(data) + ' no existe o no esta activo, ' &
									+ 'por favor verifique')
			return 1
		end if
		
END CHOOSE
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

type gb_3 from groupbox within w_fi353_provision_simplificada
integer width = 2432
integer height = 212
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Periodo"
end type

