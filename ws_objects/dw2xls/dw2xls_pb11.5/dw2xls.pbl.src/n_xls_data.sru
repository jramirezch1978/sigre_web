$PBExportHeader$n_xls_data.sru
forward
global type n_xls_data from nonvisualobject
end type
end forward

global type n_xls_data from nonvisualobject
end type
global n_xls_data n_xls_data

type variables
PUBLIC INTEGER ii_fnum = 1
PROTECTED UINT ii_max_current_size = 4048
PROTECTED BLOB ib_arr[]

PROTECTED ULONG il_count
PROTECTED ULONG il_total_size
PROTECTED UINT ii_current_size = 4048

end variables

forward prototypes
protected function integer of_add_item ()
public function integer of_append (ref blob ab_data)
public function integer of_write (olestream ai_stream)
end prototypes

protected function integer of_add_item ();integer li_ret = 1

il_count ++
ii_current_size = 0
return li_ret
end function

public function integer of_append (ref blob ab_data);INTEGER li_ret = 1
ULONG ll_size
UINT li_right_size
BLOB lb_part

ll_size = LEN(ab_data)

DO While ll_size > 0
	
	IF ii_current_size = ii_max_current_size THEN
		of_add_item()
	END IF
	
	
	IF ll_size <= ii_max_current_size - ii_current_size THEN
		
		IF ii_current_size = 0 THEN
			ib_arr[il_count] = ab_data
		ELSE
			ib_arr[il_count] = ib_arr[il_count] + ab_data
		END IF
		
		ii_current_size = ii_current_size + ll_size
		il_total_size += ll_size
		ll_size = 0
	ELSE
		li_right_size = ii_max_current_size - ii_current_size
		lb_part = BLOBMID(ab_data, 1, li_right_size)
		ab_data = BLOBMID(ab_data, li_right_size + 1, ll_size - li_right_size)
		ll_size -= li_right_size
		
		IF ii_current_size = 0 THEN
			ib_arr[il_count] = lb_part
		ELSE
			ib_arr[il_count] = ib_arr[il_count] + lb_part
		END IF
		
		ii_current_size += li_right_size
		il_total_size += li_right_size
	END IF
	
LOOP

RETURN li_ret

end function

public function integer of_write (olestream ai_stream);INTEGER li_ret = 1
ULONG ll_i
BLOB lb_emp[]


FOR ll_i = 1 TO il_count
	
	IF ll_i = il_count THEN
		ai_stream.WRITE(BLOBMID(ib_arr[ll_i], 1, ii_current_size))
	ELSE
		ai_stream.WRITE(BLOBMID(ib_arr[ll_i], 1, ii_max_current_size))
	END IF
NEXT

ib_arr = lb_emp
RETURN li_ret



end function

on n_xls_data.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_data.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

