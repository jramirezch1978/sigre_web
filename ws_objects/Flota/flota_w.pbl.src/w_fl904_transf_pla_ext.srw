$PBExportHeader$w_fl904_transf_pla_ext.srw
forward
global type w_fl904_transf_pla_ext from w_abc
end type
type sle_origen from singlelineedit within w_fl904_transf_pla_ext
end type
type st_1 from statictext within w_fl904_transf_pla_ext
end type
type uo_fecha from u_ingreso_fecha within w_fl904_transf_pla_ext
end type
type cb_2 from commandbutton within w_fl904_transf_pla_ext
end type
type cb_1 from commandbutton within w_fl904_transf_pla_ext
end type
end forward

global type w_fl904_transf_pla_ext from w_abc
integer width = 1467
integer height = 460
string title = "[FL904] Transferencia a Planillas Externas"
string menuname = "m_smpl"
boolean maxbox = false
boolean resizable = false
event ue_aceptar ( )
event ue_cancelar ( )
sle_origen sle_origen
st_1 st_1
uo_fecha uo_fecha
cb_2 cb_2
cb_1 cb_1
end type
global w_fl904_transf_pla_ext w_fl904_transf_pla_ext

event ue_aceptar();string	ls_mensaje, ls_origen
date		ld_fecha

ld_fecha = uo_Fecha.of_get_fecha()
ls_origen = trim(sle_origen.text)

//create or replace procedure USP_FL_TRANSF_PLA_EXT(
//    adi_fec_proceso    in date,
//    asi_usuario		     in usuario.cod_usr%TYPE,
//    asi_origen         in origen.cod_origen%TYPE
//) is


DECLARE USP_FL_TRANSF_PLA_EXT PROCEDURE FOR
	USP_FL_TRANSF_PLA_EXT( 	:ld_fecha , 
									:gs_user  ,
									:ls_origen );

EXECUTE USP_FL_TRANSF_PLA_EXT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_TRANSF_PLA_EXT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_FL_TRANSF_PLA_EXT;

MessageBox('AVISO', 'TRANSFERENCIA DE PLANILLAS EFECTUADA SATISFACTORIAMENTE', Information!)


end event

event ue_cancelar();close(this)
end event

on w_fl904_transf_pla_ext.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.sle_origen=create sle_origen
this.st_1=create st_1
this.uo_fecha=create uo_fecha
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_origen
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
end on

on w_fl904_transf_pla_ext.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.uo_fecha)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;uo_fecha.of_set_fecha(Date(gnvo_app.of_fecha_actual()))
sle_origen.text = gs_origen
end event

type sle_origen from singlelineedit within w_fl904_transf_pla_ext
event ue_dobleclick pbm_lbuttondblclk
integer x = 338
integer y = 8
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_origen.text = ls_codigo
end if

end event

type st_1 from statictext within w_fl904_transf_pla_ext
integer x = 64
integer y = 24
integer width = 265
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_fecha within w_fl904_transf_pla_ext
event destroy ( )
integer x = 87
integer y = 140
integer taborder = 20
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:') // para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_2 from commandbutton within w_fl904_transf_pla_ext
integer x = 955
integer y = 128
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ca&ncelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_1 from commandbutton within w_fl904_transf_pla_ext
integer x = 955
integer y = 20
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;parent.event ue_aceptar()
end event

