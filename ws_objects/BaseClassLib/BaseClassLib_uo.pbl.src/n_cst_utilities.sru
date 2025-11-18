$PBExportHeader$n_cst_utilities.sru
forward
global type n_cst_utilities from nonvisualobject
end type
end forward

global type n_cst_utilities from nonvisualobject
end type
global n_cst_utilities n_cst_utilities

forward prototypes
public function string replace (string as_mystring, string as_old_str, string as_new_str)
end prototypes

public function string replace (string as_mystring, string as_old_str, string as_new_str);long 		ll_start_pos=1
string	ls_MyString

ls_MyString = as_mystring

// Find the first occurrence of old_str.
ll_start_pos = Pos(ls_MyString, as_old_str, ll_start_pos)

// Only enter the loop if you find old_str.
DO WHILE ll_start_pos > 0

    // Replace old_str with new_str.
    ls_MyString = Replace(ls_MyString, ll_start_pos, Len(as_old_str), as_new_str)

    // Find the next occurrence of old_str.
    ll_start_pos = Pos(ls_MyString, as_old_str, ll_start_pos + Len(as_new_str))

LOOP

return ls_MyString
end function

on n_cst_utilities.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_utilities.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

