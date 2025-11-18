$PBExportHeader$w_cn230_calendario.srw
forward
global type w_cn230_calendario from w_abc_master
end type
type uo_fecha from u_ingreso_fecha within w_cn230_calendario
end type
end forward

global type w_cn230_calendario from w_abc_master
integer width = 2382
integer height = 1488
string title = "ABC Calendario (CN230)"
string menuname = "m_abc_master_smpl"
uo_fecha uo_fecha
end type
global w_cn230_calendario w_cn230_calendario

on w_cn230_calendario.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
end on

on w_cn230_calendario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
end on

event ue_insert_pos;call super::ue_insert_pos;Date ld_fecha
Long	ll_rc
Integer	li_mes, li_dia
String	ls_flag, ls_flag_laborable

ld_fecha = uo_fecha.of_get_fecha()

ll_rc = dw_master.SetItem(al_row, 'fecha', ld_fecha)

// Determinar Dia Laborable
li_mes = Month(ld_fecha)
li_dia = Day(ld_fecha)

SELECT "CALENDARIO_FERIADO"."FLAG_MEDIO_DIA_LAB"  
  INTO :ls_flag  
  FROM "CALENDARIO_FERIADO"  
 WHERE ( "CALENDARIO_FERIADO"."MES" = :li_mes ) AND  
       ( "CALENDARIO_FERIADO"."DIA" = :li_dia )   ;
IF SQLCA.SQLCODE = 0 THEN
	IF ls_flag = '1' THEN
		ls_flag_laborable = 'M'
	ELSE
		ls_flag_laborable = 'N'
	END IF
ELSE
	IF DayNumber(ld_fecha) = 1 THEN // CUANDO ES DOMINGO
		ls_flag_laborable = 'N'
	ELSE
		ls_flag_laborable = 'L'
	END IF
END IF

ll_rc = dw_master.SetItem(al_row, 'flag_laborable', ls_flag_laborable)

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master`dw_master within w_cn230_calendario
integer x = 704
integer y = 36
integer width = 1609
integer height = 1252
string dataobject = "d_calendario2_ff"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

type uo_fecha from u_ingreso_fecha within w_cn230_calendario
integer x = 37
integer y = 64
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Fecha:') // para seatear el titulo del boton
 of_set_fecha(Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1()  para leer las fechas

end event

event ue_output;call super::ue_output;Date ld_fecha
Long	ll_rc
Integer li_msg_result

ld_fecha = uo_fecha.of_get_fecha()

ll_rc = dw_master.Retrieve(ld_fecha)

IF ll_rc = 0 THEN
	li_msg_result = MessageBox('No existe Registro', 'Desea Crear una Nueva Fecha', Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		PARENT.EVENT ue_insert()
	END IF
END IF


end event

