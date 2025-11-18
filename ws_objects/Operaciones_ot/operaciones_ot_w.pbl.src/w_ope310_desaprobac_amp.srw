$PBExportHeader$w_ope310_desaprobac_amp.srw
forward
global type w_ope310_desaprobac_amp from w_rpt_list
end type
type pb_3 from picturebutton within w_ope310_desaprobac_amp
end type
type sle_codigo from u_sle_codigo within w_ope310_desaprobac_amp
end type
type cb_1 from commandbutton within w_ope310_desaprobac_amp
end type
type cbx_todas from checkbox within w_ope310_desaprobac_amp
end type
end forward

global type w_ope310_desaprobac_amp from w_rpt_list
integer width = 4411
integer height = 2816
string title = "Desaprobacion de requerimientos aprobados a comprar (OPE310)"
string menuname = "m_salir"
long backcolor = 67108864
pb_3 pb_3
sle_codigo sle_codigo
cb_1 cb_1
cbx_todas cbx_todas
end type
global w_ope310_desaprobac_amp w_ope310_desaprobac_amp

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

on w_ope310_desaprobac_amp.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.pb_3=create pb_3
this.sle_codigo=create sle_codigo
this.cb_1=create cb_1
this.cbx_todas=create cbx_todas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.sle_codigo
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cbx_todas
end on

on w_ope310_desaprobac_amp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.sle_codigo)
destroy(this.cb_1)
destroy(this.cbx_todas)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

ib_ubica = false

end event

event resize;call super::resize;pb_1.x = newwidth / 2 - pb_1.width
pb_2.x = pb_1.x

dw_1.width = pb_1.x - dw_1.x - 10
dw_1.height = newheight - dw_1.y

dw_2.x = pb_2.x + pb_2.width + 10
dw_2.width = newwidth - dw_2.x
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;//Override
String ls_nro_ot

if cbx_todas.checked then
	ls_nro_ot = "%%"
else
	ls_nro_ot = TRIM(sle_codigo.text) + "%"
	IF Isnull(ls_nro_ot) OR Trim(ls_nro_ot) = '' THEN
		Messagebox('Aviso','Digite número de OT a buscar')
		sle_codigo.SetFocus()
		Return
	END IF
end if


dw_1.SetTransObject(sqlca)	
dw_2.SetTransObject(sqlca)	

dw_1.retrieve(ls_nro_ot, gs_user)
dw_2.Reset()

if dw_1.RowCount() > 0 then
	cb_report.enabled = true
else
	cb_report.enabled = false
end if

	

end event

type dw_report from w_rpt_list`dw_report within w_ope310_desaprobac_amp
boolean visible = false
integer x = 2510
integer y = 1348
integer width = 78
integer height = 56
boolean enabled = false
end type

type dw_1 from w_rpt_list`dw_1 within w_ope310_desaprobac_amp
integer x = 0
integer y = 128
integer width = 2226
integer height = 2068
string dataobject = "d_articulos_a_desaprobar_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;//dw_1.SetTransObject(sqlca)
//dw_1.retrieve()
//dw_2.SetTransObject(sqlca)
//

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7
ii_ck[8] = 8
ii_ck[9] = 9
ii_ck[10] = 10
ii_ck[11] = 11
ii_ck[12] = 12
ii_ck[13] = 13

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
ii_dk[7] = 7
ii_dk[8] = 8
ii_dk[9] = 9
ii_dk[10] = 10
ii_dk[11] = 11
ii_dk[12] = 12
ii_dk[13] = 13

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
ii_rk[7] = 7
ii_rk[8] = 8
ii_rk[9] = 9
ii_rk[10] = 10
ii_rk[11] = 11
ii_rk[12] = 12
ii_rk[13] = 13


end event

type pb_1 from w_rpt_list`pb_1 within w_ope310_desaprobac_amp
integer x = 2281
integer y = 828
integer width = 119
integer height = 100
integer textsize = -10
end type

type pb_2 from w_rpt_list`pb_2 within w_ope310_desaprobac_amp
integer x = 2277
integer y = 1216
integer width = 119
integer height = 100
integer textsize = -10
end type

type dw_2 from w_rpt_list`dw_2 within w_ope310_desaprobac_amp
integer x = 2423
integer y = 128
integer width = 1915
integer height = 2068
string dataobject = "d_articulos_a_desaprobar_tbl"
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
ii_ck[8] = 8
ii_ck[9] = 9
ii_ck[10] = 10
ii_ck[11] = 11
ii_ck[12] = 12
ii_ck[13] = 13

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
ii_dk[7] = 7
ii_dk[8] = 8
ii_dk[9] = 9
ii_dk[10] = 10
ii_dk[11] = 11
ii_dk[12] = 12
ii_dk[13] = 13


ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
ii_rk[7] = 7
ii_rk[8] = 8
ii_rk[9] = 9
ii_rk[10] = 10
ii_rk[11] = 11
ii_rk[12] = 12
ii_rk[13] = 13


end event

type cb_report from w_rpt_list`cb_report within w_ope310_desaprobac_amp
integer x = 1504
integer y = 0
integer width = 544
integer textsize = -8
boolean enabled = false
string text = "Desaprobar"
end type

event cb_report::clicked;call super::clicked;Long 		ll_rpta, ll_nro_mov, ll_row, ll_mes, ll_count
Decimal 	ld_cant_proyect, ld_cant_procesada, ld_cant_reservado, ld_precio_unit
String 	ls_cod_origen, ls_nro_aprob, ls_ot_adm, ls_user_aprob, ls_doc_oc, ls_msj_err, ls_nro_oc
Boolean 	lb_ok 
DateTime	ldt_fec_aprob

ll_rpta = MessageBox("Aviso", "Esta seguro de desaprobar requerimientos", Exclamation!, YesNo!, 2)

IF ll_rpta = 2 THEN RETURN

IF dw_2.RowCount() = 0 THEN RETURN

SELECT doc_oc 
  INTO :ls_doc_oc 
FROM logparam l 
WHERE reckey='1' ;

lb_ok = true

FOR ll_row = 1 TO dw_2.RowCount()
	// Capturando datos
	ldt_fec_aprob	= DateTime(dw_2.object.fecha_aprob	[ll_row])
	ls_nro_aprob	= dw_2.object.nro_aprobacion			[ll_row]
	ls_cod_origen	= dw_2.object.cod_origen				[ll_row]
	ll_nro_mov		= dw_2.object.nro_mov					[ll_row]
	ls_ot_adm		= dw_2.object.ot_adm						[ll_row]
	ls_user_Aprob	= dw_2.object.usr_aprob					[ll_row]
	ll_mes			= LONG( STRING( ldt_fec_aprob, 'mm'))

	// Verifica que no exista una compra referenciada a dicho amp
	SELECT count(*) 
	  INTO :ll_count 
     FROM articulo_mov_proy amp 
	 WHERE amp.tipo_doc = :ls_doc_oc 
	   AND amp.org_amp_ref = :ls_cod_origen 
		AND amp.nro_amp_ref = :ll_nro_mov 
		and amp.flag_estado <> '0';
	 
	IF ll_count > 0 THEN
		SELECT amp.nro_doc
		  INTO :ls_nro_oc
		  FROM articulo_mov_proy amp 
		 WHERE amp.tipo_doc 	  = :ls_doc_oc 
			AND amp.org_amp_ref = :ls_cod_origen 
			AND amp.nro_amp_ref = :ll_nro_mov 
			and amp.flag_estado <> '0';
			
		Messagebox('Requerimiento no puede desaprobarse', 'El requerimiento: ' + ls_cod_origen + '-' + string(ll_nro_mov) + " no puede desaprobarse, porque ya fue atendido con la OC: " + ls_nro_oc )
		return
	END IF

	SELECT NVL(cant_proyect,0), NVL(cant_procesada,0), NVL(cant_reservado,0), NVL(precio_unit,0)
     INTO :ld_cant_proyect, :ld_cant_procesada, :ld_cant_reservado, :ld_precio_unit
     FROM articulo_mov_proy a
	 WHERE cod_origen=:ls_cod_origen AND nro_mov=:ll_nro_mov ;
	
	IF ld_cant_reservado > 0 THEN
		Messagebox("Error", 'El requerimiento: ' + ls_cod_origen + '-' + string(ll_nro_mov) &
					+ ' no puede desaprobarse, tiene cantidad reservada')
		return 
	END IF 
	
	IF ld_cant_procesada > 0 THEN
		Messagebox("Error", 'El requerimiento: ' + ls_cod_origen + '-' + string(ll_nro_mov) &
					+ ' no puede desaprobarse, tiene consumo registrado en almacen')

		return
	end if

	// Actualiza imp_aprobado en ot_aprobaciones
	of_aprobaciones(ls_nro_aprob, ld_cant_proyect, ld_precio_unit)
	
	// Actualiza monto x mes en ot_adm_aprob_req
	of_actualiza_aprob_req(ls_ot_adm, ls_user_aprob, ll_mes, ld_cant_proyect*ld_precio_unit)
	
	// Actualiza estado en articulo_mov_proy
	of_actualiza_estado_amp(ls_cod_origen, ll_nro_mov)
	
	// Inserta registro en ot_desaprobacion_amp
	of_inserta_desaprob(ls_cod_origen, ll_nro_mov, ls_nro_aprob)
	
	// *** Este punto debe eliminarse ***
	// Elimina registro en ot_aprobacion_amp
	of_elimina_requerim(ls_nro_aprob, ls_cod_origen, ll_nro_mov)
NEXT

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error usp_ope_aprueba_operac',ls_msj_err)
	Return
end if
Commit ;


parent.event ue_retrieve()

f_mensaje("Proceso de desaprobación realizado satisfactoriamente", "")



end event

type pb_3 from picturebutton within w_ope310_desaprobac_amp
integer x = 969
integer y = 4
integer width = 123
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_sql, ls_Doc_ot, ls_codigo, ls_data

str_seleccionar lstr_seleccionar

select doc_ot into :ls_doc_ot from logparam where reckey='1' ;

ls_sql = "SELECT distinct ot.nro_orden, " &
		 + "       amp.fec_proyect, " &
		 + "       ot.titulo " &
		 + "FROM orden_trabajo     ot, " &
		 + "     articulo_mov_proy amp, " &
		 + "     ot_aprobaciones   ota " &
		 + "where ot.nro_orden = amp.nro_doc " &
		 + "  and amp.tipo_doc = '" + ls_Doc_ot + "' " &
		 + "  and amp.nro_aprob = ota.nro_aprob " &
		 + "  and amp.flag_estado = '1'  " &
		 + "  and amp.cant_procesada = 0 " &
		 + "  and ota.usr_aprob = '" + gs_user + "'"
		  
		 
f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	this.text = ls_codigo
end if


end event

type sle_codigo from u_sle_codigo within w_ope310_desaprobac_amp
event ue_tecla pbm_keydown
integer x = 526
integer y = 12
integer width = 402
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
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

type cb_1 from commandbutton within w_ope310_desaprobac_amp
integer x = 1102
integer y = 12
integer width = 343
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event ue_Retrieve()
end event

type cbx_todas from checkbox within w_ope310_desaprobac_amp
integer x = 37
integer y = 12
integer width = 466
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las OTs"
boolean checked = true
end type

event clicked;if this.checked then
	sle_Codigo.enabled = false
else
	sle_Codigo.enabled = true
end if
end event

