from gi.repository import Gtk
import gi

from pyanaconda.anaconda_loggers import get_module_logger
from pyanaconda.ui.categories.system import SystemCategory
from pyanaconda.ui.gui.spokes import NormalSpoke
from pyanaconda.core.i18n import _
from pages.profile import ProfilePage
from .pages.languages import LanguagesPage
from .pages.desktop import DesktopPage
from .pages.shell import ShellPage
from .pages.summary import SummaryPage

gi.require_version("Gtk", "3.0")

log = get_module_logger(__name__)


class Profile:
    pass

class ProfileBrewCoffeSpoken(NormalSpoke):

    category = SystemCategory
    title = "Brew Coffe Linux | Profile"

    def __init__(self, data, storage, payload):
        super().__init__(data, storage, payload)

    def initialize(self):
        super().initialize()
