# This file is generated. Manual changes will be lost
# fmt: off
# ruff: noqa
from __future__ import annotations

import typing_extensions as typ


# Definitions
TscValue: typ.TypeAlias = str
EventNumber: typ.TypeAlias = TscValue
MapName: typ.TypeAlias = str
TscScript: typ.TypeAlias = str


# Schema entries
@typ.final
class CaverdataMapsHints(typ.TypedDict):
    text: str
    facepic: TscValue
    ending: TscScript


@typ.final
class CaverdataMapsMusic(typ.TypedDict):
    original_id: TscValue
    song_id: TscValue


@typ.final
class CaverdataMaps(typ.TypedDict):
    pickups: dict[EventNumber, TscScript]
    hints: dict[EventNumber, CaverdataMapsHints]
    music: dict[EventNumber, CaverdataMapsMusic]
    entrances: dict[EventNumber, TscScript]


@typ.final
class CaverdataOtherTsc(typ.TypedDict):
    needle: str
    script: TscScript



@typ.final
class Caverdata(typ.TypedDict):
    maps: dict[MapName, CaverdataMaps]
    other_tsc: dict[MapName, dict[EventNumber, CaverdataOtherTsc]]
    mychar: None | str
    hash: list[int]
    uuid: str
    platform: typ.NotRequired[str]

CaverData: typ.TypeAlias = Caverdata
