$PBExportHeader$uf_asiento_contable.sru
forward
global type uf_asiento_contable from nonvisualobject
end type
end forward

global type uf_asiento_contable from nonvisualobject
end type
global uf_asiento_contable uf_asiento_contable

forward prototypes
public subroutine uf_val_mes_cntbl (long al_ano, long al_mes, string as_tipo, ref string as_flag_result, ref string as_mensaje)
end prototypes

public subroutine uf_val_mes_cntbl (long al_ano, long al_mes, string as_tipo, ref string as_flag_result, ref string as_mensaje);String ls_mensaje

DECLARE USF_CNT_CIERRE_CNTBL PROCEDURE FOR 
	USF_CNT_CIERRE_CNTBL (:al_ano,:al_mes,:as_tipo);
EXECUTE USF_CNT_CIERRE_CNTBL ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error en Función USF_CNT_CIERRE_CNTBL", ls_mensaje)
	return
END IF

FETCH USF_CNT_CIERRE_CNTBL INTO :as_flag_result ;
CLOSE USF_CNT_CIERRE_CNTBL ;

IF as_flag_result = '0' THEN
	as_mensaje = ('Mes Cerrado , Verifique!')
END IF
end subroutine

on uf_asiento_contable.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uf_asiento_contable.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

