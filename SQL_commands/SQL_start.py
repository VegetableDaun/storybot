SQL_login = """
            SELECT *\n
            FROM stories.readers\n
            WHERE userid = '{}';
            """

SQL_sign_up = """
                INSERT INTO stories.readers(userid)
                VALUES ('{}');
                """