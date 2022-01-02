# from mysql.connector import connect, Error
from database_secrets import HOST , USER , DATABASE , PASSWORD


# `def db(sqlquery):
#     records = None
#     con = connect(
#                     host = HOST,
#                     port = 3306,
#                     database = DATABASE,
#                     user = USER,
#                     password = PASSWORD
#                   )
#     cur = con.cursor()
#     
#     # try:
#     cur.execute(sqlquery)
#     # except Exception as e:
#     #     print("Eception", e)
#     
#     try:
#         records = cur.fetchall()
#     except:
#         pass
#     con.commit()
#     con.close()
#     return records
# 
    

