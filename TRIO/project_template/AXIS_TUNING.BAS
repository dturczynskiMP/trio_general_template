BASE(c_ax_example)
'GOTO speed_loop_tuning
GOTO position_loop_tuning
STOP

speed_loop_tuning:
DIM i AS INTEGER = 0
DIM dac_value AS INTEGER = 8000
DIM wait_time_delay AS INTEGER = 500

MSPEED_FILTER = 0.5
SERVO = OFF
AXIS_ENABLE = ON
FOR i = 0 TO 100
    GOSUB square
NEXT i
STOP

square:
DAC = dac_value
WA(wait_time_delay)
DAC = 0
WA(wait_time_delay)
DAC = -dac_value
WA(wait_time_delay)
DAC = 0
RETURN


position_loop_tuning:
SERVO = ON
WA(500)
SPEED = 15000 '/5
ACCEL = VR(vr_acc_dec_max_ax_example)
DECEL = ACCEL
JERK = VR(vr_jerk_max_ax_example)
DIM dist AS FLOAT = 0
VP_MODE = 6

dist = SPEED * 0.3
'IF dist > 250 THEN
'    dist = 250
'ENDIF

FOR i = 0 TO 100
    MOVE(dist)
    WAIT IDLE
    WA(1000)
    MOVE(-dist)
NEXT i


