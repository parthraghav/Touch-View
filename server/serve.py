import os
import sys
from flask import Flask, send_from_directory
from annotator.annotator import Annotator
from os import fspath
from flask.helpers import safe_join
from flask import json, jsonify
import config

annotator = Annotator()

app = Flask(__name__)


def _getSafeImagePath(filename):
    filename = fspath(filename)
    directory = fspath(config.IMAGE_REPOSITORY_PATH)
    filename = safe_join(directory, filename)
    return filename


@app.route("/get_accessible_image/<path:path>")
def getAccessibleImage(path):
    imgPath = _getSafeImagePath(path)
    didAnnotate = annotator.annotate(imgPath)
    return send_from_directory('../tests', path)


@app.route("/get_raw_annotation/<path:path>")
def getRawAnnotationData(path):
    if config.DEBUGGING:
        with open('./server/stub.json') as stub:
            data = json.load(stub)
            return jsonify(data)

    imgPath = _getSafeImagePath(path)
    annotation = annotator.getAnnotationData(imgPath)
    return jsonify(annotation)


@app.route("/get_raw_image/<path:path>")
def getRawImage(path):
    return send_from_directory('../tests', path)


if __name__ == "__main__":
    app.run(debug=True)
