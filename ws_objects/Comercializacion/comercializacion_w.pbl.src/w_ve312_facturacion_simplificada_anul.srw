$PBExportHeader$w_ve312_facturacion_simplificada_anul.srw
forward
global type w_ve312_facturacion_simplificada_anul from w_abc
end type
type st_2 from statictext within w_ve312_facturacion_simplificada_anul
end type
type st_1 from statictext within w_ve312_facturacion_simplificada_anul
end type
type sle_nro_doc from singlelineedit within w_ve312_facturacion_simplificada_anul
end type
type sle_tipo_doc from singlelineedit within w_ve312_facturacion_simplificada_anul
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve312_facturacion_simplificada_anul
end type
type cb_1 from commandbutton within w_ve312_facturacion_simplificada_anul
end type
type rb_2 from radiobutton within w_ve312_facturacion_simplificada_anul
end type
type rb_1 from radiobutton within w_ve312_facturacion_simplificada_anul
end type
type dw_master from u_dw_abc within w_ve312_facturacion_simplificada_anul
end type
type gb_1 from groupbox within w_ve312_facturacion_simplificada_anul
end type
end forward

global type w_ve312_facturacion_simplificada_anul from w_abc
integer width = 2560
integer height = 1740
string title = "[VE312] Anulacion Facturacion Simplificada "
string menuname = "m_proceso_anula_elim"
st_2 st_2
st_1 st_1
sle_nro_doc sle_nro_doc
sle_tipo_doc sle_tipo_doc
uo_fechas uo_fechas
cb_1 cb_1
rb_2 rb_2
rb_1 rb_1
dw_master dw_master
gb_1 gb_1
end type
global w_ve312_facturacion_simplificada_anul w_ve312_facturacion_simplificada_anul

type variables
n_cst_asiento_contable lnvo_asiento_cntbl
end variables

forward prototypes
public function boolean wf_anula_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento)
public function boolean wf_anula_guia (string as_cod_origen, string as_nro_guia, string as_nro_vale, string as_nro_ov)
public function boolean wf_anula_mov_almacen (string as_nro_vale, string as_cod_origen, string as_nro_ov)
public function boolean wf_anula_doc_cobrar (string as_tipo_doc, string as_nro_doc, string as_cod_relacion, string as_origen, string as_nro_ov, long al_nro_item, string as_nro_detraccion)
end prototypes

public function boolean wf_anula_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento);Boolean lb_ret = TRUE
String  ls_msj_err

//Actualiza detalle
update cntbl_asiento_det cad
   set cad.imp_movsol = 0.00 ,
		 cad.imp_movdol = 0.00 
 where (origen      = :as_origen      ) and
 		 (ano		     = :al_ano		    ) and
		 (mes		     = :al_mes		    ) and
		 (nro_libro   = :al_nro_libro   ) and
		 (nro_asiento = :al_nro_asiento ) ;

		 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA
END IF
		 
		 
		 
//Actualiza Cabecera
update cntbl_asiento ca
   set ca.tot_soldeb  = 0.00 ,
		 ca.tot_solhab  = 0.00 ,
		 ca.tot_doldeb  = 0.00 ,
		 ca.tot_dolhab  = 0.00 , 
		 ca.flag_estado = '0'
 where (origen      = :as_origen      ) and
 		 (ano		     = :al_ano		    ) and
		 (mes		     = :al_mes		    ) and
		 (nro_libro   = :al_nro_libro   ) and
		 (nro_asiento = :al_nro_asiento ) ;

		 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA
END IF


SALIDA:

				  
Return lb_ret				  
end function

public function boolean wf_anula_guia (string as_cod_origen, string as_nro_guia, string as_nro_vale, string as_nro_ov);Decimal {2} ldc_cant
String      ls_flag_estado,ls_msj_err,ls_sql, ls_origen_mov_proy, ls_nro_mov_proy
Long      	ll_nro_mov_proy, ll_count
Boolean		lb_ret = TRUE


/*relacion de guia vale*/
delete from guia_vale 
 where (origen_guia = :as_cod_origen) and
 		 (nro_guia	  = :as_nro_guia  ) and
		 (nro_vale	  = :as_nro_vale  )	;

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Guia Vale',ls_msj_err)
	GOTO SALIDA
END IF		 
		 

		 
delete from guia
 where (cod_origen = :as_cod_origen ) and
 		 (nro_guia   = :as_nro_guia	) ;
		  
IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Guia ',ls_msj_err)
	GOTO SALIDA
END IF		 



delete from tt_ope_amp	;

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Delete tt_ope_amp ',ls_msj_err)
	GOTO SALIDA
END IF

/*llenar tabla temporal*/	
Insert Into tt_ope_amp
(cod_origen,nro_mov,nro_vale)
select am.origen_mov_proy,am.nro_mov_proy,am.nro_vale from articulo_mov am 
 where (am.nro_vale = :as_nro_vale) ;
 
 IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Insert tt_ope_amp ',ls_msj_err)
	GOTO SALIDA
END IF
	
/*actualiza articulo_mov (Detalle de Almacen)*/		  
update articulo_mov
   set cant_procesada = 0.00 ,precio_unit = 0.00 ,
		 decuento		 = 0.00 ,impuesto    = 0.00 ,
		 flag_estado	 = '0'
 where (nro_vale = :as_nro_vale) ;

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Articulo Mov ',ls_msj_err)
	GOTO SALIDA
END IF		 
 
 
/*actualiza cabecera de mov almacen*/
update vale_mov
   set flag_estado = '0'
 where (cod_origen = :as_cod_origen ) and
  	    (nro_vale	  = :as_nro_vale   ) ;


IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Vale Mov ',ls_msj_err)
	GOTO SALIDA
END IF		 

			 
/*Armar Cursor de art mov*/
DECLARE PB_USP_FIN_ANULACION_FSIMPLE PROCEDURE FOR USP_FIN_ANULACION_FSIMPLE 
(:as_nro_vale);
EXECUTE PB_USP_FIN_ANULACION_FSIMPLE ;

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Articulo Mov Proy',ls_msj_err)
	GOTO SALIDA
	
END IF

CLOSE PB_USP_FIN_ANULACION_FSIMPLE ;


/*actualiza cabecera de orden de venta*/  
select sum(cant_proyect) into :ldc_cant from articulo_mov_proy 
 where nro_mov in (select nro_mov_proy from articulo_mov where nro_vale = :as_nro_vale) 
 group by tipo_doc,nro_doc ;	
 
IF ldc_cant > 0 THEN
	ls_flag_estado = '2' //atendido parcial
ELSE
	ls_flag_estado = '0' //anulado
END IF

/*anula orden de venta*/
update orden_venta
   set flag_estado = :ls_flag_estado
 where (cod_origen = :as_cod_origen ) and
 		 (nro_ov		 = :as_nro_ov     );

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Orden de Venta',ls_msj_err)
	GOTO SALIDA
END IF		 

SALIDA:

RETURN lb_ret
end function

public function boolean wf_anula_mov_almacen (string as_nro_vale, string as_cod_origen, string as_nro_ov);Decimal {2} ldc_cant
String      ls_flag_estado,ls_msj_err
Long 			ll_nro_mov_proy
Boolean		lb_ret = TRUE



/*actualiza articulo_mov (Detalle de Almacen)*/		  
update articulo_mov
   set cant_procesada = 0.00 ,precio_unit = 0.00 ,
		 decuento		 = 0.00 ,impuesto    = 0.00 ,
		 flag_estado	 = '0'
 where (nro_vale = :as_nro_vale) ;

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Articulo Mov ',ls_msj_err)
	GOTO SALIDA
END IF		 
 
 
/*actualiza cabecera de mov almacen*/
update vale_mov
   set flag_estado = '0'
 where (cod_origen = :as_cod_origen ) and
  	    (nro_vale	  = :as_nro_vale   ) ;


IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Vale Mov ',ls_msj_err)
	GOTO SALIDA
END IF		 
			 

			 
			 
/*Armar Cursor de art mov*/
DECLARE PB_USP_FIN_ANULACION_FSIMPLE PROCEDURE FOR USP_FIN_ANULACION_FSIMPLE 
(:as_nro_vale);
EXECUTE PB_USP_FIN_ANULACION_FSIMPLE ;

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Articulo Mov Proy',ls_msj_err)
	GOTO SALIDA
	
END IF

CLOSE PB_USP_FIN_ANULACION_FSIMPLE ;



/*actualiza cabecera de orden de venta*/  
select sum(cant_proyect) into :ldc_cant from articulo_mov_proy 
 where nro_mov in (select nro_mov_proy from articulo_mov where nro_vale = :as_nro_vale) 
 group by tipo_doc,nro_doc ;	
 
IF ldc_cant > 0 THEN
	ls_flag_estado = '2' //atendido parcial
ELSE
	ls_flag_estado = '0' //anulado
END IF

/*anula orden de venta*/
update orden_venta
   set flag_estado = :ls_flag_estado
 where (cod_origen = :as_cod_origen ) and
 		 (nro_ov		 = :as_nro_ov     );

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE	
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error Orden de Venta',ls_msj_err)
	GOTO SALIDA
END IF		 

SALIDA:


RETURN lb_ret
end function

public function boolean wf_anula_doc_cobrar (string as_tipo_doc, string as_nro_doc, string as_cod_relacion, string as_origen, string as_nro_ov, long al_nro_item, string as_nro_detraccion);String  ls_msj_err,ls_cadena,ls_cadena_2
Boolean lb_ret = true


delete from factura_simpl
 where (origen = :as_origen   ) and
 		 (nro_ov = :as_nro_ov   ) and	
		 (item	= :al_nro_item ) ;
		 
			 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 	
	Rollback ;
   MessageBox('SQL error Facturacion Simple',ls_msj_err )
	lb_ret = FALSE
	GOTO SALIDA
END IF

ls_cadena	= trim(as_origen)  +trim(as_nro_ov) +trim(String(al_nro_item))
ls_cadena_2 = trim(as_tipo_doc)+trim(as_nro_doc)

//INSERTA DATO DE eliminacion a LOG_DIARIO
//log de cambios
Insert Into log_diario
(fecha,tabla,operacion,llave,campo,val_anterior,cod_usr)
Values
(sysdate,'FACTURA_SIMPL','Elimin',:ls_cadena,'tipo_doc_cc,nro_doc_cc',:ls_cadena_2,:gs_user);

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 	
	Rollback ;
   MessageBox('SQL error en Log Diario de Facturacion Simple',ls_msj_err )
	lb_ret = FALSE
	GOTO SALIDA
END IF

update detraccion
   set flag_estado = '0'
 where (nro_detraccion = :as_nro_detraccion)	;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 	
	Rollback ;
   MessageBox('SQL error detraccion',ls_msj_err )
	lb_ret = FALSE
	GOTO SALIDA
END IF
		 
		 
delete from doc_referencias
 where (cod_relacion = :as_cod_relacion ) and
		 (tipo_doc		= :as_tipo_doc		 ) and
		 (nro_doc		= :as_nro_doc		 ) ;
		 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 	
	Rollback ;
   MessageBox('SQL error referencia',ls_msj_err )
	lb_ret = FALSE
	GOTO SALIDA
END IF		 
		 
		 
delete from cc_doc_det_imp		 
 where (tipo_doc		= :as_tipo_doc		 ) and
		 (nro_doc		= :as_nro_doc		 ) ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 	
	Rollback ;
   MessageBox('SQL error impuesto',ls_msj_err )
	lb_ret = FALSE
	GOTO SALIDA
END IF		 
		 





delete from cntas_cobrar_det
 where (tipo_doc		= :as_tipo_doc		 ) and
		 (nro_doc		= :as_nro_doc		 ) ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 	
	Rollback ;
   MessageBox('SQL error detalle cobrar',ls_msj_err )
	lb_ret = FALSE
	GOTO SALIDA
END IF		 
		 
		 
delete from cntas_cobrar
 where (tipo_doc		= :as_tipo_doc		 ) and
		 (nro_doc		= :as_nro_doc		 ) and
		 (cod_relacion = :as_cod_relacion ) ;
		 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 	
	Rollback ;
   MessageBox('SQL error cabecera',ls_msj_err )
	lb_ret = FALSE
	GOTO SALIDA
END IF		 


SALIDA:

Return lb_ret
end function

on w_ve312_facturacion_simplificada_anul.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_anula_elim" then this.MenuID = create m_proceso_anula_elim
this.st_2=create st_2
this.st_1=create st_1
this.sle_nro_doc=create sle_nro_doc
this.sle_tipo_doc=create sle_tipo_doc
this.uo_fechas=create uo_fechas
this.cb_1=create cb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_nro_doc
this.Control[iCurrent+4]=this.sle_tipo_doc
this.Control[iCurrent+5]=this.uo_fechas
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.gb_1
end on

on w_ve312_facturacion_simplificada_anul.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_nro_doc)
destroy(this.sle_tipo_doc)
destroy(this.uo_fechas)
destroy(this.cb_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija


//Crear Objeto
lnvo_asiento_cntbl = create n_cst_asiento_contable
end event

event ue_delete;//OVERRIDE
Long 	 ll_row_master ,ll_ano     ,ll_mes    ,ll_nro_libro    ,ll_nro_asiento,&
		 ll_row   	 	,ll_item
String ls_origen    ,ls_tipo_doc ,ls_nro_doc,ls_cod_relacion ,ls_nro_detrac ,&
		 ls_nro_ov    ,ls_doc_fact ,ls_doc_bol,ls_nro_guia     ,ls_nro_vale	 ,&
		 ls_nro_detraccion,ls_result,ls_mensaje

/*Parametros de Finanzas*/
select doc_fact_cobrar ,doc_bol_cobrar into :ls_doc_fact,:ls_doc_bol from finparam where reckey = '1' ;


ll_row_master = dw_master.Getrow()

ls_origen 		   = dw_master.object.origen			  [ll_row_master]
ll_ano	 		   = dw_master.object.ano				  [ll_row_master]
ll_mes	 		   = dw_master.object.mes				  [ll_row_master]
ll_nro_libro 	   = dw_master.object.nro_libro		  [ll_row_master]
ll_nro_asiento    = dw_master.object.nro_asiento	  [ll_row_master]
ls_nro_doc		   = dw_master.object.nro_doc_cc	     [ll_row_master]
ls_tipo_doc		   = dw_master.object.tipo_doc_cc     [ll_row_master]
ls_cod_relacion   = dw_master.object.cod_relacion    [ll_row_master]
ls_nro_detrac	   = dw_master.object.nro_detraccion  [ll_row_master]
ls_nro_ov		   = dw_master.object.nro_ov			  [ll_row_master]
ll_item			   = dw_master.object.item			     [ll_row_master]
ls_nro_guia		   = dw_master.object.nro_guia		  [ll_row_master]
ls_nro_vale		   = TRIM(dw_master.object.nro_vale	  [ll_row_master])
ls_nro_detraccion = dw_master.object.nro_detraccion  [ll_row_master]


/*verifica cierre*/
lnvo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario
				
IF ls_result = '0' THEN 
	Messagebox('Aviso',ls_mensaje)
	RETURN //Documento Ha sido Anulado o facturado
END IF	



IF wf_anula_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE THEN RETURN

IF wf_anula_doc_cobrar (ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_origen,ls_nro_ov,ll_item,ls_nro_detraccion) = FALSE THEN RETURN


/*Anulacion de GUIA si es factura*/
if ls_tipo_doc = ls_doc_fact then
	if wf_anula_guia(ls_origen,ls_nro_guia,ls_nro_vale,ls_nro_ov) = false then
		Return
	end if
else
	if wf_anula_mov_almacen (ls_nro_vale,ls_origen,ls_nro_ov) = false then
		Return
	end if
end if






ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

//
//THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0

END IF

end event

event ue_delete_pos;call super::ue_delete_pos;Messagebox('Aviso','Eliminacion de Documento Terminada ,Grabe el Proceso....')
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

type st_2 from statictext within w_ve312_facturacion_simplificada_anul
integer x = 1367
integer y = 176
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ve312_facturacion_simplificada_anul
integer x = 823
integer y = 176
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nro_doc from singlelineedit within w_ve312_facturacion_simplificada_anul
integer x = 1664
integer y = 168
integer width = 338
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type sle_tipo_doc from singlelineedit within w_ve312_facturacion_simplificada_anul
integer x = 1111
integer y = 168
integer width = 197
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type uo_fechas from u_ingreso_rango_fechas within w_ve312_facturacion_simplificada_anul
integer x = 736
integer y = 68
integer taborder = 50
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
//of_set_fecha(date('01/01/1900'), date('31/12/9999') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_1 from commandbutton within w_ve312_facturacion_simplificada_anul
integer x = 2158
integer y = 24
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Busqueda"
end type

event clicked;String 	ls_opcion, ls_tipo_doc,ls_nro_doc
Date		ld_Fecha1, ld_fecha2
	 


ld_Fecha1   = uo_fechas.of_get_fecha1()
ld_fecha2   = uo_fechas.of_get_fecha2()

if trim(sle_tipo_doc.text) = '' then
	ls_tipo_doc = '%%'
else
	ls_tipo_doc = trim(sle_tipo_doc.text) + '%'
end if

if trim(sle_nro_doc.text) = '' then
	ls_nro_doc = '%%'
else
	ls_nro_doc = trim(sle_nro_doc.text) + '%'
end if



if rb_1.checked then //por fecha
	ls_opcion = '1'
elseif rb_2.checked then //por nro
	ls_opcion = '2'
end if

dw_master.Retrieve(ls_opcion, ld_fecha1, ld_fecha2, ls_tipo_doc, ls_nro_doc)

end event

type rb_2 from radiobutton within w_ve312_facturacion_simplificada_anul
integer x = 64
integer y = 164
integer width = 663
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Nro de Documento"
end type

event clicked;if this.checked then
	sle_tipo_doc.enabled = true
	sle_nro_doc.enabled = true
	uo_fechas.enabled = false
end if
end event

type rb_1 from radiobutton within w_ve312_facturacion_simplificada_anul
integer x = 64
integer y = 80
integer width = 663
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Fecha de Documento"
boolean checked = true
end type

event clicked;if this.checked then
	sle_tipo_doc.enabled = false
	sle_nro_doc.enabled = false
	uo_fechas.enabled = true
end if
end event

type dw_master from u_dw_abc within w_ve312_facturacion_simplificada_anul
integer y = 324
integer width = 2473
integer height = 936
string dataobject = "d_abc_lista_factura_simplificada_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3

idw_mst = dw_master

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type gb_1 from groupbox within w_ve312_facturacion_simplificada_anul
integer x = 32
integer width = 2030
integer height = 292
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

