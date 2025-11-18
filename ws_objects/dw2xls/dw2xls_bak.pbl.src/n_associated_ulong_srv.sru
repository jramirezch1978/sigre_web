$PBExportHeader$n_associated_ulong_srv.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
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
public function ulong of_add_key (ulong al_val)
public function ulong of_find_key (ulong al_val)
protected function ulong of_get_index_min_key (ulong al_from_key)
public function ulong of_get_key (ulong al_index)
public function ulong of_get_key_index (ulong al_val)
public function ulong of_get_keys_count ()
public function integer of_sort_keys ()
end prototypes

public function ulong of_add_key (ulong al_val);ulong ll_index

if isnull(al_val) then
	return 0
end if

il_key_count ++
il_keys[il_key_count] = al_val
return il_key_count
end function

public function ulong of_find_key (ulong al_val);return of_get_key_index(al_val)
end function

protected function ulong of_get_index_min_key (ulong al_from_key);ulong ll_ret
ulong ll_i
ulong ll_min_key = -1

for ll_i = 1 to il_key_count

	if il_keys[ll_i] >= al_from_key and il_keys[ll_i] <= ll_min_key then
		ll_ret = ll_i
		ll_min_key = il_keys[ll_i]
	end if

next

return ll_ret
end function

public function ulong of_get_key (ulong al_index);return il_keys[al_index]
end function

public function ulong of_get_key_index (ulong al_val);ulong ll_i

for ll_i = 1 to il_key_count

	if il_keys[ll_i] = al_val then
		return ll_i
	end if

next

return 0
end function

public function ulong of_get_keys_count ();return il_key_count
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

on n_associated_ulong_srv.create
triggerevent("constructor")
end on

on n_associated_ulong_srv.destroy
triggerevent("destructor")
end on

