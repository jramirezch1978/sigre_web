$PBExportHeader$n_xls_subroutines_v5.sru
forward
global type n_xls_subroutines_v5 from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_subroutines_v5 from nonvisualobject
end type
global n_xls_subroutines_v5 n_xls_subroutines_v5

type variables

end variables

forward prototypes
public function blob of_pack (character ac_conv_type, unsignedlong al_val)
public function blob of_pack(char AC_CONV_TYPE, double AD_VAL)
public function string of_str2xls (string as_str)
end prototypes

public function blob of_pack (character ac_conv_type, unsignedlong al_val);ulong ll_val
char lc_val

integer li_byte_count, li_i
blob{7} lblb_val

choose case ac_conv_type
   case 'v','V','C','c'
      //byte count
      choose case ac_conv_type
         case 'v'   //unsigned VAX short 16 bit 
           li_byte_count = 2
         case 'V'   //unsigned VAX long 32 bit
           li_byte_count = 4
         case 'C','c'   //char 8 bit
           li_byte_count = 1
           if al_val < 0 then  
              al_val = 256 - abs(mod(al_val, 129))
           end if
      end choose 
      ll_val = al_val
      for li_i = 1 to li_byte_count
			blobedit(lblb_val, li_i, char(mod(ll_val, 256)))
         ll_val = ll_val/256
      next
		
   case else 
   	 
   	
      MessageBox('Error', 'Invalid argument type in of_pack(~'' + AC_CONV_TYPE + '~', ulong)')
   	
		
end choose

return blobmid(lblb_val,1, li_byte_count)

end function

public function blob of_pack(char AC_CONV_TYPE, double AD_VAL);blob{8} lb_ret 

if ac_conv_type = 'd' then
   blobedit(lb_ret, 1, ad_val)
else
	 
	
   MessageBox('Error', 'Invalid argument type in of_pack(~'' + AC_CONV_TYPE + '~', double)')
	
end if

return lb_ret
end function

public function string of_str2xls (string as_str);long ll_pos

ll_pos = pos(as_str, '~r~n')
do while ll_pos > 0
	as_str = replace(as_str, ll_pos, 2, '~n')
	ll_pos = pos(as_str, '~r~n')
loop

ll_pos = pos(as_str, '~r')
do while ll_pos > 0
	as_str = replace(as_str, ll_pos, 1, '~n')
	ll_pos = pos(as_str, '~r')
loop

return as_str

end function

on n_xls_subroutines_v5.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_subroutines_v5.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

