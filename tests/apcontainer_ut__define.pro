;==============================================================================
; :: APCONTAINER_UT ::
;+=============================================================================
;
; This class is a collection of unit tests for the apContainer class.
;
; :Author:
;    Aram Panasenco: panasencoaram@gmail.com
;-=============================================================================

function apContainer_ut::init, _EXTRA=extra
    ok = self -> MGutTestCase::init(_extra=extra)
    if not ok then return, 0
    return, 1
end

function apContainer_ut::test_empty_hasdata_getdata
    compile_opt idl2
    
    temp = obj_new('apContainer')
    assert, ~(temp -> hasData()), 'Empty container has data.'
    assert, isa(temp -> getData(), /null), 'getData() of empty container did not return NULL.'
    
    return, 1
end

function apContainer_ut::test_not_empty_hasdata_getdata
    compile_opt idl2
    
    values_list = list(5, complex(3,5), 'Hello World!',{a:-2D, b:obj_new()},obj_new('IDLgrAxis'))
    
    for i=0, values_list -> count()-1 do begin
        temp = obj_new('apContainer', list[i])
        assert, temp -> hasData(), 'Container reports no data.'
        assert, ~(isa(temp -> getData(), /null)), 'getData() of container returned NULL.'
        assert, temp -> getData() eq list[i], 'getData() returned unexpected value.'
    endfor
    
    return, 1
end

function apContainer_ut::test_setdata
    compile_opt idl2
    
    
    temp = obj_new('apContainer', dictionary('a',-10,'b',12))
    
    temp -> setData, success=s
    assert, s eq 0, 'Unexpected success'
    
    values_list = list(5, complex(3,5), 'Hello World!',{a:-2D, b:obj_new()},obj_new('IDLgrAxis'))
    for i=0, values_list -> count()-1 do begin
        temp -> setData, list[i]
        assert, temp -> hasData(), 'Container reports no data.'
        assert, ~(isa(temp -> getData(), /null)), 'getData() of container returned NULL.'
    endfor
    
    return, 1
end

function apContainer_ut::test_
    compile_opt idl2
    @error_is_pass
    
    
    return, 0
end

pro apContainer_ut__define
    class = { apContainer_ut, INHERITS MGutTestCase }
end