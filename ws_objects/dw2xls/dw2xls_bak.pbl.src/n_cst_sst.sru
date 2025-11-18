$PBExportHeader$n_cst_sst.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_cst_sst from nonvisualobject
end type
type st_extsst_item from structure within n_cst_sst
end type
end forward

type st_extsst_item from structure
	ulong		il_absolute_pos
	uint		ii_relative_pos
end type

global type n_cst_sst from nonvisualobject
end type
global n_cst_sst n_cst_sst

type variables
public n_cst_unicode_hash_long invo_hash
public n_cst_unicode invo_unicode
public n_xls_subroutines_v97 invo_sub
public ulong il_total_in_doc
public ulong il_total_unique
public ulong il_limit = 8224
public blob ib_st[]
public blob ib_extsst
public integer ii_string_per_extsst = 8
private st_extsst_item i_extsst_items[]
public integer ii_extsst_count
end variables

forward prototypes
public function ulong of_add_string (blob ab_value)
public function ulong of_add_string (string as_value)
public function blob of_get_extsst ()
public function blob of_get_sst (ulong al_offest)
end prototypes

public function ulong of_add_string (blob ab_value);il_total_in_doc ++

if invo_hash.of_key_exists(ab_value) then
	return (invo_hash.of_get_value(ab_value) - 1)
else
	il_total_unique ++
	ib_st[il_total_unique] = ab_value
	invo_hash.of_set_value(ab_value,il_total_unique)
	return (il_total_unique - 1)
end if
end function

public function ulong of_add_string (string as_value);return of_add_string(invo_unicode.of_ansi2unicode(as_value))
end function

public function blob of_get_extsst ();blob lb_ret
uint li_cnt
uint li_i

li_cnt = upperbound(i_extsst_items)
lb_ret = invo_sub.of_pack("v",255) + invo_sub.of_pack("v",li_cnt * 8 + 2) + invo_sub.of_pack("v",ii_string_per_extsst)

if li_cnt > 0 then

	for li_i = 1 to li_cnt
		lb_ret = lb_ret + invo_sub.of_pack("V",i_extsst_items[li_i].il_absolute_pos) + invo_sub.of_pack("v",i_extsst_items[li_i].ii_relative_pos) + invo_sub.of_pack("v",0)
	next

end if

return lb_ret
end function

public function blob of_get_sst (ulong al_offest);blob lb_ret
ulong ll_absolute_pos
uint li_relative_pos
ulong ll_i
integer li_header_size = 12
integer li_add_size
uint li_new_size
blob lb_cur_portion
blob lb_header
boolean lb_first_portion = true
integer li_split_pos
blob lb_first_part
blob lb_last_part
st_extsst_item l_emp[]

i_extsst_items = l_emp
ii_extsst_count = 0
lb_cur_portion = blob("")
lb_ret = blob("")
ll_absolute_pos = li_header_size + al_offest
li_relative_pos = li_header_size

for ll_i = 1 to il_total_unique
	li_add_size = 3 + len(ib_st[ll_i])
	li_new_size = li_relative_pos + li_add_size

	if li_new_size > il_limit then

		if il_limit - li_relative_pos < 5 then

			if lb_first_portion then
				lb_header = invo_sub.of_pack("v",252) + invo_sub.of_pack("v",len(lb_cur_portion) + 8) + invo_sub.of_pack("V",il_total_in_doc) + invo_sub.of_pack("V",il_total_unique)
			else
				lb_header = invo_sub.of_pack("v",60) + invo_sub.of_pack("v",len(lb_cur_portion))
			end if

			lb_ret = lb_ret + lb_header + lb_cur_portion
			lb_first_portion = false
			li_header_size = 4
			lb_cur_portion = blob("")
			li_relative_pos = li_header_size
			ll_absolute_pos += li_header_size
			lb_cur_portion = lb_cur_portion + invo_sub.of_pack("v",integer(len(ib_st[ll_i]) / 2)) + invo_sub.of_pack("C",1) + ib_st[ll_i]

			if mod(ll_i - 1,ii_string_per_extsst) = 0 then
				ii_extsst_count ++
				i_extsst_items[ii_extsst_count].il_absolute_pos = ll_absolute_pos
				i_extsst_items[ii_extsst_count].ii_relative_pos = li_relative_pos
			end if

			ll_absolute_pos += (3 + len(ib_st[ll_i]))
			li_relative_pos = li_relative_pos + 3 + len(ib_st[ll_i])
		else
			li_split_pos = il_limit - li_relative_pos - 3

			if mod(li_split_pos,2) = 1 then
				li_split_pos --
			end if

			lb_first_part = blobmid(ib_st[ll_i],1,li_split_pos)
			lb_last_part = blobmid(ib_st[ll_i],li_split_pos + 1,len(ib_st[ll_i]) - li_split_pos)
			lb_cur_portion = lb_cur_portion + invo_sub.of_pack("v",integer(len(ib_st[ll_i]) / 2)) + invo_sub.of_pack("C",1) + lb_first_part

			if mod(ll_i - 1,ii_string_per_extsst) = 0 then
				ii_extsst_count ++
				i_extsst_items[ii_extsst_count].il_absolute_pos = ll_absolute_pos
				i_extsst_items[ii_extsst_count].ii_relative_pos = li_relative_pos
			end if

			ll_absolute_pos += (3 + len(lb_first_part))
			li_relative_pos = li_relative_pos + 3 + len(lb_first_part)

			if lb_first_portion then
				lb_header = invo_sub.of_pack("v",252) + invo_sub.of_pack("v",len(lb_cur_portion) + 8) + invo_sub.of_pack("V",il_total_in_doc) + invo_sub.of_pack("V",il_total_unique)
			else
				lb_header = invo_sub.of_pack("v",60) + invo_sub.of_pack("v",len(lb_cur_portion))
			end if

			lb_ret = lb_ret + lb_header + lb_cur_portion
			lb_first_portion = false
			li_header_size = 4
			lb_cur_portion = blob("")
			li_relative_pos = li_header_size
			ll_absolute_pos += li_header_size
			lb_cur_portion = lb_cur_portion + invo_sub.of_pack("C",1) + lb_last_part
			ll_absolute_pos += (1 + len(lb_last_part))
			li_relative_pos = li_relative_pos + 1 + len(lb_last_part)
		end if

	else
		lb_cur_portion = lb_cur_portion + invo_sub.of_pack("v",integer(len(ib_st[ll_i]) / 2)) + invo_sub.of_pack("C",1) + ib_st[ll_i]

		if mod(ll_i - 1,ii_string_per_extsst) = 0 then
			ii_extsst_count ++
			i_extsst_items[ii_extsst_count].il_absolute_pos = ll_absolute_pos
			i_extsst_items[ii_extsst_count].ii_relative_pos = li_relative_pos
		end if

		ll_absolute_pos += (3 + len(ib_st[ll_i]))
		li_relative_pos = li_relative_pos + 3 + len(ib_st[ll_i])
	end if

next

if ((len(lb_cur_portion) > 0) or (lb_first_portion)) then

	if lb_first_portion then
		lb_header = invo_sub.of_pack("v",252) + invo_sub.of_pack("v",len(lb_cur_portion) + 8) + invo_sub.of_pack("V",il_total_in_doc) + invo_sub.of_pack("V",il_total_unique)
	else
		lb_header = invo_sub.of_pack("v",60) + invo_sub.of_pack("v",len(lb_cur_portion))
	end if

	lb_ret = lb_ret + lb_header + lb_cur_portion
end if

return lb_ret
end function

event constructor;invo_hash = create n_cst_unicode_hash_long
invo_sub = create n_xls_subroutines_v97
return
end event

on n_cst_sst.create
triggerevent("constructor")
end on

on n_cst_sst.destroy
triggerevent("destructor")
end on

event destructor;destroy(invo_hash)
destroy(invo_sub)
return
end event

