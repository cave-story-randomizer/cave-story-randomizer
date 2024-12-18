from __future__ import annotations

import json
import logging
import platform as pl
import shutil
import sys
import textwrap
import typing
from enum import Enum
from pathlib import Path
from uuid import UUID

import pre_edited_cs
from randovania_lupa import LuaRuntime  # type: ignore

from caver.schema.validator_with_default import DefaultValidatingDraft7Validator

LuaFile = typing.Any

if typing.TYPE_CHECKING:
    from collections.abc import Callable

    from caver.schema import (
        CaverData,
        CaverdataMaps,
        CaverdataOtherTsc,
        EventNumber,
        MapName,
    )


class CaverException(Exception):
    pass


class CSPlatform(Enum):
    FREEWARE = "freeware"
    TWEAKED = "tweaked"


def get_path() -> Path:
    if getattr(sys, "frozen", False):
        file_dir = Path(getattr(sys, "_MEIPASS"))
    else:
        file_dir = Path(__file__).parent.parent
    return file_dir.joinpath("caver")


def validate(patch_data: dict) -> None:
    with Path(__file__).parent.joinpath("schema/schema.json").open() as f:
        schema = json.load(f)
    DefaultValidatingDraft7Validator(schema).validate(patch_data)


def patch_files(
    patch_data: CaverData, output_dir: Path, platform: CSPlatform, progress_update: Callable[[str, float], None]
) -> None:
    progress_update("Validating schema...", -1)
    validate(typing.cast(dict, patch_data))

    progress_update("Copying base files...", -1)
    ensure_base_files_exist(platform, output_dir)

    total = len(patch_data["maps"].keys()) + len(patch_data["other_tsc"].keys()) + 3

    lua_file = get_path().joinpath("tsc_file.lua").read_text()
    TscFile = typing.cast(LuaFile, LuaRuntime().execute(lua_file))

    for i, (mapname, mapdata) in enumerate(patch_data["maps"].items()):
        progress_update(f"Patching {mapname}...", i / total)
        patch_map(mapname, mapdata, TscFile, output_dir)

    for filename, scripts in patch_data["other_tsc"].items():
        i += 1
        progress_update(f"Patching {filename}.tsc...", i / total)
        patch_other(filename, scripts, TscFile, output_dir)

    i += 1
    progress_update("Copying MyChar...", i / total)
    patch_mychar(patch_data["mychar"], output_dir, platform is CSPlatform.TWEAKED)

    i += 1
    progress_update("Copying hash...", i / total)
    patch_hash(patch_data["hash"], output_dir)

    i += 1
    progress_update("Copying UUID...", i / total)
    patch_uuid(patch_data["uuid"], output_dir)

    if platform == CSPlatform.TWEAKED:
        if pl.system() == "Linux":
            output_dir.joinpath("CSTweaked.exe").unlink()
        else:
            output_dir.joinpath("CSTweaked").unlink()


def ensure_base_files_exist(platform: CSPlatform, output_dir: Path) -> None:
    internal_copy = pre_edited_cs.get_path()

    with internal_copy.joinpath("data", "version.txt").open() as version_file:
        latest_version = version_file.readline()

    version = output_dir.joinpath("data", "version.txt")
    current_version = "v0.0.0.0"
    if version.exists():
        with version.open() as version_file:
            current_version = version_file.readline()

    keep_existing_files = current_version >= latest_version

    def should_ignore(path: str, names: list[str]) -> list[str]:
        base = ["__init__.py", "__pycache__", "ScriptSource", "__pyinstaller"]
        if keep_existing_files:
            p = Path(path)
            base.extend(
                [str(p.joinpath(name)) for name in names if p.joinpath(name).exists() and p.joinpath(name).is_file()]
            )
        return base

    try:
        shutil.copytree(internal_copy.joinpath(platform.value), output_dir, ignore=should_ignore, dirs_exist_ok=True)
        shutil.copytree(
            internal_copy.joinpath("data"), output_dir.joinpath("data"), ignore=should_ignore, dirs_exist_ok=True
        )
    except shutil.Error:
        raise CaverException(
            "Error copying base files. Ensure the directory is not read-only, and that Doukutsu.exe is closed"
        )
    output_dir.joinpath("data", "Plaintext").mkdir(exist_ok=True)


def patch_map(mapname: MapName, mapdata: CaverdataMaps, TscFile: LuaFile, output_dir: Path) -> None:
    mappath = output_dir.joinpath("data", "Stage", f"{mapname}.tsc")
    tsc_file = TscFile.new(TscFile, mappath.read_bytes(), logging.getLogger("caver"))

    for event, script in mapdata["pickups"].items():
        TscFile.placeScriptAtEvent(tsc_file, script, event, mapname)

    for event, song in mapdata["music"].items():
        TscFile.placeSongAtCue(tsc_file, song["song_id"], event, song["original_id"], mapname)

    for event, script in mapdata["entrances"].items():
        needle = "<EVE...."  # TODO: create a proper pattern
        TscFile.placeScriptAtEvent(tsc_file, script, event, mapname, needle)

    for event, hint in mapdata["hints"].items():
        script = create_hint_script(hint["text"], hint.get("facepic", "0000") != "0000", hint.get("ending", "<END"))
        TscFile.placeScriptAtEvent(tsc_file, script, event, mapname)

    chars = TscFile.getText(tsc_file).values()
    mappath.write_bytes(bytes(chars))
    output_dir.joinpath("data", "Plaintext", f"{mapname}.txt").write_text(TscFile.getPlaintext(tsc_file))


def patch_other(
    filename: MapName, scripts: dict[EventNumber, CaverdataOtherTsc], TscFile: LuaFile, output_dir: Path
) -> None:
    filepath = output_dir.joinpath("data", f"{filename}.tsc")
    tsc_file = TscFile.new(TscFile, filepath.read_bytes(), logging.getLogger("caver"))

    for event, script in scripts.items():
        TscFile.placeScriptAtEvent(tsc_file, script["script"], event, filename, script.get("needle", "<EVE...."))

    chars = TscFile.getText(tsc_file).values()
    filepath.write_bytes(bytes(chars))
    output_dir.joinpath("data", "Plaintext", f"{filename}.txt").write_text(TscFile.getPlaintext(tsc_file))


def patch_mychar(mychar: str | None, output_dir: Path, add_upscale: bool) -> None:
    if mychar is None:
        return
    mychar_img = Path(mychar).read_bytes()
    output_dir.joinpath("data", "MyChar.bmp").write_bytes(mychar_img)

    if add_upscale:
        mychar_name = Path(mychar).name
        mychar_up_img = Path(mychar).parent.joinpath("2x", mychar_name).read_bytes()
        output_dir.joinpath("data", "sprites_up", "MyChar.bmp").write_bytes(mychar_up_img)


def patch_hash(hash: list[int], output_dir: Path) -> None:
    hash_strings = [f"{num:04d}" for num in hash]
    hash_string = ",".join(hash_strings)
    output_dir.joinpath("data", "hash.txt").write_text(hash_string)


def patch_uuid(uuid: str, output_dir: Path) -> None:
    uuid = f"{{{UUID(uuid)}}}"
    output_dir.joinpath("data", "uuid.txt").write_text(uuid)


def wrap_msg_text(text: str, facepic: bool, *, ending: str = "<NOD", max_text_boxes: int | None = 1) -> str:
    hard_limit = 35
    msgbox_limit = 26 if facepic else hard_limit

    max_lines = max_text_boxes * 3 if max_text_boxes is not None else None
    lines = textwrap.wrap(text, width=msgbox_limit, max_lines=max_lines)

    text = ""
    for i, line in enumerate(lines):
        text += line
        if i < len(lines) - 1:
            if i % 3 == 2:
                text += "<NOD"
            if len(line) != hard_limit:
                text += "\r\n"
    text += ending

    return text


def create_hint_script(text: str, facepic: bool, ending: str) -> str:
    """
    A desperate attempt to generate valid <MSG text.
    Fills one text box (up to three lines). Attempts to wrap words elegantly.
    """
    return f"<PRI<MSG<TUR{wrap_msg_text(text, facepic, ending=ending)}"
