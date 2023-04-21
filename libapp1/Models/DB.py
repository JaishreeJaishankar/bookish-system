from flaskext.mysql import MySQL
from pymysql.cursors import DictCursor
import os


class DB(object):
	"""Initialize mysql database """
	host = "localhost"
	user = "root"
	password = ""
	db = "lms"
	table = ""

	def __init__(self, app):
		app.config["MYSQL_DATABASE_HOST"] = os.environ.get("RDS_HOSTNAME") or self.host;
		app.config["MYSQL_DATABASE_USER"] = os.environ.get("RDS_USERNAME") or self.user;
		app.config["MYSQL_DATABASE_PASSWORD"] = os.environ.get("RDS_PASSWORD") or self.password;
		app.config["MYSQL_DATABASE_DB"] = os.environ.get("RDS_DBNAME") or self.db;

		self.mysql = MySQL(app, cursorclass=DictCursor)

	def cur(self):
		return self.mysql.get_db().cursor()

	def query(self, q):
		h = self.cur()
	
		if (len(self.table)>0):
			q = q.replace("@table", self.table)

		h.execute(q)

		return h

	def commit(self):
		self.query("COMMIT;")