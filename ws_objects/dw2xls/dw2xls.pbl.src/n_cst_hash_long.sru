$PBExportHeader$n_cst_hash_long.sru
forward
global type n_cst_hash_long from n_cst_hash
end type
end forward

global type n_cst_hash_long from n_cst_hash
end type
global n_cst_hash_long n_cst_hash_long

forward prototypes
public function long of_get_value (readonly string as_key)
public function integer of_set_value (readonly string as_key, readonly long al_value)
protected function n_cst_hash_entry of_create_entry ()
end prototypes

public function long of_get_value (readonly string as_key);long ll_ret

n_cst_hash_long_entry lnvo_cur_entry
lnvo_cur_entry = of_find_hash_entry(as_key)

if not(isNull(lnvo_cur_entry)) then
	ll_ret = lnvo_cur_entry.il_value
else
	SetNull(ll_ret)
end if

return ll_ret
end function

public function integer of_set_value (readonly string as_key, readonly long al_value);integer li_ret = 1


n_cst_hash_long_entry lnvo_cur_entry
lnvo_cur_entry = of_get_hash_entry(as_key)

if not(isNull(lnvo_cur_entry)) then
	lnvo_cur_entry.il_value = al_value 
else
	li_ret = -1
end if

return li_ret
end function

protected function n_cst_hash_entry of_create_entry ();n_cst_hash_entry lnvo_ret
lnvo_ret = create n_cst_hash_long_entry
return lnvo_ret


end function

on n_cst_hash_long.create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash_long.destroy
TriggerEvent( this, "destructor" )
end on

