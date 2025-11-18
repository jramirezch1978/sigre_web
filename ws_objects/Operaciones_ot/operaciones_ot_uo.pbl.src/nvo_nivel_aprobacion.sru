$PBExportHeader$nvo_nivel_aprobacion.sru
forward
global type nvo_nivel_aprobacion from nonvisualobject
end type
end forward

global type nvo_nivel_aprobacion from nonvisualobject
end type
global nvo_nivel_aprobacion nvo_nivel_aprobacion

forward prototypes
public function boolean uf_insert_aprobacion (string as_tipo_doc, string as_nro_doc, string as_cod_usr, string as_cod_nivel)
public function boolean uf_aprobacion (string as_tipo_doc, string as_cencos, string as_cod_usr, ref string as_mensaje, ref string as_nivel)
end prototypes

public function boolean uf_insert_aprobacion (string as_tipo_doc, string as_nro_doc, string as_cod_usr, string as_cod_nivel);String   ls_mensaje
Datetime ldt_fecha_act
Boolean  lb_ret = true

/*fecha del servidor*/
SELECT sysdate INTO :ldt_fecha_act FROM dual ;
/**/

Insert Into doc_tipo_aut_realizadas
(tipo_doc,nro_doc,fecha,cod_usr,nivel)
Values
(:as_tipo_doc,:as_nro_doc,:ldt_fecha_act,:as_cod_usr,:as_cod_nivel) ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback;
   MessageBox('Aviso', ls_mensaje)
	lb_ret = FALSE
END IF

Return lb_ret
end function

public function boolean uf_aprobacion (string as_tipo_doc, string as_cencos, string as_cod_usr, ref string as_mensaje, ref string as_nivel);/*Envias tipo de documento y Nro de Documento ,centro de costo*/
//as_tipo_doc string 
//as_nro_doc  string
//as_cencos	  string 
//lb_ret      boolean
/**/
String  ls_nivel_req
Long    ll_count
Boolean lb_ret = TRUE

SELECT nivel_auto_req 
  INTO :ls_nivel_req 
  FROM doc_tipo 
 WHERE (tipo_doc = :as_tipo_doc) ;

 

IF ls_nivel_req = '1'     THEN //UNA AUTORIZACION
   /* verificar si centro de costo autorizar */
	SELECT Count(*) INTO :ll_count FROM doc_tipo_nivel_autorizacion 
	 WHERE ((tipo_doc = :as_tipo_doc  ) AND
	 		  (cencos   = :as_cencos    ) AND
			  (cod_usr  = :as_cod_usr   ) AND
			  (nivel = :ls_nivel_req )) ;
	/**/
	IF ll_count = 0 THEN
		as_mensaje = 'Usuario : '+as_cod_usr+' No tiene Autorizacion para Autorizar Sobre Centro de Costo '+as_cencos+' Verifique!'
		lb_ret = FALSE
	ELSE
		as_nivel = '1'	
	END IF
	
ELSEIF ls_nivel_req = '2' THEN //DOS AUTORIZACIONES
	/* VERIFICAR AUTORIZACION AUTORIZACION NO ESTE FINANLIZADA */
	
	/* VERIFICAR AUTORIZACION NRO 2    */
	
	/* VERIFICAR NIVEL DE AUTORIZACION */
	
	
	
ELSEIF ls_nivel_req = '3' THEN //TRES AUTORIZACIONES
	
END IF


Return lb_ret
end function

on nvo_nivel_aprobacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_nivel_aprobacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

