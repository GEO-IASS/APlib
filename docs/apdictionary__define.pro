;==============================================================================
; :: APDICTIONARY ::
;+=============================================================================
;
; This class is a wrapper around an IDL Structure that allows for very quick
; and easy field value setting. You can add all types of values to the
; dictionary that an IDL structure can hold.
;
; :Author:
;    Aram Panasenco (panasencoaram@gmail.com)
;
;-=============================================================================


;==============================================================================
;    APDICTIONARY::INIT
;+=============================================================================
;
; Initializes an apDictionary object, with or without initial key-value pairs.
;
; :Examples:
;    Initializing an apDictionary object::
;
;       IDL> mydict = obj_new('apDictionary', strkey='hi', intkey=-3)
;
; :Returns:
;    Boolean success value (1/0)
;
; :Keywords:
;    _EXTRA : optional
;      Keywords of the format KEY=VALUE. These define the initial class
;      structure.
;
;-=============================================================================
function apDictionary::init, _EXTRA=initStruct
    ;Initialize the internal structure pointer
    self.pStruct = ptr_new(/allocate_heap)
    ;Use the add method to define any intial key-value pairs
    self -> add, _extra=initStruct
    return, 1B
end


;==============================================================================
;    APDICTIONARY::ADD
;+=============================================================================
;
;  Adds one or more key-value pairs to the dictionary, passed in as keywords.
;  SUCCESS is the only reserved key.
;
; :Examples:
;    Using the add method::
;
;       IDL> mydict -> add, arrkey=[1,7,3], success=successBool
;       IDL> print, successBool
;          1
;
; :Keywords:
;    _EXTRA : required
;      Keywords of the format KEY=VALUE. The key-value pairs will be added to
;      the dictionary. If some of the keys are already defined, they will be
;      overwritten.
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
pro apDictionary::add, _extra=addStruct, SUCCESS=successBool
    
    ;Check if any key-value pairs were passed at all
    if (n_elements(addStruct) eq 0) then begin
        successBool = 0B
        return
    endif
    
    ;Check if the internal structure is not empty
    if (n_elements(*self.pStruct) ne 0) then begin
        ;Get the keys of the values being added and the already existing values
        addKeys = tag_names(addStruct)
        curKeys = tag_names(*self.pStruct)
        ;Remove all fields where the keys are duplicate
        for i=0, n_elements(addKeys)-1 do begin
            dupIndex = (where(curKeys eq addKeys))[0]
            if (dupIndex ne -1) then self -> _remove, dupIndex
        endfor
        ;Check if the container didn't get entirely deleted in the removal process
        if (n_elements(*self.pStruct) ne 0) then begin
            *self.pStruct = create_struct(*self.pStruct, addStruct)
        endif else begin
            *self.pStruct = addStruct
        endelse
    endif else begin
        *self.pStruct = addStruct
    endelse
    
    successBool = 1B
    return
    
end


;==============================================================================
;    APDICTIONARY::_REMOVE
;+=============================================================================
;
;  Removes (multiple) values from the container. Not user-friendly, meant
;  to be called from within the class only.
;
; :Private:
;
; :Params:
;    indices : required
;      An array of indices of the dictionary key-value pairs to be removed.
;
; :Keywords:
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
pro apDictionary::_remove, indices, SUCCESS=successBool
    
    ;Define the successBool to be 0B (false) by default
    successBool = 0B
    
    ;Check if no field values were passed or no container exists
    if (n_elements(indices) eq 0 or n_elements(*self.pStruct) eq 0) then return
    
    ;Get the number of elements and the tag names of the internal container
    nContainer = n_tags(*self.pStruct)
    tContainer = tag_names(*self.pStruct)
    
    ;Create a new container structure from scratch, not including the specified indices
    for i=0, nContainer-1 do begin
        if ((where(indices eq i))[0] eq -1) then begin
            if (n_elements(newContainer) ne 0) then begin
                newContainer = create_struct(tContainer[i],(*self.pStruct).(i),newContainer)
            endif else begin
                newContainer = create_struct(tContainer[i],(*self.pStruct).(i))
            endelse
        endif
    endfor
    
    if (n_elements(newContainer) ne 0) then begin
        ;Set the new container
        *self.pStruct = newContainer
    endif else begin
        ;Set the container to an empty pointer
        self.pStruct = ptr_new(/allocate_heap)
    endelse
    
    ;Set the success boolean to true and return
    successBool = 1B
    return
    
end


;==============================================================================
;    APDICTIONARY::SET
;+=============================================================================
;
;  Sets (multiple) values based on their keys.
;
; :Examples:
;    Using the set method::
;
;       IDL> mydict -> set, strkey='A quick brown fox', success=successBool
;       IDL> print, successBool
;          1
;
; :Keywords:
;    _EXTRA : required
;      Keywords of the format KEY=VALUE. The keys have to already exist in the
;      dictionary (not case-sensitive).
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
pro apDictionary::set, _extra=setStruct, SUCCESS=successBool
    
    ;Define the successBool to be 0B (false) by default
    successBool = 0B
    
    ;Check if no field values were passed or no container exists
    if (n_elements(setStruct) eq 0 or n_elements(*self.pStruct) eq 0) then return
    
    ;Get the keys of the values being set
    keyArray = tag_names(setStruct)
    
    ;Loop through the field names in the field structure
    for keyIndex=0, n_elements(keyArray)-1 do begin
        
        key = keyArray[keyIndex]
        
        ;Get the index of the matching key in the internal structure
        matchArray = strcmp(tag_names(*self.pStruct), key, /fold_case)
        structIndex = (where(matchArray eq 1))[0]
        
        if (structIndex eq -1) then begin
            ;No match, start the next iteration
            continue
        endif
        
        ;Set the field
        (*self.pStruct).(structIndex) = setStruct.(keyIndex)
        successBool = 1B
        
    endfor
    
    ;If none of the values have been set, successBool will be 0B
    ;If any of the values have been set, successBool will be 1B
    return
    
end


;==============================================================================
;    APDICTIONARY::GET
;+=============================================================================
;
; Retrieves a value based on a key.
;
; :Examples:
;    Using the get method::
;
;       IDL> strval = mydict -> get(/strkey, success=successBool)
;       IDL> print, strval
;       A quick brown fox
;       IDL> print, successBool
;          1
;
; :Returns:
;    The value.
;
; :Keywords:
;    _EXTRA : required
;      Keyword of the format /KEY. The key has to correspond to an existing
;      value in the dictionary (not case-sensitive).
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
function apDictionary::get, _extra=getStruct, SUCCESS=successBool
    
    ;Define the successBool to be 0B (false) by default
    successBool = 0B
    ;Value to be returned if the get is unsuccessful
    NULL_RETURN_VALUE = -1
    
    ;Check if more/less than one key was passed or no internal structure exists
    if (n_elements(getStruct) ne 1 or n_elements(*self.pStruct) eq 0) then $
     return, NULL_RETURN_VALUE
    
    ;Get the key of the value being retirved
    key = (tag_names(getStruct))[0]
    
    ;Get the index of the matching field in the class structure
    matchArray = strcmp(tag_names(*self.pStruct), key, /fold_case)
    structIndex = (where(matchArray eq 1))[0]
    
    ;If no match, return unsuccessfully
    if (structIndex eq -1) then return, NULL_RETURN_VALUE
    
    successBool = 1B
    return, (*self.pStruct).(structIndex)
    
end


;==============================================================================
;    APDICTIONARY::DUPLICATE
;+=============================================================================
;
;    Creates a duplicate of the dictionary
;
; :Examples:
;    Using the duplicate method::
;
;       IDL> dupdict = mydict -> duplicate(success=successBool)
;       IDL> print, dupdict -> get(/intkey)
;                 -3
;       IDL> print, successBool
;          1
;
; :Returns:
;    A new apDictionary object identical to this one.
;
; :Keywords:
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
function apDictionary::duplicate, SUCCESS=successBool
    dupObject = obj_new('apDictionary', _extra=(*self.pStruct))
    successBool = obj_valid(dupObject)
    return, dupObject
end


;==============================================================================
;    APDICTIONARY::CLEANUP
;+=============================================================================
; :Hidden:
;
; :Description:
;    Cleanup procedure for the apDictionary class. Called on obj_destroy.
;
;-=============================================================================
pro apDictionary::cleanup
    ;Free the internal structure pointer
    ptr_free, self.pStruct
end


;==============================================================================
;    APDICTIONARY__DEFINE
;+=============================================================================
; :Hidden:
;
; :Description:
;    Definition procedure for the apDictionary class.
;
;-=============================================================================
pro apDictionary__define
    class = { $
        apDictionary, $
        pStruct: ptr_new() $
    }
end