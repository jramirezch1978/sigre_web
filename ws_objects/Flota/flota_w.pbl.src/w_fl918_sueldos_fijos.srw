$PBExportHeader$w_fl918_sueldos_fijos.srw
forward
global type w_fl918_sueldos_fijos from w_abc
end type
type em_fecha from editmask within w_fl918_sueldos_fijos
end type
type st_1 from statictext within w_fl918_sueldos_fijos
end type
type cbx_1 from checkbox within w_fl918_sueldos_fijos
end type
type cb_2 from commandbutton within w_fl918_sueldos_fijos
end type
type cb_1 from commandbutton within w_fl918_sueldos_fijos
end type
end forward

global type w_fl918_sueldos_fijos from w_abc
integer width = 1902
integer height = 796
string title = "Calculo de Sueldos Fijos (FL918)"
string menuname = "m_smpl"
boolean maxbox = false
boolean resizable = false
event ue_aceptar ( )
event ue_cancelar ( )
em_fecha em_fecha
st_1 st_1
cbx_1 cbx_1
cb_2 cb_2
cb_1 cb_1
end type
global w_fl918_sueldos_fijos w_fl918_sueldos_fijos

event ue_aceptar();date		ld_fecha
String	ls_mensaje, ls_envia

em_fecha.Getdata(ld_fecha)

if cbx_1.checked then
	ls_envia = '1'
else
	ls_envia = '0'
end if

//create or replace procedure USP_FL_CAL_SUELDOS_FIJOS(
//		adi_fec_proceso 	  in  date,
//    	asi_env_rrhh        in  char,
//    	asi_usuario         in  usuario.cod_usr%TYPE
//) is

DECLARE USP_FL_CAL_SUELDOS_FIJOS PROCEDURE FOR
	USP_FL_CAL_SUELDOS_FIJOS( :ld_fecha, 
									  :ls_envia, 
									  :gs_user	);

EXECUTE USP_FL_CAL_SUELDOS_FIJOS;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_CAL_SUELDOS_FIJOS: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_FL_CAL_SUELDOS_FIJOS;

MessageBox('AVISO', 'CALCULO DE PLANILLAS DE SUELDOS FIJOS HA SIDO SATISFACTORIO', Information!)



end event

event ue_cancelar();close(this)
end event

on w_fl918_sueldos_fijos.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.em_fecha=create em_fecha
this.st_1=create st_1
this.cbx_1=create cbx_1
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_fecha
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
end on

on w_fl918_sueldos_fijos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_fecha)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;em_fecha.text = string( gnvo_app.of_fecha_actual(), 'dd/mm/yyyy' )
end event

type em_fecha from editmask within w_fl918_sueldos_fijos
integer x = 457
integer y = 60
integer width = 402
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean spin = true
end type

type st_1 from statictext within w_fl918_sueldos_fijos
integer x = 50
integer y = 76
integer width = 352
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Fecha Calculo"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_fl918_sueldos_fijos
integer x = 50
integer y = 220
integer width = 1509
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Transferir a Recursos Humanos (RR.HH.)"
end type

type cb_2 from commandbutton within w_fl918_sueldos_fijos
integer x = 1390
integer y = 332
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

type cb_1 from commandbutton within w_fl918_sueldos_fijos
integer x = 1010
integer y = 332
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Calcular"
end type

event clicked;parent.event ue_aceptar()
end event

