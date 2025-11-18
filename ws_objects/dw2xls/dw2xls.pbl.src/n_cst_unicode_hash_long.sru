$PBExportHeader$n_cst_unicode_hash_long.sru
forward
global type n_cst_unicode_hash_long from n_cst_hash_blob
end type
end forward

global type n_cst_unicode_hash_long from n_cst_hash_blob
end type
global n_cst_unicode_hash_long n_cst_unicode_hash_long

forward prototypes
public function integer of_set_value (readonly blob ab_key, ulong al_value)
public function unsignedlong of_get_value (readonly blob ab_key)
end prototypes

public function integer of_set_value (readonly blob ab_key, ulong al_value);integer li_ret = 1


n_cst_unicode_hash_long_entry lnvo_cur_entry
lnvo_cur_entry = event ue_get_hash_entry(ab_key)

if not(isNull(lnvo_cur_entry)) then
	lnvo_cur_entry.il_value = al_value 
else
	li_ret = -1
end if

return li_ret
end function

public function unsignedlong of_get_value (readonly blob ab_key);long li_ret

n_cst_unicode_hash_long_entry lnvo_cur_entry
lnvo_cur_entry = of_find_hash_entry(ab_key)

if not(isNull(lnvo_cur_entry)) then
	li_ret = lnvo_cur_entry.il_value
else
	SetNull(li_ret)
end if

return li_ret
end function

on n_cst_unicode_hash_long.create
call super::create
end on

on n_cst_unicode_hash_long.destroy
call super::destroy
end on

event ue_create_entry;n_cst_unicode_hash_long_entry lnvo_entry
lnvo_entry = create n_cst_unicode_hash_long_entry
return lnvo_entry
end event

