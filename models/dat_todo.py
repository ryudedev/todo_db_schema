from models.base_model import BaseModel, CreatedMixin, UpdatedMixin
from sqlalchemy import Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from models.cnf_user import CnfUser


class DatTodo(BaseModel, CreatedMixin, UpdatedMixin):
    __tablename__ = "dat_todo"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    title: Mapped[str] = mapped_column(String, nullable=False)
    description: Mapped[str] = mapped_column(String, nullable=True)
    completed: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    user_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("cnf_user.id"), nullable=False
    )
    user: Mapped["CnfUser"] = relationship("CnfUser", back_populates="todos")
