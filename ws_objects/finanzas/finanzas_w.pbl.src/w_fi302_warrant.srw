$PBExportHeader$w_fi302_warrant.srw
forward
global type w_fi302_warrant from w_abc
end type
type cb_1 from commandbutton within w_fi302_warrant
end type
type sle_nro from singlelineedit within w_fi302_warrant
end type
type cb_buscar from commandbutton within w_fi302_warrant
end type
type st_1 from statictext within w_fi302_warrant
end type
type tab_1 from tab within w_fi302_warrant
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
type dw_renovacion from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_renovacion dw_renovacion
end type
type tabpage_3 from userobject within tab_1
end type
type st_3 from statictext within tabpage_3
end type
type pb_1 from picturebutton within tabpage_3
end type
type st_2 from statictext within tabpage_3
end type
type pb_lib from picturebutton within tabpage_3
end type
type dw_liberado_det from u_dw_abc within tabpage_3
end type
type dw_liberado from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
st_3 st_3
pb_1 pb_1
st_2 st_2
pb_lib pb_lib
dw_liberado_det dw_liberado_det
dw_liberado dw_liberado
end type
type tab_1 from tab within w_fi302_warrant
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_master from u_dw_abc within w_fi302_warrant
end type
type gb_1 from groupbox within w_fi302_warrant
end type
end forward

global type w_fi302_warrant from w_abc
integer width = 3392
integer height = 2356
string title = "Warrant  [FI302]"
string menuname = "m_mantenimiento_cl_print"
event ue_genera_deuda_fin ( )
cb_1 cb_1
sle_nro sle_nro
cb_buscar cb_buscar
st_1 st_1
tab_1 tab_1
dw_master dw_master
gb_1 gb_1
end type
global w_fi302_warrant w_fi302_warrant

type variables
u_dw_abc	  idw_detail, idw_renovacion, idw_liberado, idw_lib_det

String	  is_accion, is_soles, is_dolares, is_desc_soles,  &
			  is_desc_dolares, is_salir, is_doc_warrant, is_desc_doc_warrant

//Variables para el log_diario
String      is_tabla_m,    is_colname_m[],    is_coltype_m[], &
				is_tabla_d,    is_colname_d[],    is_coltype_d[], &
				is_tabla_ren,  is_colname_ren[],  is_coltype_ren[], &
				is_tabla_lib,  is_colname_lib[],  is_coltype_lib[], &
				is_tabla_ldet, is_colname_ldet[], is_coltype_ldet[]
						


n_cst_log_diario	in_log
end variables

forward prototypes
public subroutine of_retrieve (string as_nro_warrant)
public function integer of_nro_item (datawindow adw_pd, long al_columna)
public subroutine of_accepttext ()
public function decimal of_monto_warrant ()
public subroutine of_set_modify ()
public function integer of_get_param ()
public function decimal wf_lote_emb_pendiente (string as_embarque, string as_lote_embaqrue)
public function decimal wf_cant_items_lib (string as_nro_warrant, long al_item_lib, long al_item_prod, string as_nro_embarque, string as_lote_emb)
end prototypes

event ue_genera_deuda_fin();String ls_doc_warrant  ,ls_cod_moneda  ,ls_tdeuda_fin,ls_tipo_doc    ,ls_nro_doc,&
		 ls_flag_cxc_cxp ,ls_flag_capital,ls_tdoc_warr ,ls_nro_warrant ,ls_obs	  ,&
		 ls_nro_deuda    ,ls_cod_relacion,ls_cod_banco 
Long   	ll_row_master,ll_count
Decimal 	ldc_monto_neg
Date	  	ld_fecha_actual	
Boolean 	lb_ret = TRUE


nvo_numeradores lnvo_numeradores
lnvo_numeradores = CREATE nvo_numeradores


if (dw_master.ii_update      = 1 OR idw_detail.ii_update   = 1 OR &
	 idw_renovacion.ii_update = 1 OR idw_liberado.ii_update = 1 OR &
	 idw_lib_det.ii_update    = 1 ) then
	 lb_ret = FALSE
	 Messagebox('Aviso','Tiene Grabaciones Pendientes,Verifique!')
	 GOTO SALIDA
end if


//verificar que se realizen grabaciones pendientes
ll_row_master = dw_master.Getrow()

if ll_row_master = 0 then
	lb_ret = FALSE
	Messagebox('Aviso','Debe Registrar Información para Generar Dedua Financiera,Verifique!')
	GOTO SALIDA
end if

dw_master.Accepttext()





//encuentro parametro de referencia de doc a generar
select doc_ref_warrant into :ls_doc_warrant from finparam where reckey = '1' ;

//encuentro datos segun tipo de deuda financiera
ls_nro_warrant	 = dw_master.object.nro_warrant		 [ll_row_master]
ls_obs			 = 'Warrant : '+ls_nro_warrant
ldc_monto_neg   = dw_master.object.monto_negociado  [ll_row_master]
ls_cod_moneda	 = dw_master.object.cod_moneda		 [ll_row_master]
ls_tdeuda_fin 	 = dw_master.object.tipo_deuda_fin   [ll_row_master]
ls_tipo_doc		 = dw_master.object.tipo_doc			 [ll_row_master]
ls_nro_doc		 = dw_master.object.nro_doc			 [ll_row_master]
ls_cod_banco	 = dw_master.object.cod_banco			 [ll_row_master]
ld_fecha_actual = today()


//VERIFICAR QUE WARRANT NO ESTE REGISTRADO EN DEDUA FINACIERA
select count(*) into :ll_count from deuda_financiera 
 where (tipo_doc = :ls_tipo_doc ) and
		 (nro_doc  = :ls_nro_doc  ) ;


if ll_count > 0 then
	Messagebox('Aviso','Deuda Financiera ya fue registrada ,verifique!')
	lb_ret = FALSE
	GOTO SALIDA
end if


if ldc_monto_neg = 0  or Isnull(ldc_monto_neg) then
	Messagebox('Aviso','Monto Negociado debe Ser mayor que 0')
	lb_ret = FALSE
	GOTO SALIDA
end if

if Isnull(ls_cod_moneda) OR trim(ls_cod_moneda) = '' then
	Messagebox('Aviso','Debe seleccionar un tipo de Moneda')
	lb_ret = FALSE
	GOTO SALIDA
end if

if Isnull(ls_tdeuda_fin) OR trim(ls_tdeuda_fin) = '' then
	Messagebox('Aviso','Debe seleccionar un tipo de Deuda Financiera')
	lb_ret = FALSE
	GOTO SALIDA
end if

if Isnull(ls_cod_banco) OR trim(ls_cod_banco) = '' then
	Messagebox('Aviso','Debe seleccionar un Banco')
	lb_ret = FALSE
	GOTO SALIDA
end if

//datos de banco
select proveedor into :ls_cod_relacion
  from banco
 where (cod_banco = :ls_cod_banco) ;

//datos de deuda financiera
select flag_cxc_cxp,flag_capital,tipo_doc
  into :ls_flag_cxc_cxp	,:ls_flag_capital,:ls_tdoc_warr
  from deuda_financ_tipo
 where (tipo_deuda_fin = :ls_tdeuda_fin ) and
 		 (flag_estado    = '1'            ) ;

//verificar si codigo de banco tiene asignado codigo de relacion
if Isnull(ls_cod_relacion) OR trim(ls_cod_relacion) = '' then
	Messagebox('Aviso','Banco no Tiene Asigando Codigo de Relación')
	lb_ret = FALSE
	GOTO SALIDA
end if

//incrementa numerador de deuda financiera
IF lnvo_numeradores.uf_num_deuda_financiera(gs_origen,ls_nro_deuda) = FALSE THEN
	lb_ret = FALSE
	GOTO SALIDA
END IF

//cabecera
Insert Into deuda_financiera
(tipo_doc       ,tipo_deuda_fin ,fec_registro ,cod_origen    ,usr_reg       ,    
 cod_moneda     ,tot_capital    ,tot_interes  ,tot_portes    ,tot_igv       ,   
 fec_aprobacion ,usr_vobo		  ,tipo_doc_ref ,nro_doc_ref   ,saldo_capital ,   
 saldo_interes  ,saldo_portes   ,saldo_igv    ,observaciones ,flag_estado   ,   
 nro_registro	 ,cod_relacion   ,nro_doc		 ,fec_documento )  
Values
(:ls_tdoc_warr  ,:ls_tdeuda_fin   ,:ld_fecha_actual  ,:gs_origen ,:gs_user 	  ,
 :ls_cod_moneda ,:ldc_monto_neg   ,0.00			     ,0.00       ,0.00     	  ,
 null				 ,null             ,null				  ,null		  ,:ldc_monto_neg ,
 0.00				 ,0.00			    ,0.00				  ,:ls_obs	  ,'3'				,
 :ls_nro_deuda  ,:ls_cod_relacion ,:ls_nro_doc		  ,:ld_fecha_actual) ;


//fallo grabación
IF SQLCA.SQLCode = -1 THEN 
	lb_ret = false
   MessageBox('SQL error', SQLCA.SQLErrText)
	GOTO SALIDA
END IF

SALIDA:



if lb_ret = FALSE then
	
	Rollback ;
	
	
else
	//ejecuta grabacion
	triggerevent('ue_update')
	//actualiza dw cabcera con la deuda
	dw_master.object.nro_registro [ll_row_master] = ls_nro_deuda
end if


destroy lnvo_numeradores
end event

public subroutine of_retrieve (string as_nro_warrant);// Limpieza de los datawindows
dw_master.reset( )
idw_detail.reset( )
idw_renovacion.reset( )
idw_liberado.reset( )
idw_lib_det.reset( )

//Recupera la data
dw_master.retrieve     ( as_nro_warrant )
idw_detail.retrieve    ( as_nro_warrant )
idw_renovacion.retrieve( as_nro_warrant )
idw_liberado.retrieve  ( as_nro_warrant )
//idw_lib_det.retrieve  ( as_nro_warrant )

dw_master.ii_protect 	  = 0
idw_detail.ii_protect 	  = 0
idw_renovacion.ii_protect = 0
idw_liberado.ii_protect   = 0
idw_lib_det.ii_protect	  = 0

dw_master.of_protect		 ( )
idw_detail.of_protect	 ( )
idw_renovacion.of_protect( )
idw_liberado.of_protect	 ( )
idw_lib_det.of_protect	 ( )

dw_master.ii_update 			= 0
idw_detail.ii_update 		= 0
idw_renovacion.ii_update 	= 0
idw_liberado.ii_update		= 0
idw_lib_det.ii_update		= 0	

is_Accion = 'open'

//of_set_status_menu(dw_1)

end subroutine

public function integer of_nro_item (datawindow adw_pd, long al_columna);integer li_item, li_x
long	  ll_item

li_item = 0

For li_x = 1 to adw_pd.RowCount()
	ll_item = adw_pd.GetItemNumber(li_x, al_columna)
	IF li_item < ll_item THEN
		li_item = ll_item
	END IF
Next


Return li_item + 1
end function

public subroutine of_accepttext ();// AceptText a todos los Datawindows


dw_master.Accepttext( )
idw_detail.Accepttext()
idw_renovacion.Accepttext( )
idw_liberado.Accepttext( )
idw_lib_det.Accepttext( )
end subroutine

public function decimal of_monto_warrant ();// Funcion para calcular los montos real y negociado del warrant

Long ll_i
Decimal  ldc_real, ldc_negociado

IF dw_master.GetRow() = 0 THEN RETURN 0

ldc_real 		= 0.00
ldc_negociado = 0.00

FOR ll_i = 1 TO idw_detail.RowCount()
	ldc_real 		= ldc_real + (idw_detail.object.precio_real[ll_i] * &
		 	     		  idw_detail.object.cantidad[ll_i] )

	ldc_negociado = ldc_negociado + (idw_detail.object.precio_neg[ll_i] * &
		 	     		 idw_detail.object.cantidad[ll_i] )

NEXT

dw_master.object.monto_real 		[dw_master.GetRow()] = ldc_real
dw_master.object.monto_negociado	[dw_master.GetRow()] = ldc_negociado

dw_master.ii_update = 1

return ldc_real
end function

public subroutine of_set_modify ();//cantidad

idw_detail.Modify("cantidad.Protect ='1~tIf((cantidad_liberado > 0),1,0)'")
idw_detail.Modify("cantidad.Background.color ='1~tIf(cantidad_liberado > 0,RGB(192,192,192), RGB(255,255,255))'")

//Templa
idw_detail.Modify("cod_templa.Protect ='1~tIf((cantidad_liberado > 0),1,0)'")
idw_detail.Modify("cod_templa.Background.color ='1~tIf(cantidad_liberado > 0,RGB(192,192,192), RGB(255,255,255))'")

//Articulo
idw_detail.Modify("cod_art.Protect ='1~tIf((cantidad_liberado > 0),1,0)'")
idw_detail.Modify("cod_art.Background.color ='1~tIf(cantidad_liberado > 0,RGB(192,192,192), RGB(255,255,255))'")

//Unidad
idw_detail.Modify("und.Protect ='1~tIf((cantidad_liberado > 0),1,0)'")
idw_detail.Modify("und.Background.color ='1~tIf(cantidad_liberado > 0,RGB(192,192,192), RGB(255,255,255))'")



end subroutine

public function integer of_get_param ();//Carga los parametros definidos en LOGPARAM

SELECT L.COD_SOLES, M.DESCRIPCION, L.COD_DOLARES,  M1.DESCRIPCION  
  INTO :is_soles, :is_desc_soles, :is_dolares, :is_desc_dolares
FROM   LOGPARAM L,
       MONEDA   M,
       MONEDA   M1
WHERE  L.COD_SOLES   = M.COD_MONEDA      
  AND  L.COD_DOLARES = M1.COD_MONEDA;

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros de Moneda LOGPARAM")
	RETURN 0
END IF

SELECT  A.DOC_REF_WARRANT, B.DESC_TIPO_DOC
  INTO  :is_doc_warrant, :is_desc_doc_warrant
FROM    FINPARAM   A, DOC_TIPO   B
WHERE   A.DOC_REF_WARRANT  = B.TIPO_DOC;

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros de tipo_doc en FINPARAM")
	RETURN 0
END IF

RETURN 1
end function

public function decimal wf_lote_emb_pendiente (string as_embarque, string as_lote_embaqrue);Decimal {4} ldc_cant_pend



select (Nvl(cant_maxima_permitida,0) - Nvl(le.cant_liberada,0))
  into :ldc_cant_pend
  from lote_embarque le
 where (le.nro_embarque = :as_embarque      ) and
 		 (le.nro_lote		= :as_lote_embaqrue ) ;







Return ldc_cant_pend
end function

public function decimal wf_cant_items_lib (string as_nro_warrant, long al_item_lib, long al_item_prod, string as_nro_embarque, string as_lote_emb);Decimal {4} ldc_cant_lib

select cantidad_liberado into :ldc_cant_lib
  from warrant_liberado_det 
 where (nro_warrant  = :as_nro_warrant  ) and
 		 (item_lib	   = :al_item_lib     ) and
		 (item_prod	   = :al_item_prod    ) and
		 (nro_embarque = :as_nro_embarque ) and
		 (nro_lote_emb = :as_lote_emb	    ) ;
		 
		 
Return ldc_cant_lib	 
end function

on w_fi302_warrant.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_print" then this.MenuID = create m_mantenimiento_cl_print
this.cb_1=create cb_1
this.sle_nro=create sle_nro
this.cb_buscar=create cb_buscar
this.st_1=create st_1
this.tab_1=create tab_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_nro
this.Control[iCurrent+3]=this.cb_buscar
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.gb_1
end on

on w_fi302_warrant.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_nro)
destroy(this.cb_buscar)
destroy(this.st_1)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event open;// Ancester Override

idw_detail 		= tab_1.tabpage_1.dw_detail
idw_renovacion = tab_1.tabpage_2.dw_renovacion
idw_liberado	= tab_1.tabpage_3.dw_liberado
idw_lib_det		= tab_1.tabpage_3.dw_liberado_det


IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_open_pre;call super::ue_open_pre;
is_accion = 'open'

is_salir = ''

//Verifico que se cargen los parametros en variables de instancia
IF of_get_param() = 0 THEN
   is_salir = 'S'
	post event closequery()   
	RETURN
END IF

dw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos
dw_master.ii_protect = 0
dw_master.of_protect( )

//Datawindow por defecto
idw_1 = dw_master

idw_detail.SetTransObject    (Sqlca)
idw_renovacion.SetTransObject(Sqlca)
idw_liberado.SetTransObject  (Sqlca)
idw_lib_det.SetTransObject   (Sqlca)


// Regitro del Log Diario
is_tabla_m   = dw_master.Object.Datawindow.Table.UpdateTable
is_tabla_d   = idw_detail.Object.Datawindow.Table.UpdateTable
is_tabla_ren = idw_renovacion.Object.Datawindow.Table.UpdateTable
is_tabla_lib = idw_liberado.Object.Datawindow.Table.UpdateTable
is_tabla_ldet= idw_lib_det.Object.Datawindow.Table.UpdateTable

end event

event ue_insert;call super::ue_insert;Long   ll_row_master, ll_row, ll_verifica
String ls_clase, ls_nro_warrant, ls_cod_almacen

of_accepttext() //accepttext de los dw

ll_row_master  = dw_master.getrow( )

CHOOSE CASE idw_1
	CASE dw_master
	   // Adicionando en dw_master
	   TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   IF ib_update_check = FALSE THEN RETURN
	  
	   // Limpieza de los demas dw en insercion
	   idw_detail.reset		( ) 
	   idw_renovacion.reset	( )
	   idw_liberado.reset	( )
	   idw_lib_det.reset		( )
	 
	CASE idw_detail
		
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
		ls_nro_warrant = dw_master.object.nro_warrant [ll_row_master]
		
		IF IsNull(ls_nro_warrant) or Len(ls_nro_warrant) = 0 THEN
			MessageBox('Error', 'Por favor ingrese un Numero de Warrant')
			RETURN
		END IF
		
		ls_cod_almacen = dw_master.object.almacen		 [ll_row_master]
		IF IsNull(ls_cod_almacen) or Len(ls_cod_almacen) = 0 THEN
			MessageBox('Error', 'Por favor ingrese un Codigo de Almacen')
			RETURN
		END IF
		
	CASE idw_renovacion
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
		ls_nro_warrant = dw_master.object.nro_warrant [ll_row_master]
		IF IsNull(ls_nro_warrant) or Len(ls_nro_warrant) = 0 THEN
			MessageBox('Error', 'Por favor ingrese un Numero de Warrant')
			RETURN
		END IF
		
	CASE idw_liberado
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
		ls_nro_warrant = dw_master.object.nro_warrant [ll_row_master]
		IF IsNull(ls_nro_warrant) or Len(ls_nro_warrant) = 0 THEN
			MessageBox('Error', 'Por favor ingrese un Numero de Warrant')
			RETURN
		END IF
		
	CASE idw_lib_det
		IF dw_master.GetRow() = 0 OR idw_liberado.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
	
		ls_nro_warrant = dw_master.object.nro_warrant [ll_row_master]
		IF IsNull(ls_nro_warrant) or Len(ls_nro_warrant) = 0 THEN
			MessageBox('Error', 'Por favor ingrese un Numero de Warrant')
			RETURN
		END IF
		
   CASE ELSE
	  RETURN
	  
END CHOOSE

//insertar
is_accion = 'new' 

IF idw_1 = idw_lib_det THEN
	tab_1.tabpage_3.pb_lib.event clicked( )
ELSE
	ll_row = idw_1.Event ue_insert()
	
	IF ll_row <> -1 THEN
		THIS.EVENT ue_insert_pos(ll_row)
	END IF
END IF
end event

event resize;call super::resize;This.SetRedraw(false)

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.height = newheight - tab_1.y - 10
tab_1.width  = newwidth  - tab_1.x - 10


//resize de los objetos dentro del tab

tab_1.tabpage_1.dw_detail.width  	= tab_1.width  - tab_1.tabpage_1.dw_detail.x - 40
tab_1.tabpage_1.dw_detail.height 	= tab_1.height - tab_1.tabpage_1.dw_detail.y - 150
tab_1.tabpage_2.dw_renovacion.width = tab_1.width  - tab_1.tabpage_2.dw_renovacion.x - 40
tab_1.tabpage_2.dw_renovacion.height= tab_1.height - tab_1.tabpage_2.dw_renovacion.y - 150

//idw_liberado.height  = tab_1.height - idw_lib_det.y - 800
//idw_lib_det.width    = tab_1.width  - idw_lib_det.x - 40
tab_1.tabpage_3.dw_liberado_det.height = tab_1.height - tab_1.tabpage_3.dw_liberado_det.y - 150

This.SetRedraw(True)
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar

IF (dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR &
	 idw_renovacion.ii_update = 1 OR idw_liberado.ii_update = 1 OR &
	 idw_lib_det.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 			= 0
		idw_detail.ii_update 		= 0
		idw_renovacion.ii_update 	= 0	
		idw_liberado.ii_update  	= 0
		idw_lib_det.ii_update  		= 0	
		ROLLBACK;
	END IF
END IF
end event

event ue_update_pre;call super::ue_update_pre;
IF dw_master.rowcount( ) = 0 THEN RETURN

ib_update_check = FALSE

// Verifica datos obligatorios en el dw_master
IF f_row_Processing( dw_master, "form") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_datos_generales
IF f_row_Processing( idw_detail, "tabular") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_depreciacion
IF f_row_Processing( idw_renovacion, "tabular") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_incidencias
IF f_row_Processing( idw_liberado, "tabular") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_adaptaciones
IF f_row_Processing( idw_lib_det, "tabular") <> TRUE THEN RETURN


// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = TRUE
end event

event ue_update;// Override
Boolean lbo_ok = TRUE
Integer	li_rc
String	ls_msg, ls_nro_warrant

of_accepttext() 

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


// Para el Log Diario

IF ib_log THEN
	Datastore	lds_log_m, lds_log_d , lds_log_ren, lds_log_lib, &
					lds_log_ldet
					
	lds_log_m 	 = Create DataStore
	lds_log_d 	 = Create DataStore
	lds_log_ren  = Create DataStore
	lds_log_lib  = Create DataStore			
	lds_log_ldet = Create DataStore
	
	lds_log_m.DataObject 	= 'd_log_diario_tbl'
	lds_log_d.DataObject 	= 'd_log_diario_tbl'
	lds_log_ren.DataObject 	= 'd_log_diario_tbl'
	lds_log_lib.DataObject 	= 'd_log_diario_tbl'
	lds_log_ldet.DataObject = 'd_log_diario_tbl'
	
	lds_log_m.SetTransObject	(SQLCA)
	lds_log_d.SetTransObject	(SQLCA)
	lds_log_ren.SetTransObject	(SQLCA)
	lds_log_lib.SetTransObject	(SQLCA)
	lds_log_ldet.SetTransObject(SQLCA)
	
	in_log.of_create_log(dw_master, 			lds_log_m,    is_colname_m,    is_coltype_m, 	gs_user, is_tabla_m)
	in_log.of_create_log(idw_detail, 		lds_log_d,    is_colname_d,    is_coltype_d, 	gs_user, is_tabla_d)
	in_log.of_create_log(idw_renovacion, 	lds_log_ren,  is_colname_ren,  is_coltype_ren, 	gs_user, is_tabla_ren)
	in_log.of_create_log(idw_liberado,  	lds_log_lib,  is_colname_lib,  is_coltype_lib, 	gs_user, is_tabla_lib)
	in_log.of_create_log(idw_lib_det, 		lds_log_ldet, is_colname_ldet, is_coltype_ldet, gs_user, is_tabla_ldet)
	
END IF

ls_msg = "Se ha procedido al Rollback"

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		            // Grabación del Masestro
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación del Maestro", ls_msg, exclamation!)
	END IF
END IF

IF idw_detail.ii_update = 1 THEN
	IF idw_detail.Update() = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación Detalle de Warrant", ls_msg, exclamation!)
	END IF
END IF

IF idw_renovacion.ii_update = 1 THEN
	IF idw_renovacion.Update() = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación en Renovacion de Warrant", ls_msg, exclamation!)
	END IF
END IF

IF idw_liberado.ii_update = 1 THEN
	IF idw_liberado.Update() = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación en liberación de Warrant", ls_msg, exclamation!)
	END IF
END IF

IF idw_lib_det.ii_update = 1 THEN
	IF idw_lib_det.Update() = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación en Detalle de Liberacion", ls_msg, exclamation!)
	END IF
END IF

// Para el log Diario
ls_msg = 'No se pudo grabar el Log Diario'

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', ls_msg + ', Maestro')
		END IF
		
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', ls_msg +', Detalle')
		END IF
		
   	IF lds_log_ren.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', ls_msg + ', Renovacion')
		END IF
		
		IF lds_log_lib.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', ls_msg + ',Liberación')
		END IF
		
		IF lds_log_ldet.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', ls_msg + ', Detalle Liberacion')
		END IF
		
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
	DESTROY lds_log_ren
	DESTROY lds_log_lib
	DESTROY lds_log_ldet
END IF



IF lbo_ok THEN
	COMMIT using SQLCA;
	ls_nro_warrant = dw_master.object.nro_warrant[dw_master.GetRow()]
	of_retrieve(ls_nro_warrant)
	
	dw_master.ii_update 			= 0
	idw_detail.ii_update 		= 0
	idw_renovacion.ii_update	= 0
	idw_liberado.ii_update		= 0
	idw_lib_det.ii_update		= 0
	
	is_accion = 'open'
	
END IF

end event

event close;call super::close;IF ib_log THEN
	DESTROY in_log
END IF
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(idw_detail, is_colname_d, is_coltype_d)
	in_log.of_dw_map(idw_renovacion, is_colname_ren, is_coltype_ren)
	in_log.of_dw_map(idw_liberado, is_colname_lib, is_coltype_lib)
	in_log.of_dw_map(idw_lib_det, is_colname_ldet, is_coltype_ldet)
	
END IF
end event

event ue_list_open;call super::ue_list_open;// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'd_lista_warrant_tbl'
sl_param.titulo = 'WARRANTS'
sl_param.field_ret_i[1] = 1	//Cod_Origen
sl_param.field_ret_i[2] = 2	//Nro_Warrant

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[2])
END IF
end event

event ue_modify;//override
is_accion = 'modify'

IF dw_master.GetRow() = 0 THEN RETURN

idw_1.of_protect()

IF idw_1 = dw_master THEN
	dw_master.object.almacen.Protect = 1
END IF

of_set_modify()


end event

event closequery;call super::closequery;CHOOSE CASE is_salir
	CASE 'S'
		CLOSE (this)
//		
//	CASE ELSE
//		THIS.Event ue_close_pre()
//		THIS.EVENT ue_update_request()
//		IF ib_update_check = False THEN
//			ib_update_check = TRUE
//			RETURN 1
//		END IF
//		Destroy	im_1
//		of_close_sheet()
END CHOOSE
end event

type cb_1 from commandbutton within w_fi302_warrant
integer x = 2135
integer y = 188
integer width = 704
integer height = 104
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Genera Deuda Financiera"
end type

event clicked;Parent.triggerEvent('ue_genera_deuda_fin')
end event

type sle_nro from singlelineedit within w_fi302_warrant
integer x = 434
integer y = 60
integer width = 430
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;cb_buscar.event clicked()
end event

type cb_buscar from commandbutton within w_fi302_warrant
integer x = 987
integer y = 44
integer width = 297
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type st_1 from statictext within w_fi302_warrant
integer x = 114
integer y = 68
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero :"
alignment alignment = right!
boolean focusrectangle = false
end type

type tab_1 from tab within w_fi302_warrant
integer x = 18
integer y = 960
integer width = 3200
integer height = 1196
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3163
integer height = 1068
long backcolor = 79741120
string text = "   Detalle de Warrant"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Cursor!"
long picturemaskcolor = 536870912
string powertiptext = "Datos del Detalle del Warrant"
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
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 28
integer width = 3104
integer height = 924
integer taborder = 20
string dataobject = "d_abc_warrant_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_string, ls_evaluate

str_seleccionar lstr_seleccionar

			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE 'cod_art'
 		   lstr_seleccionar.s_sql = "SELECT A.COD_ART AS CODIGO," &
								 		   +"A.NOM_ARTICULO AS DESCRIPCION,"&
										   +"A.UND AS UNIDAD "&			  
					  						+"FROM ARTICULO A "&
					  						+"WHERE A.FLAG_ESTADO = "+"'"+'1'+"'"
												 
			OpenWithParm(w_seleccionar,lstr_seleccionar)
				
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN

				This.object.cod_art [al_row] = lstr_seleccionar.param1[1]
				This.object.desc_art[al_row] = lstr_seleccionar.param2[1]
				This.object.und     [al_row] = lstr_seleccionar.param3[1]
				ii_update = 1
			END IF		
			
END CHOOSE
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2


end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;String  ls_nro_warrant

IF dw_master.GetRow() = 0 THEN RETURN

ls_nro_warrant = dw_master.object.nro_warrant[dw_master.getrow()]

This.object.nro_warrant [al_row] = ls_nro_warrant
This.object.item_prod	[al_row] = of_nro_item(this, 2)
This.object.cantidad		[al_row] = 0.00
This.object.precio_real	[al_row] = 0.00
This.object.precio_neg	[al_row] = 0.00

of_set_modify()

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_null , ls_cod_art , ls_und
Long	 	ll_count
Decimal {4} ldc_cant_liberada


SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
		 CASE 'cod_art'
			   SELECT  a.nom_articulo,a.und
			     INTO  :ls_data,:ls_und
				  FROM   articulo a
				 WHERE  (a.cod_art     = :data ) and 
					     (a.flag_estado = '1'   ) ;
			
				IF SQLCA.sqlcode = 100 THEN
					MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
					This.object.cod_art	[row] = ls_null
					This.object.desc_art	[row]	= ls_null
					This.object.und    	[row]	= ls_null
					RETURN 1
				END IF
			
				This.object.desc_art [row]	= ls_data
				This.object.und      [row]	= ls_und

END CHOOSE

of_monto_warrant()
end event

event itemerror;call super::itemerror;RETURN 1

end event

event keydwn;call super::keydwn;String 	ls_columna, ls_cadena
Integer 	li_column
Long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
IF key = KeyF2! THEN
	This.AcceptText()
	li_column = this.GetColumn()
	IF li_column <= 0 THEN
		RETURN 0
	END IF
	ls_cadena = "#" + string( li_column ) + ".Protect"
	IF This.Describe(ls_cadena) = '1' THEN RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( This.Describe(ls_cadena) )
	
	ll_row = This.GetRow()
	IF ls_columna <> "!" then
	 	This.event dynamic ue_display( ls_columna, ll_row )
	END IF
END IF
RETURN 0
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3163
integer height = 1068
long backcolor = 79741120
string text = "Renovación de Warrant"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Compute!"
long picturemaskcolor = 536870912
dw_renovacion dw_renovacion
end type

on tabpage_2.create
this.dw_renovacion=create dw_renovacion
this.Control[]={this.dw_renovacion}
end on

on tabpage_2.destroy
destroy(this.dw_renovacion)
end on

type dw_renovacion from u_dw_abc within tabpage_2
integer x = 18
integer y = 40
integer width = 3104
integer height = 928
integer taborder = 20
string dataobject = "d_abc_warrant_renovacion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
end event

event ue_insert_pre;call super::ue_insert_pre;String  ls_nro_warrant

IF dw_master.GetRow() = 0 THEN RETURN

ls_nro_warrant = dw_master.object.nro_warrant[dw_master.getrow()]

This.object.nro_warrant 		[al_row] = ls_nro_warrant
This.object.item_lib				[al_row] = of_nro_item(this, 2)
This.object.fecha_registro		[al_row] = f_fecha_actual()
This.object.fecha_emision		[al_row] = f_fecha_actual()
This.object.fecha_vencimiento	[al_row] = f_fecha_actual()
This.object.interes				[al_row] = 0.00
This.object.monto_renovado		[al_row] = 0.00

IF al_row = 1 Then
	This.object.monto[al_row] = dw_master.object.monto_negociado[dw_master.getrow()]
ELSEIF al_row > 1 THEN
	This.object.monto[al_row] = dw_master.object.monto_renovado[dw_master.getrow()]
END IF

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String ls_data, ls_null


SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'monto_renovado'
			dw_master.object.monto_renovado [dw_master.getrow()] = dec(data)
			dw_master.ii_update = 1
END CHOOSE
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3163
integer height = 1068
long backcolor = 79741120
string text = "Liberación de Warrant"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Inherit!"
long picturemaskcolor = 536870912
st_3 st_3
pb_1 pb_1
st_2 st_2
pb_lib pb_lib
dw_liberado_det dw_liberado_det
dw_liberado dw_liberado
end type

on tabpage_3.create
this.st_3=create st_3
this.pb_1=create pb_1
this.st_2=create st_2
this.pb_lib=create pb_lib
this.dw_liberado_det=create dw_liberado_det
this.dw_liberado=create dw_liberado
this.Control[]={this.st_3,&
this.pb_1,&
this.st_2,&
this.pb_lib,&
this.dw_liberado_det,&
this.dw_liberado}
end on

on tabpage_3.destroy
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.pb_lib)
destroy(this.dw_liberado_det)
destroy(this.dw_liberado)
end on

type st_3 from statictext within tabpage_3
integer x = 1833
integer y = 16
integer width = 960
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Genera Cuota de Deuda Financiera"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within tabpage_3
integer x = 2162
integer y = 84
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "CreateLibrary!"
alignment htextalign = left!
end type

event clicked;Long   ll_row,ll_item_lib,ll_row_master,ll_nro_cuota = 0
String ls_nro_warrant,ls_nro_registro,ls_cod_relacion,ls_tipo_doc,ls_nro_doc,&
		 ls_cod_banco	,ls_flag_estado ,ls_msj_err     ,ls_flag_estado_lib
Date	 ld_fecha		 	


ll_row = dw_liberado.Getrow()


if ll_row = 0  then 
	Messagebox('Aviso','Debe Indicar Liberacion a Generar Cuota ,Verifique!')
	Return
end if	

ll_row_master = dw_master.Getrow()

if ll_row_master = 0  then 
	Messagebox('Aviso','No Existe Datos Principales de Warrant ,Verifique!')
	Return
end if	

//datos de cabecera
ls_cod_banco	 = dw_master.object.cod_banco   [ll_row_master]
ls_tipo_doc		 =	dw_master.object.tipo_doc    [ll_row_master] 
ls_nro_doc		 = dw_master.object.nro_doc     [ll_row_master]


IF Isnull(ls_cod_banco) Or Trim(ls_cod_banco) = '' THEN
	Messagebox('Aviso','Debe Considerar algun Banco para Generar Cuotas de Deuda Financiera ,Verifique!')
	Return
END IF

//buscar codigo de Relacion de BANCO 
select proveedor into :ls_cod_relacion from banco 
 where cod_banco = :ls_cod_banco ;
 
if Isnull(ls_cod_relacion) or Trim(ls_cod_relacion) = '' then
	Messagebox('Aviso','Codigo de Banco no tiene Codigo de Relación , Verifique')
	Return
end if



ls_nro_warrant     = dw_liberado.object.nro_warrant     [ll_row]
ll_item_lib		    = dw_liberado.object.item_lib		  [ll_row]
ls_flag_estado_lib = dw_liberado.object.flag_estado	  [ll_row]
ld_fecha			    = Date(dw_liberado.object.fecha_emision [ll_row])


if ls_flag_estado_lib = '2' then
	Messagebox('Aviso','Item ya fue Cerrado ,Verifique!')
end if	


//generar cuota de deuda financiera
//verificar que deuda financiera este generada
select nro_registro,flag_estado into :ls_nro_registro,:ls_flag_estado
  from deuda_financiera
 where (cod_relacion = :ls_cod_relacion ) and
	 	 (tipo_doc		= :ls_tipo_doc		 ) and
 		 (nro_doc 		= :ls_nro_doc		 ) ;
		  
if sqlca.sqlcode = 100 then
	Messagebox('Aviso','Deuda Financiera no ha sido Generada ,Verifique! ')
	Return
end if	




//genera cuota 

DECLARE PB_USP_FIN_gen_cuota_x_lib PROCEDURE FOR USP_FIN_gen_cuota_x_lib
(:ls_nro_warrant,:ll_item_lib,:ls_nro_registro,:ls_tipo_doc,:ls_nro_doc,:gs_user,:ls_flag_estado,:ld_fecha);
EXECUTE PB_USP_FIN_gen_cuota_x_lib ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error',ls_msj_err)
END IF

FETCH PB_USP_FIN_gen_cuota_x_lib INTO :ll_nro_cuota ;



Messagebox('Aviso','Se Generara Cuota Nº  ' + Trim(String(ll_nro_cuota)) + ' de Deuda Fiananciera Nº '+ls_nro_Registro +' Para Continuar Presione <Aceptar> ')

//actualiza estado de lIberacion
dw_liberado.object.flag_estado [ll_row]= '2'
dw_liberado.ii_update = 1


//dispara update de warrant
Parent.TriggerEvent('ue_update')
end event

type st_2 from statictext within tabpage_3
integer x = 2382
integer y = 324
integer width = 741
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Referencias de EMBARQUE"
boolean focusrectangle = false
end type

type pb_lib from picturebutton within tabpage_3
integer x = 2720
integer y = 428
integer width = 128
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Compile!"
alignment htextalign = left!
string powertiptext = "Ingresar Detalle de Liberacion"
end type

event clicked;str_parametros sl_param
String ls_nro_warrant,ls_flag_estado


ls_nro_warrant		 = dw_master.object.nro_warrant[dw_master.Getrow()]
tab_1.tabpage_3.dw_liberado.il_row = tab_1.tabpage_3.dw_liberado.getrow( )


//datos de liberacion
ls_flag_estado = tab_1.tabpage_3.dw_liberado.object.flag_estado [tab_1.tabpage_3.dw_liberado.getrow()]

if ls_flag_estado = '2' then
	Messagebox('Aviso','Liberacion Fue Cerrada , Inserte Nueva Liberación')
	Return
end if


sl_param.tipo		 = '13'
sl_param.opcion	 = 12         //Warrant - Embarque
sl_param.titulo 	 = 'Selección de Embarque pendientes'
sl_param.dw_master = 'd_lista_warrant_det_liberado_tbl'
sl_param.dw1		 = 'd_abc_lista_lotes_embarque_disp_tbl'
sl_param.dw_m		 = dw_master
sl_param.dw_d		 = tab_1.tabpage_3.dw_liberado
sl_param.dw_c		 = tab_1.tabpage_3.dw_liberado_det
sl_param.string1	 = ls_nro_warrant
sl_param.db1		 = tab_1.tabpage_3.dw_liberado_det.il_row

dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
	IF sl_param.titulo = 's' THEN

	END IF

end event

type dw_liberado_det from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 560
integer width = 3086
integer height = 500
integer taborder = 20
string dataobject = "d_abc_warrant_liberado_det_Tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);////as columna, al_row
//
//boolean 	lb_ret
//string 	ls_codigo, ls_data, ls_sql, ls_data2, ls_data3, ls_string, &
//			ls_evaluate
//			
//str_parametros sl_param
//
//ls_string = this.Describe(lower(as_columna) + '.Protect' )
//
//IF len(ls_string) > 1 THEN
//	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
//	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
//	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
//	IF This.Describe(ls_evaluate) = '1' THEN RETURN
//ELSE
//	IF ls_string = '1' THEN RETURN
//END IF
//
//CHOOSE CASE lower(as_columna)
//	CASE "confin"
//		sl_param.tipo			= ''
//		sl_param.opcion		= 1
//		sl_param.titulo 		= 'Selección de Concepto Financiero'
//		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
//		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
//		sl_param.dw_m			=  This
//				
//		OpenWithParm( w_abc_seleccion, sl_param)
//		
//		IF not isvalid(message.PowerObjectParm) or IsNull(Message.PowerObjectParm) THEN return
//		sl_param = message.PowerObjectParm			
//		
//		IF sl_param.titulo = 's' THEN 
//			This.object.confin 		[al_row] = sl_param.field_ret[1]
//			This.object.desc_confin [al_row] = sl_param.field_ret[3]
//			This.ii_update = 1
//		END IF
//				
//	CASE "tipo_mov"
//		ls_sql = "SELECT TIPO_MOV AS CODIGO, " &
//				  +"DESC_TIPO_MOV AS DESCRIPCION "&
//				  +"FROM ARTICULO_MOV_TIPO " &
//				  +"WHERE FLAG_ESTADO = '1' " &
//				 
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//		IF ls_codigo <> '' THEN
//			This.object.tipo_mov 	 [al_row] = ls_codigo
//			This.object.desc_tipo_mov[al_row] = ls_data
//			This.ii_update = 1
//		END IF
//		
//END CHOOSE
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
is_mastdet = 'd'
ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1		// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3

ii_rk[1] = 1		  // columnas que recibimos del master
ii_rk[2] = 2

idw_mst =tab_1.tabpage_3.dw_liberado
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;String  	ls_nro_warrant
Long		ll_item

IF dw_master.GetRow() = 0 THEN RETURN


end event

event itemerror;call super::itemerror;RETURN 1

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event itemchanged;call super::itemchanged;String ls_nro_warrant,ls_nro_embarque,ls_nro_lote ,ls_flag_estado
Long   ll_item_lib,ll_item_prod
Decimal {4} ldc_cant_liberada,ldc_cant_pend,ldc_cantidad_old
dwItemStatus ldis_status

ldc_cantidad_old = this.object.cantidad_liberado [row]

This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 	 CASE 'cantidad_liberado'
				//verificar estado de liberacion
				ls_flag_estado  = tab_1.tabpage_3.dw_liberado.object.flag_estado [tab_1.tabpage_3.dw_liberado.Getrow()]
				if ls_flag_estado = '2' then
					Messagebox('Aviso','No puede Modificar Cantidad liberada por que Cuota fue Generada  de Acuerdo A Cantidades Registradas')
					this.object.cantidad_liberado [row] = ldc_cantidad_old
					Return 1
				end if				
				
				//datos de lote_embarque
				ldis_status = this.GetItemStatus(row,0,Primary!)				
				ls_nro_warrant    = this.object.nro_warrant       [row]
				ll_item_lib			= this.object.item_lib			  [row]
				ll_item_prod		= this.object.item_prod			  [row]
				ls_nro_embarque   = this.object.nro_embarque      [row]
				ls_nro_lote		   = this.object.nro_lote_emb      [row]
				ldc_cant_liberada = this.object.cantidad_liberado [row]
				

				IF ldis_status = NewModified! THEN
					ldc_cant_pend = wf_lote_emb_pendiente (ls_nro_embarque,ls_nro_lote	)
					
					if ldc_cant_liberada > ldc_cant_pend   then //coloco cantidad pendientes
						Messagebox('Aviso','Cantida a Liberarse no puede ser Mayor que Cantidad Pendiente de Embarque')
						this.object.cantidad_liberado [row] = ldc_cant_pend
						Return 1
					end if	
				ELSE	
					ldc_cant_pend     = wf_lote_emb_pendiente (ls_nro_embarque,ls_nro_lote)
					ldc_cant_liberada = wf_cant_items_lib (ls_nro_warrant,ll_item_lib,ll_item_prod,ls_nro_embarque,ls_nro_lote)					
					
					ldc_cant_pend     = ldc_cant_pend + ldc_cant_liberada
					ldc_cant_liberada = this.object.cantidad_liberado [row]
					
					if ldc_cant_liberada > ldc_cant_pend   then //coloco cantidad pendientes
						Messagebox('Aviso','Cantida a Liberarse no puede ser Mayor que Cantidad Pendiente de Embarque')
						this.object.cantidad_liberado [row] = ldc_cant_pend
						Return 1
					end if	
				END IF
				
				
				
				

END CHOOSE
end event

type dw_liberado from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer x = 27
integer y = 12
integer width = 1755
integer height = 528
integer taborder = 20
string dataobject = "d_abc_warrant_liberado_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);//boolean 	lb_ret
//string 	ls_codigo, ls_data, ls_sql, ls_data2, ls_data3,  & 
//			ls_string, ls_evaluate
//			
//str_parametros sl_param
//
//ls_string = this.Describe(lower(as_columna) + '.Protect' )
//
//IF len(ls_string) > 1 THEN
//	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
//	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
//	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
//	IF This.Describe(ls_evaluate) = '1' THEN RETURN
//ELSE
//	IF ls_string = '1' THEN RETURN
//END IF
//
//CHOOSE CASE lower(as_columna)
//	CASE 'nro_embarque', 'nro_lote_emb'
//		sl_param.dw1    = 'd_lista_nro_embarque_warrant_tbl'
//		sl_param.titulo = 'EMBARQUES'
//		sl_param.tipo				= ''
//		sl_param.field_ret_i[1] = 1	//Nro_Embarque
//		sl_param.field_ret_i[2] = 2	//Nro_Lote de Embarque
//				
//		OpenWithParm( w_lista, sl_param )
//		
//		sl_param = Message.PowerObjectParm
//		
//		IF sl_param.titulo <> 'n' THEN
//			This.object.nro_embarque[al_row] = sl_param.field_ret[1]
//			This.object.nro_lote_emb[al_row] = sl_param.field_ret[2]
//			This.ii_update = 1
//		END IF
//				
//END CHOOSE
//

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
is_mastdet = 'md'
ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_dk[1] = 1 	      	// columnas que se pasan al detalle
ii_dk[2] = 2

idw_det  = tab_1.tabpage_3.dw_liberado_det
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;String  ls_nro_warrant

IF dw_master.GetRow() = 0 THEN RETURN

ls_nro_warrant = dw_master.object.nro_warrant[dw_master.getrow()]

This.object.nro_warrant 		[al_row] = ls_nro_warrant
This.object.nro_item				[al_row] = of_nro_item(this, 2)
This.object.fecha_registro		[al_row] = f_fecha_actual()
This.object.fecha_emision		[al_row] = f_fecha_actual()
This.object.flag_estado 		[al_row] = '1'

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event itemchanged;call super::itemchanged;String ls_data, ls_null


SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE ''


END CHOOSE
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rowfocuschanged;call super::rowfocuschanged;int    li_item
string ls_filtro

IF NOT isNull(currentrow) AND currentrow > 0 THEN
	li_item		 = This.object.item_lib		[currentrow]
   ls_filtro = "item_lib = " + string(li_item)
	IF isNull(ls_filtro) THEN ls_filtro = ''
	idw_lib_det.setfilter( ls_filtro )
	idw_lib_det.Filter( )
END IF
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1], aa_id[2])
end event

type dw_master from u_dw_abc within w_fi302_warrant
event ue_display ( string as_columna,  long al_row )
integer x = 37
integer y = 160
integer width = 2843
integer height = 776
string dataobject = "d_abc_warrant_ff"
end type

event ue_display(string as_columna, long al_row);//as columna, al_row

boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate
			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE "tipo_deuda_fin"	
		ls_sql = "SELECT DEUDA_FINANC_TIPO.TIPO_DEUDA_FIN AS CODIGO_DEUDA,"&
       		 			+"DEUDA_FINANC_TIPO.DESCRIPCION AS DESCRIPCION, "& 
       		 			+"DEUDA_FINANC_TIPO.TIPO_DOC AS TIPO_DOC  "&   
							+"FROM DEUDA_FINANC_TIPO				 "&	
							+"WHERE DEUDA_FINANC_TIPO.FLAG_ESTADO = "+"'"+'1'+"'"
							
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_deuda_fin		[al_row] = ls_codigo
		END IF
			
			  
			  
			  
	CASE "almacen"
		
		IF idw_detail.rowcount( ) > 0 THEN 
			messagebox('Error' , 'No puede cambiar de almacen, ya existe detalle')
		ELSE		
			ls_sql = "SELECT ALMACEN AS COD_ALMACEN, " &
					  +"DESC_ALMACEN AS DESCRIPCION "&
					  +"FROM ALMACEN " &
					  +"WHERE FLAG_ESTADO = '1' " &
					  +"AND FLAG_TIPO_ALMACEN <> 'M' "
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			IF ls_codigo <> '' THEN
				This.object.almacen 		[al_row] = ls_codigo
				This.object.desc_almacen[al_row] = ls_data
				This.ii_update = 1
			END IF
	   END IF
		
	CASE "cod_moneda"
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				  +"DESCRIPCION AS DESCRIPCION "&
				  +"FROM MONEDA " &
				  +"WHERE FLAG_ESTADO = '1' " &
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.cod_moneda 			[al_row] = ls_codigo
			This.object.moneda_descripcion[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE "cod_banco"
		ls_sql = "SELECT COD_BANCO AS CODIGO, " &
				  +"NOM_BANCO AS DESCRIPCION "&
				  +"FROM BANCO " &
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.cod_banco[al_row] = ls_codigo
			This.object.nom_banco[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE "tipo_doc"
		ls_sql = "SELECT TIPO_DOC AS CODIGO, " &
				  +"DESC_TIPO_DOC AS DESCRIPCION "&
				  +"FROM DOC_TIPO " &
				  +"WHERE FLAG_ESTADO = '1' " &
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc 		[al_row] = ls_codigo
			This.object.desc_tipo_doc	[al_row] = ls_data
			This.ii_update = 1
		END IF
		
END CHOOSE
end event

event constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw


end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;
This.object.cod_origen			[al_row]	= gs_origen
This.object.fecha_registro 	[al_row]	= f_fecha_actual()
This.object.flag_estado    	[al_row]	= '1'
This.object.fecha_emision  	[al_row]	= f_fecha_actual()
This.object.fecha_vencimiento [al_row] = f_fecha_actual()
This.object.cod_moneda			[al_row] = is_dolares
This.object.moneda_descripcion[al_row] = is_desc_dolares
This.object.tipo_doc				[al_row] = is_doc_warrant
This.object.desc_tipo_doc		[al_row] = is_desc_doc_warrant
end event

event itemerror;call super::itemerror;RETURN 1
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event itemchanged;call super::itemchanged;String ls_data, ls_null, ls_cod_almacen
Long   ll_count


SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
		 CASE 'tipo_deuda_fin'	
				ii_update = 0 
		
				select Count(*) into :ll_count 
				  from deuda_financ_tipo
				 where (tipo_deuda_fin = :data) and
				 		 (flag_estado    = '1'	) ;
						  
				
				if ll_count = 0 then
					Messagebox('Aviso','Deuda Financiera No Existe ,Verifique!')
					Return 1
				end if
							
							
		 CASE 'almacen'
			   IF idw_detail.rowcount( ) > 0 THEN
					messagebox('Error' , 'No puede cambiar de almacen, ya existe detalle')
					ls_cod_almacen = idw_detail.object.almacen[1]
					This.object.almacen[row] = ls_cod_almacen
					RETURN 1
				ELSE
					SELECT Desc_almacen	
				 	  INTO :ls_data
					  FROM Almacen	
					 WHERE almacen           = :data and
					 		 flag_tipo_almacen <> 'M'  and
							  flag_estado 		 = '1';
				
					IF SQLCA.sqlcode = 100 THEN
						MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
						this.object.almacen			[row] = ls_null
						this.object.desc_almacen	[row]	= ls_null
						return 1
					END IF
				
					this.object.desc_almacen[row]	= ls_data
				END IF
	
		CASE 'cod_moneda'
			  SELECT descripcion	
				 INTO :ls_data
				 FROM Moneda
				WHERE cod_moneda  = :data and
						flag_estado = '1'   ;
			
				IF SQLCA.sqlcode = 100 THEN
					MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
					this.object.cod_moneda			[row] = ls_null
					this.object.moneda_descripcion[row]	= ls_null
					return 1
				END IF
			
				This.object.moneda_descripcion[row]	= ls_data
			
			
		CASE 'cod_banco'
			   SELECT nom_banco	
			 	  INTO :ls_data
				  FROM banco
				 WHERE cod_banco = :data;
			
			   IF SQLCA.sqlcode = 100 THEN
					MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
					this.object.cod_banco	[row] = ls_null
					this.object.nom_banco	[row]	= ls_null
					Return 1
				END IF
			
				This.object.nom_banco[row]	= ls_data
			
		CASE 'tipo_doc'
				SELECT desc_tipo_doc	
				  INTO :ls_data
				  FROM doc_tipo
				 WHERE tipo_doc    = :data and
				 		 flag_estado = '1';
			
				IF SQLCA.sqlcode = 100 THEN
					MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
					this.object.tipo_doc			[row] = ls_null
					this.object.desc_tipo_doc	[row]	= ls_null
					return 1
				END IF
			
				This.object.desc_tipo_doc[row]	= ls_data


END CHOOSE
end event

type gb_1 from groupbox within w_fi302_warrant
integer x = 46
integer width = 869
integer height = 152
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

