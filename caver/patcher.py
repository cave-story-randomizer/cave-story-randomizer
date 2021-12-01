from pathlib import Path
from typing import Callable, Optional
from lupa import LuaRuntime
import logging
import shutil
pre_edited_cs = __import__("pre-edited-cs")


CSVERSION = 3

def patch_files(patch_data: dict, output_dir: Path, progress_update: Callable[[str, float], None]):
    progress_update("Copying base files...", 0.0)
    ensure_base_files_exist(output_dir)

    mapcount = len(patch_data["maps"].keys())

    lua_file = Path(__file__).parent.joinpath("tsc_file.lua").read_text()
    try:
        TscFile = LuaRuntime().execute(lua_file)
    except Exception as e:
        print(lua_file)
        raise e
    
    for i, (mapname, mapdata) in enumerate(patch_data["maps"].items()):
        progress_update(f"Patching {mapname}...", i/mapcount)
        patch_map(mapname, mapdata, TscFile, output_dir)
    
    progress_update("Copying MyChar...", 1.0)
    patch_mychar(patch_data["mychar"], output_dir)

    progress_update("Copying hash...", 1.0)
    patch_hash(patch_data["hash"], output_dir)

def ensure_base_files_exist(output_dir: Path):
    internal_copy = pre_edited_cs.get_path()

    version = output_dir.joinpath("data", "Stage", "_version.txt")
    keep_existing_files = version.exists() and int(version.read_text()) >= CSVERSION

    def should_ignore(path: str, names: list[str]):
        base = ["__init__.py", "__pycache__"]
        if keep_existing_files:
            p = Path(path)
            base.extend([p.joinpath(name) for name in names if p.joinpath(name).exists() and p.joinpath(name).is_file()])
        return base
        
    shutil.copytree(internal_copy, output_dir, ignore=should_ignore, dirs_exist_ok=True)
    output_dir.joinpath("data", "Plaintext").mkdir(exist_ok=True)

def patch_map(mapname: str, mapdata: dict[str, dict], TscFile, output_dir: Path):
    mappath = output_dir.joinpath("data", "Stage", f"{mapname}.tsc")
    tsc_file = TscFile.new(TscFile, mappath.read_bytes(), logging.getLogger("caver"))

    for event, script in mapdata["pickups"].items():
        TscFile.placeItemAtLocation(tsc_file, script, event, mapname)
    
    for event, song in mapdata["music"].items():
        TscFile.placeSongAtCue(tsc_file, song["song_id"], event, song["original_id"], mapname)
    
    for event, script in mapdata["entrances"].items():
        TscFile.placeTraAtEntrance(tsc_file, script, event, mapname)
    
    for event, script in mapdata["hints"].items():
        TscFile.placeHintAtEvent(tsc_file, script, event, mapname)

    chars = TscFile.getText(tsc_file).values()
    mappath.write_bytes(bytes(chars))
    output_dir.joinpath("data", "Plaintext", f"{mapname}.txt").write_text(TscFile.getPlaintext(tsc_file))

def patch_mychar(mychar: Optional[str], output_dir: Path):
    if mychar is None:
        return
    mychar_img = Path(mychar).read_bytes()
    output_dir.joinpath("data", "MyChar.bmp").write_bytes(mychar_img)

def patch_hash(hash: list[int], output_dir: Path):
    hash_strings = [f"{num:04d}" for num in hash]
    hash_string = ",".join(hash_strings)
    output_dir.joinpath("data", "hash.txt").write_text(hash_string)