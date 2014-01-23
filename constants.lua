SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

HERO_SPEED = 500
FORMATION_SPEED = 20 -- poruszanie sie szyku zarazkow

-- szybkosc poruszania sie zarazkow
BACTERIA_SPEED = 50
VIRUS_SPEED = 70

-- liczba pociskow zarazkow

-- jak czesto ma nastepowac atak kamikaze - losowany od min do max, w sekundach
KAMIKAZE_FREQ_MIN_L1 = 1
KAMIKAZE_FREQ_MAX_L1 = 2
KAMIKAZE_FREQ_MIN = 3
KAMIKAZE_FREQ_MAX = 5

-- po ilu sekundach pojawi sie pierwszy kamikaze
FIRST_KAMIKAZE = 2

-- ustawienia kamery dla pierwszego levelu
CAMERA_POS_X_L1 = SCREEN_WIDTH/2
CAMERA_POS_Y_L1 = SCREEN_HEIGHT-300
CAMERA_ZOOM_L1 = 1.1