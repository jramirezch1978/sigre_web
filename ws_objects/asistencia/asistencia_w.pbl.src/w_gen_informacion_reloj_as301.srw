$PBExportHeader$w_gen_informacion_reloj_as301.srw
forward
global type w_gen_informacion_reloj_as301 from w_rpt
end type
type uo_deldia from u_ingreso_fecha within w_gen_informacion_reloj_as301
end type
type pb_1 from picturebutton within w_gen_informacion_reloj_as301
end type
type pb_2 from picturebutton within w_gen_informacion_reloj_as301
end type
type st_1 from statictext within w_gen_informacion_reloj_as301
end type
type gb_1 from groupbox within w_gen_informacion_reloj_as301
end type
type mle_1 from multilineedit within w_gen_informacion_reloj_as301
end type
end forward

global type w_gen_informacion_reloj_as301 from w_rpt
integer width = 2121
integer height = 1108
string title = "Proceso debe ser Diario (AS301)"
long backcolor = 79741120
uo_deldia uo_deldia
pb_1 pb_1
pb_2 pb_2
st_1 st_1
gb_1 gb_1
mle_1 mle_1
end type
global w_gen_informacion_reloj_as301 w_gen_informacion_reloj_as301

forward prototypes
public function integer of_lee_data ()
end prototypes

public function integer of_lee_data ();//  Lee datos del reloj
//  Return 1 = Ok
//			  0 = Falló

Integer  j
String   ls_codcam, ls_cad, ls_file, ls_fecha, ls_hora
String   ls_carnet_trabajador, ls_nro_reloj
DateTime ld_fecha
Long     li_reg, li_veces

ls_file = STRING(uo_deldia.of_get_fecha(), 'DD/MM/YYYY')
ls_file = MID(ls_file,7,4) + MID(ls_file,4,2) + MID(ls_file,1,2)

// Crea cursor dinamico
ls_cad = "SELECT cadreloj FROM " + ls_file

DECLARE c_reloj DYNAMIC CURSOR FOR SQLSA;
IF tr_reloj.sqlcode <> 0 then
	MessageBox("Error al declarar cursor", tr_reloj.sqlerrtext)
	return 0
END IF

PREPARE SQLSA FROM :ls_cad USING tr_reloj;
OPEN DYNAMIC c_reloj;
IF tr_reloj.sqlcode <> 0 then
	MessageBox("Error al abrir cursor", tr_reloj.sqlerrtext)
	return 0
END IF

DO 
	FETCH c_reloj INTO :ls_codcam;
	IF tr_reloj.sqlcode = 100 then exit
	IF tr_reloj.sqlcode <> 0 then
		MessageBox("Error al leer cursor", tr_reloj.sqlerrtext)
		return 0
	END IF
	ls_nro_reloj = MID(ls_codcam,01,3)
	ls_fecha     = MID(ls_codcam,04,4) + "/" + MID(ls_codcam,08,2) + "/" + MID(ls_codcam,10,2)
	ls_hora      = MID(ls_codcam,12,2) + ":" + MID(ls_codcam,14,2) + ":" + MID(ls_codcam,16,2)
	ld_fecha     = DATETIME( DATE( ls_fecha), TIME(ls_hora) )
	ls_carnet_trabajador = MID(ls_codcam, 25,10)
	w_main.SetMicroHelp ("Procesando Código: " + ls_carnet_trabajador)
	
	// Verifica si ya existe
	SELECT count(carnet_trabajador) into :li_veces FROM marcacion_reloj_asistencia 
	WHERE carnet_trabajador = :ls_carnet_trabajador and fecha_marcacion = :ld_fecha;
	
	IF li_veces = 0 THEN
		INSERT INTO MARCACION_RELOJ_ASISTENCIA (carnet_trabajador, fecha_marcacion, nro_reloj)
      VALUES (:ls_carnet_trabajador, :ld_fecha, :ls_nro_reloj)
		USING SQLCA;
		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox( "Error", Sqlca.SqlErrText)
		END IF
	ELSE
		UPDATE marcacion_reloj_asistencia
		  SET nro_reloj = :ls_nro_reloj
		  WHERE carnet_trabajador = :ls_carnet_trabajador AND fecha_marcacion = :ld_fecha;
	END IF
	COMMIT USING SQLCA;
LOOP WHILE TRUE

Close c_reloj;
w_main.SetMicroHelp( "Esperando")
Return 1
end function

on w_gen_informacion_reloj_as301.create
int iCurrent
call super::create
this.uo_deldia=create uo_deldia
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.gb_1=create gb_1
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_deldia
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.mle_1
end on

on w_gen_informacion_reloj_as301.destroy
call super::destroy
destroy(this.uo_deldia)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.mle_1)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - w_gen_informacion_reloj_as301.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - w_gen_informacion_reloj_as301.WorkSpaceHeight()) / 2) - 150
w_gen_informacion_reloj_as301.move(ll_x,ll_y)

// objeto fecha deldia
uo_deldia.of_set_label( "Día")
uo_deldia.of_set_fecha(today())
uo_deldia.of_set_rango_inicio(DATE("01/01/2000"))
uo_deldia.of_set_rango_fin(DATE("31/12/2025"))
end event

type uo_deldia from u_ingreso_fecha within w_gen_informacion_reloj_as301
integer x = 773
integer y = 352
integer taborder = 10
boolean bringtotop = true
end type

on uo_deldia.destroy
call u_ingreso_fecha::destroy
end on

type pb_1 from picturebutton within w_gen_informacion_reloj_as301
integer x = 677
integer y = 660
integer width = 320
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\Cur\taladro.cur"
string text = "Continuar"
boolean default = true
string picturename = "h:\source\bmp\blanco.bmp"
vtextalign vtextalign = vcenter!
end type

event clicked;SetPointer( Hourglass!)

// Verifica fecha ingresada
if TRIM( STRING( uo_deldia.of_get_Fecha())) = "" then
	messagebox( "Atención", "Ingrese fecha del día")
	uo_deldia.SetFocus()
	return
end if	

if of_lee_data() <> 1 then return
	MESSAGEBOX( "Atención", "Proceso Ha Culminado Satifactoriamente")	

Return 1
IF SQLCA.SQLCode = -1 THEN 
  rollback ;
  MessageBox("SQL error", SQLCA.SQLErrText)
  MessageBox('Atención','No se pudo transferir informacióm diaria', Exclamation! )
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF

end event

type pb_2 from picturebutton within w_gen_informacion_reloj_as301
integer x = 1106
integer y = 660
integer width = 320
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\Cur\taladro.cur"
string text = "Salir"
boolean default = true
string picturename = "h:\source\bmp\blanco.bmp"
vtextalign vtextalign = vcenter!
end type

event clicked;close( parent )
end event

type st_1 from statictext within w_gen_informacion_reloj_as301
integer x = 27
integer y = 112
integer width = 2048
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "TRANSFIERE INFORMACION DIARIA DEL RELOJ"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_gen_informacion_reloj_as301
integer x = 704
integer y = 280
integer width = 731
integer height = 188
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Fecha "
borderstyle borderstyle = styleraised!
end type

type mle_1 from multilineedit within w_gen_informacion_reloj_as301
integer x = 562
integer y = 596
integer width = 960
integer height = 240
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16776960
alignment alignment = center!
borderstyle borderstyle = styleshadowbox!
end type

