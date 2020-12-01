# python3 -m annotator.exif

import pyexiv2
import json


class MetaDataManager(object):
    @classmethod
    def read(cls, imgPath: str):
        image = pyexiv2.Image(imgPath)
        return MetaData(image)


class MetaData(object):
    def __init__(self, img: pyexiv2.Image):
        self._img = img
        self._cache = None

    def get(self):
        if self._cache is None:
            self._cache = self._img.read_exif()
        return self._cache

    def put(self, data: dict):
        self._img.modify_exif({
            'Exif.Image.ImageDescription': json.dumps(data)}, encoding='utf-8')

    def doesKeyExist(self, key: str):
        data = self.get()
        if 'Exif.Image.ImageDescription' in data:
            return key in data['Exif.Image.ImageDescription']
        return False

# Exif.Image.ImageDescription
# Exif.Photo.UserComment
