$PBExportHeader$nvo_numeradores.sru
forward
global type nvo_numeradores from nonvisualobject
end type
end forward

global type nvo_numeradores from nonvisualobject
end type
global nvo_numeradores nvo_numeradores

forward prototypes
public function boolean uf_num_detraccion (string as_origen, ref string as_ult_nro)
public function boolean uf_num_programacion_pagos (string as_origen, ref string as_ult_nro)
public function boolean uf_num_embarque (string as_origen, ref string as_ult_nro)
public function boolean uf_num_lote_embarque (string as_origen, ref string as_ult_nro)
public function boolean uf_num_subsidio (string as_origen, ref string as_ult_nro)
public function boolean uf_num_maestro (string as_origen, ref string as_ult_nro)
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

public function boolean uf_num_embarque (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_VEN_NUM_EMBARQUE PROCEDURE FOR USF_VEN_NUM_EMBARQUE (:as_origen) ; 
EXECUTE PB_USF_VEN_NUM_EMBARQUE ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Embarque', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_VEN_NUM_EMBARQUE INTO :as_ult_nro ;

CLOSE PB_USF_VEN_NUM_EMBARQUE ;




Return lb_ret 




end function

public function boolean uf_num_lote_embarque (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_VEN_NUM_LOTE_EMB PROCEDURE FOR USF_VEN_NUM_LOTE_EMB (:as_origen) ; 
EXECUTE PB_USF_VEN_NUM_LOTE_EMB ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Embarque', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_VEN_NUM_LOTE_EMB INTO :as_ult_nro ;

CLOSE PB_USF_VEN_NUM_LOTE_EMB ;




Return lb_ret 




end function

public function boolean uf_num_subsidio (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_RRHH_NUM_SUBSIDIO PROCEDURE FOR USF_RRHH_NUM_SUBSIDIO (:as_origen) ; 
EXECUTE PB_USF_RRHH_NUM_SUBSIDIO ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador Subsidio', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_RRHH_NUM_SUBSIDIO INTO :as_ult_nro ;

CLOSE PB_USF_RRHH_NUM_SUBSIDIO ;




Return lb_ret 

end function

public function boolean uf_num_maestro (string as_origen, ref string as_ult_nro);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE USF_RRHH_NUM_MAESTRO PROCEDURE FOR 
	USF_RRHH_NUM_MAESTRO (:as_origen) ; 
	
EXECUTE USF_RRHH_NUM_MAESTRO ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador Maestro', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH USF_RRHH_NUM_MAESTRO INTO :as_ult_nro ;

CLOSE USF_RRHH_NUM_MAESTRO ;




Return lb_ret 

end function

on nvo_numeradores.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_numeradores.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

