$PBExportHeader$n_xls_subroutines_v5.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_xls_subroutines_v5 from nonvisualobject
end type
end forward

global type n_xls_subroutines_v5 from nonvisualobject
end type
global n_xls_subroutines_v5 n_xls_subroutines_v5

forward prototypes
public function blob of_pack (char ac_conv_type,double ad_val)
public function blob of_pack (char ac_conv_type,ulong al_val)
public function string of_str2xls (string as_str)
end prototypes

public function blob of_pack (char ac_conv_type,double ad_val);blob{8} lb_ret

if ac_conv_type = "d" then
	blobedit(lb_ret,1,ad_val)
else
	messagebox("Error","Invalid argument type in of_pack('" + ac_conv_type + "', double)")
end if

return lb_ret
end function

public function blob of_pack (char ac_conv_type,ulong al_val);ulong ll_val
char lc_val
integer li_byte_count
integer li_i
blob{7} lblb_val

choose case ac_conv_type
	case "v", "V", "C", "c"

		choose case ac_conv_type
			case "v"
				li_byte_count = 2
			case "V"
				li_byte_count = 4
			case "C", "c"
				li_byte_count = 1

				if al_val < 0 then
					al_val = 256 - mod(al_val,129)
				end if

		end choose

		ll_val = al_val

		for li_i = 1 to li_byte_count
			blobedit(lblb_val,li_i,char(mod(ll_val,256)))
			ll_val = ll_val / 256
		next

	case else
		messagebox("Error","Invalid argument type in of_pack('" + ac_conv_type + "', ulong)")
end choose

return blobmid(lblb_val,1,li_byte_count)
end function

public function string of_str2xls (string as_str);long ll_pos

ll_pos = pos(as_str,"~r~n")

do while ll_pos > 0
	as_str = replace(as_str,ll_pos,2,"~n")
	ll_pos = pos(as_str,"~r~n")
loop

ll_pos = pos(as_str,"~r")

do while ll_pos > 0
	as_str = replace(as_str,ll_pos,1,"~n")
	ll_pos = pos(as_str,"~r")
loop

return as_str
end function

on n_xls_subroutines_v5.create
call super::create;

triggerevent("constructor")
end on

on n_xls_subroutines_v5.destroy
triggerevent("destructor")
call super::destroy
end on

