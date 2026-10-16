import sys
from pathlib import Path

from rembg import new_session, remove

session = new_session("birefnet-general")
for f in map(Path, sys.argv[1:]):
    f.with_name(f.stem + "-nobg.png").write_bytes(remove(f.read_bytes(), session=session))
