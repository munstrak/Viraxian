SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

STARTING_LEVEL="intro"
LEVEL_BLACK_SCREEN=3
LEVEL_FADE_OUT=2

TEXT_SPEED = 0.01
TEXT_SPEED_FAST = 0.05

HERO_SPEED = 500
FORMATION_SPEED = 40 -- poruszanie sie szyku zarazkow
HERO_SHOTS = 1

HEART_BEAT = 3

-- szybkosc poruszania sie zarazkow
BACTERIA_SPEED = 50
BACTERIA_SHOTS = 3
BACTERIA_SHOT_RECOIL=20

VIRUS_SPEED = 70
VIRUS_SHOTS = 3
BACTERIA_SHOT_RECOIL=10

-- liczba pociskow zarazkow

-- jak czesto ma nastepowac atak kamikaze - losowany od min do max, w sekundach
KAMIKAZE_FREQ_MIN_L1 = 2
KAMIKAZE_FREQ_MAX_L1 = 4
KAMIKAZE_FREQ_MIN = 2
KAMIKAZE_FREQ_MAX = 5
KAMIKAZE_SHOT_FREQ_MIN = 50 -- ms
KAMIKAZE_SHOT_FREQ_MAX = 300 -- ms


-- po ilu sekundach pojawi sie pierwszy kamikaze
FIRST_KAMIKAZE = 2

-- ustawienia kamery dla pierwszego levelu
CAMERA_POS_X_L1 = SCREEN_WIDTH/2
CAMERA_POS_Y_L1 = SCREEN_HEIGHT-300
CAMERA_ZOOM_L1 = 1.1