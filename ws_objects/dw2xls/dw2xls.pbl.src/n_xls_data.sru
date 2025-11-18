$PBExportHeader$n_xls_data.sru
forward
global type n_xls_data from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_data from nonvisualobject
end type
global n_xls_data n_xls_data

type variables
integer ii_fnum = 1
protected uint ii_max_current_size =4048
protected blob ib_arr[]
protected ulong il_count = 0
protected ulong il_total_size = 0
protected uint ii_current_size = 4048

end variables

forward prototypes
protected function int of_add_item()
public function integer of_append (ref blob ab_data)
public function integer of_write (olestream ai_stream)
end prototypes

protected function int of_add_item();int li_ret = 1
il_count ++
ii_current_size = 0
return li_ret

end function

public function integer of_append (ref blob ab_data);int li_ret = 1
ulong ll_size
uint li_right_size
blob lb_part
ll_size = len(ab_data)


do while ll_size > 0 
   if ii_current_size = ii_max_current_size then
		of_add_item()
	end if	

   if ll_size <= (ii_max_current_size - ii_current_size) then
      if ii_current_size = 0 then
         ib_arr[il_count] = ab_data
      else
         ib_arr[il_count] += ab_data
      end if
      ii_current_size += ll_size
      il_total_size += ll_size
      ll_size = 0
   else
      li_right_size = ii_max_current_size - ii_current_size
      lb_part = blobmid(ab_data, 1, li_right_size)
      ab_data = blobmid(ab_data, li_right_size + 1, ll_size - li_right_size)
      ll_size -= li_right_size

      if ii_current_size = 0 then
         ib_arr[il_count] = lb_part
      else
         ib_arr[il_count] += lb_part
      end if
      ii_current_size += li_right_size
      il_total_size += li_right_size
   end if
loop
return li_ret

end function

public function integer of_write (olestream ai_stream);int li_ret = 1
ulong ll_i
blob lb_emp[]

for ll_i = 1 to  il_count
  if ll_i = il_count then
     ai_stream.write(blobmid(ib_arr[ll_i],1,ii_current_size))
  else
     ai_stream.write(blobmid(ib_arr[ll_i],1,ii_max_current_size))
  end if
next
ib_arr = lb_emp

return li_ret

end function

on n_xls_data.create
TriggerEvent( this, "constructor" )
end on

on n_xls_data.destroy
TriggerEvent( this, "destructor" )
end on

