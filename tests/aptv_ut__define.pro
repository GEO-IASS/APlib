;==============================================================================
; :: APTV_UT ::
;+=============================================================================
;
; This class is a collection of tests for the apTV procedure
;
; :Author:
;    Aram Panasenco: panasencoaram@gmail.com
;-=============================================================================

function aptv_ut::init, _EXTRA=extra
    ok = self -> MGutTestCase::init(_extra=extra)
    if not ok then return, 0
    return, 1
end

function aptv_ut::test_zero_args_raises_error
    compile_opt idl2
    @error_is_pass

    aptv
    
    return, 0
end

function aptv_ut::test_medium_image_shows_up
    compile_opt idl2

    file = filepath('nyny.dat', sub = ['examples', 'data'])
    nyny = read_binary(file, data_dims = [768, 512])
    
    aptv, bytscl(nyny)

    print, 'Has an aerial view of New York been displayed? (y/n)'
    response = get_kbrd()
    assert, response eq 'y', 'No image displayed'

    return, 1
end

function aptv_ut::test_color_works
    compile_opt idl2

    file = filepath('rose.jpg', sub = ['examples', 'data'])
    rose = read_image(file)
    aptv, rose

    print, 'Has a color picture of a rose been displayed? (y/n)'
    response = get_kbrd()
    assert, response eq 'y', 'No image displayed'
    
    return, 1
end

pro aptv_ut__define
    class = { aptv_ut, INHERITS MGutTestCase }
end

