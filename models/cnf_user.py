from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship
from models import DatTodo
from models.base_model import BaseModel, CreatedMixin, UpdatedMixin


class CnfUser(BaseModel, CreatedMixin, UpdatedMixin):
    __tablename__ = "cnf_user"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String, nullable=False, default="guest")
    email: Mapped[str] = mapped_column(String, nullable=False, unique=False)
    password: Mapped[str] = mapped_column(String, nullable=False, unique=False)

    todos: Mapped[list["DatTodo"]] = relationship("DatTodo", back_populates="user")
