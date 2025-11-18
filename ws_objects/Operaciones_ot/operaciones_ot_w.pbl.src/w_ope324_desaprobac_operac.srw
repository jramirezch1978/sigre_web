$PBExportHeader$w_ope324_desaprobac_operac.srw
forward
global type w_ope324_desaprobac_operac from w_rpt_list
end type
type st_1 from statictext within w_ope324_desaprobac_operac
end type
type pb_3 from picturebutton within w_ope324_desaprobac_operac
end type
type sle_codigo from u_sle_codigo within w_ope324_desaprobac_operac
end type
end forward

global type w_ope324_desaprobac_operac from w_rpt_list
integer width = 4411
integer height = 2488
string title = "(OPE324) Desaprobacion de operaciones de OT"
string menuname = "m_salir"
st_1 st_1
pb_3 pb_3
sle_codigo sle_codigo
end type
global w_ope324_desaprobac_operac w_ope324_desaprobac_operac

type variables
Boolean ib_ubica
end variables

forward prototypes
public function integer of_aprobaciones (string as_nro_aprob, decimal ad_cant_proyect, decimal ad_precio_unit)
public function integer of_actualiza_aprob_req (string as_ot_adm, string as_cod_user, long al_mes, decimal ad_monto)
public function integer of_actualiza_estado_amp (string as_cod_origen, long al_nro_mov)
public function integer of_inserta_desaprob (string as_cod_origen, long al_nro_mov, string as_nro_aprob)
public function integer of_elimina_requerim (string as_nro_aprob, string as_cod_origen, long ll_nro_mov)
end prototypes

public function integer of_aprobaciones (string as_nro_aprob, decimal ad_cant_proyect, decimal ad_precio_unit);// Actualizando monto de la aprobacion
UPDATE ot_aprobaciones o
   SET o.imp_aprobado = NVL(o.imp_aprobado,0) - (:ad_cant_proyect * :ad_precio_unit)
 WHERE nro_aprob = :as_nro_aprob ;

RETURN 1
end function

public function integer of_actualiza_aprob_req (string as_ot_adm, string as_cod_user, long al_mes, decimal ad_monto);Long ll_count

SELECT count(*) 
  INTO :ll_count 
  FROM ot_adm_aprob_req a
 WHERE a.ot_adm	= :as_ot_adm 
   AND a.cod_usr	= :as_cod_user 
	AND a.mes_aprob= :al_mes ;

// Esta mal, debe evaluarse el mes, año, etc.
IF ll_count>0 THEN
	UPDATE ot_adm_aprob_req
   	SET saldo_aprob_mes = NVL(saldo_aprob_mes) - NVL(ad_monto,0)
	 WHERE ot_adm 	= :as_ot_adm 
	   AND cod_usr = :as_cod_user ;
END IF 

RETURN 1
end function

public function integer of_actualiza_estado_amp (string as_cod_origen, long al_nro_mov);String ls_null, ls_flag_reposicion 
Long ll_count
DateTime ldt_null

SetNull(ls_null)
SetNull(ldt_null)

// Actualiza datos de amp
UPDATE articulo_mov_proy
	SET flag_estado = '3', 
		 flag_modificacion = '1', 
		 nro_aprob = :ls_null, 
		 fec_proy_aprob = :ldt_null 
 WHERE cod_origen = :as_cod_origen
	AND nro_mov 	= :al_nro_mov ;

//SELECT aa.flag_reposicion 
//  INTO :ls_flag_reposicion
//  FROM articulo_mov_proy amp, articulo_almacen aa 
// WHERE (amp.cod_art = aa.cod_art and 
// 		  amp.almacen = aa.almacen) and 
//       (amp.cod_origen = :as_cod_origen AND 
//        amp.nro_mov = :al_nro_mov) ;
//
//IF ls_flag_reposicion = '0' THEN
//	UPDATE articulo_mov_proy
//		SET flag_estado = '3', 
//			 flag_modificacion = '1', 
//			 nro_aprob = :ls_null, 
//			 fec_proy_aprob = :ldt_null 
//	 WHERE cod_origen = :as_cod_origen
//		AND nro_mov 	= :al_nro_mov ;
//ELSE
//	UPDATE articulo_mov_proy
//		SET flag_estado = '3', 
//			 flag_modificacion = '1', 
//			 nro_aprob = :ls_null, 
//			 fec_proy_aprob = :ldt_null 
//	 WHERE cod_origen = :as_cod_origen
//		AND nro_mov 	= :al_nro_mov ;
//END IF 

RETURN 1

end function

public function integer of_inserta_desaprob (string as_cod_origen, long al_nro_mov, string as_nro_aprob);// Insertando registro en ot_desaprobacion_amp
DateTime ldt_fecha

SELECT sysdate into :ldt_fecha from dual ;

INSERT INTO ot_desaprobacion_amp
		(cod_origen, nro_mov, fecha_desaprob, nro_aprob, cod_usr, flag_replicacion )
VALUES(:as_cod_origen, :al_nro_mov, :ldt_fecha, :as_nro_aprob, :gs_user, '1') ;


RETURN 1
end function

public function integer of_elimina_requerim (string as_nro_aprob, string as_cod_origen, long ll_nro_mov);String ls_nulo

SetNull(ls_nulo)

UPDATE articulo_mov_proy amp
   SET amp.nro_aprob = :ls_nulo
 WHERE cod_origen 	= :as_cod_origen 
   AND nro_mov		   = :ll_nro_mov 
	AND nro_aprob 	   = :as_nro_aprob ;

RETURN 1
end function

on w_ope324_desaprobac_operac.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_1=create st_1
this.pb_3=create pb_3
this.sle_codigo=create sle_codigo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_3
this.Control[iCurrent+3]=this.sle_codigo
end on

on w_ope324_desaprobac_operac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_3)
destroy(this.sle_codigo)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

ib_ubica = false

end event

event resize;call super::resize;//dw_report.width = newwidth - dw_report.x
//dw_report.height = newheight - dw_report.y
end event

type dw_report from w_rpt_list`dw_report within w_ope324_desaprobac_operac
boolean visible = false
integer x = 2811
integer y = 2776
integer width = 219
integer height = 160
boolean enabled = false
end type

type dw_1 from w_rpt_list`dw_1 within w_ope324_desaprobac_operac
integer x = 27
integer y = 208
integer width = 2226
integer height = 2068
string dataobject = "d_desaprobacion_operacion_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;//dw_1.SetTransObject(sqlca)
//dw_1.retrieve()
//dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7


ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
ii_dk[7] = 7


ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
ii_rk[7] = 7

end event

type pb_1 from w_rpt_list`pb_1 within w_ope324_desaprobac_operac
integer x = 2281
integer y = 828
integer width = 119
integer height = 100
integer textsize = -10
end type

type pb_2 from w_rpt_list`pb_2 within w_ope324_desaprobac_operac
integer x = 2277
integer y = 1216
integer width = 119
integer height = 100
integer textsize = -10
end type

type dw_2 from w_rpt_list`dw_2 within w_ope324_desaprobac_operac
integer x = 2423
integer y = 208
integer width = 1915
integer height = 2068
string dataobject = "d_desaprobacion_operacion_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7


ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
ii_dk[7] = 7


ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
ii_rk[7] = 7

end event

type cb_report from w_rpt_list`cb_report within w_ope324_desaprobac_operac
integer x = 3534
integer y = 60
integer width = 768
string text = "Actualiza desaprobaciones"
end type

event cb_report::clicked;call super::clicked;Long ll_rpta, ll_count, ll_row //, ll_mes, ll_count
//Decimal ld_cant_proyect, ld_cant_procesada, ld_cant_reservado, ld_precio_unit
String ls_opersec, ls_nro_aprob, ls_nro_orden, ls_user, ls_doc_ot, ls_tipo_mov, ls_msj_err 
//Date ld_fecha_emis, ld_fecha
Boolean lb_ok 

ll_rpta = MessageBox("Aviso", "Esta seguro de desaprobar operaciones", Exclamation!, YesNo!, 2)

IF ll_rpta = 2 THEN RETURN

IF dw_2.RowCount() = 0 THEN RETURN

ls_nro_aprob = TRIM(sle_codigo.text)

//// Captura fecha de emision de la aprobacion
//SELECT fecha_emis 
//  INTO :ld_fecha_emis 
//  FROM ot_aprobaciones 
// WHERE nro_aprob = :ls_nro_aprob ;
//
SELECT l.doc_oc, l.oper_cons_interno 
  INTO :ls_doc_ot, :ls_tipo_mov 
FROM logparam l 
WHERE reckey='1' ;

lb_ok = true

FOR ll_row = 1 TO dw_2.RowCount()
	// Capturando datos
	ls_opersec		= dw_2.object.oper_sec	[ll_row]
	ls_nro_orden	= dw_2.object.nro_orden	[ll_row]
	//ls_ot_adm		= dw_2.object.orden_trabajo_ot_adm[ll_row]
	//ls_user			= dw_2.object.ot_aprobaciones_usr_creacion[ll_row]
	//ll_mes			= LONG( STRING( dw_2.object.ot_aprobaciones_fecha_emis[ll_row], 'mm'))
	
	// Verifica si tiene AMPs con dicha numero de aprobacion
	SELECT count(*) 
	  INTO :ll_count 
     FROM articulo_mov_proy amp 
	 WHERE amp.tipo_doc 		= :ls_doc_ot 
	   AND amp.tipo_mov 		= :ls_tipo_mov  
		AND amp.nro_aprob		= :ls_nro_aprob  
		AND amp.oper_sec 		= :ls_opersec ;
	 
	IF ll_count > 0 THEN
		Messagebox('Aviso', 'Existes registros AMP aprobados en la misma aprobación '+ ls_nro_aprob + ', desapruebelos' )
		lb_ok = false 
	END IF

	// Actualiza operacion
	UPDATE operaciones o 
   	SET o.flag_estado = '3', 
			 o.nro_aprob = null 
    WHERE o.oper_sec = :ls_opersec ; 

	// Actualiza importe de aprobacion
	UPDATE ot_aprobaciones ot 
      SET ot.imp_aprobado = (SELECT ROUND(NVL(SUM(amp.cant_proyect*amp.precio_unit),0),2) 
  										 FROM articulo_mov_proy amp 
										WHERE amp.nro_aprob = :ls_nro_aprob 
										  AND amp.tipo_mov=:ls_tipo_mov 
										  AND amp.tipo_doc=:ls_doc_ot) 
	 WHERE ot.nro_aprob = :ls_nro_aprob ;
NEXT

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error en objeto w_ope324',ls_msj_err)
	Return
ELSE	
	IF lb_ok THEN
		Commit ;
		messagebox('Aviso', 'Proceso termino satisfactoriamente')
	ELSE
		rollback ;
		messagebox('Aviso', 'Proceso no actualizó cambios')
		return
	END IF 
END IF 

dw_1.reset()
dw_2.reset()

end event

type st_1 from statictext within w_ope324_desaprobac_operac
integer x = 59
integer y = 72
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro aprobación :"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_ope324_desaprobac_operac
integer x = 955
integer y = 56
integer width = 128
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_aprobacion, ls_codigo, ls_doc_ot
str_seleccionar lstr_seleccionar

select doc_ot into :ls_doc_ot from logparam where reckey='1' ;

IF ib_ubica = false then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ot_aprobaciones.nro_aprob AS nro_aprobacion,'&
											 +'ot_aprobaciones.fecha_emis AS fecha, '&
											 +'ot_aprobaciones.usr_creacion AS usuario, '&
											 +'ot_aprobaciones.imp_aprobado AS importe_dol '&
											 +'FROM ot_aprobaciones '
	
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		ls_aprobacion = TRIM(sle_codigo.text)
		//dw_1.SetTransObject(sqlca)
		dw_1.retrieve(ls_aprobacion)
		idw_1.Visible = True
		dw_2.SetTransObject(sqlca)	
	END IF
ELSE
	ls_aprobacion = TRIM(sle_codigo.text)
	IF Isnull(ls_aprobacion) OR Trim(ls_aprobacion) = '' THEN
		Messagebox('Aviso','Digite número de aprobación a buscar')
		Return
	END IF
	dw_1.retrieve(ls_aprobacion)
	idw_1.Visible = True
	dw_2.SetTransObject(sqlca)	
	
END IF

ib_ubica = false

end event

type sle_codigo from u_sle_codigo within w_ope324_desaprobac_operac
event ue_tecla pbm_keydown
integer x = 517
integer y = 64
integer width = 402
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_tecla;ib_ubica = true
IF Key = KeyEnter! THEN
	pb_3.triggerevent(clicked!)
END IF
end event

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

