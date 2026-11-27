from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from .config import settings

engine = create_engine(settings.database_url, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine, autoflush=False, expire_on_commit=False)


class Base(DeclarativeBase):
    """Base ORM SQLAlchemy 2 untuk seluruh model TabungKu Cloud."""


def get_db():
    """Menyediakan satu session database per request dan menutupnya setelah selesai."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
