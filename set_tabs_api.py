from flask import Flask, jsonify

app = Flask(__name__)

tabs = [
    "https://ut11.masterf.org",
    "https://srv-l8.asm-s.com/TbAdi6F1Tm7melimVpPF"
]

@app.route('/get/tabs', methods=['GET'])
def get_tabs():
    return jsonify({"tabs": tabs})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)