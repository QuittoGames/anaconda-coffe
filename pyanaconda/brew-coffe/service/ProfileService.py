from dataclasses import dataclass,asdict
from pathlib import Path

from models.profile import Profile
from anaconda_loggers import get_brew_coffe_linux_logger

import json

@dataclass
class ProfileService:
    logger = get_brew_coffe_linux_logger()
    TEMP_PROFILE = Path("/tmp/brew_coffe_linux")

    def export(self, profile: Profile) -> None:
        data: dict = {}

        try:
            self.logger.debug("[DEBUG] Starting profile export")

            if profile is None:
                raise ValueError("profile cannot be None.")

            if not self.TEMP_PROFILE.exists():
                self.logger.info("[INFO] Temporary configuration directory not found. Creating...")
                self.initialize_temp_directory()

            data = asdict(profile)
            self.initialize_profile_json(data)

            if data["work"] != profile.work:
                raise ValueError("Profile serialization validation failed.")

            self.logger.info("[INFO] Profile exported successfully")

        except ValueError as e:
            self.logger.error(f"[ERROR] {e}")
            raise

        except TypeError as e:
            self.logger.error(f"[ERROR] Failed to serialize profile to JSON: {e}")
            raise

        except OSError as e:
            self.logger.error(f"[ERROR] File system error: {e}")
            raise

    def initialize_temp_directory(self) -> None:
        try:
            self.TEMP_PROFILE.mkdir(parents=True, exist_ok=True)
            self.logger.info(f"[INFO] Temporary directory created: {self.TEMP_PROFILE}")

        except FileExistsError:
            self.logger.warning(f"[WARN] Temporary directory already exists: {self.TEMP_PROFILE}")

        except Exception as e:
            self.logger.error(f"[ERROR] Failed to create temporary directory: {e}")
            raise

    def initialize_profile_json(self,data:dict) -> None:
        if data is None:
            raise ValueError("Cannot initialize profile.json: profile data is None.")

        path:Path = self.TEMP_PROFILE.joinpath("profile.json")

        with open(path, "w" ,encoding="UTF-8") as profile:
            json.dump(data,profile,indent=4)
