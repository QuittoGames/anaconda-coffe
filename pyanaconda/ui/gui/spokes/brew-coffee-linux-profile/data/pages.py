from dataclasses import dataclass

from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.start_brew import StartBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.languagesPage import LanguagesBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.desktopPage import DesktopBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.developerPage import DeveloperBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.shellPage import ShellBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.repositoriesPage import RepositoriesBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.packagesPage import PackagesBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.summaryPage import SummaryBrewCoffeSpoken
from pyanaconda.ui.gui.spokes.brew_coffee_linux_profile.pages.workPage import WorkBrewCoffeSpoken


@dataclass
class PagesBrewCoffe:
    PAGE_HOME_COFFE = 0
    PAGE_LANGUAGES = 1
    PAGE_DESKTOP = 2
    PAGE_DEVELOPER = 3
    PAGE_SHELL = 4
    PAGE_REPOSITORIES = 5
    PAGE_PACKAGES = 6
    PAGE_SUMMARY = 7
    PAGE_WORK = 8

    _pages = {
        PAGE_HOME_COFFE: StartBrewCoffeSpoken,
        PAGE_LANGUAGES: LanguagesBrewCoffeSpoken,
        PAGE_DESKTOP: DesktopBrewCoffeSpoken,
        PAGE_DEVELOPER: DeveloperBrewCoffeSpoken,
        PAGE_SHELL: ShellBrewCoffeSpoken,
        PAGE_REPOSITORIES: RepositoriesBrewCoffeSpoken,
        PAGE_PACKAGES: PackagesBrewCoffeSpoken,
        PAGE_SUMMARY: SummaryBrewCoffeSpoken,
        PAGE_WORK: WorkBrewCoffeSpoken,
    }

    def getPage(self) -> dict:
        return self._pages
