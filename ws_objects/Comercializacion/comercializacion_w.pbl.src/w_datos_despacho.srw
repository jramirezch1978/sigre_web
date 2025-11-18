$PBExportHeader$w_datos_despacho.srw
forward
global type w_datos_despacho from w_abc
end type
type cb_cancelar from commandbutton within w_datos_despacho
end type
type cb_aceptar from commandbutton within w_datos_despacho
end type
type dw_master from u_dw_abc within w_datos_despacho
end type
end forward

global type w_datos_despacho from w_abc
integer width = 3045
integer height = 936
string title = "Ingrese los datos para el despacho"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_master dw_master
end type
global w_datos_despacho w_datos_despacho

type variables
n_cst_utilitario	invo_utility
String				is_flag_bol_fact
end variables

event ue_aceptar;call super::ue_aceptar;str_despacho lstr_despacho

if IsNull(dw_master.object.serie_gr [1]) or trim(dw_master.object.serie_gr [1]) = '' then
	MessageBox('Error', 'Debe especificar la Serie de la GUIA DE REMISION, por favor verifique!', StopSign!)
	dw_master.setColumn('serie_gr')
	return
end if

if IsNull(dw_master.object.serie_ce [1]) or trim(dw_master.object.serie_ce [1]) = '' then
	MessageBox('Error', 'Debe especificar la Serie del COMPROBANTE DE PAGO, por favor verifique!', StopSign!)
	dw_master.setColumn('serie_ce')
	return
end if


if IsNull(dw_master.object.prov_transp [1]) or trim(dw_master.object.prov_transp [1]) = '' then
	MessageBox('Error', 'Debe especificar el Prov de transporte, por favor verifique!', StopSign!)
	dw_master.setColumn('prov_transp')
	return
end if

if IsNull(dw_master.object.nom_chofer [1]) or trim(dw_master.object.nom_chofer [1]) = '' then
	MessageBox('Error', 'Debe especificar el Nombre del Chofer, por favor verifique!', StopSign!)
	dw_master.setColumn('nom_chofer')
	return
end if

if IsNull(dw_master.object.motivo_traslado [1]) or trim(dw_master.object.motivo_traslado [1]) = '' then
	MessageBox('Error', 'Debe especificar el Motivo del Traslado, por favor verifique!', StopSign!)
	dw_master.setColumn('motivo_traslado')
	return
end if

if IsNull(dw_master.object.nro_placa [1]) or trim(dw_master.object.nro_placa [1]) = '' then
	MessageBox('Error', 'Debe especificar el Nro de PLACA, por favor verifique!', StopSign!)
	dw_master.setColumn('nro_placa')
	return
end if

if IsNull(dw_master.object.guia_obs [1]) or trim(dw_master.object.guia_obs [1]) = '' then
	MessageBox('Error', 'Debe ingresar alguna Observacion, por favor verifique!', StopSign!)
	dw_master.setColumn('guia_obs')
	return
end if

lstr_despacho.b_return = true

lstr_despacho.serie_gr 					= dw_master.object.serie_gr 				[1]
lstr_despacho.serie_ce 					= dw_master.object.serie_ce 				[1]
lstr_despacho.prov_transporte 		= dw_master.object.prov_transp 			[1]
lstr_despacho.nom_chofer 				= dw_master.object.nom_chofer 			[1]
lstr_despacho.motivo_traslado 		= dw_master.object.motivo_traslado 		[1]
lstr_despacho.obs 						= dw_master.object.guia_obs				[1]
lstr_despacho.nro_brevete 				= dw_master.object.nro_brevete 			[1]
lstr_despacho.nro_placa 				= dw_master.object.nro_placa 				[1]
lstr_despacho.nro_placa_carreta 		= dw_master.object.nro_placa_carreta 	[1]
lstr_despacho.marca_vehiculo 			= dw_master.object.marca_vehiculo 		[1]
lstr_despacho.cert_insc_mtc 			= dw_master.object.cert_insc_mtc		 			[1]
lstr_despacho.fec_inicio_traslado	= Date(dw_master.object.fec_inicio_traslado	[1])



CloseWithReturn(this, lstr_despacho)
end event

on w_datos_despacho.create
int iCurrent
call super::create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancelar
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.dw_master
end on

on w_datos_despacho.destroy
call super::destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_master)
end on

event ue_cancelar;call super::ue_cancelar;str_despacho lstr_despacho

lstr_despacho.b_return = false

CloseWithReturn(this, lstr_despacho)
end event

event ue_open_pre;call super::ue_open_pre;str_parametros	lstr_param

lstr_param = Message.PowerObjectParm

is_flag_bol_fact = lstr_param.string1

dw_master.event ue_insert()
end event

type cb_cancelar from commandbutton within w_datos_despacho
integer x = 2441
integer y = 716
integer width = 567
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar( )
end event

type cb_aceptar from commandbutton within w_datos_despacho
integer x = 1861
integer y = 716
integer width = 567
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event dynamic ue_aceptar( )
end event

type dw_master from u_dw_abc within w_datos_despacho
integer y = 12
integer width = 3003
integer height = 684
string dataobject = "d_abc_opciones_guia_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_display;call super::ue_display;boolean 		lb_ret
string 		ls_codigo, ls_data, ls_sql, ls_mensaje
Long			ll_count
str_ubigeo	lstr_ubigeo

//if lower(as_columna) <> 'serie' then
//	if this.object.serie[1] = '' or IsNull(this.object.serie[1]) then
//		MessageBox('Aviso', 'No ha indicado la serie de la guia', StopSign!)
//		return
//	end if
//end if

choose case lower(as_columna)

	case "serie_gr"
		ls_sql = "SELECT b.desc_tipo_doc as descripcion_tipo_doc, " &
				  + "a.nro_serie AS Numero_serie " &
				  + "FROM doc_tipo_usuario a, " &
				  + "doc_tipo b " &
				  + "WHERE a.tipo_doc = b.tipo_doc " &
				  + "AND a.cod_usr = '" + gs_user + "' " &
				  + "AND a.tipo_doc  = '" + gnvo_app.is_doc_gr + "'"
				 
		lb_ret = f_lista(ls_sql, ls_data, ls_codigo, '1')
		
		if ls_codigo <> '' then
			this.object.serie_gr[1] = invo_utility.of_get_serie(ls_codigo + '-')
		end if
		
	case "serie_ce"
		ls_sql = "SELECT b.desc_tipo_doc as descripcion_tipo_doc, " &
				  + "a.nro_serie AS Numero_serie " &
				  + "FROM doc_tipo_usuario a, " &
				  + "     doc_tipo 			b, " &
				  + "     num_doc_tipo 		n " &
				  + "WHERE a.tipo_doc  = b.tipo_doc " &
				  + "  and a.tipo_doc  = n.tipo_doc " &
				  + "  and a.nro_serie = n.nro_serie " & 
				  + "  and n.flag_tipo_impresion = '1' " &
				  + "  AND a.cod_usr   = '" + gs_user + "' "
		
		if is_flag_bol_fact = 'F' then
			
			ls_sql += "AND a.tipo_doc  in ('" + gnvo_app.finparam.is_doc_fac + "')"
			
		elseif is_flag_bol_fact = 'B' then
			
			ls_sql += "AND a.tipo_doc  in ('" + gnvo_app.finparam.is_doc_bvc + "')"
			
		elseif is_flag_bol_fact = 'N' then
			//ls_sql += "AND a.tipo_doc  in ('" + gnvo_app.finparam.is_doc_nvc + "')"
			MessageBox('Error', 'Documento a Generar es NVC, no esta permitido en esta opcion, por favor corrija', StopSign!)
			return
		end if
		
				 
		lb_ret = f_lista(ls_sql, ls_data, ls_codigo, '1')
		
		if ls_codigo <> '' then
			this.object.serie_ce[1] = invo_utility.of_get_serie(ls_codigo + '-')
		end if
		
	case "prov_transp"
		ls_sql = "SELECT p.proveedor AS CODIGO_transportista, " &
				  + "p.nom_proveedor AS nombre_transportista, " &
				  + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as RUC_dni " &
				  + "FROM proveedor p " &
				  + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.prov_transp	[al_row] = ls_codigo
			this.object.nom_transp	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "motivo_traslado"
		ls_sql = "SELECT motivo_traslado AS motivo_traslado, " &
				  + "descripcion AS descripcion_motivo_traslado " &
				  + "FROM motivo_traslado " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.motivo_traslado		[al_row] = ls_codigo
			this.object.desc_motivo_traslado	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
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

event itemchanged;call super::itemchanged;String ls_desc

this.Accepttext()

CHOOSE CASE dwo.name		
		
	 CASE 'prov_transp'
		SELECT NOM_PROVEEDOR 
			INTO :ls_desc
		FROM proveedor
      WHERE  PROVEEDOR = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE <> 0 THEN
			dw_master.Object.prov_transp[row] = gnvo_app.is_null
			dw_master.object.nom_transp [row] = gnvo_app.is_null
			Messagebox('Aviso','Debe Ingresar Un Codigo de Cliente Valido',  StopSign!)
			RETURN 1
		END IF		
		
		dw_master.object.nom_transp[row] = ls_desc
		
	CASE 'motivo_traslado'
		select descripcion
			into :ls_desc
		from motivo_traslado
		where motivo_traslado = :data;
		
		if SQLCA.SQLCode = 100 then
			dw_master.Object.motivo_traslado			[row] = gnvo_app.is_null
			dw_master.object.desc_motivo_traslado 	[row] = gnvo_app.is_null
			MessageBox('Aviso', 'No existe Motivo de traslado', StopSign!)
			return 1
		end if
		
		this.object.desc_motivo_traslado [row] = ls_desc
END CHOOSE

end event

event ue_insert_pre;call super::ue_insert_pre;String	ls_serie_gr, ls_Serie_ce


SELECT a.nro_serie
	into :ls_serie_gr
FROM doc_tipo_usuario a
WHERE a.cod_usr = :gs_user
  AND a.tipo_doc  = :gnvo_app.is_doc_gr;
  
if is_flag_bol_fact = 'F' then
	
	SELECT a.nro_serie
		into :ls_serie_ce
		FROM 	doc_tipo_usuario 	a,
				NUM_DOC_TIPO		b
	WHERE a.tipo_doc 					= b.tipo_doc 
	  and a.nro_serie 				= b.nro_Serie
	  AND a.cod_usr 					= :gs_user
	  and b.flag_tipo_impresion 	= '1'
	  AND a.tipo_doc  				in (:gnvo_app.finparam.is_doc_fac);
	  
	
elseif is_flag_bol_fact = 'B' then

	SELECT a.nro_serie
		into :ls_serie_ce
		FROM 	doc_tipo_usuario 	a,
				NUM_DOC_TIPO		b
	WHERE a.tipo_doc 					= b.tipo_doc 
	  and a.nro_serie 				= b.nro_Serie
	  AND a.cod_usr 					= :gs_user
	  and b.flag_tipo_impresion 	= '1'
	  AND a.tipo_doc  				in (:gnvo_app.finparam.is_doc_fac, :gnvo_app.finparam.is_doc_bvc);
	
elseif is_flag_bol_fact = 'N' then
	//ls_sql += "AND a.tipo_doc  in ('" + gnvo_app.finparam.is_doc_nvc + "')"
	MessageBox('Error', 'Documento a Generar es NVC, no esta permitido en esta opcion, por favor corrija', StopSign!)
	return
end if


dw_master.object.serie_gr					[al_row] = ls_serie_gr
dw_master.object.serie_ce					[al_row] = ls_serie_ce
dw_master.object.fec_inicio_traslado	[al_row] = Date(gnvo_app.of_fecha_actual())
end event

