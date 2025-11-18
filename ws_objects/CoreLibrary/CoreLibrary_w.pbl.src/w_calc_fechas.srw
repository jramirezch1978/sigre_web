$PBExportHeader$w_calc_fechas.srw
$PBExportComments$Ventana que calcula diferencia entre fechas, y suma o resta dias a fechas
forward
global type w_calc_fechas from Window
end type
type cb_4 from commandbutton within w_calc_fechas
end type
type cb_3 from commandbutton within w_calc_fechas
end type
type sle_fecha_menos from singlelineedit within w_calc_fechas
end type
type sle_fecha from singlelineedit within w_calc_fechas
end type
type st_1 from statictext within w_calc_fechas
end type
type em_dias from editmask within w_calc_fechas
end type
type cb_exit from commandbutton within w_calc_fechas
end type
type cb_2 from commandbutton within w_calc_fechas
end type
type cb_1 from commandbutton within w_calc_fechas
end type
end forward

global type w_calc_fechas from Window
int X=439
int Y=456
int Width=951
int Height=372
boolean TitleBar=true
long BackColor=12639424
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
cb_4 cb_4
cb_3 cb_3
sle_fecha_menos sle_fecha_menos
sle_fecha sle_fecha
st_1 st_1
em_dias em_dias
cb_exit cb_exit
cb_2 cb_2
cb_1 cb_1
end type
global w_calc_fechas w_calc_fechas

type variables
str_calculos istr_calc
string is_num
string is_prevnum
string is_sign
Integer ii_len = 9
Boolean ib_ultsig = False
end variables

forward prototypes
public function string of_trim (string as_numero)
end prototypes

public function string of_trim (string as_numero);integer	li_len, i, li_dec, li_round

if Pos(as_numero, '.') = 0 then GOTO SALIDA

li_len = Len(as_numero)
FOR i = li_len TO 1 Step -1
	CHOOSE CASE Mid(as_numero, i, 1)
		CASE '0'
			as_numero = Replace(as_numero, i, 1, ' ')
		CASE '.'
			as_numero = Replace(as_numero, i, 1, ' ')
			EXIT
		CASE ELSE
			EXIT
	END CHOOSE
NEXT

as_numero = RightTrim(as_numero)

if Len(as_numero) < ii_len then GOTO SALIDA

li_dec = Pos(as_numero, '.')
if li_dec = 0 then GOTO SALIDA

li_round = 9 - li_dec
as_numero = String(Round(Dec(as_numero), li_round))

SALIDA:

RETURN as_numero

end function

event open;istr_calc = Message.PowerObjectParm
this.y = istr_calc.y
this.x = istr_calc.x

sle_fecha.text = istr_calc.valor


end event

on deactivate;close(this)
end on

on w_calc_fechas.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.sle_fecha_menos=create sle_fecha_menos
this.sle_fecha=create sle_fecha
this.st_1=create st_1
this.em_dias=create em_dias
this.cb_exit=create cb_exit
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.cb_4,&
this.cb_3,&
this.sle_fecha_menos,&
this.sle_fecha,&
this.st_1,&
this.em_dias,&
this.cb_exit,&
this.cb_2,&
this.cb_1}
end on

on w_calc_fechas.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.sle_fecha_menos)
destroy(this.sle_fecha)
destroy(this.st_1)
destroy(this.em_dias)
destroy(this.cb_exit)
destroy(this.cb_2)
destroy(this.cb_1)
end on

type cb_4 from commandbutton within w_calc_fechas
int X=626
int Y=152
int Width=91
int Height=92
int TabOrder=50
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_3 from commandbutton within w_calc_fechas
int X=370
int Y=16
int Width=91
int Height=92
int TabOrder=40
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;sle_fecha.EVENT ue_calendar()
end event

type sle_fecha_menos from singlelineedit within w_calc_fechas
event ue_calendar ( )
int X=265
int Y=152
int Width=357
int Height=92
int TabOrder=60
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event ue_calendar;Long ls_rs

ls_rs = OpenWithParm(w_pb_calendar,THIS)

IF ls_rs <> 1 THEN
	MessageBox("Error","Error en la apertura del calendario")
END IF
end event

type sle_fecha from singlelineedit within w_calc_fechas
event ue_calendar ( )
int X=9
int Y=16
int Width=357
int Height=92
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event ue_calendar;Long ls_rs

ls_rs = OpenWithParm(w_pb_calendar,THIS)

MessageBox('calendar', ls_rs)

IF ls_rs <> 1 THEN
	MessageBox("Error","Error en la apertura del calendario")
END IF
end event

type st_1 from statictext within w_calc_fechas
int X=174
int Y=136
int Width=82
int Height=76
boolean Enabled=false
string Text="-"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12639424
int TextSize=-20
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_dias from editmask within w_calc_fechas
int X=517
int Y=16
int Width=219
int Height=100
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
string Mask="#####"
boolean Spin=true
double Increment=1
string MinMax="-999~~999"
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_exit from commandbutton within w_calc_fechas
int X=14
int Y=152
int Width=146
int Height=92
int TabOrder=10
string Text="Exit"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Close(Parent)
end event

type cb_2 from commandbutton within w_calc_fechas
int X=754
int Y=144
int Width=142
int Height=108
int TabOrder=50
string Text="="
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String	ls_temp, ls_resultado
Date		ld_mas, ld_menos

ld_mas   = Date(sle_fecha.text)
ld_menos = Date(sle_fecha_menos.text)

ls_resultado = String(DaysAfter(ld_mas,ld_menos))

istr_calc.datawindow.SetText(ls_resultado)

Close(Parent)


end event

type cb_1 from commandbutton within w_calc_fechas
int X=763
int Y=8
int Width=133
int Height=108
int TabOrder=70
string Text="="
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String	ls_temp, ls_resultado
Date		ld_temp

ld_temp = Date(sle_fecha.text)

ls_resultado = String(RelativeDate(ld_temp,Integer(em_dias.text)))

istr_calc.datawindow.SetText(ls_resultado)

Close(Parent)
end event

