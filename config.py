# Imports
import hy
from wm import *

# Settings
keys = get_keys()
layouts = get_layouts()
groups = get_groups()
extension_defaults = get_extension_defaults()
screens = get_screens()

# Misc
dgroups_key_binder = None
dgroups_app_rules = []
main = None 
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LispRice"

# Set Wallpaper
set_wallpaper()
