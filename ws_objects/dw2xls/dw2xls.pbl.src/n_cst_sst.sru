$PBExportHeader$n_cst_sst.sru
forward
global type n_cst_sst from nonvisualobject
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
n_cst_unicode_hash_long invo_hash
n_cst_unicode invo_unicode
n_xls_subroutines_v97 invo_sub
ulong il_total_in_doc = 0
ulong il_total_unique = 0
ulong il_limit = 8224
blob ib_st[]
blob ib_extsst
integer ii_string_per_extsst = 8
private st_extsst_item i_extsst_items[]
integer ii_extsst_count = 0


end variables

forward prototypes
public function ulong of_add_string (string as_value)
public function ulong of_add_string (blob ab_value)
public function blob of_get_sst (unsignedlong al_offest)
public function blob of_get_extsst ()
end prototypes

public function ulong of_add_string (string as_value);return of_add_string(invo_unicode.of_ansi2unicode(as_value))

end function

public function ulong of_add_string (blob ab_value);il_total_in_doc ++ 
if invo_hash.of_key_exists(ab_value) then
	return invo_hash.of_get_value(ab_value) - 1
else
	il_total_unique ++
	ib_st[il_total_unique] = ab_value
	invo_hash.of_set_value(ab_value, il_total_unique)
	return il_total_unique - 1
end if
	
end function

public function blob of_get_sst (unsignedlong al_offest);blob lb_ret
ulong ll_absolute_pos = 0
uint  li_relative_pos = 0
ulong ll_i
integer li_header_size = 12
integer li_add_size
uint li_new_size
blob lb_cur_portion
blob lb_header
boolean lb_first_portion = true
integer li_split_pos
blob lb_first_part, lb_last_part

st_extsst_item l_emp[]
i_extsst_items = l_emp
ii_extsst_count = 0


lb_cur_portion = blob('')
lb_ret = blob('')

ll_absolute_pos = li_header_size + al_offest
li_relative_pos = li_header_size

for ll_i = 1 to il_total_unique 
	li_add_size = 3 + len(ib_st[ll_i]) 
	li_new_size = li_relative_pos + li_add_size
	
	if li_new_size > il_limit then
		if (il_limit - li_relative_pos) < 5 then
			
			//all string in the next portion
			if lb_first_portion then
				lb_header = invo_sub.of_pack('v', 252) +               /*record identifier 0x00FC*/ &    
				            invo_sub.of_pack('v', len(lb_cur_portion) + 8) + /*length*/ &
				            invo_sub.of_pack('V', il_total_in_doc) + /*Total number of strings in the workbook*/ &
				            invo_sub.of_pack('V', il_total_unique)   /*Total number of unique strings in the workbook*/ 
			else
				lb_header = invo_sub.of_pack('v', 60) +                 /*record identifier 0x003C*/ &    
				            invo_sub.of_pack('v', len(lb_cur_portion))  /*length*/ 
			end if
			lb_ret += lb_header + lb_cur_portion //add new cur portion
			
			lb_first_portion = false    //next portion - continue 
			li_header_size = 4          //continue header size
			lb_cur_portion = blob('')   //clear cur portion
			li_relative_pos = li_header_size  //set new relative position
			ll_absolute_pos += li_header_size //update absolute position
			
			//add string into new portion
			lb_cur_portion += invo_sub.of_pack('v', integer(len(ib_st[ll_i])/2)) + &
									invo_sub.of_pack('C', 1) + &
									ib_st[ll_i]
			if  mod(ll_i - 1, ii_string_per_extsst) = 0 then
				 //add EXTSST entry
				 ii_extsst_count ++
				 i_extsst_items[ii_extsst_count].il_absolute_pos = ll_absolute_pos
				 i_extsst_items[ii_extsst_count].ii_relative_pos = li_relative_pos
			end if
	
			ll_absolute_pos += 3 + len(ib_st[ll_i])
			li_relative_pos += 3 + len(ib_st[ll_i])
		
		else
			//split string 
			li_split_pos = (il_limit - li_relative_pos) - 3
			if mod(li_split_pos, 2) = 1 then li_split_pos --
			lb_first_part = blobmid(ib_st[ll_i], 1, li_split_pos)
			lb_last_part  = blobmid(ib_st[ll_i], li_split_pos + 1, len(ib_st[ll_i]) - li_split_pos )

         //first part
			lb_cur_portion += invo_sub.of_pack('v', integer(len(ib_st[ll_i])/2)) + &
									invo_sub.of_pack('C', 1) + &
									lb_first_part
									
			if  mod(ll_i - 1, ii_string_per_extsst) = 0 then
				 //add EXTSST entry
				 ii_extsst_count ++
				 i_extsst_items[ii_extsst_count].il_absolute_pos = ll_absolute_pos
				 i_extsst_items[ii_extsst_count].ii_relative_pos = li_relative_pos
			end if
   		ll_absolute_pos += 3 + len(lb_first_part)
	   	li_relative_pos += 3 + len(lb_first_part)

			if lb_first_portion then
				lb_header = invo_sub.of_pack('v', 252) +               /*record identifier 0x00FC*/ &    
				            invo_sub.of_pack('v', len(lb_cur_portion) + 8) + /*length*/ &
				            invo_sub.of_pack('V', il_total_in_doc) + /*Total number of strings in the workbook*/ &
				            invo_sub.of_pack('V', il_total_unique)   /*Total number of unique strings in the workbook*/ 
			else
				lb_header = invo_sub.of_pack('v', 60) +                 /*record identifier 0x003C*/ &    
				            invo_sub.of_pack('v', len(lb_cur_portion))  /*length*/ 
			end if

			lb_ret += lb_header + lb_cur_portion //add new cur portion
			
			lb_first_portion = false    //next portion - continue 
			li_header_size = 4          //continue header size
			lb_cur_portion = blob('')   //clear cur portion
			li_relative_pos = li_header_size  //set new relative position
			ll_absolute_pos += li_header_size //update absolute position
			
			//add last string into new portion
			lb_cur_portion += invo_sub.of_pack('C', 1) + &
									lb_last_part

			ll_absolute_pos += 1 + len(lb_last_part)
			li_relative_pos += 1 + len(lb_last_part)
			
		end if

	else
		//add string into current portion 
		lb_cur_portion += invo_sub.of_pack('v', integer(len(ib_st[ll_i])/2)) + &
		                  invo_sub.of_pack('C', 1) + &
								ib_st[ll_i]
		if  mod(ll_i - 1, ii_string_per_extsst) = 0 then
			 //add EXTSST entry
			 ii_extsst_count ++
			 i_extsst_items[ii_extsst_count].il_absolute_pos = ll_absolute_pos
			 i_extsst_items[ii_extsst_count].ii_relative_pos = li_relative_pos
		end if
		
		ll_absolute_pos += 3 + len(ib_st[ll_i])
		li_relative_pos += 3 + len(ib_st[ll_i])
	end if
next

if (len(lb_cur_portion) > 0) or lb_first_portion then
	//last portion
	if lb_first_portion then
		lb_header = invo_sub.of_pack('v', 252) +               /*record identifier 0x00FC*/ &    
						invo_sub.of_pack('v', len(lb_cur_portion) + 8) + /*length*/ &
						invo_sub.of_pack('V', il_total_in_doc) + /*Total number of strings in the workbook*/ &
						invo_sub.of_pack('V', il_total_unique)   /*Total number of unique strings in the workbook*/ 
	else
		lb_header = invo_sub.of_pack('v', 60) +                 /*record identifier 0x003C*/ &    
						invo_sub.of_pack('v', len(lb_cur_portion))  /*length*/ 
	end if
	lb_ret += lb_header + lb_cur_portion //add cur portion
end if

return lb_ret
end function

public function blob of_get_extsst ();blob lb_ret
uint li_cnt, li_i

li_cnt = UpperBound(i_extsst_items)

lb_ret = invo_sub.of_pack('v', 255) +                /* 0x00FF Record identifier*/&   
         invo_sub.of_pack('v', (li_cnt * 8) + 2) +   /* Record length */&   
         invo_sub.of_pack('v', ii_string_per_extsst) /* Number of strings in portion */
			
if li_cnt > 0 then
	for li_i = 1 to li_cnt
		lb_ret += invo_sub.of_pack('V', i_extsst_items[li_i].il_absolute_pos) +&
		          invo_sub.of_pack('v', i_extsst_items[li_i].ii_relative_pos) +&
					 invo_sub.of_pack('v', 0) //not used
	next
end if

return lb_ret
end function

on n_cst_sst.create
TriggerEvent( this, "constructor" )
end on

on n_cst_sst.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;invo_hash = create n_cst_unicode_hash_long
invo_sub = create n_xls_subroutines_v97

end event

event destructor;destroy invo_hash
destroy invo_sub
end event

