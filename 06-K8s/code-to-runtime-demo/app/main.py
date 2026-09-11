from flask import Flask

app = Flask(__name__)


@app.route("/")
def index():
    return "code-to-runtime demo app\n"


@app.route("/healthz")
def healthz():
    return "ok\n"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
