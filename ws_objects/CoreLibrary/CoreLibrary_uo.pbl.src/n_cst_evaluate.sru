$PBExportHeader$n_cst_evaluate.sru
$PBExportComments$Evalua formulas y las convierte en un valor numerico
forward
global type n_cst_evaluate from nonvisualobject
end type
end forward

global type n_cst_evaluate from nonvisualobject
end type
global n_cst_evaluate n_cst_evaluate

type variables
u_ds_evaluate ids_1
end variables

forward prototypes
public function string of_evaluate (string as_formula)
public function string of_calculo (string as_formula)
public function string of_replace (string as_formula, string as_variable, string as_value)
end prototypes

public function string of_evaluate (string as_formula);string ls_rc

ls_rc = of_calculo(as_formula)

RETURN ls_rc
end function

public function string of_calculo (string as_formula);String ls_rc

ids_1.SetItem(1, "formula", as_formula)

ls_rc = ids_1.describe("evaluate('" + as_formula + "', 1)")

RETURN ls_rc
end function

public function string of_replace (string as_formula, string as_variable, string as_value);String	ls_formula
Long		ll_len_text, ll_len, ll_pos

ls_formula = as_formula
ll_len_text = len(ls_formula)

ll_len = LEN(as_variable)
ll_pos = 1

DO UNTIL (ll_pos >= ll_len_text)
	ll_pos = Pos(ls_formula,as_variable, ll_pos)
	IF ll_pos = 0 THEN EXIT
	ls_formula = REPLACE(ls_formula, ll_pos, ll_len, as_value)
	ll_pos = ll_pos + ll_len + 1
LOOP
	
RETURN ls_formula
end function

event constructor;ids_1 = create u_ds_evaluate


end event

on n_cst_evaluate.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_evaluate.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;destroy ids_1
end event

