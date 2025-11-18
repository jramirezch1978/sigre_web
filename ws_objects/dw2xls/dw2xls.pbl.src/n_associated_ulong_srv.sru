$PBExportHeader$n_associated_ulong_srv.sru
forward
global type n_associated_ulong_srv from nonvisualobject
end type
end forward

shared variables

end variables

global type n_associated_ulong_srv from nonvisualobject
end type
global n_associated_ulong_srv n_associated_ulong_srv

type variables
private ulong il_keys[]
private ulong il_key_count = 0

end variables

forward prototypes
public function ulong of_add_key(ulong AL_VAL)
public function ulong of_find_key(ulong AL_VAL)
public function ulong of_get_key_index(ulong AL_VAL)
protected function ulong of_get_index_min_key(ulong AL_FROM_KEY)
public function int of_sort_keys()
public function ulong of_get_keys_count()
public function ulong of_get_key(ULong AL_INDEX)

end prototypes

public function ulong of_add_key(ulong AL_VAL);ulong ll_index
if isNull(al_val) then return 0
il_key_count ++
il_keys[il_key_count] = al_val
return il_key_count
end function

public function ulong of_find_key(ulong AL_VAL);return of_get_key_index(al_val)
end function

public function ulong of_get_key_index(ulong AL_VAL);ulong ll_i

for ll_i = 1 to il_key_count
    if il_keys[ll_i] = al_val then return ll_i
next

return 0

end function

protected function ulong of_get_index_min_key(ulong AL_FROM_KEY);ulong ll_ret = 0
ulong ll_i 
ulong ll_min_key = 4294967295  //max value

for ll_i = 1 to il_key_count
    if (il_keys[ll_i] >= al_from_key) and (il_keys[ll_i] <= ll_min_key) then
       ll_ret = ll_i
       ll_min_key = il_keys[ll_i]
    end if
next

return ll_ret

end function

public function int of_sort_keys();int li_ret = 1
ulong ll_i, ll_cnt = 0
ulong ll_new_keys[]
ulong ll_start_key = 0
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

public function ulong of_get_keys_count();return il_key_count
end function

public function ulong of_get_key(ULong AL_INDEX);return il_keys[al_index]
end function

on n_associated_ulong_srv.create
TriggerEvent(this, "constructor" )
end on

on n_associated_ulong_srv.destroy
TriggerEvent(this, "destructor" )
end on

