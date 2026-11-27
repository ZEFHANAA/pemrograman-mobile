from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Konfigurasi backend dari environment Docker Compose atau .env lokal."""

    database_url: str = "mysql+pymysql://tabungku:tabungku-dev-password@localhost:3307/tabungku"

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()
