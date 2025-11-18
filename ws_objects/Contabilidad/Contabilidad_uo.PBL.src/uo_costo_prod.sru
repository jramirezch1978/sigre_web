$PBExportHeader$uo_costo_prod.sru
forward
global type uo_costo_prod from nonvisualobject
end type
end forward

global type uo_costo_prod from nonvisualobject
end type
global uo_costo_prod uo_costo_prod

type variables
string is_op_cod_hielo ='HIELO-002', &
		 is_cencos_hielo = 'HIELO-001', &
		 is_grp_costo    = 'GRP-COSTO', &
		 is_grp_res01	  = 'GRP_RES_01', &
		 is_mov_cons_int = 'MOVCONSINT'

//Parametros de Logparam
String is_oper_ing_prod, is_oper_cons_interno, is_ope_cons_directo = 'S19'

//Datos para costo de hielo
decimal 	idc_total_costo_hielo, idc_prod_hielo, idc_otros_ingr_hielo, idc_consumo_hielo, &
			idc_venta_hielo, idc_otros_egre_hielo, idc_cup_hielo
end variables

forward prototypes
public function string of_get_parametro_string (string as_parametro, string as_default)
public function string of_get_cod_hielo ()
public function string of_get_parametro_string (string as_parametro)
public function boolean of_logparam ()
end prototypes

public function string of_get_parametro_string (string as_parametro, string as_default);String ls_value, ls_msj

//  function uf_get_parametro_string(
//           asi_opcion CNTBL_COSTO_PARAM.opcion%TYPE, 
//           asi_default CNTBL_COSTO_PARAM.VALOR_STRING%TYPE
//  ) return varchar2 is


DECLARE uf_get_parametro_string PROCEDURE FOR 
	PKG_CNTBL_COSTO.uf_get_parametro_string ( :as_parametro,
															:as_default   ) ;

EXECUTE uf_get_parametro_string  ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error function PKG_CNTBL_COSTO.uf_get_parametro_string', &
					'Se produjo un error al ejecutar la función PKG_CNTBL_COSTO.uf_get_parametro_string: ' + ls_msj, StopSign! )
	return gnvo_app.is_null
END IF

fetch uf_get_parametro_string into :ls_value;

Close uf_get_parametro_string;

return ls_value
end function

public function string of_get_cod_hielo ();return this.of_get_parametro_string( this.is_op_cod_hielo, '')
end function

public function string of_get_parametro_string (string as_parametro);return this.of_get_parametro_string( as_parametro, gnvo_app.is_null)
end function

public function boolean of_logparam ();select oper_ing_prod, oper_cons_interno
	into :is_oper_ing_prod, :is_oper_cons_interno
from logparam
where reckey = '1';

if SQLCA.SQLCOde = 100 then
	rollback;
	MessageBox('Error', 'No existen parametros en logparam, por favor verifique', Information!)
	return false
end if

return true
end function

on uo_costo_prod.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_costo_prod.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;this.of_logparam()
end event

