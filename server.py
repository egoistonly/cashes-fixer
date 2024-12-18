from flask import Flask, jsonify, render_template_string

app = Flask(__name__)

# Список вкладок
tabs = [
    "https://ut11.masterf.org",
    "https://srv-l8.asm-s.com/TbAdi6F1Tm7melimVpPF"
]

@app.route('/', methods=['GET'])
def home():
    """
    Отображает веб-страницу, которая открывает вкладки.
    """
    html_template = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Открытие вкладок</title>
        <script>
            async function openTabs() {
                // Получение списка вкладок с сервера
                const response = await fetch('/api/tabs');
                const data = await response.json();
                const tabs = data.tabs;

                // Открытие каждой вкладки
                tabs.forEach(tab => {
                    window.open(tab, '_blank');
                });
            }

            // Запускаем открытие вкладок при загрузке страницы
            window.onload = openTabs;
        </script>
    </head>
    <body>
        <h1>Открытие вкладок...</h1>
    </body>
    </html>
    """
    return render_template_string(html_template)

@app.route('/api/tabs', methods=['GET'])
def get_tabs():
    """
    Возвращает список вкладок в формате JSON.
    """
    return jsonify({"tabs": tabs})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)