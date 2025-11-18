$PBExportHeader$n_cst_log_proceso.sru
forward
global type n_cst_log_proceso from nonvisualobject
end type
end forward

global type n_cst_log_proceso from nonvisualobject
end type
global n_cst_log_proceso n_cst_log_proceso

forward prototypes
public function integer of_set_flag_reversion (decimal adc_nro_proceso)
public function double of_get_nro_proceso ()
public function double of_set_log (date ad_fecha_obj_inicial, date ad_fecha_obj_final, string as_cod_proceso, string as_window, string as_desc_proceso, string as_flag_mayoriz, string as_cod_usr)
public function double of_set_log (double adb_nro_proceso, date ad_fecha_obj_inicial, date ad_fecha_obj_final, string as_cod_proceso, string as_window, string as_desc_proceso, string as_flag_mayoriz, string as_cod_usr)
end prototypes

public function integer of_set_flag_reversion (decimal adc_nro_proceso);UPDATE "OPER_PROCESOS"  
   SET "FLAG_REVERSION" = '1'  
 WHERE "OPER_PROCESOS"."NRO_PROCESO" = :adc_nro_proceso   ;


IF SQLCA.SQLCode <> 0 THEN MessageBox('Error', 'No se pudo modificar el Flag Reversion')


RETURN SQLCA.SQLCode
end function

public function double of_get_nro_proceso ();Double	ldb_nro_proceso



SELECT SEQ_OPER_PROCESOS.NEXTVAL
	  INTO :ldb_nro_proceso
	  FROM DUAL ;


IF SQLCA.SQLCode < 0 THEN
	MessageBox('Error', 'No se pudo obtener el numero de proceso')
	ldb_nro_proceso = -1
END IF



RETURN ldb_nro_proceso
end function

public function double of_set_log (date ad_fecha_obj_inicial, date ad_fecha_obj_final, string as_cod_proceso, string as_window, string as_desc_proceso, string as_flag_mayoriz, string as_cod_usr);DateTime	ldt_ahora, ldt_inicial, ldt_final
Date		ld_ahora
Integer	li_lw, li_ld
Double	ldb_nro_oper
String	ls_window, ls_desc_proceso

ldt_ahora  = DateTime(Today(), Now())
ldt_inicial = DateTime(ad_fecha_obj_inicial)
ldt_final  = DateTime(ad_fecha_obj_final)
ls_window = as_window
ls_desc_proceso = as_desc_proceso
li_lw = Len(ls_window)
li_ld = len(ls_desc_proceso)

IF li_lw > 30 THEN ls_window = Left(ls_window, 30)
IF li_ld > 60 THEN ls_desc_proceso = Left(ls_desc_proceso, 60)

INSERT INTO "OPER_PROCESOS"  
         ( "NRO_PROCESO", "FECHA_PROCESO", "FECHA_OBJ_INICIAL", "FECHA_OBJ_FINAL",   
           "COD_PROCESO", "WINDOW", "DESC_PROCESO", "FLAG_REVERSION", "COD_USR",   
           "FLAG_MAYORIZ" )  
  VALUES ( 0, :ldt_ahora, :ldt_inicial, :ldt_final,
           :as_cod_proceso, :ls_window, :ls_desc_proceso,'0',:as_cod_usr,
			  :as_flag_mayoriz );

IF SQLCA.SQLCode < 0 THEN
	MessageBox('Error', 'No se pudo grabar el Log')
	ldb_nro_oper = SQLCA.SQLCode
ELSE
	SELECT SEQ_OPER_PROCESOS.CURRVAL
	  INTO :ldb_nro_oper
	  FROM DUAL ;
END IF

RETURN ldb_nro_oper


end function

public function double of_set_log (double adb_nro_proceso, date ad_fecha_obj_inicial, date ad_fecha_obj_final, string as_cod_proceso, string as_window, string as_desc_proceso, string as_flag_mayoriz, string as_cod_usr);DateTime	ldt_ahora, ldt_inicial, ldt_final
Date		ld_ahora
Integer	li_lw, li_ld
Double	ldb_nro_oper
String	ls_window, ls_desc_proceso

ldt_ahora  = DateTime(Today(), Now())
ldt_inicial = DateTime(ad_fecha_obj_inicial)
ldt_final  = DateTime(ad_fecha_obj_final)
ls_window = as_window
ls_desc_proceso = as_desc_proceso
li_lw = Len(ls_window)
li_ld = len(ls_desc_proceso)

IF li_lw > 30 THEN ls_window = Left(ls_window, 30)
IF li_ld > 60 THEN ls_desc_proceso = Left(ls_desc_proceso, 60)

INSERT INTO "OPER_PROCESOS"  
         ( "NRO_PROCESO", "FECHA_PROCESO", "FECHA_OBJ_INICIAL", "FECHA_OBJ_FINAL",   
           "COD_PROCESO", "WINDOW", "DESC_PROCESO", "FLAG_REVERSION", "COD_USR",   
           "FLAG_MAYORIZ" )  
  VALUES ( :adb_nro_proceso, :ldt_ahora, :ldt_inicial, :ldt_final,
           :as_cod_proceso, :ls_window, :ls_desc_proceso,'0',:as_cod_usr,
			  :as_flag_mayoriz );

IF SQLCA.SQLCode < 0 THEN
	MessageBox('Error', 'No se pudo grabar el Log')
	ldb_nro_oper = SQLCA.SQLCode
ELSE
	SELECT SEQ_OPER_PROCESOS.CURRVAL
	  INTO :ldb_nro_oper
	  FROM DUAL ;
END IF

RETURN ldb_nro_oper


end function

on n_cst_log_proceso.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_log_proceso.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

