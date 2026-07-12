from gi.repository import Gtk
import gi

from pyanaconda.anaconda_loggers import get_module_logger
from pyanaconda.ui.categories.the_brew_of_coffe import TheBrewOfCoffeCategory
from pyanaconda.ui.gui.spokes import NormalSpoke
from pyanaconda.core.i18n import _

gi.require_version("Gtk", "3.0")

log = get_module_logger(__name__)

class WorkBrewCoffeSpoken(NormalSpoke):

    builderObjects = ["workBrewCoffeWindow"]
    mainWidgetName = "workBrewCoffeWindow"

    category = TheBrewOfCoffeCategory
    title = "Brew Coffe Linux | Profile"

    uiFile = "glade/work.glade"

    def __init__(self, data, storage, payload):
        super().__init__(data, storage, payload)

    def initialize(self):
        super().initialize()
