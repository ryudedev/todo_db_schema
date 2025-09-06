from datetime import datetime
import os
from sqlalchemy import DateTime, MetaData, func
from sqlalchemy.orm import (
    Mapped,
    declarative_mixin,
    DeclarativeBase,
    declared_attr,
    mapped_column,
)

from models import localtime_now


def recursive_subclasses(klass, base_package: str = "database.models"):
    current_dir = os.path.dirname(os.path.abspath(__file__))  # src/database/models
    exclude_file_names = ["base_model.py", "__pycache__"]
    for file_name in os.listdir(current_dir):
        if file_name.endswith(".py") and file_name not in exclude_file_names:
            module_name = file_name[:-3]
            module = __import__(f"{base_package}.{module_name}", fromlist=[module_name])

    seen = set()
    for subclass in klass.__subclasses__():
        yield subclass
        for subsubclass in recursive_subclasses(subclass, base_package=base_package):
            if subsubclass not in seen:
                seen.add(subsubclass)
                yield subsubclass


class BaseModel(DeclarativeBase):
    __abstract__ = True

    metadata = MetaData(
        naming_convention={
            "ix": "%(column_0_label)s_idx",
            "uq": "%(table_name)s_%(column_0_name)s_key",
            "ck": "%(table_name)s_%(constraint_name)s_check",
            "fk": "%(table_name)s_%(join_col_names)s_%(referred_table_name)s_fkey",
            "pk": "%(table_name)s_pkey",
        }
    )


@declarative_mixin
class CreatedMixin:
    @declared_attr
    def created_at(cls) -> Mapped[datetime]:
        return mapped_column(
            DateTime,
            default=datetime.now,
            nullable=False,
            server_default=func.current_timestamp(),
            insert_default=localtime_now,
        )


@declarative_mixin
class UpdatedMixin:
    @declared_attr
    def updated_at(cls) -> Mapped[datetime]:
        return mapped_column(
            DateTime,
            default=datetime.now,
            nullable=False,
        )
