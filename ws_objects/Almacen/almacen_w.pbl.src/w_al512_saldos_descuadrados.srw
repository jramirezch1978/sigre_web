$PBExportHeader$w_al512_saldos_descuadrados.srw
forward
global type w_al512_saldos_descuadrados from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_al512_saldos_descuadrados
end type
type cb_procesar from commandbutton within w_al512_saldos_descuadrados
end type
end forward

global type w_al512_saldos_descuadrados from w_abc_master_smpl
integer height = 1104
string title = "Saldos Descuadrados (AL512)"
string menuname = "m_salir"
event ue_procesar ( )
event ue_reporte ( )
cb_1 cb_1
cb_procesar cb_procesar
end type
global w_al512_saldos_descuadrados w_al512_saldos_descuadrados

forward prototypes
public function boolean of_procesar (string as_cod_art)
end prototypes

event ue_procesar();string 	ls_mensaje, ls_cod_art
Long		ll_i, ll_count

SetPointer(HourGlass!)
ll_count = dw_master.RowCount()
for ll_i = 1 to ll_Count 
	ls_cod_art = dw_master.object.cod_art[ll_i]
	SetMicroHelp('Procesando: ' + string(ll_i/ll_count * 100, '###,##0.00') + '%')
	if of_procesar(dw_master.object.cod_art[ll_i])= false then return 
next

SetPointer(Arrow!)
end event

event ue_reporte();string ls_mensaje

SetPointer(HourGlass!)

update articulo_mov_proy
   set flag_Estado = '2',
		 flag_replicacion ='1'
 where NVL(cant_proyect,0) <= NVL(cant_procesada,0)
   and flag_Estado = '1';

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrTExt
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return
end if

commit;

// Tengo que actualizar la cantidad liquidada de los ingresos 
// con todas las salidas que se le hicieron con respecto a 
//ese ingreso
update articulo_consignacion a
  set a.cantidad_liquidada = (select NVL(sum(ac.cantidad),0)
										 from articulo_consignacion   ac,
												art_consignacion_enlace ace
										where ace.nro_mov_sal = ac.nro_mov
										  and ac.flag_estado = '1'  // Solo los activos
										  and ace.nro_mov_ing = a.nro_mov)
where a.tipo_mov in (select tipo_mov from articulo_mov_tipo amt
							 where amt.factor_sldo_consig = 1) // Solo los Ingresos
  and a.flag_estado = '1';

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrTExt
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return
end if

commit;

dw_master.Retrieve()

if dw_master.RowCount() > 0 then
	cb_procesar.enabled = true
end if
SetPointer(Arrow!)
end event

public function boolean of_procesar (string as_cod_art);string ls_mensaje
//create or replace procedure usp_alm_cuadre_saldos(
//     asi_cod_art        in  articulo.cod_art%TYPE
//) is

DECLARE usp_alm_cuadre_saldos PROCEDURE FOR
	usp_alm_cuadre_saldos( :as_cod_art );

EXECUTE usp_alm_cuadre_saldos;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_cuadre_saldos: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

CLOSE usp_alm_cuadre_saldos;

return true


end function

on w_al512_saldos_descuadrados.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_1=create cb_1
this.cb_procesar=create cb_procesar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_procesar
end on

on w_al512_saldos_descuadrados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_procesar)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

type dw_master from w_abc_master_smpl`dw_master within w_al512_saldos_descuadrados
integer x = 0
integer y = 120
string dataobject = "d_abc_saldos_descuadrados_grid"
end type

type cb_1 from commandbutton within w_al512_saldos_descuadrados
integer y = 8
integer width = 402
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;parent.event dynamic ue_reporte()
end event

type cb_procesar from commandbutton within w_al512_saldos_descuadrados
integer x = 421
integer y = 8
integer width = 402
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;parent.event dynamic ue_procesar()
end event

