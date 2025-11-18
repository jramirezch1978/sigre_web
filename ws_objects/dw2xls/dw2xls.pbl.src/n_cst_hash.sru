$PBExportHeader$n_cst_hash.sru
forward
global type n_cst_hash from nonvisualobject
end type
end forward

global type n_cst_hash from nonvisualobject
end type
global n_cst_hash n_cst_hash

type variables
private: 
n_cst_hash_entry invo_fields[]
long  il_field_max_value = 7
long  il_field_count = 0
long  il_max_capacity = -1


end variables

forward prototypes
public function boolean of_key_exists (readonly string as_key)
public function long of_get_capacity ()
public function long of_get_keys (ref string as_keys[])
protected function n_cst_hash_entry of_create_entry ()
protected function integer of_extend_hash (long al_power)
protected function integer of_set_capacity (long al_new_capacity)
protected function integer of_set_max_capacity (long al_new_max_capacity)
public function integer of_delete_key (readonly string as_key)
public function n_cst_hash_entry of_find_hash_entry (readonly string as_key)
public function n_cst_hash_entry of_get_hash_entry (readonly string as_key)
public function unsignedlong of_hash (readonly string as_key)
end prototypes

public function boolean of_key_exists (readonly string as_key);ulong ll_h
ulong ll_i
n_cst_hash_entry lnvo_entry

ll_h = of_hash(as_key)
ll_i =  mod(ll_h, il_field_max_value) + 1

lnvo_entry = invo_fields[ll_i]
do while not(isNull(lnvo_entry))
    if lnvo_entry.il_hash = ll_h then
       if lnvo_entry.is_key = as_key then  return true
    end if
    lnvo_entry = lnvo_entry.invo_next
loop	 

return false

end function

public function long of_get_capacity ();return il_field_max_value + 1

end function

public function long of_get_keys (ref string as_keys[]);string ls_ret[]
long ll_cnt
long ll_i
n_cst_hash_entry lnvo_cur_entry
ll_cnt = 0

for ll_i = 1 to il_field_max_value + 1 
  lnvo_cur_entry = invo_fields[ll_i]	
  do while Not(isNull(lnvo_cur_entry)) 
	  ll_cnt ++ 
	  ls_ret[ll_cnt] = lnvo_cur_entry.is_key
	  lnvo_cur_entry = lnvo_cur_entry.invo_next
  loop
next
as_keys = ls_ret
return ll_cnt


end function

protected function n_cst_hash_entry of_create_entry ();n_cst_hash_entry ret
SetNull(ret)
return ret
end function

protected function integer of_extend_hash (long al_power);ulong ll_i, ll_old_size, ll_new_size, ll_new_pos
n_cst_hash_entry lnvo_cur_entry, lnvo_prev_entry, lnvo_next_entry

ll_old_size = il_field_max_value + 1
ll_new_size = ll_old_size * 2^al_power

if (ll_new_size > il_max_capacity) and (il_max_capacity <> -1) then return -1

il_field_max_value = ll_new_size - 1

for ll_i = ll_old_size + 1 to ll_new_size
	SetNull(invo_fields[ll_i])
next	

for ll_i = 1 to ll_old_size
	lnvo_cur_entry = invo_fields[ll_i]
	SetNull(lnvo_prev_entry)
   do while not(isNull(lnvo_cur_entry))
		ll_new_pos = mod(lnvo_cur_entry.il_hash, il_field_max_value) + 1
		if ll_new_pos <> ll_i then
			if lnvo_cur_entry = invo_fields[ll_i] then
				invo_fields[ll_i] =  lnvo_cur_entry.invo_next
				lnvo_next_entry = lnvo_cur_entry.invo_next
			else
				lnvo_prev_entry.invo_next = lnvo_cur_entry.invo_next
				lnvo_next_entry = lnvo_cur_entry.invo_next
			end if
			
			lnvo_cur_entry.invo_next = invo_fields[ll_new_pos]
			invo_fields[ll_new_pos] = lnvo_cur_entry
		else
			lnvo_prev_entry = lnvo_cur_entry
			lnvo_next_entry = lnvo_cur_entry.invo_next
		end if
		lnvo_cur_entry = lnvo_next_entry
	loop
next	

return 1
end function

protected function integer of_set_capacity (long al_new_capacity);long ll_power
long ll_capacity

ll_capacity = of_get_capacity()
if al_new_capacity > ll_capacity then
	ll_power = 1 + Truncate(Log( al_new_capacity - 1 ) / Log(2) - &
	                        Log( ll_capacity ) / Log(2) + 0.00001, 0) 
									
   if ll_power > 0 then return of_extend_hash(ll_power)									
end if

return 1
end function

protected function integer of_set_max_capacity (long al_new_max_capacity);long ll_capacity
if al_new_max_capacity < 0 then
     il_max_capacity = -1
else 
	ll_capacity = of_get_capacity()
	if al_new_max_capacity < ll_capacity then
      il_max_capacity = ll_capacity
   else
     il_max_capacity = al_new_max_capacity
   end if
end if

return 1


end function

public function integer of_delete_key (readonly string as_key);n_cst_hash_entry lnvo_cur_entry, lnvo_prev_entry, lnvo_next_entry
ulong ll_h
ulong ll_i

ll_h = of_hash(as_key)
ll_i = mod(ll_h, il_field_max_value) + 1
lnvo_cur_entry = invo_fields[ll_i]
SetNull(lnvo_prev_entry)
do while not(isNull(lnvo_cur_entry)) 
	if lnvo_cur_entry.il_hash = ll_h then
		if lnvo_cur_entry.is_key = as_key then
			if lnvo_cur_entry = invo_fields[ll_i] then
				invo_fields[ll_i] = lnvo_cur_entry.invo_next
				lnvo_next_entry = lnvo_cur_entry.invo_next
			else
				lnvo_prev_entry.invo_next = lnvo_cur_entry.invo_next
				lnvo_next_entry = lnvo_cur_entry.invo_next
			end if
			il_field_count --
			destroy lnvo_cur_entry
		else
			lnvo_prev_entry = lnvo_cur_entry
			lnvo_next_entry = lnvo_cur_entry.invo_next
		end if
	else
		lnvo_prev_entry = lnvo_cur_entry
		lnvo_next_entry = lnvo_cur_entry.invo_next
	end if
	lnvo_cur_entry = lnvo_next_entry		
loop

return 1
end function

public function n_cst_hash_entry of_find_hash_entry (readonly string as_key);ulong ll_h, ll_i
n_cst_hash_entry lnvo_cur_entry
n_cst_hash_entry ret

SetNull(ret)

ll_h = of_hash(as_key)
ll_i = mod(ll_h, il_field_max_value) + 1
lnvo_cur_entry = invo_fields[ll_i]

do while not (isNull(lnvo_cur_entry))
   if lnvo_cur_entry.il_hash = ll_h then
      if lnvo_cur_entry.is_key = as_key then 
         ret = lnvo_cur_entry
			exit
      end if
   end if
   lnvo_cur_entry = lnvo_cur_entry.invo_next
loop	

return ret

end function

public function n_cst_hash_entry of_get_hash_entry (readonly string as_key);ulong ll_h, ll_i
n_cst_hash_entry lnvo_cur_entry, ret

SetNull(ret)

if il_field_count > il_field_max_value then of_extend_hash(1)
ll_h = of_hash(as_key)
ll_i = mod(ll_h, il_field_max_value) + 1
lnvo_cur_entry = invo_fields[ll_i]

do while not (isNull(lnvo_cur_entry))
   if lnvo_cur_entry.il_hash = ll_h then
      if lnvo_cur_entry.is_key = as_key then 
         ret = lnvo_cur_entry
			exit
      end if
   end if
   lnvo_cur_entry = lnvo_cur_entry.invo_next
loop	

if isNull(ret) then
    ret = of_create_entry()
    il_field_count ++
    ret.invo_next = invo_fields[ll_i]
    ret.il_hash = ll_h
    ret.is_key = as_key
	 invo_fields[ll_i] = ret
end if

return ret

end function

public function unsignedlong of_hash (readonly string as_key);ulong ll_i, ll_len
ulong ll_ret = 0

ll_len = Len(as_key)
for ll_i = 1 to ll_len 
    ll_ret = 33 * ll_ret + Asc(mid(as_key, ll_i, 1))
next
ll_ret += ll_ret/32

return ll_ret
end function

on n_cst_hash.create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;long ll_i

for ll_i = 1 to il_field_max_value + 1 
	SetNull(invo_fields[ll_i])
next


end event

event destructor;long ll_i
n_cst_hash_entry lnvo_cur_entry

for ll_i = 1 to il_field_max_value + 1
//--Tomikhin - 01.09.04
//	do while not(isNull(invo_fields[ll_i]))
	do while not(isNull(invo_fields[ll_i])) and isValid(invo_fields[ll_i])
//--
		lnvo_cur_entry = invo_fields[ll_i]
      invo_fields[ll_i] = lnvo_cur_entry.invo_next
      destroy lnvo_cur_entry
   loop
next

return 1
end event

