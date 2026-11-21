from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Configuration provided by the Docker Compose environment."""

    database_url: str = "mysql+pymysql://tabungku:change-me@localhost:3307/tabungku"

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()
