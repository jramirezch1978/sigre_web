$PBExportHeader$n_dwr_sub.sru
forward
global type n_dwr_sub from nonvisualobject
end type
end forward

global type n_dwr_sub from nonvisualobject
end type
global n_dwr_sub n_dwr_sub

type prototypes
Function ulong GetTempPath (ulong nBufferLength, ref string lpBuffer) Library "KERNEL32.DLL"  Alias for "GetTempPathA"
Function uint GetDC(uint hw) Library "User32"
Function uint ReleaseDC(uint hw, uint hDC) Library "User32"
Function long GetDeviceCaps(long hDC, long iCapability) Library "Gdi32"

end prototypes

type variables
double id_x_coef_0 = 32
double id_x_coef_1
double id_x_coef_2
double id_x_coef_3

double id_cur_x_coef


double id_y_coef_0 = 5.1 //2178
double id_y_coef_1
double id_y_coef_2
double id_y_coef_3

double id_cur_y_coef

end variables

forward prototypes
public function string of_gettemppath ()
public function double of_get_coef_x (integer a_units)
public subroutine of_set_cur_units (integer ai_units)
public function double of_get_cur_coef_x ()
public function double of_get_coef_y (integer a_units)
public function double of_get_cur_coef_y ()
public function double of_get_conv_x ()
public function double of_get_conv_y ()
end prototypes

public function string of_gettemppath ();string ls_path
ulong ls_len
ulong ls_buff_size = 200
ls_path = space( ls_buff_size )

ls_len = GetTempPath(ls_buff_size, ls_path)

if ls_len > 0 then 
	return '' // mid(ls_path, 1, len(ls_path) - 1)
else
	return ''
end if


end function

public function double of_get_coef_x (integer a_units);choose case a_units
	case 0
		return id_x_coef_0
	case 1
		return id_x_coef_1
	case 2
		return id_x_coef_2
	case 3
		return id_x_coef_3
	case else
		return id_x_coef_0
end choose
end function

public subroutine of_set_cur_units (integer ai_units); id_cur_x_coef = of_get_coef_x(ai_units)
 id_cur_y_coef = of_get_coef_y(ai_units)
 
end subroutine

public function double of_get_cur_coef_x ();return id_cur_x_coef
end function

public function double of_get_coef_y (integer a_units);choose case a_units
	case 0
		return id_y_coef_0
	case 1
		return id_y_coef_1
	case 2
		return id_y_coef_2
	case 3
		return id_y_coef_3
	case else
		return id_y_coef_0
end choose
end function

public function double of_get_cur_coef_y ();return id_cur_y_coef
end function

public function double of_get_conv_x ();return of_get_cur_coef_x()/of_get_coef_x(0)
end function

public function double of_get_conv_y ();return of_get_coef_y(0)/of_get_cur_coef_y() 
end function

on n_dwr_sub.create
TriggerEvent( this, "constructor" )
end on

on n_dwr_sub.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;uint li_hDC
constant long   LCI_LogPixelsX = 88
constant long   LCI_LogPixelsY = 90
long ll_PixelsPerInchX
long ll_PixelsPerInchY

li_hDC = GetDC(0)
//messagebox('1', li_hDC)
ll_PixelsPerInchX = GetDeviceCaps(li_hDC, LCI_LogPixelsX)
ll_PixelsPerInchY = GetDeviceCaps(li_hDC, LCI_LogPixelsY)
li_hDC = ReleaseDC(0, li_hDC)

if ll_PixelsPerInchX = 0 then ll_PixelsPerInchX = 96
if ll_PixelsPerInchY = 0 then ll_PixelsPerInchY = 96

//messagebox('ll_PixelsPerInchX', ll_PixelsPerInchX)
//messagebox('ll_PixelsPerInchY', ll_PixelsPerInchY)


id_x_coef_1 = id_x_coef_0 * UnitstoPixels(100, XUnitsToPixels!)/100 
id_x_coef_2 = (1000*id_x_coef_1)/ll_PixelsPerInchX
id_x_coef_3 = id_x_coef_2 * 2.54

id_y_coef_1 = id_y_coef_0 * UnitstoPixels(100, YUnitsToPixels!)/100 
id_y_coef_2 = (1000*id_y_coef_1)/ll_PixelsPerInchY
id_y_coef_3 = id_y_coef_2 * 2.54

end event

