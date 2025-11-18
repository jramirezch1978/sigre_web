$PBExportHeader$w_fl308_anula_arribos.srw
forward
global type w_fl308_anula_arribos from w_abc
end type
type pb_2 from picturebutton within w_fl308_anula_arribos
end type
type em_1 from editmask within w_fl308_anula_arribos
end type
type pb_1 from picturebutton within w_fl308_anula_arribos
end type
type st_2 from statictext within w_fl308_anula_arribos
end type
type dw_master from u_dw_abc within w_fl308_anula_arribos
end type
end forward

global type w_fl308_anula_arribos from w_abc
integer width = 2290
integer height = 1904
string title = "Anular Arribos en Bloques (FL308)"
string menuname = "m_smpl"
event ue_retrieve ( )
event ue_procesar ( )
pb_2 pb_2
em_1 em_1
pb_1 pb_1
st_2 st_2
dw_master dw_master
end type
global w_fl308_anula_arribos w_fl308_anula_arribos

event ue_retrieve();integer li_dias

li_dias = integer(em_1.text)

dw_master.Retrieve(li_dias, gs_origen)
end event

event ue_procesar();Integer 	li_ok, li_dias, li_nro
string	ls_mensaje
Date		ld_fecha

ld_fecha = Today()
li_dias = integer(em_1.text)

//create or replace procedure usp_fl_anula_arribos (
//       aii_dias 		in  number,
//       asi_origen 		in  string,
//       adi_fecha    	in  date,
//       aio_anulados 	out integer,
//       aso_mensaje  	out varchar2,
//       aio_ok 			out number
//) is

DECLARE usp_fl_anula_arribos PROCEDURE FOR
	usp_fl_anula_arribos( :li_dias, :gs_origen, :ld_fecha );

EXECUTE usp_fl_anula_arribos;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_anula_arribos: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_fl_anula_arribos 
	INTO :li_nro, :ls_mensaje, :li_ok;
	
CLOSE usp_fl_anula_arribos;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE usp_fl_anula_arribos', ls_mensaje, StopSign!)	
	return
end if

if li_nro = 0 then
	MessageBox('Aviso', 'No se han encontrado arribos para anular', Information! )
else
	MessageBox('Aviso', 'Se han anulado '+trim(string(li_nro))+' arribos', Information!)
end if

end event

on w_fl308_anula_arribos.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.pb_2=create pb_2
this.em_1=create em_1
this.pb_1=create pb_1
this.st_2=create st_2
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_master
end on

on w_fl308_anula_arribos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.em_1)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 


end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type pb_2 from picturebutton within w_fl308_anula_arribos
integer x = 1253
integer y = 24
integer width = 192
integer height = 156
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Retrieve!"
alignment htextalign = right!
boolean map3dcolors = true
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type em_1 from editmask within w_fl308_anula_arribos
integer x = 1001
integer y = 48
integer width = 215
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "0~~99"
end type

type pb_1 from picturebutton within w_fl308_anula_arribos
integer x = 1454
integer y = 24
integer width = 192
integer height = 156
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\cancel.bmp"
alignment htextalign = right!
boolean map3dcolors = true
string powertiptext = "Proceder a Anular los Arribos"
end type

type st_2 from statictext within w_fl308_anula_arribos
integer x = 462
integer y = 64
integer width = 521
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Días de tolerancia"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_fl308_anula_arribos
integer y = 204
integer width = 2222
integer height = 1472
string dataobject = "d_posib_arribos_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

