from flask import Flask, send_from_directory

app = Flask(__name__)


@app.route("/get_accessible_image/<path:path>")
def hello(path):
    return send_from_directory('../tests', path)


if __name__ == "__main__":
    app.run(debug=True)
