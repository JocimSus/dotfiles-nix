import hashlib

def sha256_file(path, chunk_size=8192):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(chunk_size), b""):
            h.update(chunk)
    return h.hexdigest()

print(sha256_file("GT_New_Horizons_2.8.4_Server_Java_8.zip"))
