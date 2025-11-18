$PBExportHeader$n_xls_subroutines.sru
forward
global type n_xls_subroutines from nonvisualobject
end type
end forward

global type n_xls_subroutines from nonvisualobject
end type
global n_xls_subroutines n_xls_subroutines

type variables
 public n_cst_unicode invo_uc
end variables

forward prototypes
public function blob of_pack (character ac_conv_type, unsignedlong al_val)
public function blob of_pack_hex (string as_val)
public function blob of_pack (character ac_conv_type, double ad_val)
public function string of_str2xls (string as_str)
public function string to_ansi (blob ab_value)
public function string to_ansi (blob ab_value, unsignedinteger ai_codepage)
public function string to_ansi (blob ab_value, unsignedinteger ai_codepage, character ac_defaultchar)
public function blob to_unicode (string as_value)
public function blob to_unicode (string as_value, unsignedinteger ai_codepage)
end prototypes

public function blob of_pack (character ac_conv_type, unsignedlong al_val);ulong ll_val
char lc_val
integer li_byte_count
integer li_i
blob{10} lblb_val




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
                    al_val = 256 - mod(al_val, 129)
                end if

        end choose

        ll_val = al_val
        
		  
	
        for li_i = 1 to li_byte_count
            blobedit(lblb_val, li_i, char(mod(ll_val, 256)))
            ll_val = ll_val / 256
        next

    case else
        messagebox("Error", "Invalid argument type in of_pack('" + ac_conv_type + "', ulong)")
end choose

return blobmid(lblb_val, 1, li_byte_count)


end function

public function blob of_pack_hex (string as_val);blob lblb_val
blob{100} lblb_buff
integer li_buff_size = 100
integer li_buff_pos = 1
integer li_i
integer li_cnt
string ls_str[2]
integer li_j
integer li_val

setnull(lblb_val)
li_cnt = len(as_val)

lblb_buff=blob(space(li_buff_size))

for li_i = 1 to li_cnt step 2

    if li_i = li_cnt then
        ls_str[1] = "0"
        ls_str[2] = mid(as_val, li_i, 1)
    else
        ls_str[1] = mid(as_val, li_i, 1)
        ls_str[2] = mid(as_val, li_i + 1, 1)
    end if

    li_val = 0

    for li_j = 1 to 2
        li_val = li_val * 16

        choose case ls_str[li_j]
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
                li_val += integer(ls_str[li_j])
            case "A"
                li_val = li_val + 10
            case "B"
                li_val = li_val + 11
            case "C"
                li_val = li_val + 12
            case "D"
                li_val = li_val + 13
            case "E"
                li_val = li_val + 14
            case "F"
                li_val = li_val + 15
        end choose

    next

    blobedit(lblb_buff, li_buff_pos, char(li_val))
    li_buff_pos ++

    if li_buff_pos = li_buff_size then

        if isnull(lblb_val) then
            lblb_val = lblb_buff
        else
            lblb_val = lblb_val + lblb_buff
        end if

        li_buff_pos = 1
    end if

next


if li_buff_pos > 1 then
	
    if isnull(lblb_val) then
        lblb_val = lblb_buff
    else
        lblb_val = lblb_val + lblb_buff
    end if

end if

return lblb_val
end function

public function blob of_pack (character ac_conv_type, double ad_val);blob{8} lb_ret
Int li 

if ac_conv_type = "d" then
    li=blobedit(lb_ret, 1, ad_val)
else
    messagebox("Error", "Invalid argument type in of_pack('" + ac_conv_type + "', double)")
end if

IF li>0 Then
	lb_ret= BlobMid(lb_ret, 1, li -1 )
ELSE
	 lb_ret=Blob("")
END IF


return lb_ret


end function

public function string of_str2xls (string as_str);long ll_pos

ll_pos = pos(as_str, char(13)+"~n")

do while ll_pos > 0
    as_str = replace(as_str, ll_pos, 2, "~n")
    ll_pos = pos(as_str, char(13)+"~n")
loop

ll_pos = pos(as_str, char(13))

do while ll_pos > 0
    as_str = replace(as_str, ll_pos, 2, "~n")
    ll_pos = pos(as_str, char(13))
loop

return as_str


end function

public function string to_ansi (blob ab_value);return invo_uc.of_unicode2ansi(ab_value)
end function

public function string to_ansi (blob ab_value, unsignedinteger ai_codepage);return invo_uc.of_unicode2ansi(ab_value,ai_codepage)
end function

public function string to_ansi (blob ab_value, unsignedinteger ai_codepage, character ac_defaultchar);return invo_uc.of_unicode2ansi(ab_value,ai_codepage,ac_defaultchar)
end function

public function blob to_unicode (string as_value);RETURN invo_uc.of_ansi2unicode(as_value)


end function

public function blob to_unicode (string as_value, unsignedinteger ai_codepage);return invo_uc.of_ansi2unicode(as_value,ai_codepage)
end function

on n_xls_subroutines.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_subroutines.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

