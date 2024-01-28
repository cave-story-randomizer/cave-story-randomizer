from enum import Enum
from pathlib import Path
from typing import Callable, Optional
from lupa import LuaRuntime # type: ignore
import logging
import shutil
import textwrap
import sys
import platform as pl

import pre_edited_cs



CSVERSION = 5

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

def patch_files(patch_data: dict, output_dir: Path, platform: CSPlatform, progress_update: Callable[[str, float], None]):
    progress_update("Copying base files...", -1)
    ensure_base_files_exist(platform, output_dir)

    total = len(patch_data["maps"].keys()) + len(patch_data["other_tsc"].keys()) + 3

    lua_file = get_path().joinpath("tsc_file.lua").read_text()
    TscFile = LuaRuntime().execute(lua_file)

    for i, (mapname, mapdata) in enumerate(patch_data["maps"].items()):
        progress_update(f"Patching {mapname}...", i/total)
        patch_map(mapname, mapdata, TscFile, output_dir)

    for filename, scripts in patch_data["other_tsc"].items():
        i += 1
        progress_update(f"Patching {filename}.tsc...", i/total)
        patch_other(filename, scripts, TscFile, output_dir)

    i += 1
    progress_update("Copying MyChar...", i/total)
    patch_mychar(patch_data["mychar"], output_dir, platform is CSPlatform.TWEAKED)

    i += 1
    progress_update("Copying hash...", i/total)
    patch_hash(patch_data["hash"], output_dir)

    i += 1
    progress_update("Copying UUID...", i/total)
    patch_uuid(patch_data["uuid"], output_dir)

    if platform == CSPlatform.TWEAKED:
        if pl.system() == "Linux":
            output_dir.joinpath("CSTweaked.exe").unlink()
        else:
            output_dir.joinpath("CSTweaked").unlink()

def ensure_base_files_exist(platform: CSPlatform, output_dir: Path):
    internal_copy = pre_edited_cs.get_path()

    version = output_dir.joinpath("data", "Stage", "_version.txt")
    keep_existing_files = version.exists() and int(version.read_text()) >= CSVERSION

    def should_ignore(path: str, names: list[str]):
        base = ["__init__.py", "__pycache__", "ScriptSource", "__pyinstaller"]
        if keep_existing_files:
            p = Path(path)
            base.extend([str(p.joinpath(name)) for name in names if p.joinpath(name).exists() and p.joinpath(name).is_file()])
        return base

    try:
        shutil.copytree(internal_copy.joinpath(platform.value), output_dir, ignore=should_ignore, dirs_exist_ok=True)
        shutil.copytree(internal_copy.joinpath("data"), output_dir.joinpath("data"), ignore=should_ignore, dirs_exist_ok=True)
    except shutil.Error:
        raise CaverException("Error copying base files. Ensure the directory is not read-only, and that Doukutsu.exe is closed")
    output_dir.joinpath("data", "Plaintext").mkdir(exist_ok=True)

def patch_map(mapname: str, mapdata: dict[str, dict], TscFile, output_dir: Path):
    mappath = output_dir.joinpath("data", "Stage", f"{mapname}.tsc")
    tsc_file = TscFile.new(TscFile, mappath.read_bytes(), logging.getLogger("caver"))

    for event, script in mapdata["pickups"].items():
        TscFile.placeScriptAtEvent(tsc_file, script, event, mapname)

    for event, song in mapdata["music"].items():
        TscFile.placeSongAtCue(tsc_file, song["song_id"], event, song["original_id"], mapname)

    for event, script in mapdata["entrances"].items():
        needle = "<EVE...." # TODO: create a proper pattern
        TscFile.placeScriptAtEvent(tsc_file, script, event, mapname, needle)

    for event, hint in mapdata["hints"].items():
        script = create_hint_script(hint["text"], hint.get("facepic", "0000") != "0000", hint.get("ending", "<END"))
        TscFile.placeScriptAtEvent(tsc_file, script, event, mapname)

    chars = TscFile.getText(tsc_file).values()
    mappath.write_bytes(bytes(chars))
    output_dir.joinpath("data", "Plaintext", f"{mapname}.txt").write_text(TscFile.getPlaintext(tsc_file))

def patch_other(filename: str, scripts: dict[str, dict[str, str]], TscFile, output_dir: Path):
    filepath = output_dir.joinpath("data", f"{filename}.tsc")
    tsc_file = TscFile.new(TscFile, filepath.read_bytes(), logging.getLogger("caver"))

    for event, script in scripts.items():
        TscFile.placeScriptAtEvent(tsc_file, script["script"], event, filename, script.get("needle", "<EVE...."))

    chars = TscFile.getText(tsc_file).values()
    filepath.write_bytes(bytes(chars))
    output_dir.joinpath("data", "Plaintext", f"{filename}.txt").write_text(TscFile.getPlaintext(tsc_file))

def patch_mychar(mychar: Optional[str], output_dir: Path, add_upscale: bool):
    if mychar is None:
        return
    mychar_img = Path(mychar).read_bytes()
    output_dir.joinpath("data", "MyChar.bmp").write_bytes(mychar_img)

    if add_upscale:
        mychar_name = Path(mychar).name
        mychar_up_img = Path(mychar).parent.joinpath("2x", mychar_name).read_bytes()
        output_dir.joinpath("data", "sprites_up", "MyChar.bmp").write_bytes(mychar_up_img)


def patch_hash(hash: list[int], output_dir: Path):
    hash_strings = [f"{num:04d}" for num in hash]
    hash_string = ",".join(hash_strings)
    output_dir.joinpath("data", "hash.txt").write_text(hash_string)

def patch_uuid(uuid: str, output_dir: Path):
    output_dir.joinpath("data", "uuid.txt").write_text(uuid)

def wrap_msg_text(text: str, facepic: bool, *, ending: str = "<NOD", max_text_boxes: Optional[int] = 1) -> str:
    hard_limit = 35
    msgbox_limit = 26 if facepic else hard_limit

    max_lines = max_text_boxes * 3 if max_text_boxes is not None else None
    lines = textwrap.wrap(text, width=msgbox_limit, max_lines=max_lines)

    text = ""
    for i, l in enumerate(lines):
        text += l
        if i < len(lines)-1:
            if i % 3 == 2:
                text += "<NOD"
            if len(l) != hard_limit:
                text += "\r\n"
    text += ending

    return text

def create_hint_script(text: str, facepic: bool, ending: str) -> str:
    """
    A desperate attempt to generate valid <MSG text. Fills one text box (up to three lines). Attempts to wrap words elegantly.
    """
    return f"<PRI<MSG<TUR{wrap_msg_text(text, facepic, ending=ending)}"
