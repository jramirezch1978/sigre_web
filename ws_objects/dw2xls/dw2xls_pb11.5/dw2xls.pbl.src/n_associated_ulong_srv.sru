$PBExportHeader$n_associated_ulong_srv.sru
forward
global type n_associated_ulong_srv from nonvisualobject
end type
end forward

global type n_associated_ulong_srv from nonvisualobject
end type
global n_associated_ulong_srv n_associated_ulong_srv

type variables
 private ulong il_keys[]
 private ulong il_key_count
end variables

forward prototypes
public function unsignedlong of_add_key (unsignedlong al_val)
public function unsignedlong of_find_key (unsignedlong al_val)
public function unsignedlong of_get_key_index (unsignedlong al_val)
public function integer of_sort_keys ()
public function unsignedlong of_get_keys_count ()
public function unsignedlong of_get_key (unsignedlong al_index)
protected function unsignedlong of_get_index_min_key (unsignedlong al_from_key)
end prototypes

public function unsignedlong of_add_key (unsignedlong al_val);ulong ll_index


if isnull(al_val) then
    return 0
end if

il_key_count ++
il_keys[il_key_count] = al_val
return il_key_count


end function

public function unsignedlong of_find_key (unsignedlong al_val);return of_get_key_index(al_val)
end function

public function unsignedlong of_get_key_index (unsignedlong al_val);ulong ll_i


for ll_i = 1 to il_key_count

    if il_keys[ll_i] = al_val then
        return ll_i
    end if

next

return 0


end function

public function integer of_sort_keys ();integer li_ret = 1
ulong ll_i
ulong ll_cnt
ulong ll_new_keys[]
ulong ll_start_key

ll_cnt = il_key_count

do while true
    ll_i = of_get_index_min_key(ll_start_key)

    if ll_i > 0 then
        ll_cnt ++
        ll_new_keys[ll_cnt] = il_keys[ll_i]
        ll_start_key = il_keys[ll_i] + 1
    else
        exit
    end if

loop

il_keys = ll_new_keys
il_key_count = upperbound(il_keys)
return li_ret


end function

public function unsignedlong of_get_keys_count ();return il_key_count
end function

public function unsignedlong of_get_key (unsignedlong al_index);return il_keys[al_index]
end function

protected function unsignedlong of_get_index_min_key (unsignedlong al_from_key);ulong ll_ret
ulong ll_i
ulong ll_min_key = 4294967295


for ll_i = 1 to il_key_count

    if il_keys[ll_i] >= al_from_key and il_keys[ll_i] <= ll_min_key then
        ll_ret = ll_i
        ll_min_key = il_keys[ll_i]
    end if

next

return ll_ret


end function

on n_associated_ulong_srv.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_associated_ulong_srv.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

