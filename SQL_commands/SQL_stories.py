SQL_start_story = """
INSERT INTO stories.progress_stories(id_user, id_story, progress, points)
VALUES (
(SELECT id FROM stories.readers WHERE userid = {}), 
{}, jsonb_build_array('0.0'), jsonb_build_object(0, 0)
);
"""

SQL_data = """
SELECT *
FROM stories.line_story_{id_title} as st
WHERE st.start_state = (SELECT pg.progress->>-1 as state
                        FROM stories.progress_stories as pg
                        WHERE pg.id_user = (SELECT id FROM stories.readers WHERE userid = {id_user}) and pg.id_story = {id_title});
"""

SQL_data_short = """
SELECT *
FROM stories.line_story_{id_title} as st
WHERE st.start_state = '{state}';
"""
