from datetime import datetime
from zoneinfo import ZoneInfo

JST = ZoneInfo("Asia/Tokyo")


def localtime_now() -> datetime:
    return datetime.now(JST)
