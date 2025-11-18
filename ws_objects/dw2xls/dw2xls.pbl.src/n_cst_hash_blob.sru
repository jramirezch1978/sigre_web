$PBExportHeader$n_cst_hash_blob.sru
forward
global type n_cst_hash_blob from nonvisualobject
end type
end forward

global type n_cst_hash_blob from nonvisualobject
event type n_cst_hash_blob_entry ue_create_entry ( )
event type n_cst_hash_blob_entry ue_get_hash_entry ( readonly blob ab_key )
end type
global n_cst_hash_blob n_cst_hash_blob

type variables
private: 
n_cst_hash_blob_entry invo_fields[]
long  il_field_max_value = 7
long  il_field_count = 0
long  il_max_capacity = -1


end variables

forward prototypes
public function boolean of_key_exists (readonly blob ab_key)
public function long of_get_capacity ()
public function long of_get_keys (ref blob ab_keys[])
protected function integer of_extend_hash (long al_power)
protected function integer of_set_capacity (long al_new_capacity)
protected function integer of_set_max_capacity (long al_new_max_capacity)
public function integer of_delete_key (readonly blob ab_key)
public function n_cst_hash_blob_entry of_find_hash_entry (readonly blob ab_key)
public function unsignedlong of_hash (readonly blob ab_key)
end prototypes

event ue_create_entry;n_cst_hash_blob_entry ret
SetNull(ret)
return ret
end event

event ue_get_hash_entry;ulong ll_h, ll_i
n_cst_hash_blob_entry lnvo_cur_entry, ret

SetNull(ret)

if il_field_count > il_field_max_value then of_extend_hash(1)
ll_h = of_hash(ab_key)
ll_i = mod(ll_h, il_field_max_value) + 1
lnvo_cur_entry = invo_fields[ll_i]

do while not (isNull(lnvo_cur_entry))
   if lnvo_cur_entry.il_hash = ll_h then
      if lnvo_cur_entry.ib_key = ab_key then 
         ret = lnvo_cur_entry
			exit
      end if
   end if
   lnvo_cur_entry = lnvo_cur_entry.invo_next
loop	

if isNull(ret) then
    ret = event ue_create_entry()
    il_field_count ++
    ret.invo_next = invo_fields[ll_i]
    ret.il_hash = ll_h
    ret.ib_key = ab_key
	 invo_fields[ll_i] = ret
end if

return ret

end event

public function boolean of_key_exists (readonly blob ab_key);ulong ll_h
ulong ll_i
n_cst_hash_blob_entry lnvo_entry

ll_h = of_hash(ab_key)
ll_i =  mod(ll_h, il_field_max_value) + 1

lnvo_entry = invo_fields[ll_i]
do while not(isNull(lnvo_entry))
    if lnvo_entry.il_hash = ll_h then
       if lnvo_entry.ib_key = ab_key then  return true
    end if
    lnvo_entry = lnvo_entry.invo_next
loop	 

return false

end function

public function long of_get_capacity ();return il_field_max_value + 1

end function

public function long of_get_keys (ref blob ab_keys[]);blob lb_ret[]
long ll_cnt
long ll_i
n_cst_hash_blob_entry lnvo_cur_entry
ll_cnt = 0

for ll_i = 1 to il_field_max_value + 1 
  lnvo_cur_entry = invo_fields[ll_i]	
  do while Not(isNull(lnvo_cur_entry)) 
	  ll_cnt ++ 
	  lb_ret[ll_cnt] = lnvo_cur_entry.ib_key
	  lnvo_cur_entry = lnvo_cur_entry.invo_next
  loop
next
ab_keys = lb_ret
return ll_cnt


end function

protected function integer of_extend_hash (long al_power);ulong ll_i, ll_old_size, ll_new_size, ll_new_pos
n_cst_hash_blob_entry lnvo_cur_entry, lnvo_prev_entry, lnvo_next_entry

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

public function integer of_delete_key (readonly blob ab_key);n_cst_hash_blob_entry lnvo_cur_entry, lnvo_prev_entry, lnvo_next_entry
ulong ll_h
ulong ll_i

ll_h = of_hash(ab_key)
ll_i = mod(ll_h, il_field_max_value) + 1
lnvo_cur_entry = invo_fields[ll_i]
SetNull(lnvo_prev_entry)
do while not(isNull(lnvo_cur_entry)) 
	if lnvo_cur_entry.il_hash = ll_h then
		if lnvo_cur_entry.ib_key = ab_key then
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

public function n_cst_hash_blob_entry of_find_hash_entry (readonly blob ab_key);ulong ll_h, ll_i
n_cst_hash_blob_entry lnvo_cur_entry
n_cst_hash_blob_entry ret

SetNull(ret)

ll_h = of_hash(ab_key)
ll_i = mod(ll_h, il_field_max_value) + 1
lnvo_cur_entry = invo_fields[ll_i]

do while not (isNull(lnvo_cur_entry))
   if lnvo_cur_entry.il_hash = ll_h then
      if lnvo_cur_entry.ib_key = ab_key then 
         ret = lnvo_cur_entry
			exit
      end if
   end if
   lnvo_cur_entry = lnvo_cur_entry.invo_next
loop	

return ret

end function

public function unsignedlong of_hash (readonly blob ab_key);ulong ll_i, ll_len
ulong ll_ret = 0
ll_len = Len(ab_key)
for ll_i = 1 to ll_len 
    ll_ret = 33 * ll_ret + Asc(char(blobmid(ab_key, ll_i, 1)))
next
ll_ret += ll_ret/32

return ll_ret
end function

on n_cst_hash_blob.create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash_blob.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;long ll_i

for ll_i = 1 to il_field_max_value + 1 
	SetNull(invo_fields[ll_i])
next


end event

event destructor;long ll_i
n_cst_hash_blob_entry lnvo_cur_entry

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

