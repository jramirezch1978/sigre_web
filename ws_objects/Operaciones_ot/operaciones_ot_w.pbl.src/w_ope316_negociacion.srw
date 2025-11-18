$PBExportHeader$w_ope316_negociacion.srw
forward
global type w_ope316_negociacion from w_abc
end type
type dw_temp from datawindow within w_ope316_negociacion
end type
type uo_1 from u_ingreso_rango_fechas within w_ope316_negociacion
end type
type st_1 from statictext within w_ope316_negociacion
end type
type cb_2 from commandbutton within w_ope316_negociacion
end type
type cb_1 from commandbutton within w_ope316_negociacion
end type
type sle_1 from singlelineedit within w_ope316_negociacion
end type
type dw_master from u_dw_abc within w_ope316_negociacion
end type
type gb_1 from groupbox within w_ope316_negociacion
end type
end forward

global type w_ope316_negociacion from w_abc
integer width = 3314
integer height = 1288
string title = "Negociación (OPE316)"
string menuname = "m_master_sin_lista"
event ue_retrieve ( )
dw_temp dw_temp
uo_1 uo_1
st_1 st_1
cb_2 cb_2
cb_1 cb_1
sle_1 sle_1
dw_master dw_master
gb_1 gb_1
end type
global w_ope316_negociacion w_ope316_negociacion

forward prototypes
public subroutine wf_insert_amp (long al_inicio, long al_nro_mov, string as_origen_old, long al_nro_old, decimal adc_proy_old)
end prototypes

event ue_retrieve();String ls_nro_oc

ls_nro_oc = trim(sle_1.text)
dw_master.retrieve(ls_nro_oc)
end event

public subroutine wf_insert_amp (long al_inicio, long al_nro_mov, string as_origen_old, long al_nro_old, decimal adc_proy_old);Long ll_row

ll_row = dw_master.InsertRow(0)

dw_master.object.cod_origen 	  			[ll_row] = dw_master.object.cod_origen 		 	  [al_inicio]
dw_master.object.nro_mov 		  			[ll_row] = al_nro_mov
dw_master.object.tipo_doc 		  			[ll_row] = dw_master.object.tipo_doc 			 	  [al_inicio] 
dw_master.object.nro_doc 		  			[ll_row] = dw_master.object.nro_doc 			 	  [al_inicio] 
dw_master.object.org_amp_ref    			[ll_row] = as_origen_old 
dw_master.object.nro_amp_ref    			[ll_row] = al_nro_old 
dw_master.object.cod_art 		  			[ll_row] = dw_master.object.cod_art 			 	  [al_inicio] 
dw_master.object.articulo_nom_articulo [ll_row] = dw_master.object.articulo_nom_articulo [ll_row]
dw_master.object.cant_proyect   			[ll_row] = adc_proy_old 
dw_master.object.precio_unit 	  			[ll_row] = dw_master.object.precio_unit 		 	  [al_inicio] 
dw_master.object.impuesto 		  			[ll_row] = dw_master.object.impuesto 			 	  [al_inicio] 
dw_master.object.cod_moneda 	  			[ll_row] = dw_master.object.cod_moneda 		 	  [al_inicio] 
dw_master.object.fec_proyect 	  			[ll_row] = dw_master.object.fec_proyect 		 	  [al_inicio] 
dw_master.object.oper_sec 		  			[ll_row] = dw_master.object.oper_sec 			 	  [al_inicio] 
dw_master.object.decuento 		  			[ll_row] = dw_master.object.decuento 			 	  [al_inicio] 
dw_master.object.cant_reservado 			[ll_row] = dw_master.object.cant_reservado 	 	  [al_inicio] 
dw_master.object.almacen 		  			[ll_row] = dw_master.object.almacen 			 	  [al_inicio] 
dw_master.object.cant_procesada 			[ll_row] = dw_master.object.cant_procesada 	 	  [al_inicio] 
dw_master.object.flag_estado 	  			[ll_row] = dw_master.object.flag_estado		 	  [al_inicio] 
dw_master.object.tipo_mov	 	  			[ll_row] = dw_master.object.tipo_mov 			 	  [al_inicio] 
dw_master.object.fec_registro	  			[ll_row] = dw_master.object.fec_registro 		 	  [al_inicio] 
dw_master.object.nro_aprob		  			[ll_row] = dw_master.object.nro_aprob 			 	  [al_inicio] 
dw_master.object.flag_nota		  			[ll_row] = dw_master.object.flag_nota 			 	  [al_inicio] 
dw_master.object.fec_proy_aprob 			[ll_row] = dw_master.object.fec_proy_aprob 	 	  [al_inicio] 
dw_master.object.cod_usr		  			[ll_row] = dw_master.object.cod_usr 			 	  [al_inicio] 
dw_master.object.flag_ctrl_ret_alm  	[ll_row] = dw_master.object.flag_ctrl_ret_alm 	  [al_inicio] 
dw_master.object.fec_venc_resv	   	[ll_row] = dw_master.object.fec_venc_resv		 	  [al_inicio] 
dw_master.object.flag_reservado	   	[ll_row] = dw_master.object.flag_reservado 	 	  [al_inicio] 
dw_master.object.flag_replicacion		[ll_row] = dw_master.object.flag_replicacion  	  [al_inicio] 
dw_master.object.cant_parte_diario  	[ll_row] = dw_master.object.cant_parte_diario 	  [al_inicio] 
dw_master.object.fec_crg_prsp		   	[ll_row] = dw_master.object.fec_crg_prsp 		 	  [al_inicio] 
dw_master.object.flag_crg_inm_prsp  	[ll_row] = dw_master.object.flag_crg_inm_prsp 	  [al_inicio] 
dw_master.object.origen_ref		   	[ll_row] = dw_master.object.org_doc_ref_old 	 	  [al_inicio] 
dw_master.object.referencia	   		[ll_row] = dw_master.object.referencia_old 	 	  [al_inicio] 
dw_master.object.tipo_ref  				[ll_row] = dw_master.object.tipo_ref_old 	 	 	  [al_inicio] 
dw_master.object.cnta_prsp			   	[ll_row] = dw_master.object.cnta_prsp 		 	 	  [al_inicio] 
dw_master.object.cencos				   	[ll_row] = dw_master.object.cencos			 	 	  [al_inicio] 
dw_master.object.cant_facturada			[ll_row] = dw_master.object.cant_facturada 	 	  [al_inicio] 

end subroutine

on w_ope316_negociacion.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.dw_temp=create dw_temp
this.uo_1=create uo_1
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_1=create sle_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_temp
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_1
end on

on w_ope316_negociacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_temp)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_temp.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente



of_position_window(0,0)
end event

event ue_update_pre;call super::ue_update_pre;Long   ll_inicio    ,ll_nro_mov_old ,ll_nro_mov_new ,ll_row ,ll_nro_mov
String ls_cod_art ,ls_cod_origen_old,ls_cod_origen_new,ls_msj_err
Decimal {4} ldc_cant_proc,ldc_cant_proy,ldc_cant_neg,ldc_cant_reserv
dwItemStatus ldis_status

//inicializacion
ib_update_check = true

DELETE FROM tt_ope_amp;


dw_master.accepttext()

For ll_inicio = 1 to dw_master.Rowcount()
	 ldis_status = dw_master.GetItemStatus(ll_inicio,0,Primary!)
	 
	if ldis_status = NewModified!		 then
		
	else
		
	 ls_cod_art  = dw_master.object.cod_art [ll_inicio]
	 
	 ldc_cant_proc = dw_master.object.cant_procesada [ll_inicio]
	 ldc_cant_proy = dw_master.object.cant_proyect   [ll_inicio]
	 ldc_cant_neg	= dw_master.object.c_proyec_old	 [ll_inicio] //cantidad negociada
	 
	 //movimiento de ariculo old 
	 ls_cod_origen_old = dw_master.object.org_ref_old [ll_inicio]
	 ll_nro_mov_old    = dw_master.object.nro_ref_old [ll_inicio]
	 
	 //movimiento de ariculo new
	 ls_cod_origen_new = dw_master.object.org_amp_ref [ll_inicio]
	 ll_nro_mov_new    = dw_master.object.nro_amp_ref [ll_inicio]	 
	 
	 
	 
	 IF ldis_status = DataModified!	 THEN
		 if ldc_cant_proc = 0 then //movimientos tiene ingresos almacen
			 if ldc_cant_proy < ldc_cant_neg then //crear movimiento en orden de compra
 				 //ACTUALIZAR EL NRO DE MOVIMIENTO ANTIGUO
				 SetNull(ll_nro_mov)

				 wf_insert_amp(ll_inicio,ll_nro_mov,ls_cod_origen_old,ll_nro_mov_old,ldc_cant_neg - ldc_cant_proy)
				 //actualiza cantidad facturada de movimiento reemplazado
				 
				 dw_master.object.cant_facturada	[ll_inicio] = 0.0000
				 
			 end if
		 end if


		 	 
		 //actualizar Articulo de orden de trabajo old
		 Insert Into tt_ope_amp
		 (cod_origen ,nro_mov ,cant_reservada)
		 select amp.cod_origen,amp.nro_mov,Nvl(amp.cant_reservado,0) - Nvl(:ldc_cant_proc,0) 
		   from articulo_mov_proy amp
		  where (amp.cod_origen            = :ls_cod_origen_old ) and
		  		  (amp.nro_mov               = :ll_nro_mov_old    ) and
				  (Nvl(amp.cant_procesada,0) > 0 					  ) ;
		 
		 if SQLCA.SQLCode = -1 then
			 ls_msj_err =  SQLCA.SQLErrText
 			 rollback ;
        	 MessageBox('SQL error',ls_msj_err)
			 ib_update_check = false
			 Return	
		 end if



		 //actualizar Articulo de orden de trabajo new
		 Insert Into tt_ope_amp
		 (cod_origen ,nro_mov ,cant_reservada)
		 select amp.cod_origen,amp.nro_mov,Nvl(amp.cant_reservado,0) - Nvl(:ldc_cant_proc,0) 
		   from articulo_mov_proy amp
		  where (amp.cod_origen            = :ls_cod_origen_new ) and
		  		  (amp.nro_mov               = :ll_nro_mov_new    ) and
				  (Nvl(amp.cant_procesada,0) > 0 					  ) ;
		 
		 		 
 		 if SQLCA.SQLCode = -1 then
			 ls_msj_err =  SQLCA.SQLErrText
 			 rollback ;
        	 MessageBox('SQL error',ls_msj_err)
			 ib_update_check = false
			 Return	
		 end if
			

	 END IF
	end if 
Next
end event

event ue_update;call super::ue_update;String  ls_cod_origen,ls_msj_err
Long    ll_inicio,ll_nro_mov
Boolean lbo_ok = TRUE
Decimal {4} ldc_cant_reservado

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN

	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		Messagebox('Error en Grabacion Master','Se ha procedido al rollback',exclamation!)
	END IF
END IF

//ACTUALIZA INFORMACION 
dw_temp.retrieve()

For ll_inicio = 1 to dw_temp.Rowcount()
	 
	 ls_cod_origen      = dw_temp.object.cod_origen     [ll_inicio]
	 ll_nro_mov         = dw_temp.object.nro_mov        [ll_inicio]
	 ldc_cant_reservado = dw_temp.object.cant_reservada [ll_inicio]
	 
	 update articulo_mov_proy amp
	    set amp.cant_reservado = :ldc_cant_reservado 
	  where (amp.cod_origen = :ls_cod_origen ) and
			  (amp.nro_mov	   = :ll_nro_mov    ) ;	
	
	 if SQLCA.SQLCode = -1 then
		 ls_msj_err =  SQLCA.SQLErrText
 		 rollback ;
     	 MessageBox('SQL error',ls_msj_err)
		 lbo_ok = false
		 Return	
	 end if
			  
Next


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	Messagebox('Aviso','Grabación Satisfactoria')
ELSE
	ROLLBACK ;
END IF


delete from  tt_ope_amp ;

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type dw_temp from datawindow within w_ope316_negociacion
boolean visible = false
integer x = 87
integer y = 1136
integer width = 686
integer height = 400
integer taborder = 20
string title = "none"
string dataobject = "d_abc_tt_negociacion_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_rango_fechas within w_ope316_negociacion
integer x = 1765
integer y = 112
integer taborder = 20
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
// of_set_fecha(date('01/01/1900'), date('31/12/9999') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type st_1 from statictext within w_ope316_negociacion
integer x = 27
integer y = 44
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro Orden Compra :"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_ope316_negociacion
integer x = 969
integer y = 24
integer width = 91
integer height = 100
integer taborder = 20
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
lstr_seleccionar.s_sql = 'SELECT ORDEN_COMPRA.COD_ORIGEN   AS ORIGEN    , '&
									    +'ORDEN_COMPRA.NRO_OC       AS NRO_ORDEN , '&
       								 +'ORDEN_COMPRA.PROVEEDOR    AS PROVEEDOR , '&
										 +'ORDEN_COMPRA.COD_USR      AS USUARIO   , '&
										 +'ORDEN_COMPRA.FEC_REGISTRO AS FECHA	     '&
										 +'FROM ORDEN_COMPRA				 '&
										 +'WHERE ORDEN_COMPRA. FLAG_ESTADO <> '+"'"+'0'+"'"
 
OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		
		sle_1.text = lstr_seleccionar.param2[1]
	END IF


end event

type cb_1 from commandbutton within w_ope316_negociacion
integer x = 1097
integer y = 24
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.Triggerevent( 'ue_retrieve')
end event

type sle_1 from singlelineedit within w_ope316_negociacion
integer x = 544
integer y = 24
integer width = 407
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type dw_master from u_dw_abc within w_ope316_negociacion
integer x = 14
integer y = 300
integer width = 3250
integer height = 784
string dataobject = "d_abc_det_oc_x_ot_change_tbl"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;

Accepttext()


end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'			// 'm' = master sin detalle (default), 'd' =  detalle,

is_dwform = 'tabular'	// tabular


ii_ck[1] = 1				// columnas de lectura de este dw

idw_mst = dw_master

end event

event doubleclicked;call super::doubleclicked;String  ls_fecha_inicio,ls_fecha_final
Decimal {4} ldc_cant_procesada,ldc_cant_proyect
str_parametros sl_param 


if dwo.name = 'p_neg' and row > 0 then
	
	ldc_cant_procesada = this.object.cant_procesada   [row]
	ldc_cant_proyect	 = this.object.cant_proyect [row]
	
	sl_param.dw1		= 'd_prueba_negociacion'
	sl_param.dw_m		= dw_master
	sl_param.titulo	= 'Negociación '
	sl_param.opcion   = 25
	sl_param.db1 		= 1600
	sl_param.string1 	= 'OT'
	sl_param.tipo	 	= 'OT'


	sl_param.string2  = String(uo_1.of_get_fecha1(),'yyyymmdd')
	sl_param.string3  = String(uo_1.of_get_fecha2(),'yyyymmdd')
	sl_param.string4	= this.object.almacen [row]
	sl_param.string5	= this.object.cod_art [row]
	sl_param.dc1 		= ldc_cant_proyect
	
	//verificar ingreso al almacen
	if ldc_cant_procesada > 0 then 
		sl_param.bret = FALSE
	else
		sl_param.bret = TRUE
	end if
		
		
		
	OpenWithParm( w_abc_seleccion_lista_search, sl_param)
	
	IF IsValid(message.powerobjectparm) then
		
		sl_param = message.PowerObjectParm
	
		if sl_param.titulo = 's' then
			dw_master.ii_update = 1
		end if
	END IF	

end if
end event

type gb_1 from groupbox within w_ope316_negociacion
integer x = 1719
integer y = 24
integer width = 1550
integer height = 212
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas de Operaciones de Ordenes Trabajo a Recuperar"
end type

