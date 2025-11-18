$PBExportHeader$w_fi363_aprob_deuda_financiera.srw
forward
global type w_fi363_aprob_deuda_financiera from w_abc
end type
type p_help from picture within w_fi363_aprob_deuda_financiera
end type
type st_help from statictext within w_fi363_aprob_deuda_financiera
end type
type st_search from statictext within w_fi363_aprob_deuda_financiera
end type
type st_refresh from statictext within w_fi363_aprob_deuda_financiera
end type
type pb_refresh from picturebutton within w_fi363_aprob_deuda_financiera
end type
type dw_1 from datawindow within w_fi363_aprob_deuda_financiera
end type
type pb_aceptar from picturebutton within w_fi363_aprob_deuda_financiera
end type
type pb_salir from picturebutton within w_fi363_aprob_deuda_financiera
end type
type dw_master from u_dw_abc within w_fi363_aprob_deuda_financiera
end type
end forward

global type w_fi363_aprob_deuda_financiera from w_abc
integer width = 3474
integer height = 1892
string title = "Aprobacion Deuda Financiera (FI308)"
string menuname = "m_proceso_salida"
p_help p_help
st_help st_help
st_search st_search
st_refresh st_refresh
pb_refresh pb_refresh
dw_1 dw_1
pb_aceptar pb_aceptar
pb_salir pb_salir
dw_master dw_master
end type
global w_fi363_aprob_deuda_financiera w_fi363_aprob_deuda_financiera

type variables
String is_col
integer ii_ik[]
end variables

forward prototypes
public function boolean f_genera_aprobacion_deuda (long al_row)
end prototypes

public function boolean f_genera_aprobacion_deuda (long al_row);String	ls_tipo_doc  ,ls_nro_doc     ,ls_origen          ,ls_cod_relacion ,ls_fpago	      ,&
			ls_tipo_deuda,ls_flag_cxc_cxp,ls_flag_cxc_cxp_det,ls_flag_capital ,ls_flag_numerador,&
			ls_obs		 ,ls_cod_moneda  ,ls_soles				 ,ls_dolares		,ls_cencos			,&
			ls_cnta_prsp ,ls_nro_registro,ls_msj_err
Date	 ld_fecha_registro,ld_fecha_doc
Decimal {2} ldc_monto_capital,ldc_saldo_dol,ldc_saldo_sol
Decimal {3}	ldc_tasa_cambio
Boolean		lb_ret = TRUE

nvo_insert_documentos lf_insert

//crea objeto
lf_insert = create nvo_insert_documentos


dw_master.Accepttext()

ls_tipo_deuda 		= dw_master.object.tipo_deuda_fin    [al_row]
ls_origen			= dw_master.object.cod_origen		    [al_row]
ld_fecha_registro = Date(dw_master.object.fec_registro [al_row])
ld_fecha_doc		= Today ()
ls_tipo_doc			= dw_master.object.tipo_doc			 [al_row]
ls_nro_doc			= dw_master.object.nro_doc			    [al_row]
ls_cod_relacion	= dw_master.object.cod_relacion	    [al_row]
ls_obs				= Mid(dw_master.object.observaciones [al_row],1,40)
ls_cod_moneda		= dw_master.object.cod_moneda		    [al_row]
ldc_monto_capital	= dw_master.object.tot_capital	    [al_row]
ls_nro_registro	= dw_master.object.nro_registro	    [al_row]

/*buscar tipo de cambio de Documento*/
ldc_tasa_cambio = gnvo_app.of_tasa_cambio(ld_fecha_doc)

if ldc_tasa_cambio = 0 then
	lb_ret = FALSE
   GOTO SALIDA
end if

/*Parametros*/
select pago_contado into :ls_fpago from finparam where reckey = '1' ;

select cod_soles,cod_dolares into :ls_soles,:ls_dolares from logparam where reckey = '1' ;

/*Recupero Datos de Tipo Deuda Financiera*/
select dft.flag_cxc_cxp,dft.flag_cxc_cxp_det,dft.flag_capital,dt.flag_num_interno,dft.tipo_doc
  into :ls_flag_cxc_cxp,:ls_flag_cxc_cxp_det,:ls_flag_capital,:ls_flag_numerador,:ls_tipo_doc
  from deuda_financ_tipo dft,doc_tipo dt
 where (dft.tipo_doc	       = dt.tipo_doc    ) and
 		 (dft.tipo_deuda_fin  = :ls_tipo_deuda ) and
 		 (dft.flag_estado     = '1'				  ) ;

		  
/*Encontrar Monto Soles Y Dolares de Monto de Capital*/		  
if     ls_cod_moneda = ls_soles   then
	ldc_saldo_dol = Round(ldc_monto_capital / ldc_tasa_cambio,2)
	ldc_saldo_sol = ldc_monto_capital	 
elseif ls_cod_moneda = ls_dolares then
	ldc_saldo_dol = ldc_monto_capital	 
	ldc_saldo_sol = Round(ldc_monto_capital * ldc_tasa_cambio,2)	 
end if
		  
		  

//generar documento de acuerdo a datos de cabecera
if     ls_flag_cxc_cxp = '0' then //no genera nada
   //no genera documento de cabecera		
elseif ls_flag_cxc_cxp = '1' then //cnta cobrar directo
	//generar numero de documento
	if ls_flag_numerador = '1' then //generar nro correlativo de acuerdo a docuemnto y origen
		if lf_insert.uf_genera_nro_doc_tipo(ls_tipo_doc,ls_nro_doc,ls_origen ) = FALSE then
			lb_ret = FALSE
		 	GOTO SALIDA
		end if
	end if
	//genera cnta cobrar directo
	if  lf_insert.uf_insert_cnta_x_cobrar(ls_tipo_doc   ,ls_nro_doc        ,ls_cod_relacion ,&
											 	 	  '1'			    ,ld_fecha_registro ,ld_fecha_doc	 ,&
												     ld_fecha_doc	 ,ls_cod_moneda	  ,ldc_tasa_cambio ,&
												     gs_user  		 ,ls_fpago			  ,ls_origen		 ,&
											        ls_obs			 ,ldc_monto_capital ,ldc_saldo_sol	 ,&
												     ldc_saldo_dol ,'0'					  ,'0'				 ,&
												     'D' ) = FALSE then
		 lb_ret = FALSE
		 GOTO SALIDA
	end if
	
	//inserta detalle de cntas cobrar
	if lf_insert.uf_insert_cnta_x_cobrar_det(ls_tipo_doc,ls_nro_doc,1, '1',ls_obs,1,ldc_monto_capital ) = false THEN
		lb_ret = FALSE
		GOTO SALIDA													 
	end if
	
elseif ls_flag_cxc_cxp = '2' then //cnta cobrar cta crrte
	//genera cnta
	if ls_flag_numerador = '1' then //generar nro correlativo de acuerdo a docuemnto y origen
		if lf_insert.uf_genera_nro_doc_tipo(ls_tipo_doc,ls_nro_doc,ls_origen ) = FALSE then
			lb_ret = FALSE
			GOTO SALIDA
		end if
	end if
	//genera cnta cobrar directo
	if  lf_insert.uf_insert_cnta_x_cobrar(ls_tipo_doc   ,ls_nro_doc        ,ls_cod_relacion ,&
											 	 	  '1'			    ,ld_fecha_registro ,ld_fecha_doc	 ,&
												     ld_fecha_doc	 ,ls_cod_moneda	  ,ldc_tasa_cambio ,&
												     gs_user  		 ,ls_fpago			  ,ls_origen		 ,&
											        ls_obs			 ,ldc_monto_capital ,ldc_saldo_sol	 ,&
												     ldc_saldo_dol ,'1'					  ,'0'				 ,&
												     'D' ) = FALSE then
		 lb_ret = FALSE
		 GOTO SALIDA
	end if
	
	//inserta registro en el detalle de cuentas por cobrar
	//inserta detalle de cntas cobrar
	if lf_insert.uf_insert_cnta_x_cobrar_det(ls_tipo_doc,ls_nro_doc,1, '1',ls_obs,1,ldc_monto_capital ) = false THEN
		lb_ret = FALSE
		GOTO SALIDA
	end if
	
elseif ls_flag_cxc_cxp = '3' then //cnta pagar directo
	//genera cnta
	if ls_flag_numerador = '1' then //generar nro correlativo de acuerdo a docuemnto y origen
		if lf_insert.uf_genera_nro_doc_tipo(ls_tipo_doc,ls_nro_doc,ls_origen ) = FALSE then
			lb_ret = FALSE
			GOTO SALIDA
		end if
	end if

	//CABECERA DE CNTAS POR PAGAR
	if lf_insert.uf_insert_cnta_x_pagar(ls_cod_relacion , ls_tipo_doc       , ls_nro_doc        , &
													'1'				 , ld_fecha_registro , ld_fecha_doc      , &
													ld_fecha_doc    , ls_fpago				, ls_cod_moneda     , &
													ldc_tasa_cambio , gs_user				, ls_origen         , &
													ls_obs			 , 'D'					, ldc_monto_capital , &
													ldc_saldo_sol   , ldc_saldo_dol		, '0'					  , &
													'0'	) = false then
		lb_ret = FALSE
		GOTO SALIDA
	end if
	
	//DETALLE DE CNTAS POR PAGAR
	if lf_insert.uf_insert_cnta_x_pagar_det( ls_cod_relacion   , ls_tipo_doc , ls_nro_doc  ,&
														  1                 , ls_obs		 , 1           ,&
														  ldc_monto_capital , ls_cencos	 , ls_cnta_prsp ) = false then
		lb_ret = FALSE
		GOTO SALIDA

	end if			
														  
	
	
	
elseif ls_flag_cxc_cxp = '4' then //cnta pagar cta crrte	
	
		//genera cnta
	if ls_flag_numerador = '1' then //generar nro correlativo de acuerdo a docuemnto y origen
		if lf_insert.uf_genera_nro_doc_tipo(ls_tipo_doc,ls_nro_doc,ls_origen ) = FALSE then
			lb_ret = FALSE
			GOTO SALIDA
		end if
	end if

	//CABECERA DE CNTAS POR PAGAR
	if lf_insert.uf_insert_cnta_x_pagar(ls_cod_relacion , ls_tipo_doc       , ls_nro_doc        , &
													'1'				 , ld_fecha_registro , ld_fecha_doc      , &
													ld_fecha_doc    , ls_fpago				, ls_cod_moneda     , &
													ldc_tasa_cambio , gs_user				, ls_origen         , &
													ls_obs			 , 'D'					, ldc_monto_capital , &
													ldc_saldo_sol   , ldc_saldo_dol		, '1'					  , &
													'0'	) = false then
		lb_ret = FALSE
		GOTO SALIDA
	end if
	
	//DETALLE DE CNTAS POR PAGAR
	if lf_insert.uf_insert_cnta_x_pagar_det( ls_cod_relacion   , ls_tipo_doc , ls_nro_doc  ,&
														  1                 , ls_obs		 , 1           ,&
														  ldc_monto_capital , ls_cencos	 , ls_cnta_prsp ) = false then
		lb_ret = FALSE
		GOTO SALIDA
	end if			

	
end if



//verifica detalle

DECLARE PB_USP_FIN_DEUDA_FINANCIERA PROCEDURE FOR USP_FIN_DEUDA_FINANCIERA
(:ls_nro_registro,:gs_user,:gs_origen);
EXECUTE PB_USP_FIN_DEUDA_FINANCIERA ;



IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error',ls_msj_err)
END IF




SALIDA:


Return lb_ret

end function

on w_fi363_aprob_deuda_financiera.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_salida" then this.MenuID = create m_proceso_salida
this.p_help=create p_help
this.st_help=create st_help
this.st_search=create st_search
this.st_refresh=create st_refresh
this.pb_refresh=create pb_refresh
this.dw_1=create dw_1
this.pb_aceptar=create pb_aceptar
this.pb_salir=create pb_salir
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_help
this.Control[iCurrent+2]=this.st_help
this.Control[iCurrent+3]=this.st_search
this.Control[iCurrent+4]=this.st_refresh
this.Control[iCurrent+5]=this.pb_refresh
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.pb_aceptar
this.Control[iCurrent+8]=this.pb_salir
this.Control[iCurrent+9]=this.dw_master
end on

on w_fi363_aprob_deuda_financiera.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_help)
destroy(this.st_help)
destroy(this.st_search)
destroy(this.st_refresh)
destroy(this.pb_refresh)
destroy(this.dw_1)
destroy(this.pb_aceptar)
destroy(this.pb_salir)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
//270
dw_master.height = newheight - dw_master.y - 300

pb_aceptar.y	  = newheight -  200
pb_salir.y		  = newheight -  200
p_help.y			  = newheight -  105
st_help.y		  = newheight -  105

end event

event ue_open_pre;call super::ue_open_pre;

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

st_search.text = 'Busca Por Nro. de Deuda Financiera : '
is_col = 'nro_registro'

TriggerEvent('ue_retrieve_list')
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		Rollback ;
	END IF
END IF

end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;String ls_estado[]

ls_estado [1] = '1'
ls_estado [2] = '3'

idw_1.retrieve(ls_estado)
IF idw_1.Rowcount() > 0 THEN
	idw_1.SelectRow(0,FALSE)
	idw_1.SelectRow(1,TRUE)
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type p_help from picture within w_fi363_aprob_deuda_financiera
integer x = 14
integer y = 1552
integer width = 110
integer height = 76
string picturename = "H:\Source\Bmp\Chkmark.bmp"
boolean border = true
boolean focusrectangle = false
end type

type st_help from statictext within w_fi363_aprob_deuda_financiera
integer x = 165
integer y = 1572
integer width = 1394
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dar Doble Click Para Aporbar Deuda Financiera"
boolean focusrectangle = false
end type

type st_search from statictext within w_fi363_aprob_deuda_financiera
integer x = 41
integer y = 128
integer width = 695
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type st_refresh from statictext within w_fi363_aprob_deuda_financiera
integer x = 2807
integer y = 136
integer width = 343
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Refrescar"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_refresh from picturebutton within w_fi363_aprob_deuda_financiera
integer x = 3205
integer y = 92
integer width = 128
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\db.bmp"
end type

event clicked;Parent.TriggerEvent('ue_update_request')
Parent.TriggerEvent('ue_retrieve_list')
end event

type dw_1 from datawindow within w_fi363_aprob_deuda_financiera
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 800
integer y = 120
integer width = 942
integer height = 84
integer taborder = 10
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();dw_master.triggerevent(clicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_master.Getrow()
Return ll_row
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type pb_aceptar from picturebutton within w_fi363_aprob_deuda_financiera
integer x = 2624
integer y = 1448
integer width = 325
integer height = 180
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Parent.TriggerEvent('ue_update')
Parent.TriggerEvent('ue_retrieve_list')
end event

type pb_salir from picturebutton within w_fi363_aprob_deuda_financiera
integer x = 3013
integer y = 1448
integer width = 315
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type dw_master from u_dw_abc within w_fi363_aprob_deuda_financiera
integer x = 23
integer y = 224
integer width = 3323
integer height = 1160
integer taborder = 20
string dataobject = "d_abc_deuda_financiera_aprob_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

/////**************///
Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color, ls_etiqueta
Long 	  ll_row


li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column   = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_report   = mid(ls_column,1,li_pos - 1) + "_t.tag"
	ls_color    = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	ls_etiqueta = This.Describe(ls_report)	
	
	st_search.text = "Busca Por : " + ls_etiqueta
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
END  IF

// Si el evento es disparado desde otro objeto que esta activo, este evento no recono

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

idw_mst  = dw_master		// dw_master

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event doubleclicked;call super::doubleclicked;Datetime ld_fecha_doc
String   ls_flag_estado
Integer  li_opcion

//aprobacion de deuda financiera
select sysdate into :ld_fecha_doc from dual ;



li_opcion = MessageBox('Aviso', 'Esta Seguro de Accion a Realizar ?', Question!, YesNo!, 2)

IF li_opcion = 1 THEN
	//verificar estado de la deuda
	ls_flag_estado = this.object.flag_estado 	[row]
	
	if ls_flag_estado = '3' then //proyectado
		//generar documentos
		if f_genera_aprobacion_deuda (row) = FALSE THEN
			Rollback ;
			Messagebox('Aviso','Aprobacion no ha sido Aceptada , Verifique!')
		else
			//actualiza estado de la deuda
			this.object.usr_vobo			[row] = gs_user
			this.object.fec_aprobacion [row] = Date(ld_fecha_doc)
			this.object.flag_estado 	[row] = '1'
			this.ii_update = 1
	
			Messagebox('Aviso','Aprobacion ha sido Aceptada , Por Favor Presionar Boton <Aceptar> ')
		end if
	elseif ls_flag_estado = '1' then //activo
		//revertir aprobacion siempre y cuando no se encuentren realida alguna transación
		
	end if
	
	
	
ELSE


END IF


end event

