$PBExportHeader$nvo_numeradores.sru
forward
global type nvo_numeradores from nonvisualobject
end type
end forward

global type nvo_numeradores from nonvisualobject
end type
global nvo_numeradores nvo_numeradores

type variables
n_cst_utilitario 	invo_util
end variables

forward prototypes
public function boolean uf_num_detraccion (string as_origen, ref string as_ult_nro)
public function boolean uf_num_programacion_pagos (string as_origen, ref string as_ult_nro)
public function boolean uf_num_deuda (string as_origen, ref string as_ult_nro)
public function boolean uf_num_deuda_financiera (string as_origen, ref string as_ult_nro)
public function boolean of_get_nro_doc_tipo (string as_tipo_doc, ref string as_nro_doc, string as_origen)
end prototypes

public function boolean uf_num_detraccion (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_CAM_NUM_DETRACCION PROCEDURE FOR USF_CAM_NUM_DETRACCION (:as_origen) ; 
EXECUTE PB_USF_CAM_NUM_DETRACCION ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador Detracción', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_CAM_NUM_DETRACCION INTO :as_ult_nro ;

CLOSE PB_USF_CAM_NUM_DETRACCION ;




Return lb_ret 




end function

public function boolean uf_num_programacion_pagos (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_FIN_NUM_PROG_PAG PROCEDURE FOR USF_FIN_NUM_PROG_PAG (:as_origen) ; 
EXECUTE PB_USF_FIN_NUM_PROG_PAG ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador Detracción', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_FIN_NUM_PROG_PAG INTO :as_ult_nro ;

CLOSE PB_USF_FIN_NUM_PROG_PAG ;




Return lb_ret 

end function

public function boolean uf_num_deuda (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_FIN_NUM_DEUDA PROCEDURE FOR USF_FIN_NUM_DEUDA (:as_origen) ; 
EXECUTE PB_USF_FIN_NUM_DEUDA ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador Deuda Financiera', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_FIN_NUM_DEUDA INTO :as_ult_nro ;

CLOSE PB_USF_FIN_NUM_DEUDA ;




Return lb_ret 




end function

public function boolean uf_num_deuda_financiera (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_FIN_NUM_DEUDA_FIN PROCEDURE FOR USF_FIN_NUM_DEUDA_FIN (:as_origen) ; 
EXECUTE PB_USF_FIN_NUM_DEUDA_FIN ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Deuda Financiera', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_FIN_NUM_DEUDA_FIN INTO :as_ult_nro ;

CLOSE PB_USF_FIN_NUM_DEUDA_FIN ;




Return lb_ret 

end function

public function boolean of_get_nro_doc_tipo (string as_tipo_doc, ref string as_nro_doc, string as_origen);String  	ls_lock_table, ls_mensaje
Long		ln_count, ln_ult_nro
Boolean 	lb_ret = TRUE



//ls_lock_table = 'LOCK TABLE NUM_DOC_TIPO IN EXCLUSIVE MODE'
//EXECUTE IMMEDIATE :ls_lock_table ;


SELECT count(*)
  INTO :ln_count
  FROM num_doc_tipo
 WHERE tipo_doc = :as_tipo_doc 
   and trim(NRO_SERIE) = trim(:as_origen);

  
IF ln_count = 0 THEN
	insert into num_doc_tipo(tipo_doc, nro_Serie, ultimo_numero)
	values(:as_tipo_doc, :as_origen, 1);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al insertar registro en tabla NUM_DOC_TIPO. Mensaje :' + ls_mensaje, StopSign!)
		return false
	end if
end if

SELECT ultimo_numero
  INTO :ln_ult_nro
  FROM num_doc_tipo
 WHERE tipo_doc = :as_tipo_doc 
   and trim(NRO_SERIE) = trim(:as_origen);

as_nro_doc = trim(as_origen) + invo_util.lpad(Trim(String(ln_ult_nro)),8, '0')

UPDATE num_doc_tipo
	SET ultimo_numero = :ln_ult_nro + 1
 WHERE tipo_doc = :as_tipo_doc 
   and trim(NRO_SERIE) = trim(:as_origen);
	
IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje =  SQLCA.SQLErrText
	Rollback ;
	MessageBox('Error', 'Error al actualizar registro en tabla NUM_DOC_TIPO. Mensaje :' + ls_mensaje, StopSign!)
	return false
END IF	 
	 
return true
end function

on nvo_numeradores.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_numeradores.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

