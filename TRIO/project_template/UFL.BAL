'UFL File
'the user function library contains user functions prepared for a specific project
'
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~IMPORTANT INFORMATION
'
'
'Organization:
'   1.) The function name starts with
'       f_ - (function) means function
'
'       for example:
'         FUNCTION f_ecat_test(temp_vr AS INTEGER, devices_number AS INTEGER) AS INTEGER
'       Use:
'         f_ecat_test(vr_ecat, 6) 'vr_ecat contains the VR register number
'
'       Use:
'         f_ecat_test(234, devices_number) 'devices_number contains a specific variable
'
'   2.) the function should return status:
'       -1 - The function completed successfully
'       0 - Basic conditions error
'       1... - Errors with specific meaning
'
'   3.) below the FUNCTION keyword and ENDFUNC keyword there should be a description of the arguments accepted by the
'       FUNCTION
'
'       for example:
'         FUNCTION f_program_sd(action AS INTEGER, program_no AS INTEGER) AS INTEGER
'          'action = 1     'insert a row with an offset
'          'action = 2     'delete row with offset
'          'action = 3     'clear row without shifting
'          'action = 4     'clear entire program
'          'program_no = 1...99   'program number
'
'          'RETURN state
'          'state =  -1 (TRUE) 'OK
'          'state =   0 (FALSE)'ERROR
'          'state.0 = 1        'ERROR invalid line number
'          'state.1 = 1        'ERROR invalid action number
'          'state.2 = 1        'ERROR no copied data to paste

'
'         ///function code....///
'
'         RETURN state
'         ENDFUNC
'         'f_program_sd(action AS INTEGER, program_number AS INTEGER) AS INTEGER
'         'action = 1     'insert a row with an offset
'         'action = 2     'delete row with offset
'         'action = 3     'clear row without shifting
'         'action = 4     'clear entire program
'         'program_no = 1...99   'program line
'         '
'         'RETURN state
'         'state =  -1 (TRUE) 'OK
'         'state =   0 (FALSE)'ERROR
'         'state.0 = 1        'ERROR invalid line number
'         'state.1 = 1        'ERROR invalid action number
'         'state.2 = 1        'ERROR no copied data to paste
'
'   4.) between ENDFUN and next FUNCTION keywords keep 5 ENTER distances

