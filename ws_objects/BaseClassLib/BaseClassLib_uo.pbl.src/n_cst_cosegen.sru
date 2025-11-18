$PBExportHeader$n_cst_cosegen.sru
forward
global type n_cst_cosegen from nonvisualobject
end type
end forward

global type n_cst_cosegen from nonvisualobject
end type
global n_cst_cosegen n_cst_cosegen

forward prototypes
public function string of_cosegen (string as_codigo)
end prototypes

public function string of_cosegen (string as_codigo);String	ls_codigo, ls_resultado, ls_work
Long		ll_codigo, ll_x, ll_numero, ll_total, ll_primo[], ll_result, ll_pos

ll_primo[1] = 1
ll_primo[2] = 3
ll_primo[3] = 5
ll_primo[4] = 7
ll_primo[5] = 11
ll_primo[6] = 13
ll_primo[7] = 17
ll_primo[8] = 19
ll_primo[9] = 23
ll_primo[10] = 29
ll_primo[11] = 31
ll_primo[12] = 37
ll_primo[13] = 41
ll_primo[14] = 43
ll_primo[15] = 47
ll_primo[16] = 51
ll_primo[17] = 53
ll_primo[18] = 57
ll_primo[19] = 61
ll_primo[20] = 67

ls_codigo = trim(as_codigo)
ll_codigo = Len(ls_codigo)
ll_total = 0

FOR ll_x = 1 TO ll_codigo
	ll_numero = ASC(mid(ls_codigo, ll_x, 1))
	ll_total = ll_total + ll_numero * ll_primo[ll_x]
NEXT

ll_result = ll_total
Do While ll_result > 9
	ls_work = String(ll_result)
	ll_result = 0
	Do While Len(ls_work) >= 1
		ll_result = ll_result + Integer(left(ls_work, 1))
   	ls_work = mid(ls_work, 2)
	Loop
Loop

ll_pos = Mod(ll_result, ll_codigo)
IF ll_pos = 0 THEN ll_pos = ll_codigo

RETURN(Left(ls_codigo,ll_pos -1) + string(ll_result) + Mid(ls_codigo, ll_pos))



end function

on n_cst_cosegen.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_cosegen.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

