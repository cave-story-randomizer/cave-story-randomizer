from pathlib import Path
from typing import Optional
from lupa import LuaRuntime
import logging
import shutil
pre_edited_cs = __import__("pre-edited-cs")


CSVERSION = 3

def patch_files(patch_data: dict, output_dir: Path):
    ensure_base_files_exist(output_dir)

    TscFile = LuaRuntime().eval(Path(__file__).parent.joinpath("tsc_file.lua").read_text())
    for mapname, mapdata in patch_data["maps"].items():
        patch_map(mapname, mapdata, TscFile, output_dir)
    
    patch_mychar(patch_data["mychar"], output_dir)

    patch_hash(patch_data["hash"], output_dir)

def ensure_base_files_exist(output_dir: Path):
    internal_copy = pre_edited_cs.get_path()

    version = output_dir.joinpath("data", "Stage", "_version.txt")
    keep_existing_files = version.exists() and int(version.read_text()) >= CSVERSION

    def should_ignore(path: Path, names: list[str]):
        if not keep_existing_files:
            return []
        return [path.joinpath(name) for name in names if path.joinpath(name).exists() and path.joinpath(name).is_file()]
    
    shutil.copytree(internal_copy, output_dir, ignore=should_ignore)

def patch_map(mapname: str, mapdata: dict[str, dict], TscFile, output_dir: Path):
    mappath = output_dir.joinpath("data", "Stage", f"{mapname}.tsc")
    tsc_file = TscFile.new({}, mappath.read_bytes(), logging.getLogger("caver"))

    for event, script in mapdata["pickups"].items():
        TscFile.placeItemAtLocation(tsc_file, script, event, mapname)
    
    for event, song in mapdata["music"].items():
        TscFile.placeSongAtCue(tsc_file, song["song_id"], event, song["original_id"], mapname)
    
    for event, script in mapdata["entrances"].items():
        TscFile.placeTraAtEntrance(tsc_file, script, event, mapname)

    mappath.write_bytes(TscFile.getText(tsc_file))
    output_dir.joinpath("data", "Plaintext", f"{mapname}.txt")

def patch_mychar(mychar: Optional[str], output_dir: Path):
    if mychar is None:
        return
    mychar_img = Path(mychar).read_bytes()
    output_dir.joinpath("data", "MyChar.bmp").write_bytes(mychar_img)

def patch_hash(hash: list[int], output_dir: Path):
    hash_strings = [f"{num:04d}" for num in hash]
    hash_string = ",".join(hash_strings)
    output_dir.joinpath("data", "hash.txt").write_text(hash_string)