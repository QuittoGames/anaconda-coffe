from dataclasses import dataclass

@dataclass
class PagesBrewCoffe:
    PAGE_PROFILE = 0
    PAGE_LANGUAGES = 1
    PAGE_DESKTOP = 2
    PAGE_SHELL = 3
    PAGE_SUMMARY = 4

    _pages = {
            PAGE_PROFILE: ProfilePage(self.builder),
            PAGE_LANGUAGES: LanguagesPage(self.builder),
            PAGE_DESKTOP: DesktopPage(self.builder),
            PAGE_SHELL: ShellPage(self.builder),
            PAGE_SUMMARY: SummaryPage(self.builder),
        }

    def getPage(self) -> dict:
        return self._pages
