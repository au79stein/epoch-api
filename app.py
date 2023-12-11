from flask import Flask
from flask_restful import Api, Resource
import time

app = Flask(__name__)
api = Api(app)

class returnjson(Resource):
    def get(self):
        data={
          "The current epoch time": int(time.time()),
        }
        return data

api.add_resource(returnjson, '/')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080, debug = True)
