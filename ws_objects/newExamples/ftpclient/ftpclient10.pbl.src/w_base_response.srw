$PBExportHeader$w_base_response.srw
forward
global type w_base_response from window
end type
end forward

global type w_base_response from window
integer width = 1911
integer height = 1484
boolean titlebar = true
string title = "Untitled"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
end type
global w_base_response w_base_response

forward prototypes
public function boolean wf_edit ()
public subroutine wf_load ()
public subroutine wf_save ()
end prototypes

public function boolean wf_edit ();// True=Edits Passed, False=Edits Failed

Return True

end function

public subroutine wf_load ();// Load

end subroutine

public subroutine wf_save ();// Save

end subroutine

on w_base_response.create
end on

on w_base_response.destroy
end on

event open;Integer li_offset

li_offset = gn_app.of_TitlebarOffset() + 28

this.Height = this.Height + li_offset

end event

