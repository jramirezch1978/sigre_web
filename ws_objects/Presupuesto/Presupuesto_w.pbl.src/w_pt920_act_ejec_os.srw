$PBExportHeader$w_pt920_act_ejec_os.srw
$PBExportComments$Adiciona articulos proyectados al presupuesto de materiales
forward
global type w_pt920_act_ejec_os from w_abc
end type
type uo_fecha from u_ingreso_rango_fechas within w_pt920_act_ejec_os
end type
type st_1 from statictext within w_pt920_act_ejec_os
end type
type pb_2 from picturebutton within w_pt920_act_ejec_os
end type
type pb_1 from picturebutton within w_pt920_act_ejec_os
end type
end forward

global type w_pt920_act_ejec_os from w_abc
integer width = 1673
integer height = 788
string title = "Regenera Ejecutado de Ordenes de Servicio (PT920)"
string menuname = "m_only_exit"
boolean toolbarvisible = false
uo_fecha uo_fecha
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt920_act_ejec_os w_pt920_act_ejec_os

on w_pt920_act_ejec_os.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.uo_fecha=create uo_fecha
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
end on

on w_pt920_act_ejec_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;of_center_window()


end event

type uo_fecha from u_ingreso_rango_fechas within w_pt920_act_ejec_os
integer x = 133
integer y = 140
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; String ls_desde

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

 
 


end event

type st_1 from statictext within w_pt920_act_ejec_os
integer y = 16
integer width = 1614
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Regenera Ejecutado de OS"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt920_act_ejec_os
integer x = 809
integer y = 344
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type pb_1 from picturebutton within w_pt920_act_ejec_os
integer x = 434
integer y = 344
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long 		ln_count
String 	ls_modo, ls_mensaje
Date		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

//create or replace procedure USP_PTO_EJEC_OS(
//       adi_fecha1  in date,
//       adi_fecha2  in date
//) is

DECLARE USP_PTO_EJEC_OS PROCEDURE FOR
	USP_PTO_EJEC_OS( :ld_fecha1,
						  :ld_fecha2 );
	
EXECUTE USP_PTO_EJEC_OS;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	rollback ;
	Messagebox( "Error USP_PTO_EJEC_OS", ls_mensaje, stopsign!)
	return 0
end if

CLOSE USP_PTO_EJEC_OS;

MessageBox( 'Mensaje', "Proceso terminado Satisfactoriamente" )


end event

