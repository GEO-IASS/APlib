;==============================================================================
; :: APCONTAINER ::
;+=============================================================================
;
; This class is a basic data container meant to be used instead of bothering
; with pointers or the clunky IDLitData class.
;
; :Author:
;    Aram Panasenco (panasencoaram@gmail.com)
;
;-=============================================================================


;==============================================================================
;    APCONTAINER::INIT
;+=============================================================================
; :Description:
;    Initializes a container object .
;
; :Params:
;    data : optional
;      The data to store in the object
;
; :Returns:
;    Boolean success value (1/0)
;-=============================================================================
function apContainer::init, data
	self -> setData, data
	return, 1B
end


;==============================================================================
;    APCONTAINER::HASDATA
;+=============================================================================
; :Description:
;    Checks if the container has data
;-=============================================================================
function apContainer::hasData
	if (ptr_valid(self.data)) then begin
		return, 1B
	endif else begin
		return, 0B
	endelse
end


;==============================================================================
;    APCONTAINER::GETDATA
;+=============================================================================
; :Description:
;    Returns the data stored in the container.
;
; :Returns:
;    Data stored in the container.
;-=============================================================================
function apContainer::getData, SUCCESS=success
	if (ptr_valid(self.data)) then begin
		success = 1B
		return, *(self.data)
	endif else begin
		success = 0B
		return, 0
	endelse
end


;==============================================================================
;    APCONTAINER::SETDATA
;+=============================================================================
; :Description:
;    Replaces the data stored in the container with a new value.
;
; :Params:
;    data : required
;      The data to store in the object
;-=============================================================================
pro apContainer::setData, data, SUCCESS=success
	;Do nothing if the data is undefined
	if (n_elements(data) eq 0) then begin
		success = 0B
		return
	endif
	
	if (ptr_valid(self.data)) then begin
		*(self.data) = data
	endif else begin
		self.data = ptr_new(data)
	endelse
	success = 1B
end


;==============================================================================
;    APCONTAINER::DUPLICATE
;+=============================================================================
; :Description:
;    Duplicates the container with identical data, but a different object
;    reference.
;-============================================================================
function apContainer::duplicate, SUCCESS=success
	return, obj_new('apContainer',self -> getData())
end


;==============================================================================
;    APCONTAINER::CLEANUP
;+=============================================================================
; :Private:
;
; :Description:
;    Free the data pointer
;-=============================================================================
pro apContainer::cleanup
	ptr_free, self.data
end


;==============================================================================
;    APCONTAINER__DEFINE
;+=============================================================================
; :Hidden:
;
; :Description:
;    Definition procedure for the apContainer class
;
;-=============================================================================
pro apContainer__define
	class = { $
		apContainer, $
		data: ptr_new() $
	}
end