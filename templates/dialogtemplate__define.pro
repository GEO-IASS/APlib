;==============================================================================
; :: DIALOG ::
;+=============================================================================
;
; This class is a template for dialogs.
;
; :Author:
;    Aram Panasenco: panasencoaram@gmail.com
;-=============================================================================


;==============================================================================
;    DIALOG::INIT
;+=============================================================================
; :Description:
;    Initializes the Dialog class.
;
; :Returns:
;    Success boolean (1/0)
;
; :Params:
;    groupLeader : required
;      Object reference of the group leader widget
;-=============================================================================
function Dialog::init, groupLeader
	
	;Call the parent initialization method
	parentInitOK = self -> TopLevelBase::init(group_leader=groupLeader, $
	 name='self', title='Hello', /base_align_center, /column, $
	 /no_mbar, /kill_request_events)
	if (~parentInitOK) then return, 0B
	
	;Create the settings object
	self.settings = obj_new('apContainer', $
	 canceled=0B $
	)
	
	;Create all the GUI elements
	self -> gui
	
	;Update all elements
	self -> update, /all
	
	;Draw the dialog, blocking input
	self -> draw, /block
	
	;Return success
	return, 1B
end


;==============================================================================
;    DIALOG::GUI
;+=============================================================================
; :Private:
; 
; :Description:
;    Creates all the GUI elements of the dialog and renders the dialog.
;-=============================================================================
pro Dialog::gui
	;Create platform-independent newline character
	if (!D.NAME eq 'WIN') then newline = string([13B, 10B])$
	else newline = string(10B)
	
	;Create the body of the dialog
	
	
	;Create the OK/Cancel return buttons
	returnButtons = obj_new('apUIokCancel', self, ok_name='ok', cancel_name='cancel')
end


;==============================================================================
;    DIALOG::EVENTHANDLER
;+=============================================================================
; :Private:
;
; :Description:
;    Handles all widget events generated in the dialog.
;
; :Params:
;    event : required
;      Event structure to be handled.
;-=============================================================================
pro Dialog::eventHandler, event
	;Process the event by name
	case event.name of
		'ok': begin
			;The user pressed OK
			self.settings -> set, canceled=0B
			;Close the dialog
			self -> update, /dclose
		end
		'cancel': begin
			;The user pressed Cancel
			self.settings -> set, canceled=1B
			;Close the dialog
			self -> update, /dclose
		end
		'self': begin
			;This is a kill request event, same as cancel
			self.settings -> set, canceled=1B
			;Close the dialog
			self -> update, /dclose
		end
		else: ;Do nothing
	endcase
end


;==============================================================================
;    DIALOG::UPDATE
;+=============================================================================
; :Description:
;    Makes the necessary updates based on the internal settings object
;
; :Keywords:
;    ALL : optional
;      Set this keyword to update all UI elements
;    DCLOSE : optional
;      Set this keyword to close the dialog
;
;-=============================================================================
pro Dialog::update, ALL=all, DCLOSE=dClose
	updateAll = keyword_set(all)
	
	if (keyword_set() or updateAll) then begin
		
	endif
	
	if (keyword_set(dClose)) then begin
		self -> draw
		return
	endif
	
	self -> draw, /block
end


;==============================================================================
;    DIALOG::GETSETTINGS
;+=============================================================================
; :Description:
;    This method is used to retrieve user data from the dialog.
;
; :Keywords:
;    CANCELED : optional
;      Boolean (1/0) value of whether the user canceled the dialog.
;-=============================================================================
pro Dialog::getSettings, CANCELED=canceled
	canceled = self.settings -> get(/canceled)
end


;==============================================================================
;    DIALOG::CLEANUP
;+=============================================================================
; :Private:
;
; :Description:
;    Cleanup procedure for the dialog.
;
;-=============================================================================
pro Dialog::cleanup
	obj_destroy, [self.settings]
	self -> TopLevelBase::cleanup
end


;==============================================================================
;    DIALOG__DEFINE
;+=============================================================================
; :Description:
;    Definition procedure for the Dialog class.
;-=============================================================================
pro Dialog__define
	class = { $
		Dialog, $
		INHERITS TopLevelBase, $
		settings: obj_new() $
	}
end