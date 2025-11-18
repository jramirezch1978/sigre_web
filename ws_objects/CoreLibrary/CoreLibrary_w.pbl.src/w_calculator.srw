$PBExportHeader$w_calculator.srw
$PBExportComments$Calculadora para campos en datawindows
forward
global type w_calculator from Window
end type
type cb_exit from commandbutton within w_calculator
end type
type sle_display from singlelineedit within w_calculator
end type
type cb_clear2 from commandbutton within w_calculator
end type
type cb_7 from commandbutton within w_calculator
end type
type cb_4 from commandbutton within w_calculator
end type
type cb_1 from commandbutton within w_calculator
end type
type cb_clear1 from commandbutton within w_calculator
end type
type cb_8 from commandbutton within w_calculator
end type
type cb_5 from commandbutton within w_calculator
end type
type cb_2 from commandbutton within w_calculator
end type
type cb_0 from commandbutton within w_calculator
end type
type cb_dec from commandbutton within w_calculator
end type
type cb_3 from commandbutton within w_calculator
end type
type cb_6 from commandbutton within w_calculator
end type
type cb_9 from commandbutton within w_calculator
end type
type cb_shift from commandbutton within w_calculator
end type
type cb_percent from commandbutton within w_calculator
end type
type cb_mult from commandbutton within w_calculator
end type
type cb_div from commandbutton within w_calculator
end type
type cb_minus from commandbutton within w_calculator
end type
type cb_plus from commandbutton within w_calculator
end type
type cb_enter from commandbutton within w_calculator
end type
end forward

global type w_calculator from Window
int X=439
int Y=456
int Width=672
int Height=732
long BackColor=12639424
WindowType WindowType=popup!
cb_exit cb_exit
sle_display sle_display
cb_clear2 cb_clear2
cb_7 cb_7
cb_4 cb_4
cb_1 cb_1
cb_clear1 cb_clear1
cb_8 cb_8
cb_5 cb_5
cb_2 cb_2
cb_0 cb_0
cb_dec cb_dec
cb_3 cb_3
cb_6 cb_6
cb_9 cb_9
cb_shift cb_shift
cb_percent cb_percent
cb_mult cb_mult
cb_div cb_div
cb_minus cb_minus
cb_plus cb_plus
cb_enter cb_enter
end type
global w_calculator w_calculator

type variables
str_calculos istr_calc
string is_num
string is_prevnum
string is_sign
Integer ii_len = 9
Boolean ib_ultsig = False
end variables

forward prototypes
public subroutine of_digito (string as_digito)
public function boolean of_verificar_len (string as_numero)
public function string of_trim (string as_numero)
public subroutine of_calculo ()
public subroutine of_display_mas (string as_texto)
public subroutine of_display_rs (string as_rs)
public subroutine of_operador (string as_sign)
end prototypes

public subroutine of_digito (string as_digito);//decimal	lc_null

if is_num = '' then
//	SetNull(lc_null)
//	istr_calc.datawindow.SetItem(istr_calc.datawindow.GetRow(), istr_calc.columna, lc_null)
	sle_display.Text = ''
end if

if of_verificar_len(is_num + as_digito) then Return

is_num = is_num + as_digito
//istr_calc.datawindow.SetText(is_num)

sle_display.Text = is_num

ib_ultsig = False
end subroutine

public function boolean of_verificar_len (string as_numero);Boolean	lb_rc = FALSE

IF Len(as_numero) > ii_len then
	Beep(2)
	lb_rc = TRUE
END IF

RETURN lb_rc
end function

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

public subroutine of_calculo ();string	ls_num
Dec		ldc_x

if Dec(is_prevnum) > 0 then
	CHOOSE CASE is_sign
		CASE '+'
			ls_num = String(Dec(is_prevnum) + Dec(is_num))
		CASE '-'
			ls_num = String(Dec(is_prevnum) - Dec(is_num))
		CASE '/'
			ldc_x =  Dec(is_num)
			IF ldc_x = 0 THEN
				MessageBox('Error', 'Divisor = 0')
			ELSE
				ls_num = String(Dec(is_prevnum) / ldc_x)
			END IF
		CASE '*'
			ls_num = String(Dec(is_prevnum) * Dec(is_num))
	END CHOOSE
else
	ls_num = is_num
end if

ls_num = of_Trim(ls_num)
if of_verificar_len(ls_num) then Return

is_num = ls_num

end subroutine

public subroutine of_display_mas (string as_texto);sle_display.text = sle_display.text + as_texto
end subroutine

public subroutine of_display_rs (string as_rs);istr_calc.datawindow.SetText(is_num)

//of_display_mas( '=' + is_num)
end subroutine

public subroutine of_operador (string as_sign);IF ib_ultsig THEN
	sle_display.text = left(sle_display.Text, len(sle_display.Text) - 2)
END IF

	of_calculo()
	ib_ultsig = True

	
is_prevnum = String(Dec(is_num))

is_num = ''
is_sign = as_sign

of_display_mas(' ' + is_sign)

//istr_calc.datawindow.SetText(is_prevnum)
end subroutine

event open;istr_calc = Message.PowerObjectParm
this.y = istr_calc.y
this.x = istr_calc.x
is_num = istr_calc.valor

sle_display.text = is_num
end event

on deactivate;close(this)
end on

on w_calculator.create
this.cb_exit=create cb_exit
this.sle_display=create sle_display
this.cb_clear2=create cb_clear2
this.cb_7=create cb_7
this.cb_4=create cb_4
this.cb_1=create cb_1
this.cb_clear1=create cb_clear1
this.cb_8=create cb_8
this.cb_5=create cb_5
this.cb_2=create cb_2
this.cb_0=create cb_0
this.cb_dec=create cb_dec
this.cb_3=create cb_3
this.cb_6=create cb_6
this.cb_9=create cb_9
this.cb_shift=create cb_shift
this.cb_percent=create cb_percent
this.cb_mult=create cb_mult
this.cb_div=create cb_div
this.cb_minus=create cb_minus
this.cb_plus=create cb_plus
this.cb_enter=create cb_enter
this.Control[]={this.cb_exit,&
this.sle_display,&
this.cb_clear2,&
this.cb_7,&
this.cb_4,&
this.cb_1,&
this.cb_clear1,&
this.cb_8,&
this.cb_5,&
this.cb_2,&
this.cb_0,&
this.cb_dec,&
this.cb_3,&
this.cb_6,&
this.cb_9,&
this.cb_shift,&
this.cb_percent,&
this.cb_mult,&
this.cb_div,&
this.cb_minus,&
this.cb_plus,&
this.cb_enter}
end on

on w_calculator.destroy
destroy(this.cb_exit)
destroy(this.sle_display)
destroy(this.cb_clear2)
destroy(this.cb_7)
destroy(this.cb_4)
destroy(this.cb_1)
destroy(this.cb_clear1)
destroy(this.cb_8)
destroy(this.cb_5)
destroy(this.cb_2)
destroy(this.cb_0)
destroy(this.cb_dec)
destroy(this.cb_3)
destroy(this.cb_6)
destroy(this.cb_9)
destroy(this.cb_shift)
destroy(this.cb_percent)
destroy(this.cb_mult)
destroy(this.cb_div)
destroy(this.cb_minus)
destroy(this.cb_plus)
destroy(this.cb_enter)
end on

type cb_exit from commandbutton within w_calculator
int Y=608
int Width=201
int Height=108
int TabOrder=210
string Text="Exit"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Close(parent)
end event

type sle_display from singlelineedit within w_calculator
int X=18
int Y=12
int Width=626
int Height=92
int TabOrder=10
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

type cb_clear2 from commandbutton within w_calculator
int X=530
int Y=120
int Width=114
int Height=108
int TabOrder=20
string Text="C"
int TextSize=-11
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;is_num = ''
is_prevnum = ''
is_sign = ''
//istr_calc.datawindow.SetText(is_num)

sle_display.text = ''

end event

type cb_7 from commandbutton within w_calculator
int X=18
int Y=120
int Width=114
int Height=108
int TabOrder=80
string Text="7"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_4 from commandbutton within w_calculator
int X=18
int Y=236
int Width=114
int Height=108
int TabOrder=120
string Text="4"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_1 from commandbutton within w_calculator
int X=18
int Y=352
int Width=114
int Height=108
int TabOrder=160
string Text="1"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_clear1 from commandbutton within w_calculator
int X=530
int Y=236
int Width=114
int Height=108
int TabOrder=30
string Text="CE"
int TextSize=-11
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;is_num = ''

sle_display.Text = is_num

//istr_calc.datawindow.SetText(is_num)
end event

type cb_8 from commandbutton within w_calculator
int X=146
int Y=120
int Width=114
int Height=108
int TabOrder=70
string Text="8"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_5 from commandbutton within w_calculator
int X=146
int Y=236
int Width=114
int Height=108
int TabOrder=110
string Text="5"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_2 from commandbutton within w_calculator
int X=146
int Y=352
int Width=114
int Height=108
int TabOrder=150
string Text="2"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_0 from commandbutton within w_calculator
int X=18
int Y=476
int Width=114
int Height=108
int TabOrder=190
string Text="0"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_dec from commandbutton within w_calculator
int X=274
int Y=476
int Width=114
int Height=108
int TabOrder=200
string Text="."
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_3 from commandbutton within w_calculator
int X=274
int Y=352
int Width=114
int Height=108
int TabOrder=170
string Text="3"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_6 from commandbutton within w_calculator
int X=274
int Y=236
int Width=114
int Height=108
int TabOrder=130
string Text="6"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_9 from commandbutton within w_calculator
int X=274
int Y=120
int Width=114
int Height=108
int TabOrder=90
string Text="9"
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_digito(this.text)
end event

type cb_shift from commandbutton within w_calculator
int X=530
int Y=352
int Width=114
int Height=108
int TabOrder=40
string Text="<"
int TextSize=-11
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;IF ib_ultsig THEN
	sle_display.text= left(sle_display.text, len(sle_display.text) - 2)
	is_sign =''
	ib_ultsig = False
ELSE
	is_num = left(is_num, len(is_num) - 1)
	sle_display.text = is_num
END IF

//istr_calc.datawindow.SetText(is_num)


end event

type cb_percent from commandbutton within w_calculator
int X=530
int Y=476
int Width=114
int Height=108
int TabOrder=50
string Text="%"
int TextSize=-11
int Weight=700
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;is_num = String(dec(is_num) / 100)
//istr_calc.datawindow.SetText(is_num)

sle_display.text = is_num
end event

type cb_mult from commandbutton within w_calculator
int X=402
int Y=120
int Width=114
int Height=108
int TabOrder=60
string Text="X"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_operador('*')
end event

type cb_div from commandbutton within w_calculator
int X=402
int Y=236
int Width=114
int Height=108
int TabOrder=100
string Text="/"
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
of_operador('/')


end event

type cb_minus from commandbutton within w_calculator
int X=402
int Y=352
int Width=119
int Height=108
int TabOrder=140
string Text="-"
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_operador('-')
end event

type cb_plus from commandbutton within w_calculator
int X=402
int Y=476
int Width=119
int Height=108
int TabOrder=180
string Text="+"
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_operador('+')
end event

type cb_enter from commandbutton within w_calculator
int X=229
int Y=608
int Width=416
int Height=108
int TabOrder=210
string Text="=    Enter"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;of_calculo()
of_display_rs(is_num)
Close(Parent)
end event

